# 算法模板整理约定

## 总原则

- 模板要优先符合已有代码风格，再考虑封装完整性。
- 老模板不主动改；除非明确要求，只整理本次新增或正在重构的模板。
- 两个仓库中的代码模板要同步：
  - `Competitive-Programming-Templates`
  - `Algorithm-Competitive-Codes`
- 同步内容以 GitHub 上游
  `https://github.com/JimmyWang0417/Algorithm-Competitive-Codes.git` 的
  `master` 分支为准。隔壁 `../Algorithm-Competitive-Codes` 工作区只用于读取维护约定和预览尚未上游的改动，不能把其中未提交或未推送的内容直接同步进来。
- 同步后需要逐文件比较，保证对应 `.hpp` 内容一致。

## C++ 书写风格

- 默认比赛环境有 `using namespace std;`，模板代码中不要写 `std::`。
- 存数组统一优先使用 `vector`。
- 命名尽量短，使用驼峰命名法。
- 不为了“工程化”引入过长名字或额外抽象。
- 能贴近原题解代码习惯的地方，优先保留原习惯。
- 保留现有模板中的方法顺序；新增方法放在对应功能组末尾，没有对应分组时放在类型末尾。
- 模运算沿用周围代码的余数约定，不额外引入通用 `norm`、临时 `+mod`/`-mod` 或条件归一化；只在既有结果边界做归一化。
- 通用数学算法不得绑定某一种数据表示。例如 Hensel 提升接口应由调用方传入 $f$ 与 $f'$，不能从特定系数容器中自行推导导数。

## 构造与初始化

- 空构造函数如果确实什么都不做，可以写 `= default`。
- 如果无参构造需要初始化哨兵节点、根数组、随机数种子等，不写 `= default`，要写初始化列表：
  ```cpp
  FhqTreap() : tree(1), rnd((unsigned)chrono::steady_clock::now().time_since_epoch().count()) {}
  ```
- 有参构造不要写成单纯转发：
  ```cpp
  sieve(int n) { init(n); }
  ```
  应直接把初始化逻辑写在构造函数中，和参数无关的初始化放在 `:` 后。
- 新对象初始化时不要多余 `clear()`；如果对象本来是空的，就直接 `resize` 或初始化列表构造。
- `init/build/clear` 可以保留给复用对象，但不要让构造函数只是调用它们。

## 数据结构模板

- 线段树类模板中使用原来的宏习惯：
  ```cpp
  #define lc (rt << 1)
  #define rc (rt << 1 | 1)
  ```
- 指针式节点或平衡树中使用：
  ```cpp
  #define lc(x) tree[x].l
  #define rc(x) tree[x].r
  ```
  或 `ch[2]` 版本：
  ```cpp
  #define lc(x) tree[x].ch[0]
  #define rc(x) tree[x].ch[1]
  ```
- 每个使用宏的模板文件末尾要 `#undef lc`、`#undef rc`。
- Splay 中保留 `check` 函数名，不改成 `direction`。
- 原代码中边界判断通常比较可靠，整理时尽量不改边界条件。

## 多项式模板

- 多项式模板以源仓库当前完整的 `math/polynomial.hpp` 为准。
- 不拆成 `poly-basic.hpp`、`poly-ntt.hpp`、`poly-calculus.hpp` 等片段文件。
- `lagrange.hpp` 和 `linear_recurrence.hpp` 与 `polynomial.hpp` 同放在 `math/` 顶层。
- `math/main.typ` 中展示完整 `polynomial.hpp`，再展示 `lagrange.hpp` 和 `linear_recurrence.hpp`。

## 验证流程

- 检查或应用 GitHub 上游模板同步：
  ```bash
  python3 scripts/sync_upstream_templates.py --check
  python3 scripts/sync_upstream_templates.py --apply
  python3 scripts/sync_upstream_templates.py --check-entries
  ```
- `--apply` 只在受管目标文件和同步清单没有本地改动时执行；本仓库独有的 Typst、Markdown、图片和拆分几何模板不属于同步删除范围。
- 新增上游头文件同步后，必须为它选择准确的 Typst 章节、中文标题和必要说明；`--check-entries` 无输出缺口后才能认为文本入口完整。
- 新增或改动代码模板后，至少做：
  - C++ 语法检查。
  - 已有随机/小样例测试。
  - 与 GitHub 上游仓库逐文件比较。
- 改动 Typst 文档后，运行：
  ```bash
  typst compile Templates/math/main.typ /tmp/cp-math.pdf
  typst compile --root . codebook/wide/main.typ /tmp/cp-wide.pdf
  typst compile --root . codebook/compact/main.typ /tmp/cp-compact.pdf
  ```
