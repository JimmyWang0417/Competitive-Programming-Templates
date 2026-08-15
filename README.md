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

## Documentation

- [文档索引](docs/README.md)

Count My Code:
<!-- count the code begin -->
```plain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Language              Files        Lines         Code     Comments       Blanks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 C++                       1           91           91            0            0
 C++ Header               82         8691         8189           55          447
 Makefile                  1            2            2            0            0
 Python                    1           24           22            1            1
 Shell                     1           61           50            1           10
 Typst                    30         2333         1823           85          425
─────────────────────────────────────────────────────────────────────────────────
 Markdown                  9         5136            0         3716         1420
 |- BASH                   2            6            6            0            0
 (Total)                             5142            6         3716         1420
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Total                   125        16344        10183         3858         2303
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
    ├── dataStructure
    │   ├── cartesianTree.hpp
    │   ├── decomposition.hpp
    │   ├── decompTree.hpp
    │   ├── dynamicSeg.hpp
    │   ├── fenwick.hpp
    │   ├── fhqTreap.hpp
    │   ├── implicitTreap.hpp
    │   ├── lichao.hpp
    │   ├── linkCutTree.hpp
    │   ├── main.typ
    │   ├── persistImplicitTreap.hpp
    │   ├── persistSeg.hpp
    │   ├── persistTreap.hpp
    │   ├── scanlineSeg.hpp
    │   ├── scapegoat.hpp
    │   ├── segBeats.hpp
    │   ├── segDivide.hpp
    │   ├── segmentTreeBeats.hpp
    │   ├── segTree.hpp
    │   ├── splay.hpp
    │   ├── topTree.hpp
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
    │   └── nearestPoints.cpp
    ├── graph
    │   ├── blockForest.hpp
    │   ├── dilworth.typ
    │   ├── dominatorTree.hpp
    │   ├── dominatorTree.typ
    │   ├── eulerTour.hpp
    │   ├── johnson.hpp
    │   ├── main.typ
    │   ├── minCycle.hpp
    │   ├── networkFlow
    │   │   ├── main.typ
    │   │   ├── minCostFlow.hpp
    │   │   └── networkFlow.hpp
    │   ├── ringCount.hpp
    │   ├── steinerTree.hpp
    │   ├── stoerWagner.hpp
    │   ├── tarjan.hpp
    │   └── twoSat.typ
    ├── initialization & misc
    │   ├── approx.hpp
    │   ├── bit.hpp
    │   ├── hashTable.hpp
    │   ├── io.hpp
    │   ├── main.md
    │   ├── main.typ
    │   └── makefile
    ├── main.typ
    ├── math
    │   ├── berlekampMassey.hpp
    │   ├── comb.hpp
    │   ├── combinatorics.typ
    │   ├── duSieve.hpp
    │   ├── euclidean.hpp
    │   ├── euclidean.typ
    │   ├── fib.typ
    │   ├── fwt.hpp
    │   ├── fwt.typ
    │   ├── gameTheory.typ
    │   ├── jYZpd0.png
    │   ├── linearBasis.hpp
    │   ├── main.typ
    │   ├── matrix.hpp
    │   ├── min25.hpp
    │   ├── modint.hpp
    │   ├── numberTheory.hpp
    │   ├── numberTheorySieve.typ
    │   ├── polynomial
    │   │   ├── lagrange.hpp
    │   │   ├── linearRecurrence.hpp
    │   │   └── poly.hpp
    │   ├── polynomial.hpp
    │   ├── prime.hpp
    │   ├── prime.typ
    │   ├── schreierSims.hpp
    │   ├── setPowerSeries.hpp
    │   ├── setPowerSeries.typ
    │   ├── sieve.hpp
    │   ├── Simpson.hpp
    │   ├── stirling.hpp
    │   ├── stirling.typ
    │   └── youngTableaux.typ
    └── stringAlgorithm
        ├── acam.hpp
        ├── exkmp.hpp
        ├── exsam.hpp
        ├── kmp.hpp
        ├── lyndon.hpp
        ├── main.typ
        ├── manacher.hpp
        ├── pam.hpp
        ├── sa.hpp
        ├── sam.hpp
        └── trie.hpp
```
<!-- directory tree end -->
