# Upstream Template Sync Automation Design

## Goal

Keep the codebook's shared algorithm templates synchronized with
`JimmyWang0417/Algorithm-Competitive-Codes` on GitHub without treating a
neighboring dirty worktree as authoritative, while preserving codebook-only
Typst and Markdown content.

## Source of Truth

- Repository: `https://github.com/JimmyWang0417/Algorithm-Competitive-Codes.git`
- Default ref: `master`
- Each run records the resolved upstream commit in a versioned manifest.
- `../Algorithm-Competitive-Codes` may be inspected for maintenance guidance
  and upcoming changes, but uncommitted or unpushed files are never imported.

The baseline for this design is upstream commit
`83bb30e44e3cfc7cea24b0ffd4e3ea9c8eb7c010`. At that commit all managed target
templates match upstream, except for the user's existing uncommitted edit to
`Templates/initialization_misc/makefile`; automation must not overwrite that
local edit.

## Chosen Approach

Use a standard-library Python synchronizer backed by a committed JSON
manifest. The script clones the requested GitHub ref into a temporary
directory unless a local source checkout is explicitly supplied for testing.
It discovers upstream `Templates/**/*.hpp` files and
`Templates/initialization_misc/makefile`, maps them to target paths, and either
checks or safely applies the resulting transaction.

This is preferred over a submodule or whole-directory mirror because the
codebook deliberately contains target-only notes, split geometry components,
and Typst entry files. It is preferred over reading the sibling worktree
because GitHub is the requested authority and the sibling currently contains
unpublished template experiments.

## Path and Preservation Rules

- Most upstream files retain their path below `Templates/`.
- `geometry/2d.hpp` maps to `geometry/2D/2d.hpp`.
- `geometry/3d.hpp` maps to `geometry/3D/3d.hpp`.
- Target-only `.typ`, Markdown, images, split geometry headers, and graph
  templates remain untouched.
- A newly discovered upstream path is added to the manifest and copied unless
  its target collides with an unowned target file; collisions fail visibly.
- A path removed upstream is deleted only when the old manifest proves that
  it was managed by the synchronizer.
- Apply mode refuses to start when a managed target or the manifest has local
  changes, so it cannot overwrite in-progress work.

## Commands and Interfaces

The synchronizer supports:

```text
python3 scripts/sync_upstream_templates.py --check
python3 scripts/sync_upstream_templates.py --apply
python3 scripts/sync_upstream_templates.py --check-entries
```

`--repository`, `--ref`, and `--source-dir` make the source explicit and keep
tests network-free. Check mode reports content and manifest drift without
writing. Apply mode updates managed files and the manifest. Entry-check mode
walks reachable Typst includes and reports upstream headers that have no
`#raw(read(...))` entry.

## GitHub Automation

A scheduled and manually dispatchable workflow checks out this repository,
runs apply mode against upstream GitHub, updates a fixed automation branch,
and creates or refreshes one pull request. The pull request body records the
resolved upstream commit and lists any new headers that still need a deliberate
Typst heading or explanatory text. A fixed branch and workflow concurrency
prevent duplicate pull requests.

The workflow does not publish releases. Normal pull-request checks remain
responsible for compiling the two codebooks after the update is reviewed.

## Documentation

- `agend.md` records GitHub authority, local-worktree limitations, template
  style learned from the sibling repository, and the sync checklist.
- `README.md` documents the three operator commands and the automatic PR.
- `docs/template-sync.md` provides the complete maintainer procedure and
  explains how new files and conflicts are handled.

## Validation for This Update

This round intentionally does not compile C++ or Typst and does not build PDF
artifacts. Validation is limited to:

1. Unit tests with temporary source and target repositories for discovery,
   geometry mapping, check/apply behavior, removal, collision protection, and
   reachable-entry detection.
2. A check against the freshly cloned upstream commit.
3. Python syntax validation and workflow YAML inspection.
4. A final Git diff audit proving that the pre-existing Makefile edit was not
   overwritten or staged.

