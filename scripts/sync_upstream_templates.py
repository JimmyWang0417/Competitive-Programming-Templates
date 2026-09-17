#!/usr/bin/env python3
"""Synchronize managed templates from the GitHub upstream repository."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Iterator, Sequence


DEFAULT_REPOSITORY = (
    "https://github.com/JimmyWang0417/Algorithm-Competitive-Codes.git"
)
DEFAULT_REF = "master"
DEFAULT_MANIFEST = PurePosixPath("scripts/upstream-template-manifest.json")
MAKEFILE_PATH = PurePosixPath("initialization_misc/makefile")
PATH_MAPPINGS = {
    PurePosixPath("geometry/2d.hpp"): PurePosixPath("geometry/2D/2d.hpp"),
    PurePosixPath("geometry/3d.hpp"): PurePosixPath("geometry/3D/3d.hpp"),
}

INCLUDE_RE = re.compile(r'#include\s+"([^"]+)"')
RAW_READ_RE = re.compile(r'#raw\s*\(\s*read\s*\(\s*"([^"]+)"')


class SyncError(RuntimeError):
    """Raised when synchronization cannot proceed safely."""


@dataclass(frozen=True, order=True)
class ManagedFile:
    source: PurePosixPath
    target: PurePosixPath


@dataclass(frozen=True)
class Manifest:
    repository: str
    ref: str
    commit: str
    files: tuple[ManagedFile, ...]
    fingerprints: tuple[tuple[PurePosixPath, str], ...] = ()

    def __post_init__(self) -> None:
        object.__setattr__(self, "files", tuple(sorted(self.files)))
        object.__setattr__(self, "fingerprints", tuple(sorted(self.fingerprints)))

    def fingerprint_for(self, source: PurePosixPath) -> str | None:
        return dict(self.fingerprints).get(source)


@dataclass(frozen=True, order=True)
class SyncConflict:
    file: ManagedFile
    reason: str


@dataclass(frozen=True)
class SyncPlan:
    files: tuple[ManagedFile, ...]
    copies: tuple[ManagedFile, ...]
    deletes: tuple[ManagedFile, ...]
    unchanged: tuple[ManagedFile, ...]
    conflicts: tuple[SyncConflict, ...]


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _validate_relative_path(path: PurePosixPath, label: str) -> None:
    if path.is_absolute() or not path.parts or ".." in path.parts:
        raise SyncError(f"invalid {label} path: {path}")


def map_target_path(source: PurePosixPath) -> PurePosixPath:
    """Map one path relative to upstream Templates/ into this repository."""

    _validate_relative_path(source, "source")
    return PATH_MAPPINGS.get(source, source)


def discover_managed_files(source_root: Path) -> tuple[ManagedFile, ...]:
    """Discover the upstream files that belong to the synchronization surface."""

    templates_root = source_root / "Templates"
    if not templates_root.is_dir():
        raise SyncError(f"upstream Templates directory does not exist: {templates_root}")

    source_paths = {
        PurePosixPath(path.relative_to(templates_root).as_posix())
        for path in templates_root.rglob("*.hpp")
        if path.is_file()
    }
    if (templates_root / MAKEFILE_PATH).is_file():
        source_paths.add(MAKEFILE_PATH)

    files = tuple(
        ManagedFile(source=source, target=map_target_path(source))
        for source in sorted(source_paths)
    )
    targets: dict[PurePosixPath, PurePosixPath] = {}
    for item in files:
        previous = targets.setdefault(item.target, item.source)
        if previous != item.source:
            raise SyncError(
                f"duplicate target mapping: {previous} and {item.source} -> {item.target}"
            )
    return files


def load_manifest(path: Path) -> Manifest:
    """Load and validate the versioned synchronization manifest."""

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise SyncError(f"manifest does not exist: {path}") from error
    except (OSError, json.JSONDecodeError) as error:
        raise SyncError(f"cannot read manifest {path}: {error}") from error

    try:
        repository = data["repository"]
        ref = data["ref"]
        commit = data["commit"]
        raw_files = data["files"]
        if not all(isinstance(value, str) for value in (repository, ref, commit)):
            raise TypeError("repository, ref, and commit must be strings")
        files = []
        fingerprints = []
        for entry in raw_files:
            source = PurePosixPath(entry["source"])
            target = PurePosixPath(entry["target"])
            _validate_relative_path(source, "source")
            _validate_relative_path(target, "target")
            files.append(ManagedFile(source, target))
            fingerprint = entry.get("sha256")
            if fingerprint is not None:
                if not re.fullmatch(r"[0-9a-f]{64}", fingerprint):
                    raise ValueError(f"invalid SHA-256 for {source}")
                fingerprints.append((source, fingerprint))
    except (KeyError, TypeError, ValueError) as error:
        raise SyncError(f"invalid manifest {path}: {error}") from error

    manifest = Manifest(repository, ref, commit, tuple(files), tuple(fingerprints))
    if len({item.source for item in manifest.files}) != len(manifest.files):
        raise SyncError(f"manifest contains duplicate source paths: {path}")
    if len({item.target for item in manifest.files}) != len(manifest.files):
        raise SyncError(f"manifest contains duplicate target paths: {path}")
    if len({source for source, _ in manifest.fingerprints}) != len(
        manifest.fingerprints
    ):
        raise SyncError(f"manifest contains duplicate fingerprints: {path}")
    return manifest


def write_manifest(path: Path, manifest: Manifest) -> None:
    """Atomically write a deterministic synchronization manifest."""

    data = {
        "repository": manifest.repository,
        "ref": manifest.ref,
        "commit": manifest.commit,
        "files": [
            {
                "source": item.source.as_posix(),
                "target": item.target.as_posix(),
                **(
                    {"sha256": manifest.fingerprint_for(item.source)}
                    if manifest.fingerprint_for(item.source) is not None
                    else {}
                ),
            }
            for item in manifest.files
        ],
    }
    content = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", dir=path.parent, text=True
    )
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as output:
            output.write(content)
        os.replace(temporary_name, path)
    except BaseException:
        try:
            os.unlink(temporary_name)
        except FileNotFoundError:
            pass
        raise


def build_plan(
    source_root: Path, target_root: Path, previous_manifest: Manifest
) -> SyncPlan:
    """Plan changes without writing to the target repository."""

    current_files = discover_managed_files(source_root)
    previous_sources = {item.source: item for item in previous_manifest.files}
    previous_targets = {item.target for item in previous_manifest.files}
    current_sources = {item.source for item in current_files}
    current_targets = {item.target for item in current_files}

    copies = []
    unchanged = []
    conflicts = []
    for item in current_files:
        source_path = source_root / "Templates" / item.source
        target_path = target_root / "Templates" / item.target
        source_fingerprint = file_sha256(source_path)
        previous_fingerprint = previous_manifest.fingerprint_for(item.source)
        if target_path.exists() and item.target not in previous_targets:
            if target_path.is_file() and file_sha256(target_path) == source_fingerprint:
                unchanged.append(item)
            else:
                conflicts.append(
                    SyncConflict(item, "new upstream path collides with unowned target")
                )
            continue
        if target_path.is_dir():
            conflicts.append(SyncConflict(item, "managed target is a directory"))
            continue
        if target_path.is_file() and file_sha256(target_path) == source_fingerprint:
            unchanged.append(item)
        elif item.source in previous_sources and not target_path.exists():
            conflicts.append(SyncConflict(item, "managed target was deleted locally"))
        elif previous_fingerprint is None:
            copies.append(item)
        else:
            target_fingerprint = file_sha256(target_path)
            if source_fingerprint == previous_fingerprint:
                conflicts.append(
                    SyncConflict(item, "target changed while upstream is unchanged")
                )
            elif target_fingerprint == previous_fingerprint:
                copies.append(item)
            else:
                conflicts.append(
                    SyncConflict(item, "upstream and target both changed from baseline")
                )

    deletes = []
    for source, item in previous_sources.items():
        if source in current_sources or item.target in current_targets:
            continue
        target_path = target_root / "Templates" / item.target
        previous_fingerprint = previous_manifest.fingerprint_for(source)
        if (
            target_path.is_file()
            and previous_fingerprint is not None
            and file_sha256(target_path) != previous_fingerprint
        ):
            conflicts.append(
                SyncConflict(item, "upstream removed a target changed locally")
            )
        else:
            deletes.append(item)
    return SyncPlan(
        files=current_files,
        copies=tuple(copies),
        deletes=tuple(sorted(deletes)),
        unchanged=tuple(unchanged),
        conflicts=tuple(sorted(conflicts)),
    )


def apply_plan(plan: SyncPlan, source_root: Path, target_root: Path) -> None:
    """Apply a previously validated plan to the target repository."""

    if plan.conflicts:
        raise SyncError("cannot apply a synchronization plan with conflicts")
    for item in plan.copies:
        source_path = source_root / "Templates" / item.source
        target_path = target_root / "Templates" / item.target
        target_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source_path, target_path)
    for item in plan.deletes:
        target_path = target_root / "Templates" / item.target
        try:
            target_path.unlink()
        except FileNotFoundError:
            pass


def find_dirty_managed_paths(
    target_root: Path,
    files: Sequence[ManagedFile],
    manifest_path: PurePosixPath = DEFAULT_MANIFEST,
) -> tuple[str, ...]:
    """Return dirty managed paths while ignoring unrelated worktree changes."""

    pathspecs = sorted(
        {f"Templates/{item.target.as_posix()}" for item in files}
        | {manifest_path.as_posix()}
    )
    command = [
        "git",
        "-C",
        str(target_root),
        "status",
        "--porcelain=v1",
        "--untracked-files=all",
        "--",
        *pathspecs,
    ]
    try:
        result = subprocess.run(
            command,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        detail = error.stderr.strip() or str(error)
        raise SyncError(f"cannot inspect target worktree: {detail}") from error

    dirty = []
    for line in result.stdout.splitlines():
        if len(line) >= 4:
            dirty.append(line[3:].strip('"'))
    return tuple(sorted(dirty))


def _relative_to_templates(path: Path, templates_root: Path) -> PurePosixPath:
    try:
        return PurePosixPath(path.resolve().relative_to(templates_root.resolve()).as_posix())
    except ValueError as error:
        raise SyncError(f"Typst path escapes Templates/: {path}") from error


def find_reachable_raw_reads(target_root: Path) -> frozenset[PurePosixPath]:
    """Collect #raw(read()) paths reachable from Templates/main.typ."""

    templates_root = target_root / "Templates"
    entry = templates_root / "main.typ"
    if not entry.is_file():
        raise SyncError(f"Typst entry does not exist: {entry}")

    pending = [entry.resolve()]
    visited: set[Path] = set()
    raw_reads: set[PurePosixPath] = set()
    while pending:
        current = pending.pop()
        if current in visited:
            continue
        visited.add(current)
        try:
            content = current.read_text(encoding="utf-8")
        except OSError as error:
            raise SyncError(f"cannot read Typst entry {current}: {error}") from error

        for relative in INCLUDE_RE.findall(content):
            include_path = (current.parent / relative).resolve()
            _relative_to_templates(include_path, templates_root)
            if not include_path.is_file():
                raise SyncError(f"included Typst file does not exist: {include_path}")
            pending.append(include_path)
        for relative in RAW_READ_RE.findall(content):
            raw_path = (current.parent / relative).resolve()
            raw_reads.add(_relative_to_templates(raw_path, templates_root))
    return frozenset(raw_reads)


def find_unreferenced_targets(
    target_root: Path, files: Sequence[ManagedFile]
) -> tuple[PurePosixPath, ...]:
    """Return managed headers absent from reachable Typst raw-read entries."""

    referenced = find_reachable_raw_reads(target_root)
    return tuple(
        sorted(
            item.target
            for item in files
            if item.target.suffix == ".hpp" and item.target not in referenced
        )
    )


def resolve_upstream_commit(source_root: Path, override: str | None = None) -> str:
    """Resolve the exact source commit for the manifest and workflow report."""

    if override:
        return override
    try:
        result = subprocess.run(
            ["git", "-C", str(source_root), "rev-parse", "HEAD"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        detail = error.stderr.strip() or str(error)
        raise SyncError(f"cannot resolve upstream commit: {detail}") from error
    return result.stdout.strip()


@contextmanager
def acquire_source(
    repository: str, ref: str, source_dir: Path | None
) -> Iterator[Path]:
    """Yield an explicit source checkout, cloning GitHub when necessary."""

    if source_dir is not None:
        source_dir = source_dir.resolve()
        if not (source_dir / "Templates").is_dir():
            raise SyncError(f"source checkout has no Templates directory: {source_dir}")
        yield source_dir
        return

    with tempfile.TemporaryDirectory(prefix="template-sync-upstream.") as directory:
        destination = Path(directory) / "source"
        command = [
            "git",
            "clone",
            "--depth",
            "1",
            "--branch",
            ref,
            "--single-branch",
            repository,
            str(destination),
        ]
        try:
            subprocess.run(command, check=True)
        except subprocess.CalledProcessError as error:
            raise SyncError(f"cannot clone upstream repository: {error}") from error
        yield destination


def _new_manifest(
    repository: str,
    ref: str,
    commit: str,
    files: tuple[ManagedFile, ...],
    source_root: Path,
) -> Manifest:
    fingerprints = tuple(
        (item.source, file_sha256(source_root / "Templates" / item.source))
        for item in files
    )
    return Manifest(
        repository=repository,
        ref=ref,
        commit=commit,
        files=files,
        fingerprints=fingerprints,
    )


def retain_commit_for_unchanged_baseline(
    candidate: Manifest, previous: Manifest
) -> Manifest:
    """Avoid manifest churn when upstream changed outside Templates/."""

    if (
        candidate.repository == previous.repository
        and candidate.ref == previous.ref
        and candidate.files == previous.files
        and candidate.fingerprints == previous.fingerprints
    ):
        return Manifest(
            repository=candidate.repository,
            ref=candidate.ref,
            commit=previous.commit,
            files=candidate.files,
            fingerprints=candidate.fingerprints,
        )
    return candidate


def _print_plan(plan: SyncPlan, manifest_changed: bool) -> None:
    for item in plan.copies:
        print(f"COPY Templates/{item.source} -> Templates/{item.target}")
    for item in plan.deletes:
        print(f"DELETE Templates/{item.target}")
    for conflict in plan.conflicts:
        print(f"CONFLICT Templates/{conflict.file.target}: {conflict.reason}")
    if manifest_changed:
        print(f"UPDATE {DEFAULT_MANIFEST}")


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true", help="report synchronization drift")
    mode.add_argument("--apply", action="store_true", help="safely apply upstream changes")
    mode.add_argument(
        "--check-entries",
        action="store_true",
        help="report managed headers missing from reachable Typst entries",
    )
    parser.add_argument("--repository", default=DEFAULT_REPOSITORY)
    parser.add_argument("--ref", default=DEFAULT_REF)
    parser.add_argument("--source-dir", type=Path)
    parser.add_argument(
        "--source-commit",
        help="explicit commit identifier for a non-Git fixture or controlled checkout",
    )
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help=argparse.SUPPRESS,
    )
    return parser


def run(arguments: argparse.Namespace) -> int:
    target_root = arguments.repo_root.resolve()
    manifest_path = target_root / DEFAULT_MANIFEST
    previous_manifest = load_manifest(manifest_path)

    with acquire_source(arguments.repository, arguments.ref, arguments.source_dir) as source:
        commit = resolve_upstream_commit(source, arguments.source_commit)
        print(f"UPSTREAM_COMMIT={commit}")
        current_files = discover_managed_files(source)

        if arguments.check_entries:
            missing = find_unreferenced_targets(target_root, current_files)
            if missing:
                for path in missing:
                    print(f"MISSING_ENTRY=Templates/{path}")
                return 1
            print("All managed upstream headers have reachable Typst entries.")
            return 0

        plan = build_plan(source, target_root, previous_manifest)
        new_manifest = retain_commit_for_unchanged_baseline(
            _new_manifest(
                arguments.repository, arguments.ref, commit, current_files, source
            ),
            previous_manifest,
        )
        manifest_changed = new_manifest != previous_manifest

        if arguments.check:
            _print_plan(plan, manifest_changed)
            if plan.copies or plan.deletes or plan.conflicts or manifest_changed:
                return 1
            print("Managed templates match the requested GitHub upstream.")
            return 0

        if plan.conflicts:
            _print_plan(plan, manifest_changed)
            raise SyncError("synchronization conflicts require maintainer review")
        guarded_files = tuple(sorted(set(previous_manifest.files) | set(current_files)))
        dirty = find_dirty_managed_paths(target_root, guarded_files)
        if dirty:
            details = "\n".join(f"  {path}" for path in dirty)
            raise SyncError(f"managed paths have local changes:\n{details}")
        apply_plan(plan, source, target_root)
        write_manifest(manifest_path, new_manifest)
        _print_plan(plan, manifest_changed)
        if not plan.copies and not plan.deletes and not manifest_changed:
            print("Managed templates already match the requested GitHub upstream.")
        return 0


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_argument_parser()
    try:
        return run(parser.parse_args(argv))
    except SyncError as error:
        print(f"error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
