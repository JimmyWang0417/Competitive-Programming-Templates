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
.github/workflows/      CI 构建、上游同步 PR 与 GitHub Release 发布
scripts/                GitHub 上游模板同步脚本与受管清单
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

## 上游模板同步

自动同步以 GitHub 上的
[`JimmyWang0417/Algorithm-Competitive-Codes`](https://github.com/JimmyWang0417/Algorithm-Competitive-Codes)
`master` 分支为权威来源，不会自行读取隔壁工作区中的未提交或未推送内容。明确要求的一次性本地迁移可以先于上游进行；清单中的内容指纹会把这类文件识别为“本地领先”，避免自动任务反向覆盖。

```bash
python3 scripts/sync_upstream_templates.py --check
python3 scripts/sync_upstream_templates.py --apply
python3 scripts/sync_upstream_templates.py --check-entries
```

`--check` 只报告差异；`--apply` 在受管文件没有未提交修改且不存在基线冲突时同步源码并更新清单；`--check-entries` 检查每个上游头文件是否已经出现在可达的 Typst 章节中。本仓库独有的说明文字和拆分模板不会被删除。每周定时任务与手动工作流会维护一个固定同步 PR；本地领先或双方同时修改时任务会停止并要求人工判断，而不会回滚目标文件。同步工作流不发布 Release。新增模板仍需在 PR 中补充准确的章节标题和必要说明。完整流程见[上游模板同步维护指南](docs/template-sync.md)。

## Documentation

- [文档索引](docs/README.md)

Count My Code:
<!-- count the code begin -->
```plain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Language              Files        Lines         Code     Comments       Blanks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 C++ Header               98         8919         8847           58           14
 JSON                      1          422          422            0            0
 Makefile                  1           10           10            0            0
 Python                    3         1129          964            2          163
 Shell                     1           61           50            1           10
 Typst                    53         2827         2237           96          494
─────────────────────────────────────────────────────────────────────────────────
 Markdown                 10         5305            0         3850         1455
 |- BASH                   3           15           15            0            0
 (Total)                             5320           15         3850         1455
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Total                   167        18688        12545         4007         2136
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
<!-- count the code end -->

The Directory Tree of My Codes: 
<!-- directory tree begin -->
```plain
.
├── .clang-format
├── .directory
├── .github
│   └── workflows
│       ├── codebook-release.yml
│       └── sync-upstream-templates.yml
├── .gitignore
├── .vscode
│   ├── c_cpp_properties.json
│   ├── checker.code-snippets
│   ├── file.code-snippets
│   ├── generator.code-snippets
│   ├── interator.code-snippets
│   ├── IO.code-snippets
│   ├── latex.code-snippets
│   ├── launch.json
│   ├── main-latex.code-snippets
│   ├── settings.json
│   ├── slideshow.code-snippets
│   ├── sub-latex.code-snippets
│   ├── tasks.json
│   └── validator.code-snippets
├── agend.md
├── agent.md
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
│   ├── README.md
│   └── template-sync.md
├── Generator.py
├── image
│   └── 88D2DB2E657F7DB09DAB8A02818C9A60.jpg
├── lib.typ
├── LICENSE
├── main.typ
├── README.md
├── scripts
│   ├── sync_upstream_templates.py
│   └── upstream-template-manifest.json
├── Templates
│   ├── data_structure
│   │   ├── cartesian_tree.hpp
│   │   ├── decomp_tree.hpp
│   │   ├── decomposition.hpp
│   │   ├── dynamic_seg.hpp
│   │   ├── fenwick.hpp
│   │   ├── fhq_treap.hpp
│   │   ├── implicit_treap.hpp
│   │   ├── lichao.hpp
│   │   ├── link_cut_tree.hpp
│   │   ├── main.typ
│   │   ├── persist_implicit_treap.hpp
│   │   ├── persist_seg.hpp
│   │   ├── persist_treap.hpp
│   │   ├── scanline_seg.hpp
│   │   ├── scapegoat.hpp
│   │   ├── seg_beats.hpp
│   │   ├── seg_beats_note.typ
│   │   ├── seg_divide.hpp
│   │   ├── seg_tree.hpp
│   │   ├── sparse.hpp
│   │   ├── splay.hpp
│   │   ├── top_tree.hpp
│   │   └── treap.hpp
│   ├── dynamic_programming
│   │   ├── main.typ
│   │   ├── monotone_dp.hpp
│   │   ├── monotone_dp.typ
│   │   └── plug_dp.hpp
│   ├── geometry
│   │   ├── 2D
│   │   │   ├── 2d.hpp
│   │   │   ├── circle.hpp
│   │   │   ├── convex-hull.hpp
│   │   │   ├── half-convex-hull.hpp
│   │   │   ├── line.hpp
│   │   │   ├── main.typ
│   │   │   ├── point.hpp
│   │   │   ├── polygon.hpp
│   │   │   └── segment.hpp
│   │   ├── 3D
│   │   │   ├── 3d.hpp
│   │   │   ├── convex-hull.hpp
│   │   │   ├── Coordinate-System.hpp
│   │   │   ├── line.hpp
│   │   │   ├── main.typ
│   │   │   ├── plane.hpp
│   │   │   ├── point.hpp
│   │   │   ├── polygon.hpp
│   │   │   └── sphere.hpp
│   │   ├── main.typ
│   │   ├── nearest_points.hpp
│   │   ├── pick_theorem.typ
│   │   └── randomized_incremental.typ
│   ├── graph
│   │   ├── block_forest.hpp
│   │   ├── centroid_decomposition.hpp
│   │   ├── centroid_tree.hpp
│   │   ├── dilworth.typ
│   │   ├── dominator_tree.hpp
│   │   ├── dominator_tree.typ
│   │   ├── euler_tour.hpp
│   │   ├── johnson.hpp
│   │   ├── johnson.typ
│   │   ├── lca.hpp
│   │   ├── lgv.typ
│   │   ├── long_chain_dp.hpp
│   │   ├── main.typ
│   │   ├── matrix_tree.typ
│   │   ├── min_cycle.hpp
│   │   ├── network_flow
│   │   │   ├── cancel_cycle.hpp
│   │   │   ├── main.typ
│   │   │   ├── min_cost_flow.hpp
│   │   │   ├── network_flow.hpp
│   │   │   └── theorems.typ
│   │   ├── prufer.typ
│   │   ├── ring_count.hpp
│   │   ├── steiner_tree.hpp
│   │   ├── stoer_wagner.hpp
│   │   ├── tarjan.hpp
│   │   ├── tree_hash.typ
│   │   ├── two_sat.typ
│   │   └── virtual_tree.hpp
│   ├── initialization_misc
│   │   ├── approx.hpp
│   │   ├── approx_note.typ
│   │   ├── bit.hpp
│   │   ├── bit_operations.typ
│   │   ├── hash_table.hpp
│   │   ├── io.hpp
│   │   ├── main.md
│   │   ├── main.typ
│   │   └── makefile
│   ├── main.typ
│   ├── math
│   │   ├── berlekamp_massey.hpp
│   │   ├── berlekamp_massey_note.typ
│   │   ├── comb.hpp
│   │   ├── combinatorics.typ
│   │   ├── du_sieve.hpp
│   │   ├── euclidean.hpp
│   │   ├── euclidean.typ
│   │   ├── fft.hpp
│   │   ├── fib.typ
│   │   ├── fwt.hpp
│   │   ├── fwt.typ
│   │   ├── gameTheory.typ
│   │   ├── group_theory.typ
│   │   ├── inclusion_exclusion.typ
│   │   ├── jYZpd0.png
│   │   ├── kfwt.hpp
│   │   ├── lagrange.hpp
│   │   ├── linear_basis.hpp
│   │   ├── linear_programming.typ
│   │   ├── linear_recurrence.hpp
│   │   ├── main.typ
│   │   ├── matrix.hpp
│   │   ├── min25.hpp
│   │   ├── modint.hpp
│   │   ├── number_theory.hpp
│   │   ├── number_theory_note.typ
│   │   ├── number_theory_sieve.typ
│   │   ├── order_primitive_root.typ
│   │   ├── polynomial.hpp
│   │   ├── polynomial_notes.typ
│   │   ├── prime.hpp
│   │   ├── prime.typ
│   │   ├── schreier_sims.hpp
│   │   ├── set_power_series.hpp
│   │   ├── set_power_series.typ
│   │   ├── sieve.hpp
│   │   ├── simpson.hpp
│   │   ├── stirling.hpp
│   │   ├── stirling.typ
│   │   └── young_tableaux.typ
│   ├── misc_algorithm
│   │   ├── cdq.hpp
│   │   ├── dancing_links.hpp
│   │   ├── main.typ
│   │   ├── odt.hpp
│   │   └── parallel_binary_search.hpp
│   └── string_algorithm
│       ├── acam.hpp
│       ├── exkmp.hpp
│       ├── exsam.hpp
│       ├── hash.hpp
│       ├── kmp.hpp
│       ├── lyndon.hpp
│       ├── lyndon_note.typ
│       ├── main.typ
│       ├── manacher.hpp
│       ├── min_rep.hpp
│       ├── min_rep_note.typ
│       ├── pam.hpp
│       ├── sa.hpp
│       ├── sam.hpp
│       └── trie.hpp
└── tests
    └── test_sync_upstream_templates.py
```
<!-- directory tree end -->
