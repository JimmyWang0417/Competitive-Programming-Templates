# Upstream Template Sync Automation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a safe, GitHub-backed template synchronizer and a scheduled/manual workflow that proposes upstream changes through one reviewable pull request.

**Architecture:** A Python standard-library CLI discovers the upstream template surface, applies two explicit geometry mappings, and compares or updates only manifest-owned target files. A committed JSON manifest records the resolved upstream commit and managed source-to-target paths; a GitHub workflow runs apply mode on a clean checkout and maintains a fixed automation pull request, while a separate entry audit reports headers missing from reachable Typst content.

**Tech Stack:** Python 3 standard library, `unittest`, Git, GitHub CLI, GitHub Actions YAML, Typst source text

## Global Constraints

- The default source is exactly `https://github.com/JimmyWang0417/Algorithm-Competitive-Codes.git` at ref `master`.
- Never read template content from `../Algorithm-Competitive-Codes` unless a caller explicitly passes it through `--source-dir` for an offline check.
- Manage only upstream `Templates/**/*.hpp` and `Templates/initialization_misc/makefile`.
- Map `geometry/2d.hpp` to `geometry/2D/2d.hpp` and `geometry/3d.hpp` to `geometry/3D/3d.hpp`.
- Preserve all target-only Typst, Markdown, images, split geometry headers, and graph templates.
- Apply mode must refuse to overwrite local changes to managed targets or the manifest.
- New upstream files that collide with unowned target files must fail instead of overwriting them.
- Do not compile C++, compile Typst, generate PDFs, publish releases, push branches, or create pull requests during this implementation turn.
- Preserve the existing uncommitted edit to `Templates/initialization_misc/makefile` and never stage it.

---

### Task 1: Synchronization Core and Baseline Manifest

**Files:**
- Create: `scripts/sync_upstream_templates.py`
- Create: `scripts/upstream-template-manifest.json`
- Create: `tests/test_sync_upstream_templates.py`

**Interfaces:**
- Consumes: an upstream checkout containing `Templates/`, a target repository root, and the previous JSON manifest.
- Produces: `ManagedFile(source: PurePosixPath, target: PurePosixPath)` values, a deterministic manifest, and check/apply results.
- Public functions used by tests: `map_target_path()`, `discover_managed_files()`, `load_manifest()`, `build_plan()`, `apply_plan()`, and `resolve_upstream_commit()`.

- [x] **Step 1: Write failing discovery and mapping tests**

Add tests that create an upstream fixture containing ordinary headers, the two geometry headers, the Makefile, and ignored `.typ`/`.cpp` files:

```python
def test_discovery_maps_only_managed_files(self):
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
```

- [x] **Step 2: Run the focused test and verify failure**

Run:

```bash
python3 -m unittest tests.test_sync_upstream_templates.DiscoveryTests -v
```

Expected: import or missing-function failure because the synchronizer does not exist.

- [x] **Step 3: Implement deterministic discovery and manifest I/O**

Implement the exact model and mapping boundary:

```python
@dataclass(frozen=True, order=True)
class ManagedFile:
    source: PurePosixPath
    target: PurePosixPath

PATH_MAPPINGS = {
    PurePosixPath("geometry/2d.hpp"): PurePosixPath("geometry/2D/2d.hpp"),
    PurePosixPath("geometry/3d.hpp"): PurePosixPath("geometry/3D/3d.hpp"),
}

def map_target_path(source: PurePosixPath) -> PurePosixPath:
    return PATH_MAPPINGS.get(source, source)
```

Discover sorted `*.hpp` paths plus the exact Makefile. Serialize repository,
ref, commit, and sorted `{source, target}` objects with UTF-8, two-space
indentation, and a trailing newline.

- [x] **Step 4: Add failing plan/apply safety tests**

Cover all transaction cases:

```python
def test_apply_updates_adds_and_removes_only_owned_targets(self):
    # old.hpp is present in the previous manifest but absent upstream.
    # keep.typ is target-only. new.hpp is new upstream content.
    plan = sync.build_plan(self.source, self.target, previous_manifest)
    sync.apply_plan(plan, self.source, self.target)
    self.assertFalse((self.target / "Templates/math/old.hpp").exists())
    self.assertEqual((self.target / "Templates/math/new.hpp").read_text(), "new\n")
    self.assertEqual((self.target / "Templates/math/keep.typ").read_text(), "keep\n")

def test_new_upstream_path_cannot_overwrite_unowned_target(self):
    write(self.source / "Templates/math/new.hpp", "upstream\n")
    write(self.target / "Templates/math/new.hpp", "target-only\n")
    with self.assertRaisesRegex(sync.SyncError, "unowned target"):
        sync.build_plan(self.source, self.target, empty_manifest)
```

Also assert that check mode reports changed content and that manifest-owned
removals are included in the plan.

- [x] **Step 5: Implement check/apply planning**

Represent a plan as immutable `copies`, `deletes`, and `unchanged` tuples.
Reject duplicate target mappings and unowned collisions. Apply copies with
`shutil.copyfile`, create parent directories, delete only prior manifest-owned
targets, prune no directories, and atomically replace the manifest after file
operations succeed.

- [x] **Step 6: Seed the real baseline manifest from the fresh GitHub clone**

Use the already verified checkout at commit
`83bb30e44e3cfc7cea24b0ffd4e3ea9c8eb7c010`. The manifest must list every
upstream header and Makefile exactly once, including both geometry mappings.

- [x] **Step 7: Run core tests**

Run:

```bash
python3 -m unittest tests.test_sync_upstream_templates.DiscoveryTests tests.test_sync_upstream_templates.ApplyTests -v
```

Expected: all discovery, mapping, collision, copy, and removal tests pass.

### Task 2: CLI, Dirty-Worktree Guard, and Typst Entry Audit

**Files:**
- Modify: `scripts/sync_upstream_templates.py`
- Modify: `tests/test_sync_upstream_templates.py`

**Interfaces:**
- Consumes: `--check`, `--apply`, or `--check-entries`; optional `--repository`, `--ref`, and `--source-dir`.
- Produces: exit code `0` for a satisfied check/apply, `1` for detected drift or missing entries, and `2` for invalid input, collision, clone failure, or unsafe dirty state.

- [x] **Step 1: Write failing CLI and entry-audit tests**

Test reachable Typst traversal, including nested includes resolved relative to
the including file:

```python
def test_entry_audit_follows_includes_and_reports_missing_headers(self):
    write(self.target / "Templates/main.typ", '#include "math/main.typ"\n')
    write(
        self.target / "Templates/math/main.typ",
        '#raw(read("fft.hpp"), lang: "cpp", block: true)\n',
    )
    managed = (
        sync.ManagedFile(PurePosixPath("math/fft.hpp"), PurePosixPath("math/fft.hpp")),
        sync.ManagedFile(PurePosixPath("math/ntt.hpp"), PurePosixPath("math/ntt.hpp")),
    )
    self.assertEqual(
        sync.find_unreferenced_targets(self.target, managed),
        (PurePosixPath("math/ntt.hpp"),),
    )
```

Mock `subprocess.run` to assert that network mode invokes:

```text
git clone --depth 1 --branch <ref> --single-branch <repository> <temporary-path>
```

Test that apply mode rejects porcelain output for a managed target or the
manifest but ignores an unrelated dirty Markdown file.

- [x] **Step 2: Run the new tests and verify failure**

Run:

```bash
python3 -m unittest tests.test_sync_upstream_templates.CliTests tests.test_sync_upstream_templates.EntryAuditTests -v
```

Expected: failures for missing CLI helpers and entry traversal.

- [x] **Step 3: Implement source acquisition and exact CLI modes**

Use `argparse`, `tempfile.TemporaryDirectory`, and `subprocess.run(...,
check=True)`. `--source-dir` bypasses cloning. Resolve the commit with
`git -C SOURCE rev-parse HEAD`; when a fixture has no `.git`, accept
`--source-commit` so tests and controlled offline runs still produce an exact
manifest.

Before apply, query:

```text
git status --porcelain --untracked-files=all -- <managed targets> scripts/upstream-template-manifest.json
```

Abort on nonempty output. Do not use broad worktree cleanliness as a gate.

- [x] **Step 4: Implement reachable Typst entry traversal**

Start at `Templates/main.typ`, recursively resolve `#include "..."`, and
collect target paths from `#raw(read("..."), ...)` relative to each including
file. Report only managed `.hpp` targets; the Makefile already has a deliberate
entry but is not part of the header report.

- [x] **Step 5: Run the full unit suite and syntax check**

Run:

```bash
python3 -m unittest discover -s tests -v
python3 -m py_compile scripts/sync_upstream_templates.py tests/test_sync_upstream_templates.py
```

Expected: all tests pass and both Python files compile. This is not a C++ or
Typst build.

### Task 3: Maintainer Memory and Operator Documentation

**Files:**
- Modify: `agend.md`
- Modify: `README.md`
- Create: `docs/template-sync.md`
- Modify: `docs/README.md`

**Interfaces:**
- Consumes: the sibling repository's template-style memory and the new CLI.
- Produces: one unambiguous authority rule, local commands, automation behavior, and manual review requirements.

- [x] **Step 1: Extend template maintenance memory**

State in `agend.md` that GitHub `master` is authoritative and the sibling
worktree is preview-only. Add the sibling-derived rules to preserve method
order, follow surrounding modular-residue conventions without introducing
generic normalization, and keep generic algorithms representation-independent
(including caller-provided `f` and `f'` for Hensel lifting).

- [x] **Step 2: Document operator commands and review flow**

Add this command set to README and the detailed guide:

```bash
python3 scripts/sync_upstream_templates.py --check
python3 scripts/sync_upstream_templates.py --apply
python3 scripts/sync_upstream_templates.py --check-entries
```

Explain that apply requires clean managed paths, target-only notes are
preserved, new headers need deliberate Typst headings, and the automatic PR
does not publish a release.

- [x] **Step 3: Link the guide and audit wording**

Add `docs/template-sync.md` to `docs/README.md`. Search for statements that
still call `../Algorithm-Competitive-Codes` authoritative and mark the 2026-09-12
documents as historical rather than rewriting their recorded implementation.

- [x] **Step 4: Run documentation checks**

Run:

```bash
rg -n "Algorithm-Competitive-Codes|sync_upstream_templates|上游模板同步" README.md agend.md docs/template-sync.md docs/README.md
git diff --check -- README.md agend.md docs/template-sync.md docs/README.md
```

Expected: authority and commands are present, and no whitespace errors exist.

### Task 4: Scheduled and Manual Pull-Request Workflow

**Files:**
- Create: `.github/workflows/sync-upstream-templates.yml`
- Modify: `tests/test_sync_upstream_templates.py`

**Interfaces:**
- Consumes: the synchronizer's apply and entry-check modes.
- Produces: branch `automation/sync-algorithm-templates` and at most one open pull request into `master`.

- [x] **Step 1: Write a failing workflow contract test**

Load the workflow as text and assert it contains the schedule,
`workflow_dispatch`, `contents: write`, `pull-requests: write`, fixed branch,
apply invocation, entry audit, `git push --force-with-lease`, and `gh pr`
create/edit logic. Assert it does not contain release publication or Typst
build commands.

- [x] **Step 2: Run the workflow test and verify failure**

Run:

```bash
python3 -m unittest tests.test_sync_upstream_templates.WorkflowTests -v
```

Expected: failure because the workflow file does not exist.

- [x] **Step 3: Implement the workflow**

Use `actions/checkout@v6`, weekly cron plus manual dispatch, one concurrency
group, and GitHub-provided `GH_TOKEN`. Start from `origin/master`, run apply,
capture entry-audit output without preventing the PR, commit only when `git
status --porcelain` is nonempty, push the fixed branch with
`--force-with-lease`, and create or edit the matching open PR with the upstream
commit and missing-entry checklist.

- [x] **Step 4: Run workflow and regression checks**

Run:

```bash
python3 -m unittest discover -s tests -v
python3 -m py_compile scripts/sync_upstream_templates.py tests/test_sync_upstream_templates.py
git diff --check
```

Expected: all tests pass, Python syntax is valid, and the repository diff has
no whitespace errors. Do not execute the workflow, push its branch, or build
the codebooks in this turn.

### Task 5: Live Upstream Check and Final Audit

**Files:**
- No additional planned files.

**Interfaces:**
- Consumes: the fresh upstream checkout at `/tmp/algorithm-competitive-codes-upstream.bvhv17/source`.
- Produces: evidence that the manifest matches commit `83bb30e...`, a precise report of the known local Makefile divergence, and a clean implementation diff.

- [x] **Step 1: Check the real upstream without network access**

Run:

```bash
python3 scripts/sync_upstream_templates.py \
  --check \
  --source-dir /tmp/algorithm-competitive-codes-upstream.bvhv17/source
python3 scripts/sync_upstream_templates.py \
  --check-entries \
  --source-dir /tmp/algorithm-competitive-codes-upstream.bvhv17/source
```

Expected: entry coverage passes; content check reports only the pre-existing
local Makefile divergence and makes no changes.

- [x] **Step 2: Prove apply protection on the current dirty worktree**

Run apply mode against the same checkout. Expected: exit code `2` with a
message naming `Templates/initialization_misc/makefile`; its bytes and Git diff
remain unchanged.

- [x] **Step 3: Audit scope and staging**

Run:

```bash
git status --short
git diff -- Templates/initialization_misc/makefile
git diff --stat
git diff --check
```

Expected: the existing Makefile edit is still present and unstaged; only the
script, manifest, tests, workflow, and documentation belong to this
implementation.

- [x] **Step 4: Commit implementation files without the Makefile**

```bash
git add scripts tests .github/workflows/sync-upstream-templates.yml agend.md README.md docs/README.md docs/template-sync.md
git commit -m "feat: automate upstream template synchronization"
```

Expected: the commit excludes `Templates/initialization_misc/makefile` and the
final worktree status shows only that pre-existing modification.
