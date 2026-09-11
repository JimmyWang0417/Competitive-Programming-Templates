# Algorithm Template Synchronization Design

## Goal

Synchronize every current algorithm-template change from the sibling
`Algorithm-Competitive-Codes` worktree into this Typst-generated codebook while
preserving codebook-only notes and ensuring that every newly imported template
has a deliberate table-of-contents entry.

## Authoritative Source and Baseline

- Source worktree: `../Algorithm-Competitive-Codes`
- Last shared template snapshot: source commit `039ad99`
- Committed source range: `039ad99..a1e71cb`
- The source worktree itself is authoritative. During implementation its
  previously uncommitted `Templates/graph/virtual_tree.hpp` was committed as
  `a1e71cb`; the synchronized content was rechecked against that commit.

The baseline was verified against the target before this design was written.
Every changed pre-existing source template matches the corresponding target
file at `039ad99`, except for these already-understood layout differences:

- `Templates/geometry/2d.hpp` maps to
  `Templates/geometry/2D/2d.hpp` in this repository.
- `Templates/geometry/3d.hpp` maps to
  `Templates/geometry/3D/3d.hpp` in this repository.
- `Templates/data_structure/segment_tree_beats.hpp` was already absent here;
  its source-side deletion therefore requires no target deletion.

## Chosen Approach

Apply the source range as a template-level transaction rather than mirroring
the whole directory. Copy each modified or added source template at its current
worktree content, remove superseded target templates where the source range
contains a deletion or move, and retain target-only Typst notes and split
geometry components.

This approach is preferred over whole-directory mirroring because the target
contains substantial codebook-only material. It is preferred over importing
only new files because the source range also modernizes many existing data
structure, geometry, graph, math, and string templates.

## File and Section Design

### Existing Sections

- Data structures: refresh changed templates and add sparse table to
  `Templates/data_structure/main.typ`.
- Geometry: refresh the mapped combined 2D and 3D templates; replace the old
  standalone closest-pair program with the new reusable header and update the
  geometry entry.
- Graphs: refresh changed templates and add LCA, virtual tree, long-chain
  decomposition, centroid decomposition, centroid tree, and cycle-canceling
  min-cost flow in conceptually adjacent subsections.
- Math: refresh changed templates, adopt the source's flattened
  `polynomial.hpp`, `lagrange.hpp`, `linear_recurrence.hpp`, and lowercase
  `simpson.hpp` layout, and add K-FWT next to FWT.
- Initialization and strings: refresh the source-changed code without changing
  the established explanatory-note order.

### New Sections

- `Templates/dynamic_programming/main.typ` presents monotone DP and plug DP.
- `Templates/misc_algorithm/main.typ` presents CDQ divide-and-conquer,
  parallel binary search, dancing links, and ODT.
- `Templates/main.typ` includes both sections in a stable high-level order:
  initialization, geometry, graph, strings, data structures, dynamic
  programming, math, miscellaneous algorithms.

Each imported source file must be reachable from one of these Typst entry
files. A source file is not considered synchronized merely because it exists on
disk.

## Preservation Rules

- Preserve all target-only `.typ`, Markdown tutorial, theme, image, and split
  geometry-component files.
- Preserve the existing Johnson and Prüfer notes and their ordering.
- Do not import contest solutions or unrelated source-repository files.
- Do not rewrite source algorithm code while syncing it.
- Do not overwrite unrelated user changes; the target worktree is clean at the
  start of implementation.

## Validation

1. Compile representative changed C++ headers with a standard C++23 prelude;
   where a header intentionally depends on another template, include that
   dependency explicitly in the validation harness.
2. Check every current source template against the synchronized target using
   identical paths, plus the two documented geometry mappings.
3. Check that every source template imported as a new file is referenced by a
   reachable Typst `main.typ` entry.
4. Compile both published documents with Typst 0.15.1:
   `codebook/wide/main.typ` and `codebook/compact/main.typ`.
5. Regenerate README statistics and the directory tree with `Generator.py`,
   then repeat both Typst builds so the committed metadata describes the final
   tree.

## Failure Handling

- If a Typst build reports a missing path, fix the section entry or mapped path
  and rerun both layouts.
- If C++ syntax validation reveals an upstream code defect rather than a
  missing harness dependency, keep the synchronized source visible and report
  the exact file; do not silently diverge the repositories.
- If the source worktree changes during implementation, recompute the source
  manifest and incorporate the new template change before declaring the sync
  complete.
