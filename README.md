# Competitive-Programming-Templates

JimmyWang0417 的算法竞赛模板库。算法代码与说明统一放在 `Templates/`，并从同一份内容构建两种 PDF：

- `competitive-programming-templates-wide.pdf`：原版宽版模板，适合屏幕阅读与完整笔记。
- `competitive-programming-templates-compact.pdf`：A4 双栏紧凑模板，适合打印携带；版式参考并适配自 [chen-hongxuan/xcpc-codebook](https://github.com/chen-hongxuan/xcpc-codebook)，不包含该仓库的算法代码。

## 目录组织

```plain
Templates/              唯一的算法源码与正文来源
codebook/content.typ    两种版式的共享内容入口
codebook/wide/          原版宽版主题与入口
codebook/compact/       A4 双栏紧凑主题与入口
dist/                   本地构建产物（不提交）
.github/workflows/      CI 构建与 GitHub Release 发布
auto.sh                 本地构建、提交、推送及可选发布入口
```

根目录的 `main.typ` 和 `lib.typ` 是旧路径兼容入口。修改算法时只需编辑 `Templates/`，无需为两种版式维护两份代码。

## 本地构建

需要 Typst 0.15.1 或更高版本，以及 Noto CJK 与 DejaVu Sans Mono 字体：

```bash
mkdir -p dist
typst compile --root . codebook/wide/main.typ dist/competitive-programming-templates-wide.pdf
typst compile --root . codebook/compact/main.typ dist/competitive-programming-templates-compact.pdf
```

## 提交与发布

运行 `./auto.sh`。脚本会更新 README 统计、构建两份 PDF、暂存并提交修改。提交前会询问：

```plain
本次提交后是否发布 GitHub Release？[y/N]
```

直接回车默认不发布。输入 `y` 后，Release 标签默认取“最新稳定版本 + 0.0.1”（例如最新为 `v1.1.1`，默认发布 `v1.1.2`），也可以手动修改；脚本会推送提交和标签。GitHub Actions 收到 `v*` 标签后自动创建 Release，并附上宽版、紧凑版两个 PDF。普通 push 和 pull request 也会构建两份 PDF 作为 Actions Artifact。

也可以在 GitHub Actions 页面点击 **Run workflow**：勾选发布 Release，标签留空时同样自动使用“最新稳定版本 + 0.0.1”。不勾选则只构建并上传 PDF Artifact。

## Documentation

- [文档索引](docs/README.md)

Count My Code:
<!-- count the code begin -->
```plain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Language              Files        Lines         Code     Comments       Blanks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 C++                       1           91           91            0            0
 C++ Header               84         8745         8242           56          447
 Makefile                  1            2            2            0            0
 Python                    1           24           22            1            1
 Shell                     1           61           50            1           10
 Typst                    30         2333         1823           85          425
─────────────────────────────────────────────────────────────────────────────────
 Markdown                  9         5140            0         3719         1421
 |- BASH                   2            6            6            0            0
 (Total)                             5146            6         3719         1421
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Total                   127        16402        10236         3862         2304
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
<!-- count the code end -->

The Directory Tree of My Codes: 
<!-- directory tree begin -->
```plain
.
├── agend.md
├── agent.md
├── assets
├── auto.sh
├── codebook
│   ├── compact
│   │   ├── main.typ
│   │   └── theme.typ
│   ├── content.typ
│   └── wide
│       ├── main.typ
│       └── theme.typ
├── docs
│   ├── graph
│   │   ├── dilworth.md
│   │   ├── dominator-tree.md
│   │   └── two-sat.md
│   ├── math
│   │   └── young-tableaux.md
│   └── README.md
├── Generator.py
├── image
│   └── 88D2DB2E657F7DB09DAB8A02818C9A60.jpg
├── lib.typ
├── LICENSE
├── main.typ
├── README.md
└── Templates
    ├── data_structure
    │   ├── cartesian_tree.hpp
    │   ├── decomp_tree.hpp
    │   ├── decomposition.hpp
    │   ├── dynamic_seg.hpp
    │   ├── fenwick.hpp
    │   ├── fhq_treap.hpp
    │   ├── implicit_treap.hpp
    │   ├── lichao.hpp
    │   ├── link_cut_tree.hpp
    │   ├── main.typ
    │   ├── persist_implicit_treap.hpp
    │   ├── persist_seg.hpp
    │   ├── persist_treap.hpp
    │   ├── scanline_seg.hpp
    │   ├── scapegoat.hpp
    │   ├── seg_beats.hpp
    │   ├── seg_divide.hpp
    │   ├── seg_tree.hpp
    │   ├── segment_tree_beats.hpp
    │   ├── splay.hpp
    │   ├── top_tree.hpp
    │   └── treap.hpp
    ├── geometry
    │   ├── 2D
    │   │   ├── 2d.hpp
    │   │   ├── circle.hpp
    │   │   ├── convex-hull.hpp
    │   │   ├── half-convex-hull.hpp
    │   │   ├── line.hpp
    │   │   ├── main.typ
    │   │   ├── point.hpp
    │   │   ├── polygon.hpp
    │   │   └── segment.hpp
    │   ├── 3D
    │   │   ├── 3d.hpp
    │   │   ├── convex-hull.hpp
    │   │   ├── Coordinate-System.hpp
    │   │   ├── line.hpp
    │   │   ├── main.typ
    │   │   ├── plane.hpp
    │   │   ├── point.hpp
    │   │   ├── polygon.hpp
    │   │   └── sphere.hpp
    │   ├── main.typ
    │   └── nearest_points.cpp
    ├── graph
    │   ├── block_forest.hpp
    │   ├── dilworth.typ
    │   ├── dominator_tree.hpp
    │   ├── dominator_tree.typ
    │   ├── euler_tour.hpp
    │   ├── johnson.hpp
    │   ├── main.typ
    │   ├── min_cycle.hpp
    │   ├── network_flow
    │   │   ├── main.typ
    │   │   ├── min_cost_flow.hpp
    │   │   └── network_flow.hpp
    │   ├── ring_count.hpp
    │   ├── steiner_tree.hpp
    │   ├── stoer_wagner.hpp
    │   ├── tarjan.hpp
    │   └── two_sat.typ
    ├── initialization_misc
    │   ├── approx.hpp
    │   ├── bit.hpp
    │   ├── hash_table.hpp
    │   ├── io.hpp
    │   ├── main.md
    │   ├── main.typ
    │   └── makefile
    ├── main.typ
    ├── math
    │   ├── berlekamp_massey.hpp
    │   ├── comb.hpp
    │   ├── combinatorics.typ
    │   ├── du_sieve.hpp
    │   ├── euclidean.hpp
    │   ├── euclidean.typ
    │   ├── fib.typ
    │   ├── fwt.hpp
    │   ├── fwt.typ
    │   ├── gameTheory.typ
    │   ├── jYZpd0.png
    │   ├── linear_basis.hpp
    │   ├── main.typ
    │   ├── matrix.hpp
    │   ├── min25.hpp
    │   ├── modint.hpp
    │   ├── number_theory.hpp
    │   ├── number_theory_sieve.typ
    │   ├── polynomial
    │   │   ├── lagrange.hpp
    │   │   ├── linear_recurrence.hpp
    │   │   └── poly.hpp
    │   ├── polynomial.hpp
    │   ├── prime.hpp
    │   ├── prime.typ
    │   ├── schreier_sims.hpp
    │   ├── set_power_series.hpp
    │   ├── set_power_series.typ
    │   ├── sieve.hpp
    │   ├── Simpson.hpp
    │   ├── stirling.hpp
    │   ├── stirling.typ
    │   └── young_tableaux.typ
    └── string_algorithm
        ├── acam.hpp
        ├── exkmp.hpp
        ├── exsam.hpp
        ├── hash.hpp
        ├── kmp.hpp
        ├── lyndon.hpp
        ├── main.typ
        ├── manacher.hpp
        ├── min_rep.hpp
        ├── pam.hpp
        ├── sa.hpp
        ├── sam.hpp
        └── trie.hpp
```
<!-- directory tree end -->
