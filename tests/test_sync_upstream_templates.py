import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path, PurePosixPath
from unittest.mock import patch


try:
    from scripts import sync_upstream_templates as sync
except ImportError:
    sync = None


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def sha256(content: str) -> str:
    return hashlib.sha256(content.encode()).hexdigest()


class RepositoryFixture(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary_directory = tempfile.TemporaryDirectory()
        root = Path(self.temporary_directory.name)
        self.source = root / "source"
        self.target = root / "target"
        self.source.mkdir()
        self.target.mkdir()

    def tearDown(self) -> None:
        self.temporary_directory.cleanup()


class DiscoveryTests(RepositoryFixture):
    def test_discovery_maps_only_managed_files(self) -> None:
        write(self.source / "Templates/math/fft.hpp", "fft\n")
        write(self.source / "Templates/geometry/2d.hpp", "2d\n")
        write(self.source / "Templates/geometry/3d.hpp", "3d\n")
        write(self.source / "Templates/initialization_misc/makefile", "all:\n")
        write(self.source / "Templates/math/main.typ", "ignored\n")
        write(self.source / "Templates/geometry/demo.cpp", "ignored\n")

        files = sync.discover_managed_files(self.source)

        self.assertEqual(
            [(str(item.source), str(item.target)) for item in files],
            [
                ("geometry/2d.hpp", "geometry/2D/2d.hpp"),
                ("geometry/3d.hpp", "geometry/3D/3d.hpp"),
                ("initialization_misc/makefile", "initialization_misc/makefile"),
                ("math/fft.hpp", "math/fft.hpp"),
            ],
        )

    def test_manifest_round_trip_is_deterministic(self) -> None:
        manifest_path = self.target / "scripts/upstream-template-manifest.json"
        manifest = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="abc123",
            files=(
                sync.ManagedFile(
                    PurePosixPath("math/b.hpp"), PurePosixPath("math/b.hpp")
                ),
                sync.ManagedFile(
                    PurePosixPath("math/a.hpp"), PurePosixPath("math/a.hpp")
                ),
            ),
            fingerprints=(
                (PurePosixPath("math/a.hpp"), sha256("a\n")),
                (PurePosixPath("math/b.hpp"), sha256("b\n")),
            ),
        )

        sync.write_manifest(manifest_path, manifest)

        self.assertEqual(sync.load_manifest(manifest_path), manifest)
        parsed = json.loads(manifest_path.read_text(encoding="utf-8"))
        self.assertEqual(
            [entry["source"] for entry in parsed["files"]],
            ["math/a.hpp", "math/b.hpp"],
        )
        self.assertEqual(parsed["files"][0]["sha256"], sha256("a\n"))
        self.assertTrue(manifest_path.read_bytes().endswith(b"\n"))

    def test_unrelated_upstream_commit_does_not_churn_manifest(self) -> None:
        file = sync.ManagedFile(
            PurePosixPath("math/a.hpp"), PurePosixPath("math/a.hpp")
        )
        baseline = ((file.source, sha256("same\n")),)
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old-commit",
            files=(file,),
            fingerprints=baseline,
        )
        candidate = sync.Manifest(
            repository=previous.repository,
            ref=previous.ref,
            commit="new-unrelated-commit",
            files=(file,),
            fingerprints=baseline,
        )

        retained = sync.retain_commit_for_unchanged_baseline(candidate, previous)

        self.assertEqual(retained, previous)


class ApplyTests(RepositoryFixture):
    def test_apply_updates_adds_and_removes_only_owned_targets(self) -> None:
        write(self.source / "Templates/math/changed.hpp", "new content\n")
        write(self.source / "Templates/math/new.hpp", "new file\n")
        write(self.target / "Templates/math/changed.hpp", "old content\n")
        write(self.target / "Templates/math/old.hpp", "remove me\n")
        write(self.target / "Templates/math/keep.typ", "keep\n")
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(
                sync.ManagedFile(
                    PurePosixPath("math/changed.hpp"),
                    PurePosixPath("math/changed.hpp"),
                ),
                sync.ManagedFile(
                    PurePosixPath("math/old.hpp"), PurePosixPath("math/old.hpp")
                ),
            ),
        )

        plan = sync.build_plan(self.source, self.target, previous)
        sync.apply_plan(plan, self.source, self.target)

        self.assertFalse((self.target / "Templates/math/old.hpp").exists())
        self.assertEqual(
            (self.target / "Templates/math/changed.hpp").read_text(encoding="utf-8"),
            "new content\n",
        )
        self.assertEqual(
            (self.target / "Templates/math/new.hpp").read_text(encoding="utf-8"),
            "new file\n",
        )
        self.assertEqual(
            (self.target / "Templates/math/keep.typ").read_text(encoding="utf-8"),
            "keep\n",
        )

    def test_new_upstream_path_cannot_overwrite_different_unowned_target(self) -> None:
        write(self.source / "Templates/math/new.hpp", "upstream\n")
        write(self.target / "Templates/math/new.hpp", "target-only\n")
        empty_manifest = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(),
        )

        plan = sync.build_plan(self.source, self.target, empty_manifest)

        self.assertEqual(plan.copies, ())
        self.assertEqual(len(plan.conflicts), 1)
        self.assertIn("unowned target", plan.conflicts[0].reason)

    def test_new_upstream_path_adopts_identical_unowned_target(self) -> None:
        write(self.source / "Templates/math/new.hpp", "same\n")
        write(self.target / "Templates/math/new.hpp", "same\n")
        empty_manifest = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(),
        )

        plan = sync.build_plan(self.source, self.target, empty_manifest)

        self.assertEqual(plan.conflicts, ())
        self.assertEqual(
            plan.unchanged,
            (
                sync.ManagedFile(
                    PurePosixPath("math/new.hpp"), PurePosixPath("math/new.hpp")
                ),
            ),
        )

    def test_local_ahead_change_is_conflict_not_upstream_copy(self) -> None:
        write(self.source / "Templates/math/value.hpp", "base\n")
        write(self.target / "Templates/math/value.hpp", "local\n")
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(
                sync.ManagedFile(
                    PurePosixPath("math/value.hpp"), PurePosixPath("math/value.hpp")
                ),
            ),
            fingerprints=((PurePosixPath("math/value.hpp"), sha256("base\n")),),
        )

        plan = sync.build_plan(self.source, self.target, previous)

        self.assertEqual(plan.copies, ())
        self.assertEqual(
            plan.conflicts[0].reason, "target changed while upstream is unchanged"
        )

    def test_upstream_change_replaces_unchanged_baseline_target(self) -> None:
        write(self.source / "Templates/math/value.hpp", "upstream\n")
        write(self.target / "Templates/math/value.hpp", "base\n")
        file = sync.ManagedFile(
            PurePosixPath("math/value.hpp"), PurePosixPath("math/value.hpp")
        )
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(file,),
            fingerprints=((file.source, sha256("base\n")),),
        )

        plan = sync.build_plan(self.source, self.target, previous)

        self.assertEqual(plan.copies, (file,))
        self.assertEqual(plan.conflicts, ())

    def test_divergent_upstream_and_target_changes_conflict(self) -> None:
        write(self.source / "Templates/math/value.hpp", "upstream\n")
        write(self.target / "Templates/math/value.hpp", "local\n")
        file = sync.ManagedFile(
            PurePosixPath("math/value.hpp"), PurePosixPath("math/value.hpp")
        )
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(file,),
            fingerprints=((file.source, sha256("base\n")),),
        )

        plan = sync.build_plan(self.source, self.target, previous)

        self.assertEqual(plan.copies, ())
        self.assertEqual(
            plan.conflicts[0].reason,
            "upstream and target both changed from baseline",
        )

    def test_unchanged_owned_file_is_not_copied(self) -> None:
        write(self.source / "Templates/math/same.hpp", "same\n")
        write(self.target / "Templates/math/same.hpp", "same\n")
        previous = sync.Manifest(
            repository="https://example.invalid/source.git",
            ref="master",
            commit="old",
            files=(
                sync.ManagedFile(
                    PurePosixPath("math/same.hpp"), PurePosixPath("math/same.hpp")
                ),
            ),
        )

        plan = sync.build_plan(self.source, self.target, previous)

        self.assertEqual(plan.copies, ())
        self.assertEqual(plan.deletes, ())
        self.assertEqual(
            plan.unchanged,
            (
                sync.ManagedFile(
                    PurePosixPath("math/same.hpp"), PurePosixPath("math/same.hpp")
                ),
            ),
        )


class EntryAuditTests(RepositoryFixture):
    def test_entry_audit_follows_includes_and_reports_missing_headers(self) -> None:
        write(self.target / "Templates/main.typ", '#include "math/main.typ"\n')
        write(
            self.target / "Templates/math/main.typ",
            '#raw(read("fft.hpp"), lang: "cpp", block: true)\n',
        )
        managed = (
            sync.ManagedFile(
                PurePosixPath("math/fft.hpp"), PurePosixPath("math/fft.hpp")
            ),
            sync.ManagedFile(
                PurePosixPath("math/ntt.hpp"), PurePosixPath("math/ntt.hpp")
            ),
        )

        self.assertEqual(
            sync.find_unreferenced_targets(self.target, managed),
            (PurePosixPath("math/ntt.hpp"),),
        )

    def test_entry_audit_resolves_nested_relative_paths(self) -> None:
        write(self.target / "Templates/main.typ", '#include "graph/main.typ"\n')
        write(
            self.target / "Templates/graph/main.typ",
            '#include "network_flow/main.typ"\n',
        )
        write(
            self.target / "Templates/graph/network_flow/main.typ",
            '#raw(read("network_flow.hpp"), lang: "cpp", block: true)\n',
        )
        managed = (
            sync.ManagedFile(
                PurePosixPath("graph/network_flow/network_flow.hpp"),
                PurePosixPath("graph/network_flow/network_flow.hpp"),
            ),
        )

        self.assertEqual(sync.find_unreferenced_targets(self.target, managed), ())


class DirtyWorktreeTests(RepositoryFixture):
    def setUp(self) -> None:
        super().setUp()
        subprocess.run(["git", "init", "-q", self.target], check=True)
        write(self.target / "Templates/math/managed.hpp", "base\n")
        write(self.target / "README.md", "base\n")
        write(self.target / "scripts/upstream-template-manifest.json", "{}\n")
        subprocess.run(
            ["git", "-C", str(self.target), "add", "."],
            check=True,
        )
        subprocess.run(
            [
                "git",
                "-C",
                str(self.target),
                "-c",
                "user.name=Test",
                "-c",
                "user.email=test@example.invalid",
                "commit",
                "-qm",
                "fixture",
            ],
            check=True,
        )

    def test_dirty_guard_ignores_unrelated_file(self) -> None:
        write(self.target / "README.md", "changed\n")
        managed = (
            sync.ManagedFile(
                PurePosixPath("math/managed.hpp"),
                PurePosixPath("math/managed.hpp"),
            ),
        )

        self.assertEqual(
            sync.find_dirty_managed_paths(
                self.target,
                managed,
                PurePosixPath("scripts/upstream-template-manifest.json"),
            ),
            (),
        )

    def test_dirty_guard_reports_managed_file(self) -> None:
        write(self.target / "Templates/math/managed.hpp", "changed\n")
        managed = (
            sync.ManagedFile(
                PurePosixPath("math/managed.hpp"),
                PurePosixPath("math/managed.hpp"),
            ),
        )

        dirty = sync.find_dirty_managed_paths(
            self.target,
            managed,
            PurePosixPath("scripts/upstream-template-manifest.json"),
        )

        self.assertEqual(dirty, ("Templates/math/managed.hpp",))


class CliTests(RepositoryFixture):
    def test_network_source_clones_requested_repository_and_ref(self) -> None:
        commands = []

        def fake_run(command, **kwargs):
            commands.append(command)
            destination = Path(command[-1])
            (destination / "Templates").mkdir(parents=True)
            return subprocess.CompletedProcess(command, 0)

        with patch.object(sync.subprocess, "run", side_effect=fake_run):
            with sync.acquire_source(
                "https://github.com/example/upstream.git", "topic", None
            ) as source:
                self.assertTrue((source / "Templates").is_dir())

        self.assertEqual(len(commands), 1)
        self.assertEqual(
            commands[0][:-1],
            [
                "git",
                "clone",
                "--depth",
                "1",
                "--branch",
                "topic",
                "--single-branch",
                "https://github.com/example/upstream.git",
            ],
        )


class WorkflowTests(unittest.TestCase):
    def test_workflow_contract(self) -> None:
        workflow_path = (
            Path(__file__).resolve().parents[1]
            / ".github/workflows/sync-upstream-templates.yml"
        )
        content = workflow_path.read_text(encoding="utf-8")

        for required in (
            "schedule:",
            "workflow_dispatch:",
            "contents: write",
            "pull-requests: write",
            "actions/checkout@v6",
            "automation/sync-algorithm-templates",
            "sync_upstream_templates.py --apply",
            "sync_upstream_templates.py --check-entries",
            "git push --force-with-lease",
            "gh pr create",
            "gh pr edit",
        ):
            with self.subTest(required=required):
                self.assertIn(required, content)
        self.assertNotIn("typst compile", content)
        self.assertNotIn("gh release", content)


if __name__ == "__main__":
    unittest.main()
