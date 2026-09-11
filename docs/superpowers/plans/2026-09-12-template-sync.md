# Algorithm Template Synchronization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Synchronize the sibling repository's current algorithm templates into both Typst codebook layouts, with a deliberate entry for every new template.

**Architecture:** Apply the sibling worktree's current template state on top of the verified common snapshot `039ad99`, grouped by subject. Preserve target-only notes and split geometry components, use two explicit geometry path mappings, and expose all imported files through the shared Typst section tree.

**Tech Stack:** C++23 headers, Typst 0.15.1, zsh, Git, `Generator.py`

## Global Constraints

- Read source code from `../Algorithm-Competitive-Codes/Templates` at its current worktree state.
- Do not import contest solutions or unrelated source-repository files.
- Preserve target-only Typst/Markdown prose, themes, images, and split geometry components.
- Do not rewrite imported algorithm code; logical counterparts must compare byte-for-byte.
- Map source `geometry/2d.hpp` to target `geometry/2D/2d.hpp` and source `geometry/3d.hpp` to target `geometry/3D/3d.hpp`.
- Every newly imported header must be referenced by a reachable `main.typ` entry.
- Both wide and compact codebooks must compile with Typst 0.15.1.

## Synchronization Manifest

- Data structure, modify: `decomp_tree.hpp`, `decomposition.hpp`, `dynamic_seg.hpp`, `fenwick.hpp`, `fhq_treap.hpp`, `implicit_treap.hpp`, `lichao.hpp`, `link_cut_tree.hpp`, `persist_implicit_treap.hpp`, `persist_seg.hpp`, `persist_treap.hpp`, `scanline_seg.hpp`, `scapegoat.hpp`, `seg_beats.hpp`, `seg_divide.hpp`, `seg_tree.hpp`, `splay.hpp`, `top_tree.hpp`, `treap.hpp`.
- Data structure, create: `sparse.hpp`.
- Geometry, mapped modify: `2D/2d.hpp`, `3D/3d.hpp`; create `nearest_points.hpp`; delete `nearest_points.cpp`.
- Graph, modify: `block_forest.hpp`, `euler_tour.hpp`, `min_cycle.hpp`, `steiner_tree.hpp`, `stoer_wagner.hpp`, `network_flow/min_cost_flow.hpp`, `network_flow/network_flow.hpp`.
- Graph, create: `lca.hpp`, `virtual_tree.hpp`, `long_chain_dp.hpp`, `centroid_decomposition.hpp`, `centroid_tree.hpp`, `network_flow/cancel_cycle.hpp`.
- Initialization, modify: `io.hpp`.
- Math, modify: `berlekamp_massey.hpp`, `comb.hpp`, `du_sieve.hpp`, `fwt.hpp`, `linear_basis.hpp`, `matrix.hpp`, `min25.hpp`, `modint.hpp`, `number_theory.hpp`, `polynomial.hpp`, `prime.hpp`, `set_power_series.hpp`, `sieve.hpp`, `stirling.hpp`.
- Math, create: `kfwt.hpp`, `lagrange.hpp`, `linear_recurrence.hpp`, `simpson.hpp`; delete `polynomial/lagrange.hpp`, `polynomial/linear_recurrence.hpp`, `polynomial/poly.hpp`, `Simpson.hpp`.
- Miscellaneous algorithms, create: `cdq.hpp`, `dancing_links.hpp`, `odt.hpp`, `parallel_binary_search.hpp`.
- Dynamic programming, create: `monotone_dp.hpp`, `plug_dp.hpp`.
- Strings, modify: `acam.hpp`, `exkmp.hpp`, `exsam.hpp`, `hash.hpp`, `kmp.hpp`, `lyndon.hpp`, `manacher.hpp`, `min_rep.hpp`, `pam.hpp`, `sa.hpp`, `sam.hpp`, `trie.hpp`.

---

### Task 1: Data Structures

**Files:**
- Modify/Create: every data-structure file in the synchronization manifest.
- Modify: `Templates/data_structure/main.typ`.

**Interfaces:**
- Consumes: sibling headers under `Templates/data_structure/`.
- Produces: exact shared headers and one `Sparse Table` Typst entry.

- [x] **Step 1: Verify the expected mismatch set**

Run `diff -qr ../Algorithm-Competitive-Codes/Templates/data_structure Templates/data_structure`. Expected: changed headers and source-only `sparse.hpp`; target-only `main.typ` and `seg_beats_note.typ` remain intentional.

- [x] **Step 2: Apply the complete current sibling content**

Use the manifest to replace/create headers. Add after the Fenwick entry:

```typst
=== Sparse Table
#raw(read("sparse.hpp"), lang: "cpp", block: true)
```

- [x] **Step 3: Verify and commit**

```bash
for file in ../Algorithm-Competitive-Codes/Templates/data_structure/*.hpp; do cmp "$file" "Templates/data_structure/${file:t}"; done
rg -n 'read\("sparse\.hpp"\)' Templates/data_structure/main.typ
git add Templates/data_structure
git commit -m "sync: update data structure templates"
```

Expected: every comparison succeeds and exactly one sparse-table entry is printed.

### Task 2: Initialization and Strings

**Files:**
- Modify: `Templates/initialization_misc/io.hpp`.
- Modify: every string header in the synchronization manifest.

**Interfaces:**
- Consumes: sibling headers at identical paths.
- Produces: exact shared headers without disturbing existing explanatory notes.

- [x] **Step 1: Apply sibling content, verify, and commit**

```bash
cmp ../Algorithm-Competitive-Codes/Templates/initialization_misc/io.hpp Templates/initialization_misc/io.hpp
for file in ../Algorithm-Competitive-Codes/Templates/string_algorithm/*.hpp; do cmp "$file" "Templates/string_algorithm/${file:t}"; done
git add Templates/initialization_misc/io.hpp Templates/string_algorithm
git commit -m "sync: update initialization and string templates"
```

Expected before replacement: comparisons fail for changed files. Expected after replacement: all comparisons pass; then commit only the listed paths.

### Task 3: Geometry Mapping

**Files:**
- Modify: `Templates/geometry/2D/2d.hpp`, `Templates/geometry/3D/3d.hpp`, `Templates/geometry/main.typ`.
- Create: `Templates/geometry/nearest_points.hpp`.
- Delete: `Templates/geometry/nearest_points.cpp`.

**Interfaces:**
- Consumes: source `2d.hpp`, `3d.hpp`, and `nearest_points.hpp`.
- Produces: mapped exact headers and a reusable closest-pair entry.

- [x] **Step 1: Apply mapped content and closest-pair replacement**

Set the two mapped target files to the complete sibling content. Replace the old closest-pair file and use:

```typst
=== 平面最近点对
#raw(read("nearest_points.hpp"), lang: "cpp", block: true)
```

- [x] **Step 2: Verify and commit**

```bash
cmp ../Algorithm-Competitive-Codes/Templates/geometry/2d.hpp Templates/geometry/2D/2d.hpp
cmp ../Algorithm-Competitive-Codes/Templates/geometry/3d.hpp Templates/geometry/3D/3d.hpp
cmp ../Algorithm-Competitive-Codes/Templates/geometry/nearest_points.hpp Templates/geometry/nearest_points.hpp
test ! -e Templates/geometry/nearest_points.cpp
git add Templates/geometry
git commit -m "sync: update geometry templates"
```

### Task 4: Graphs and Network Flow

**Files:**
- Modify/Create: every graph file in the synchronization manifest.
- Modify: `Templates/graph/main.typ`, `Templates/graph/network_flow/main.typ`.

**Interfaces:**
- Consumes: sibling graph headers, including `virtual_tree.hpp` from source
  commit `a1e71cb`.
- Produces: exact shared headers and six new algorithm entries.

- [x] **Step 1: Apply all graph content**

Replace/create the manifest paths without changing target-only Johnson, Prüfer, dominator-tree, matching, or counting notes.

- [x] **Step 2: Add tree entries**

Under `树上与特殊结构`, keep Prüfer first, then add:

```typst
=== 最近公共祖先（LCA）
#raw(read("lca.hpp"), lang: "cpp", block: true)
=== 虚树
#raw(read("virtual_tree.hpp"), lang: "cpp", block: true)
=== 长链剖分优化 DP
#raw(read("long_chain_dp.hpp"), lang: "cpp", block: true)
=== 点分治
#raw(read("centroid_decomposition.hpp"), lang: "cpp", block: true)
=== 点分树
#raw(read("centroid_tree.hpp"), lang: "cpp", block: true)
```

- [x] **Step 3: Add the cycle-canceling entry**

After ordinary min-cost flow in `network_flow/main.typ`, add:

```typst
==== 消圈最小费用最大流
#raw(read("cancel_cycle.hpp"), lang: "cpp", block: true)
```

- [x] **Step 4: Verify and commit**

```bash
for file in ../Algorithm-Competitive-Codes/Templates/graph/*.hpp; do cmp "$file" "Templates/graph/${file:t}"; done
for file in ../Algorithm-Competitive-Codes/Templates/graph/network_flow/*.hpp; do cmp "$file" "Templates/graph/network_flow/${file:t}"; done
rg -n 'read\("(lca|virtual_tree|long_chain_dp|centroid_decomposition|centroid_tree|cancel_cycle)\.hpp"\)' Templates/graph
git add Templates/graph
git commit -m "sync: add advanced graph templates"
```

Expected: all comparisons pass and each new graph filename occurs once in reachable entry files.

### Task 5: Math Modernization

**Files:**
- Modify/Create/Delete: every math file in the synchronization manifest.
- Modify: `Templates/math/main.typ`, `agend.md`.

**Interfaces:**
- Consumes: the sibling's flattened math layout.
- Produces: exact current headers, no obsolete duplicate paths, and current Typst reads.

- [x] **Step 1: Apply current math content and remove old paths**

Use the complete sibling content for every current source math header; remove the four deleted paths from the manifest.

- [x] **Step 2: Update the math section**

Read `polynomial.hpp`, `lagrange.hpp`, and `linear_recurrence.hpp` directly. Add after FWT:

```typst
=== K-FWT 代码
#raw(read("kfwt.hpp"), lang: "cpp", block: true)
```

Read lowercase `simpson.hpp` in numerical computation. Update `agend.md` so its polynomial convention names these flattened source paths rather than deleted `polynomial/poly.hpp` paths.

- [x] **Step 3: Verify and commit**

```bash
for file in ../Algorithm-Competitive-Codes/Templates/math/*.hpp; do cmp "$file" "Templates/math/${file:t}"; done
test ! -e Templates/math/polynomial/poly.hpp
test ! -e Templates/math/polynomial/lagrange.hpp
test ! -e Templates/math/polynomial/linear_recurrence.hpp
test ! -e Templates/math/Simpson.hpp
rg -n 'read\("(polynomial|lagrange|linear_recurrence|kfwt|simpson)\.hpp"\)' Templates/math/main.typ
git add Templates/math agend.md
git commit -m "sync: modernize math templates"
```

### Task 6: New Dynamic-Programming and Miscellaneous Sections

**Files:**
- Create: `Templates/dynamic_programming/monotone_dp.hpp`, `Templates/dynamic_programming/plug_dp.hpp`, `Templates/dynamic_programming/main.typ`.
- Create: `Templates/misc_algorithm/cdq.hpp`, `Templates/misc_algorithm/dancing_links.hpp`, `Templates/misc_algorithm/odt.hpp`, `Templates/misc_algorithm/parallel_binary_search.hpp`, `Templates/misc_algorithm/main.typ`.
- Modify: `Templates/main.typ`.

**Interfaces:**
- Consumes: both complete new sibling directories.
- Produces: two reachable top-level sections with one entry per header.

- [x] **Step 1: Create dynamic-programming entries**

```typst
= 动态规划

== DP 优化
=== 决策单调性优化 DP
#raw(read("monotone_dp.hpp"), lang: "cpp", block: true)

== 状态压缩
=== 插头 DP
#raw(read("plug_dp.hpp"), lang: "cpp", block: true)
```

- [x] **Step 2: Create miscellaneous entries**

```typst
= 杂项算法

== 离线与分治
=== CDQ 分治
#raw(read("cdq.hpp"), lang: "cpp", block: true)
=== 整体二分
#raw(read("parallel_binary_search.hpp"), lang: "cpp", block: true)

== 搜索与区间结构
=== 舞蹈链（DLX）
#raw(read("dancing_links.hpp"), lang: "cpp", block: true)
=== 珂朵莉树（ODT）
#raw(read("odt.hpp"), lang: "cpp", block: true)
```

- [x] **Step 3: Include both sections and verify**

Place `#include "dynamic_programming/main.typ"` after data structures and `#include "misc_algorithm/main.typ"` after math in `Templates/main.typ`.

```bash
for dir in dynamic_programming misc_algorithm; do for file in ../Algorithm-Competitive-Codes/Templates/$dir/*.hpp; do cmp "$file" "Templates/$dir/${file:t}"; done; done
rg -n 'include "(dynamic_programming|misc_algorithm)/main\.typ"' Templates/main.typ
rg -n 'read\(".*\.hpp"\)' Templates/dynamic_programming/main.typ Templates/misc_algorithm/main.typ
git add Templates/dynamic_programming Templates/misc_algorithm Templates/main.typ
git commit -m "docs: add dynamic programming and miscellaneous sections"
```

Expected: all six headers match, two top-level includes appear, and six raw-read entries appear.

### Task 7: Completion Audit and Generated Metadata

**Files:**
- Modify: `README.md` via `Generator.py`.
- Create only in `/tmp`: syntax harnesses, `cp-wide.pdf`, `cp-compact.pdf`.

**Interfaces:**
- Consumes: final synchronized tree and all Typst entries.
- Produces: source-equality evidence, C++ syntax evidence, two valid PDFs, and current README metadata.

- [x] **Step 1: Revalidate source state**

```bash
git -C ../Algorithm-Competitive-Codes status --short
git -C ../Algorithm-Competitive-Codes rev-parse HEAD
```

Expected: clean source worktree at HEAD
`a1e71cb2633cb5726053d9d17d6fed46940ff59f`. Incorporate any later template
change before continuing.

- [x] **Step 2: Audit every source header and every new entry**

Compare all sibling `Templates/**/*.hpp` to same-path targets, applying only the two geometry mappings. Then run:

```bash
rg -n 'read\("(sparse|lca|virtual_tree|long_chain_dp|centroid_decomposition|centroid_tree|cancel_cycle|kfwt|monotone_dp|plug_dp|cdq|dancing_links|odt|parallel_binary_search|nearest_points)\.hpp"\)' Templates
```

Expected: no missing/differing logical counterpart and all fifteen new/import-replacement filenames appear once in reachable entry files.

- [x] **Step 3: Run C++23 syntax checks**

Create temporary translation units in `/tmp` with `<bits/stdc++.h>`, `using namespace std;`, `using i64 = long long;`, and `using u64 = unsigned long long;`. Compile every changed header independently using `g++ -std=c++23 -fsyntax-only`; include required template dependencies before dependent math headers. Expected: all changed headers parse. Preserve exact synchronization and report any genuine upstream defect rather than silently editing one repository.

- [x] **Step 4: Build both layouts**

```bash
typst compile --root . codebook/wide/main.typ /tmp/cp-wide.pdf
typst compile --root . codebook/compact/main.typ /tmp/cp-compact.pdf
```

Expected: both exit zero; font fallback warnings are acceptable.

- [x] **Step 5: Regenerate README and repeat final builds**

```bash
./Generator.py
typst compile --root . codebook/wide/main.typ /tmp/cp-wide.pdf
typst compile --root . codebook/compact/main.typ /tmp/cp-compact.pdf
```

Expected: README counts/tree match the final filesystem and both final builds exit zero.

- [x] **Step 6: Final diff audit and commit**

```bash
git diff --check
git status --short
git add README.md
git commit -m "docs: refresh template index"
```

Expected: no whitespace errors, no generated PDF tracked, and only planned files in the synchronization commits.
