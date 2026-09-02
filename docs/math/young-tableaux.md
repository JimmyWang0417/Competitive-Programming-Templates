# 杨表（Young Tableaux）详细教程

> 本文是适合连续阅读的详细文档；算法竞赛纸质模板中的压缩版本见 [杨表纸质速查版](../../Templates/math/young_tableaux.typ)。
>
> 面向零基础读者。本文采用**英式记法**：杨图左对齐，较长的行画在上面。
>
> 本文的主线是：整数分拆 → 杨图 → 标准/半标准杨表 → 钩长公式 → RSK 对应 → 最长上升子序列。最后补充斜杨表、Schur 函数、Kostka 数和 Greene 定理，方便继续学习。

## 本文的证明取舍

本文按算法竞赛选手的阅读习惯处理证明：

- 由定义一眼可验的结论，直接说明关键原因，不展开形式化废话；
- 会影响公式适用条件、严格/非严格边界的结论，给出严格论证；
- 证明依赖一整套额外理论的进阶定理，明确标成“证明思路”，绝不把直觉描述伪装成完整证明。

## 竞赛选手的核心阅读路线

第一次阅读只看：

$$
1\to2\to3\to4\to5\to6\to8\to9\to10\to11\to14.
$$

其中真正的“心脏”只有四件事：

1. **钩长公式**：固定形状有多少个标准杨表；
2. **RSK 插入**：如何把一个排列变成杨表；
3. **双杨表双射**：排列与一对同形标准杨表一一对应；
4. **形状的含义**：第一行是 LIS，第一列是 LDS，前若干行由 Greene 定理解释。

第 7、12、13 节属于选读。它们用于继续学代数组合，不是理解竞赛中杨表应用的前置知识。

## 0. 阅读说明与符号总表

### 0.1 为什么先统一符号

杨表中的困难往往不是计算，而是符号很多。例如

$$
\lambda=(4,2,1)\vdash 7,\qquad \lambda'=(3,2,1,1),\qquad
f^\lambda=\frac{7!}{\prod_{u\in[\lambda]}h_\lambda(u)}.
$$

初学者如果不知道每个符号的含义，后续公式就无法阅读。因此本文每次引入符号都会解释；下面的表可以随时回来查阅。

| 符号 | 读法或名称 | 含义 |
|---|---|---|
| $\mathbb N$ | 自然数集 | 本文取 $\{1,2,3,\ldots\}$ |
| $n!$ | $n$ 的阶乘 | $1\cdot2\cdots n$，并规定 $0!=1$ |
| $\lvert S\rvert$ 或 $\#S$ | 集合大小 | 集合 $S$ 中元素的个数 |
| $\sum$ | 求和号 | 把指定范围内的项相加 |
| $\prod$ | 连乘号 | 把指定范围内的项相乘；没有因子时规定结果为 $1$ |
| $\binom nk$ | 二项式系数 | 从 $n$ 个不同对象中选择 $k$ 个的方法数 |
| $\lambda\vdash n$ | $\lambda$ 分拆 $n$ | $\lambda$ 是总和为 $n$ 的整数分拆 |
| $\lvert\lambda\rvert$ | $\lambda$ 的大小 | $\lambda_1+\lambda_2+\cdots$ |
| $\ell(\lambda)$ | $\lambda$ 的长度 | $\lambda$ 中正部件的个数 |
| $[\lambda]$ | $\lambda$ 的杨图 | 与分拆 $\lambda$ 对应的方格集合 |
| $\lambda'$ 或 $\lambda^{\mathsf T}$ | 共轭分拆 | 把杨图沿主对角线转置 |
| $\mu\subseteq\lambda$ | 图形包含 | 对所有 $i$，都有 $\mu_i\leq\lambda_i$ |
| $\lambda/\mu$ | 斜形 | 从 $[\lambda]$ 中删去 $[\mu]$ |
| $u=(i,j)$ | 格子坐标 | 第 $i$ 行、第 $j$ 列的格子 |
| $h_\lambda(u)$ | 格子 $u$ 的钩长 | $u$ 自身、其右方格子和其下方格子的总数 |
| $\operatorname{arm}(u),\operatorname{leg}(u)$ | 臂长、腿长 | 格子 $u$ 右边、下边的格子数 |
| $c(u)$ | 格子 $u$ 的内容 | $j-i$ |
| $\operatorname{SYT}(\lambda)$ | 标准杨表集合 | 形状为 $\lambda$ 的所有标准杨表 |
| $f^\lambda$ | 标准杨表数 | $\lvert\operatorname{SYT}(\lambda)\rvert$ |
| $\operatorname{SSYT}(\lambda)$ | 半标准杨表集合 | 形状为 $\lambda$ 的所有半标准杨表 |
| $m_i(T)$ | 数字 $i$ 的重数 | $i$ 在表 $T$ 中出现的次数 |
| $K_{\lambda\mu}$ | Kostka 数 | 形状为 $\lambda$、权为 $\mu$ 的半标准杨表数 |
| $P(w),Q(w)$ | RSK 的插入表、记录表 | 由字或排列 $w$ 产生的一对杨表 |
| $\operatorname{LIS}(w)$ | 最长严格上升子序列长度 | longest increasing subsequence |
| $\operatorname{LDS}(w)$ | 最长严格下降子序列长度 | longest decreasing subsequence |
| $\Pr(A)$ | 事件 $A$ 的概率 | 读作“事件 $A$ 发生的概率”，数值在 $0$ 到 $1$ 之间 |

本文常用希腊字母 $\lambda$（lambda）、$\mu$（mu）、$\nu$（nu）给分拆命名。
$\lambda_i$ 表示分拆 $\lambda$ 的第 $i$ 个部件；下标是编号，不是乘法或指数。一个符号若在局部证明中改作其他用途，正文会当场重新定义。

### 0.2 行、列和坐标约定

本文中：

- 行从上往下编号为 $1,2,3,\ldots$；
- 列从左往右编号为 $1,2,3,\ldots$；
- 格子 $(i,j)$ 位于第 $i$ 行第 $j$ 列；
- “行递增”总是指从左到右，“列递增”总是指从上到下。

有些教材采用**法式记法**，把最长行画在最下面。两种画法表达的是同一个组合对象，只是上下方向相反。使用不同教材时，务必先确认画图约定。

---

## 1. 预备知识：整数分拆

### 1.1 什么是整数分拆

设 $n$ 是正整数。若一列正整数

$$
\lambda=(\lambda_1,\lambda_2,\ldots,\lambda_r)
$$

满足

$$
\lambda_1\geq\lambda_2\geq\cdots\geq\lambda_r>0,
\qquad
\lambda_1+\lambda_2+\cdots+\lambda_r=n,
$$

就称 $\lambda$ 是 $n$ 的一个**分拆**，记作

$$
\lambda\vdash n.
$$

这里：

- $\lambda_i$ 称为分拆的第 $i$ 个**部件**；
- $\lvert\lambda\rvert=n$ 称为分拆的**大小**；
- $\ell(\lambda)=r$ 称为分拆的**长度**。

全文统一约定：当 $i>\ell(\lambda)$ 时，令 $\lambda_i=0$。这样涉及任意
$i$ 的公式不必反复写“在末尾补零”。

例如，$4$ 的全部分拆为

$$
(4),\quad(3,1),\quad(2,2),\quad(2,1,1),\quad(1,1,1,1).
$$

注意：分拆不考虑加数顺序，所以 $3+1$ 与 $1+3$ 是同一个分拆，统一写成非增顺序 $(3,1)$。这与“整数拆成有顺序的若干项”的**有序分拆**不同。

### 1.2 空分拆

数字 $0$ 有一个特殊分拆，称为**空分拆**，记作 $\varnothing$。规定

$$
\lvert\varnothing\rvert=0,
\qquad
\ell(\varnothing)=0.
$$

这个约定使递推式在边界处仍然成立。

### 1.3 共轭分拆

给定分拆 $\lambda$，定义它的**共轭分拆** $\lambda'$ 为

$$
\lambda'_j=\#\{i:\lambda_i\geq j\}.
$$

符号 $\#S$ 表示集合 $S$ 中元素的个数。因此，$\lambda'_j$ 就是 $\lambda$ 中至少等于 $j$ 的部件数。

例如 $\lambda=(4,2,1)$：

- 至少为 $1$ 的部件有 $3$ 个；
- 至少为 $2$ 的部件有 $2$ 个；
- 至少为 $3$ 的部件有 $1$ 个；
- 至少为 $4$ 的部件有 $1$ 个。

所以

$$
\lambda'=(3,2,1,1).
$$

共轭具有以下基本性质：

$$
(\lambda')'=\lambda,
\qquad
\lvert\lambda'\rvert=\lvert\lambda\rvert,
\qquad
\ell(\lambda')=\lambda_1.
$$

它们在杨图中会一目了然。

### 1.4 包含关系与支配序

若对每个 $i$ 都有 $\mu_i\leq\lambda_i$（不足的部件补成 $0$），则记

$$
\mu\subseteq\lambda.
$$

这表示 $\mu$ 的杨图包含在 $\lambda$ 的杨图中。

另一种不同的偏序叫**支配序**。若 $\lvert\lambda\rvert=\lvert\mu\rvert$，并且对每个 $k\geq1$ 都有

$$
\lambda_1+\cdots+\lambda_k
\geq
\mu_1+\cdots+\mu_k,
$$

则称 $\lambda$ 支配 $\mu$，记作 $\lambda\unrhd\mu$。

不要混淆：$\mu\subseteq\lambda$ 可以发生在大小不同的分拆之间；支配序通常比较同一个整数的两个分拆。

---

## 2. 杨图：把分拆画成方格

### 2.1 定义

分拆 $\lambda=(\lambda_1,\ldots,\lambda_r)$ 的**杨图**（Young diagram）定义为格子集合

$$
[\lambda]=\{(i,j):1\leq i\leq r,\ 1\leq j\leq\lambda_i\}.
$$

也就是说，第 $i$ 行画 $\lambda_i$ 个方格。

例如 $\lambda=(4,2,1)$ 的杨图是

<table aria-label="形状为 (4,2,1) 的杨图" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
</table>

它有 $7$ 个格子，所以 $\lvert\lambda\rvert=7$。列长依次为 $3,2,1,1$，恰好构成共轭分拆 $\lambda'=(3,2,1,1)$。因此，共轭分拆就是把杨图沿主对角线转置。

### 2.2 可添加格与可删除格

若在杨图外添加一个格子后仍是某个分拆的杨图，则该格子叫**可添加格**（addable cell）。

若从杨图中删除一个格子后仍是某个分拆的杨图，则该格子叫**可删除格**（removable cell）。不同资料对“内角、外角”两个别名的用法并不统一，本文后面只使用“可添加格、可删除格”。

设 $\lambda=(\lambda_1,\ldots,\lambda_r)$ 非空。坐标判定为

$$
R(\lambda)=\{(i,\lambda_i):1\leq i\leq r,\ \lambda_i>\lambda_{i+1}\},
$$

$$
A(\lambda)
=\{(1,\lambda_1+1)\}
\cup\{(i,\lambda_i+1):2\leq i\leq r,\ \lambda_{i-1}>\lambda_i\}
\cup\{(r+1,1)\}.
$$

其中 $R(\lambda)$、$A(\lambda)$ 分别表示可删除格、可添加格的集合；空分拆只有一个可添加格 $(1,1)$。

对 $(4,2,1)$：

$$
R(\lambda)=\{(1,4),(2,2),(3,1)\},
$$

$$
A(\lambda)=\{(1,5),(2,3),(3,2),(4,1)\}.
$$

重要事实：标准杨表中的最大数一定在可删除格中。原因是如果它右边或下边还有格子，那么递增条件会要求那里放一个更大的数，这是不可能的。

### 2.3 斜杨图

如果 $\mu\subseteq\lambda$，则从 $[\lambda]$ 中删去 $[\mu]$ 后得到的图形称为**斜杨图**，记作

$$
\lambda/\mu.
$$

例如 $\lambda=(4,3,1),\mu=(2,1)$：

<table aria-label="斜形 (4,3,1)/(2,1)" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:none; width:2em; height:2em;"></td>
    <td style="border:none; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
  <tr>
    <td style="border:none; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em;"></td>
  </tr>
</table>

斜形的格子数为

$$
\lvert\lambda/\mu\rvert=\lvert\lambda\rvert-\lvert\mu\rvert.
$$

普通杨图是斜杨图的特例 $\lambda/\varnothing$。

---

## 3. 杨表、标准杨表与半标准杨表

### 3.1 杨表

在杨图的每个格子中填入一个数，得到的对象称为一个**杨表**（Young tableau）。如果只说“杨表”而没有加限制，填数未必有序；真正有用的通常是标准或半标准杨表。

杨表的**形状**就是底层杨图的分拆，记作

$$
\operatorname{shape}(T)=\lambda.
$$

### 3.2 标准杨表（SYT）

设 $\lvert\lambda\rvert=n$。若一个形状为 $\lambda$ 的杨表满足：

1. 数字 $1,2,\ldots,n$ 每个恰好出现一次；
2. 每一行从左到右严格递增；
3. 每一列从上到下严格递增；

则称它是**标准杨表**（standard Young tableau，缩写 SYT）。

三条条件必须同时满足。“行列递增”本身不够：填入的数还必须恰好是
$1,2,\ldots,n$。对角线没有额外条件。由三条条件立刻得到：左上角一定是
$1$，最大数 $n$ 一定在可删除格中。

例如

<table aria-label="形状为 (4,2,1) 的标准杨表" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">7</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">6</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
  </tr>
</table>

是形状 $(4,2,1)$ 的标准杨表。

记

$$
\operatorname{SYT}(\lambda)
$$

为形状 $\lambda$ 的标准杨表集合，并记

$$
f^\lambda=\lvert\operatorname{SYT}(\lambda)\rvert.
$$

因此 $f^\lambda$ 是标准杨表的数量。上标 $\lambda$ 用来标记形状，不表示普通的乘方运算。

### 3.3 半标准杨表（SSYT）

若一个形状为 $\lambda$ 的杨表满足：

1. 每个格子填正整数；
2. 每一行从左到右**弱递增**，即允许相等；
3. 每一列从上到下**严格递增**；

则称它是**半标准杨表**（semistandard Young tableau，缩写 SSYT）。

例如

<table aria-label="形状为 (4,2,1) 的半标准杨表" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
  </tr>
</table>

是形状 $(4,2,1)$ 的半标准杨表。

这是本文统一采用的约定。有些资料采用“行严格、列弱增”的约定。把表沿主对角线转置，会直接在这两种约定之间转换，同时把形状 $\lambda$ 变为 $\lambda'$。

### 3.4 权（weight）

令 $m_i(T)$ 表示数字 $i$ 在半标准杨表 $T$ 中出现的次数。序列

$$
\operatorname{wt}(T)=(m_1,m_2,m_3,\ldots)
$$

称为 $T$ 的**权**。只有有限多个 $m_i$ 非零，并且

$$
m_1+m_2+\cdots=\lvert\lambda\rvert.
$$

上例的权为

$$
\operatorname{wt}(T)=(2,2,1,2),
$$

因为 $1,2,3,4$ 分别出现 $2,2,1,2$ 次。权一般只是一个有限支撑的非负整数序列，不要求按非增顺序排列。

当权本身按非增顺序写成分拆 $\mu$ 时，形状为 $\lambda$、权为 $\mu$ 的半标准杨表数记作

$$
K_{\lambda\mu},
$$

称为 **Kostka 数**。

### 3.5 标准化

半标准杨表中可能有重复数字。令

$$
N_i=m_1(T)+\cdots+m_{i-1}(T).
$$

把所有值为 $i$ 的格按**列号从小到大**排列，依次改成

$$
N_i+1,N_i+2,\ldots,N_i+m_i(T).
$$

对 $i=1,2,\ldots$ 依次执行，得到一个标准杨表；这个过程称为**标准化**。列严格保证相同数字不在同一列，所以列号顺序唯一。同行中的相同数字从左到右获得递增编号；不同原值对应互不相交且依次增大的编号区间，因此行、列最终都严格递增。

例如把左表标准化。两个 $1$ 按列号依次改成 $1,2$；两个 $2$ 位于第
$1,3$ 列，所以依次改成 $3,4$；最后把 $3$ 改成 $5$：

<div style="display:flex; gap:1.2em; align-items:center; margin:0.75em 0;">
  <table aria-label="标准化之前的半标准杨表" style="border-collapse:collapse;">
    <tr>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    </tr>
    <tr>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
    </tr>
  </table>
  <span style="font-size:1.5em;">→</span>
  <table aria-label="标准化之后的标准杨表" style="border-collapse:collapse;">
    <tr>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
    </tr>
    <tr>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
      <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
    </tr>
  </table>
</div>

标准化是把含重复字母的 RSK 与排列上的 RSK 联系起来的重要工具。

---

## 4. 标准杨表的基础性质

### 4.1 前 $k$ 个数字总形成杨图

**命题。** 设 $T$ 是标准杨表。对任意 $k$，只保留数字 $1,2,\ldots,k$ 所在的格子，得到的格子集合仍是一个杨图。

原因很直接：一个不超过 $k$ 的格子，其左边和上边的数更小，也都不超过 $k$。所以保留区域对向左、向上封闭，必为杨图。

于是每个标准杨表都对应一条分拆链

$$
\varnothing=\lambda^{(0)}
\subset\lambda^{(1)}
\subset\cdots
\subset\lambda^{(n)}=\lambda,
$$

其中 $\lambda^{(k)}/\lambda^{(k-1)}$ 恰好只有一个格子，即数字 $k$ 所在的格子。

反过来，任何每次添加一个格子的上述分拆链，也唯一确定一个标准杨表：在第 $k$ 步新增的格子里填 $k$。

因此：

> 形状为 $\lambda$ 的标准杨表，与从空图走到 $\lambda$、每步添加一个合法格子的路径一一对应。

这张由所有分拆组成、边表示“添加一个格子”的无穷图称为 **Young 格（Young lattice）**。

### 4.2 分支递推

设 $R(\lambda)$ 是 $\lambda$ 的可删除格集合。删除格子 $u$ 后的分拆记作 $\lambda-u$。因为最大数 $n$ 必须位于某个可删除格，删掉它后得到一个大小为 $n-1$ 的标准杨表，所以

$$
\boxed{
f^\lambda=\sum_{u\in R(\lambda)}f^{\lambda-u}
}
$$

并规定 $f^\varnothing=1$。

证明就是按 $n$ 所在的可删除格分类：删掉 $n$ 得到 $\lambda-u$ 的标准杨表；反过来在格 $u$ 填回 $n$。两步互逆。

这个递推可以直接计算小规模 $f^\lambda$，但状态很多；钩长公式会给出闭式答案。

### 4.3 转置双射

把标准杨表沿主对角线转置，行严格递增与列严格递增互换，仍然是标准杨表。因此

$$
\boxed{f^{\lambda'}=f^\lambda.}
$$

这也可以从钩长公式看出，因为转置只会把每个钩子的“臂”和“腿”互换，不改变钩长。

### 4.4 极端形状

- 单行形状 $(n)$ 只有一个标准杨表：$1,2,\ldots,n$ 从左到右排列，所以 $f^{(n)}=1$。
- 单列形状 $(1^n)=(1,1,\ldots,1)$ 也只有一个标准杨表，所以 $f^{(1^n)}=1$。
- 当 $n\geq2$ 时，形状 $(n-1,1)$ 有 $n-1$ 个标准杨表。左上角必须是 $1$，只需选择 $2,\ldots,n$ 中哪个数放在第二行，其余数在第一行递增排列。

---

## 5. 钩、钩长与内容

### 5.1 臂长、腿长和钩长

对格子 $u=(i,j)\in[\lambda]$：

- **臂长** $\operatorname{arm}(u)$：同一行中位于 $u$ 右边的格子数；
- **腿长** $\operatorname{leg}(u)$：同一列中位于 $u$ 下边的格子数；
- **钩**：$u$ 自身、右边格子和下边格子的集合；
- **钩长**：钩中格子总数。

因此

$$
h_\lambda(u)=\operatorname{arm}(u)+\operatorname{leg}(u)+1.
$$

利用行长 $\lambda_i$ 和列长 $\lambda'_j$，可写成

$$
\boxed{
h_\lambda(i,j)=\lambda_i-j+\lambda'_j-i+1.
}
$$

其中 $\lambda_i-j$ 是臂长，$\lambda'_j-i$ 是腿长。

### 5.2 钩长表示例

对 $\lambda=(4,2,1)$，每格填入钩长：

<table aria-label="形状 (4,2,1) 中各格的钩长" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">6</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
  </tr>
</table>

例如左上角 $(1,1)$ 的右边有 $3$ 格，下边有 $2$ 格，所以钩长为 $3+2+1=6$。

全部钩长之积为

$$
6\cdot4\cdot2\cdot1\cdot3\cdot1\cdot1=144.
$$

### 5.3 内容

格子 $u=(i,j)$ 的**内容**定义为

$$
\boxed{c(u)=j-i.}
$$

同一条从左上到右下的对角线上的格子内容相同。对 $(4,2,1)$，内容为

<table aria-label="形状 (4,2,1) 中各格的内容" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">0</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">−1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">0</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">−2</td>
  </tr>
</table>

内容会出现在钩长—内容公式中。

---

## 6. 钩长公式

### 6.1 定理

**Frame–Robinson–Thrall 钩长公式。** 若 $\lambda\vdash n$，则形状为 $\lambda$ 的标准杨表数为

$$
\boxed{
f^\lambda
=
\frac{n!}{\displaystyle\prod_{u\in[\lambda]}h_\lambda(u)}.
}
$$

分母是杨图中**所有格子**的钩长之积。

### 6.2 完整计算示例

对 $\lambda=(4,2,1)$，$n=7$，上一节算得钩长积为 $144$，所以

$$
f^{(4,2,1)}
=\frac{7!}{144}
=\frac{5040}{144}
=35.
$$

虽然公式看起来是一个分数，但结果一定是整数，因为它本来就在计数标准杨表。

### 6.3 两行形状的化简

令 $\lambda=(a,b)$，其中 $a\geq b\geq1$，$a+b=n$。整理钩长积可得

$$
\boxed{
f^{(a,b)}
=\frac{a-b+1}{a+1}\binom{a+b}{b}
=\binom{a+b}{b}-\binom{a+b}{b-1}.
}
$$

当 $a=b=m$ 时，

$$
f^{(m,m)}=\frac{1}{m+1}\binom{2m}{m}=C_m,
$$

这正是第 $m$ 个 **Catalan 数**。

### 6.4 钩长公式的通俗证明：钩行走

先别碰公式变形。我们只做一个随机过程。

#### 第一步：最大数只能放在可删除格上

设 $\lambda$ 有 $n$ 个格子，可删除格为
$$
v_1,v_2,\ldots,v_m,
$$
删除 $v_i$ 后的形状记为 $\mu_i$。

标准杨表中的 $n$ 必须在某个可删除格上。固定它在 $v_i$，删掉 $n$，剩下的就是形状 $\mu_i$ 的任意标准杨表。因此

$$
\boxed{f^\lambda=\sum_{i=1}^m f^{\mu_i}.}
\tag{1}
$$

这个递推没有技巧，只是按 $n$ 的位置分类。

对任意分拆 $\nu$，定义

$$
g(\nu)
=\frac{\lvert\nu\rvert!}
{\displaystyle\prod_{u\in[\nu]}h_\nu(u)}.
$$

这里的 $g$ 只是临时取的函数名。特别地，$g(\mu_i)$ 表示把形状
$\mu_i$ 代入上式得到的数，不是指数函数。空分拆没有格子，分母是空乘积，因此 $g(\varnothing)=0!/1=1$。

如果能证明 $g$ 也满足

$$
g(\lambda)=\sum_{i=1}^m g(\mu_i),
\tag{2}
$$

那么从空图开始归纳，就有 $g(\lambda)=f^\lambda$。所以整个证明只剩式 (2)。

#### 第二步：把每一项变成一个概率

空分拆已经作为归纳基处理。以下假设 $\lambda\ne\varnothing$，所以
$n=\lvert\lambda\rvert\geq1$。

先解释两个词：

- **行走**：当前格会不断跳到另一个格子，直到无法继续；
- **随机**：若当前共有 $t$ 个可去的格子，每个格子被选中的概率都是 $1/t$。

在 $\lambda$ 上做如下**钩行走**：

1. 在 $n$ 个格子中等概率选一个起点；
2. 若当前格不是可删除格，就在它右边或下边的所有格子中等概率跳一个；
3. 每次都严格向右或向下，所以一定会停在某个可删除格。

这里的“右边或下边”必须准确理解：

- 可以跳到**同一行右侧的任意格**，不要求相邻；
- 也可以跳到**同一列下方的任意格**，不要求相邻；
- 每一步都重新选择，所以方向可以改变，例如先向右、再向下；
- 不能向左或向上，否则不再是这个钩行走，后面的概率公式也不会成立；
- 不是先以 $1/2$ 的概率选“右/下”方向。所有候选格放在一起等概率选择，因此两个方向的总概率可能不同。

例如在形状 $(4,3,2)$ 中，下面的高亮格给出一条合法路径：

<table aria-label="一条先向右再向下的钩行走路径" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:2px solid #2563eb; background:#dbeafe; width:3.5em; height:2.5em; text-align:center;">起点</td>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
    <td style="border:2px solid #d97706; background:#fef3c7; width:3.5em; height:2.5em; text-align:center;">第 1 跳</td>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
  </tr>
  <tr>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
    <td style="border:2px solid #16a34a; background:#dcfce7; width:3.5em; height:2.5em; text-align:center;">终点</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
    <td style="border:1px solid; width:3.5em; height:2.5em;"></td>
  </tr>
</table>

对应坐标为

$$
(1,1)\longrightarrow(1,3)\longrightarrow(2,3).
$$

第一跳向右且跨过了一格，第二跳改为向下。格 $(2,3)$ 的右边和下边都没有格，因此行走在这里结束。

令 $E_i$ 表示“最后停在 $v_i$”。
所有可能的终点恰好是这些可删除格，所以

$$
\sum_{i=1}^m\Pr(E_i)=1.
\tag{3}
$$

其中 $\Pr$ 是英文 probability（概率）的标准记号：

$$
\Pr(E_i)=\text{这次钩行走最后停在可删除格 }v_i\text{ 的概率}.
$$

因为每次行走必定停在某一个可删除格，而且不同终点不会同时发生，所以所有终点概率相加等于 $1$。

接下来证明

$$
\boxed{\Pr(E_i)=\frac{g(\mu_i)}{g(\lambda)}.}
\tag{4}
$$

#### 为什么证明式 (4) 就够了

把所有可删除格对应的式 (4) 相加：

$$
\sum_{i=1}^m\frac{g(\mu_i)}{g(\lambda)}
=\sum_{i=1}^m\Pr(E_i).
$$

右边是“最终停在各个可删除格”的概率总和。一次行走一定且只会停在一个可删除格，所以右边等于 $1$：

$$
\sum_{i=1}^m\frac{g(\mu_i)}{g(\lambda)}=1.
$$

两边乘以 $g(\lambda)$：

$$
\boxed{g(\lambda)=\sum_{i=1}^m g(\mu_i).}
$$

这正是我们想证明的式 (2)。接下来把它与真实计数比较：

- 真实杨表数满足 $f^\lambda=\sum_i f^{\mu_i}$；
- 候选公式满足 $g(\lambda)=\sum_i g(\mu_i)$；
- 空杨图时，$f^\varnothing=g(\varnothing)=1$。

因此可以按格子数归纳。假设所有 $n-1$ 格形状都有
$f^\mu=g(\mu)$，那么任意 $n$ 格形状 $\lambda$ 都有

$$
f^\lambda
=\sum_i f^{\mu_i}
=\sum_i g(\mu_i)
=g(\lambda).
$$

所以式 (4) 的作用非常具体：它借用“所有终点概率之和为 $1$”，证明候选钩长公式 $g$ 满足正确的递推。这里没有预先假设钩长公式成立，因此不是循环论证。

#### 用形状 $(3,1)$ 看一遍

这个形状有两个可删除格：

$$
v_1=(1,3),\qquad v_2=(2,1).
$$

删除它们分别得到

$$
\mu_1=(2,1),\qquad\mu_2=(3).
$$

直接计算候选公式：

$$
g\bigl((3,1)\bigr)=3,\qquad
g\bigl((2,1)\bigr)=2,\qquad
g\bigl((3)\bigr)=1.
$$

因此两个比值为

$$
\frac{g(\mu_1)}{g(\lambda)}=\frac23,\qquad
\frac{g(\mu_2)}{g(\lambda)}=\frac13.
$$

现在实际做钩行走。四个起点各以 $1/4$ 的概率被选中：

| 起点 | 对停在 $v_1$ 的概率贡献 | 对停在 $v_2$ 的概率贡献 |
|---|---:|---:|
| $v_1=(1,3)$ | $1/4$ | $0$ |
| $(1,2)$ | $1/4$ | $0$ |
| $v_2=(2,1)$ | $0$ | $1/4$ |
| $(1,1)$ | $(1/4)(2/3)=1/6$ | $(1/4)(1/3)=1/12$ |

最后一行中的 $2/3$ 与 $1/3$ 来自：格 $(1,1)$ 的钩中还有三个格子，其中两个最终走到 $v_1$，一个走到 $v_2$。所以

$$
\Pr(E_1)=\frac14+\frac14+\frac16=\frac23,
$$

$$
\Pr(E_2)=\frac14+\frac1{12}=\frac13.
$$

它们恰好等于上面的两个比值，并且

$$
\frac23+\frac13=1.
$$

于是

$$
g\bigl((3,1)\bigr)
=g\bigl((2,1)\bigr)+g\bigl((3)\bigr)
=2+1=3.
$$

这个小例子就是一般证明的缩影：每个“删除该格后的候选值占原候选值的比例”，恰好是走到该可删除格的概率；全部终点的比例相加自然等于 $1$。

#### 第三步：先算右边的比值

设目标可删除格 $v_i=(r,s)$。删掉它时：

- $n!$ 变成 $(n-1)!$，贡献因子 $1/n$；
- 第 $r$ 行中 $v_i$ 左边的格子，钩长都减 $1$；
- 第 $s$ 列中 $v_i$ 上边的格子，钩长都减 $1$；
- 其他钩长不变，$v_i$ 本身的钩长是 $1$。

所以直接约分得到

$$
\frac{g(\mu_i)}{g(\lambda)}
=\frac1n
\prod_{j<s}\frac{h_\lambda(r,j)}{h_\lambda(r,j)-1}
\prod_{k<r}\frac{h_\lambda(k,s)}{h_\lambda(k,s)-1}.
\tag{5}
$$

#### 第四步：为什么钩行走的终点概率也是这个乘积

这是钩行走引理：

> 从全图均匀选起点，再按规则跳，最终到达可删除格 $v_i=(r,s)$ 的概率等于式 (5)。

因为 $v_i=(r,s)$ 是可删除格，前 $r$ 行都至少有 $s$ 格，而第
$s$ 列恰有 $r$ 格。因此

$$
\{(x,y):1\leq x\leq r,\ 1\leq y\leq s\}
$$

是完整地包含在杨图中的矩形。矩形外的格子不可能只靠向右、向下移动到
$v_i$；矩形内的格子则有可能到达它。

给这个矩形使用反向坐标：$(a,b)$ 表示原杨图中的格

$$
(r-a,s-b),
\qquad
0\leq a\leq r-1,\quad0\leq b\leq s-1.
$$

记

$$
U_a=h_\lambda(r-a,s)-1,\qquad
V_b=h_\lambda(r,s-b)-1,
$$

并令 $U_0=V_0=0$。由钩长定义直接数格子可得

$$
h_\lambda(r-a,s-b)-1=U_a+V_b.
\tag{6}
$$

把这一步展开就更清楚：

$$
U_a=\lambda_{r-a}-s+a,\qquad
V_b=\lambda'_{s-b}-r+b,
$$

而格 $(r-a,s-b)$ 右边、下边的候选总数是

$$
\begin{aligned}
h_\lambda(r-a,s-b)-1
&=\lambda_{r-a}-(s-b)+\lambda'_{s-b}-(r-a)\\
&=(\lambda_{r-a}-s+a)+(\lambda'_{s-b}-r+b)\\
&=U_a+V_b.
\end{aligned}
$$

令 $p_{a,b}$ 表示：**已经指定从格 $(r-a,s-b)$ 出发后，最终到达
$v_i$ 的条件概率**。显然 $p_{0,0}=1$。

当 $(a,b)\ne(0,0)$ 时，按第一跳的目的地分类。仍有可能到达
$v_i$ 的目的地只有

$$
(a',b)\quad(0\leq a'<a),
\qquad
(a,b')\quad(0\leq b'<b).
$$

跳到目标列右侧或目标行下方的格子后无法返回，命中概率为 $0$；这些格子仍计入候选总数
$U_a+V_b$，但不出现在分子中。因此

$$
p_{a,b}
=\frac{
\displaystyle\sum_{a'=0}^{a-1}p_{a',b}
+\displaystyle\sum_{b'=0}^{b-1}p_{a,b'}}
{U_a+V_b}
\qquad((a,b)\ne(0,0)).
\tag{7}
$$

令

$$
S(a,b)=\sum_{i=0}^a\sum_{j=0}^b p_{i,j}.
$$

先处理边界。由式 (7)，当 $a\geq1$ 时，

$$
S(a,0)=S(a-1,0)\left(1+\frac1{U_a}\right),
$$

所以

$$
S(a,0)=\prod_{i=1}^a\left(1+\frac1{U_i}\right).
$$

同理，当 $b\geq1$ 时，

$$
S(0,b)=\prod_{j=1}^b\left(1+\frac1{V_j}\right).
$$

对 $a,b\geq1$，把式 (7) 代入

$$
S(a,b)
=S(a-1,b)+S(a,b-1)-S(a-1,b-1)+p_{a,b},
$$

下面把归纳的代数写全。记

$$
F_a=\prod_{i=1}^a\left(1+\frac1{U_i}\right),
\qquad
G_b=\prod_{j=1}^b\left(1+\frac1{V_j}\right),
$$

并规定 $F_0=G_0=1$。假设所有下标和小于 $a+b$ 的情形已经得到
$S(c,d)=F_cG_d$。式 (7) 分子中的两段和分别为

$$
\begin{aligned}
\sum_{a'=0}^{a-1}p_{a',b}
&=S(a-1,b)-S(a-1,b-1)
=\frac{F_{a-1}G_{b-1}}{V_b},\\
\sum_{b'=0}^{b-1}p_{a,b'}
&=S(a,b-1)-S(a-1,b-1)
=\frac{F_{a-1}G_{b-1}}{U_a}.
\end{aligned}
$$

因此

$$
p_{a,b}
=\frac{F_{a-1}G_{b-1}}{U_aV_b},
$$

因为

$$
\frac{1/U_a+1/V_b}{U_a+V_b}=\frac1{U_aV_b}.
$$

代回 $S(a,b)$：

$$
\begin{aligned}
S(a,b)
&=F_{a-1}G_b+F_aG_{b-1}-F_{a-1}G_{b-1}
  +\frac{F_{a-1}G_{b-1}}{U_aV_b}\\
&=F_{a-1}G_{b-1}
  \left(1+\frac1{U_a}\right)
  \left(1+\frac1{V_b}\right)\\
&=F_aG_b.
\end{aligned}
$$

连同前面已经单独证明的两条坐标轴边界，对 $a+b$ 归纳得到

$$
S(a,b)
=\prod_{i=1}^a\left(1+\frac1{U_i}\right)
\prod_{j=1}^b\left(1+\frac1{V_j}\right).
\tag{8}
$$

全图的每个起点以 $1/n$ 的概率被选中。只有上述
$r\times s$ 矩形内的起点可能到达 $v_i$，而 $S(r-1,s-1)$
正是这些起点对应条件概率之和。因此

$$
\Pr(E_i)=\frac1nS(r-1,s-1).
$$

再利用 $1+1/(h-1)=h/(h-1)$，式 (8) 化为

$$
\Pr(E_i)
=\frac1n
\prod_{j<s}\frac{h_\lambda(r,j)}{h_\lambda(r,j)-1}
\prod_{k<r}\frac{h_\lambda(k,s)}{h_\lambda(k,s)-1}.
\tag{9}
$$

式 (9) 与式 (5) 完全相同，故式 (4) 成立。再由式 (3)、式 (2)、式 (1) 归纳得到

$$
f^\lambda=g(\lambda)
=\frac{n!}{\displaystyle\prod_{u\in[\lambda]}h_\lambda(u)}.
$$

证毕。

> 记忆方式：钩长公式不是“神奇地整除”，而是因为删掉最大数时，各可删除格的钩长比值恰好构成一组概率。

### 6.5 一个常用总和恒等式

对所有 $n$ 的分拆，有

$$
\boxed{
\sum_{\lambda\vdash n}(f^\lambda)^2=n!.
}
$$

$n$ 元排列 $\pi=(\pi_1,\ldots,\pi_n)$ 是把 $1,\ldots,n$ 各写一次得到的序列。

本式会在学完 RSK 后得到一个非常直接的双射证明：每个排列唯一对应一对形状相同的标准杨表 $(P,Q)$，形状固定为 $\lambda$ 时共有 $(f^\lambda)^2$ 对。

另一个结论是

$$
\boxed{
\sum_{\lambda\vdash n}f^\lambda=I_n,
}
$$

排列 $\pi$ 的逆排列 $\pi^{-1}$ 由

$$
\pi^{-1}_j=i\quad\Longleftrightarrow\quad\pi_i=j
$$

定义：原排列在位置 $i$ 的值是 $j$，逆排列就在位置 $j$ 放入值 $i$。满足
$\pi=\pi^{-1}$ 的排列称为**对合排列**，$I_n$ 表示 $n$ 元对合排列数。RSK 下
$\pi^{-1}$ 会交换 $P,Q$，所以 $\pi=\pi^{-1}$ 当且仅当 $P=Q$；第 9.6 节会证明这个交换性质，第 9.7 节还会证明对合的不动点数量等于对应形状的奇数列数量。

---

## 7. 半标准杨表的计数（选读）

### 7.1 为什么必须限制可用数字

半标准杨表允许填任意正整数，所以固定非空形状时总共有无限多个。设 $m$ 为正整数。若要得到有限计数，需要限制所有填数属于

$$
\{1,2,\ldots,m\}.
$$

记所有这样的表组成的集合为 $\operatorname{SSYT}_m(\lambda)$；它的数量是
$\lvert\operatorname{SSYT}_m(\lambda)\rvert$。

### 7.2 钩长—内容公式

**定理。** 形状为 $\lambda$、所有填数不超过 $m$ 的半标准杨表数为

$$
\boxed{
\lvert\operatorname{SSYT}_m(\lambda)\rvert
=
\prod_{u\in[\lambda]}
\frac{m+c(u)}{h_\lambda(u)}.
}
$$

因为 $c(i,j)=j-i$，也可写成

$$
\prod_{(i,j)\in[\lambda]}
\frac{m+j-i}{h_\lambda(i,j)}.
$$

如果 $\ell(\lambda)>m$，第一列至少有 $m+1$ 格，却必须填入 $m+1$ 个严格递增且不超过 $m$ 的正整数，这是不可能的；公式中也会出现一个为 $0$ 的因子。

### 7.3 例子

取 $\lambda=(2,1)$，格子的钩长和内容分别为

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <div><strong>钩长</strong></div>
    <table aria-label="形状 (2,1) 中各格的钩长" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      </tr>
    </table>
  </div>
  <div>
    <div><strong>内容</strong></div>
    <table aria-label="形状 (2,1) 中各格的内容" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">0</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">−1</td>
      </tr>
    </table>
  </div>
</div>

所以

$$
\left\lvert\operatorname{SSYT}_m\bigl((2,1)\bigr)\right\rvert
=\frac m3(m+1)(m-1)
=\frac{m(m^2-1)}3.
$$

例如 $m=2$ 时结果为 $2$。

### 7.4 与 Schur 函数的关系

把 $x_1,x_2,\ldots$ 看成两两可交换的形式变量。这里不讨论数值代入后的收敛问题；它们的作用只是记录每个数字出现了多少次。

为半标准杨表 $T$ 定义单项式

$$
x^T=x_1^{m_1(T)}x_2^{m_2(T)}\cdots.
$$

$x^T$ 中的上标 $T$ 是“由表 $T$ 决定这个单项式”的标签，不是把 $x$ 作通常意义的 $T$ 次方。

形状为 $\lambda$ 的所有半标准杨表的权生成函数称为 **Schur 函数**：

$$
\boxed{
s_\lambda(x_1,x_2,\ldots)
=\sum_{T\in\operatorname{SSYT}(\lambda)}x^T.
}
$$

只保留变量 $x_1,\ldots,x_m$ 并令它们全为 $1$，就得到

$$
s_\lambda(1^m)
:=s_\lambda(\underbrace{1,\ldots,1}_{m\text{ 个}},0,0,\ldots)
=\lvert\operatorname{SSYT}_m(\lambda)\rvert.
$$

钩长—内容公式也常写为

$$
s_\lambda(1^m)=\prod_{u\in[\lambda]}\frac{m+c(u)}{h_\lambda(u)}.
$$

### 7.5 钩长—内容公式的推导思路

完整的常见推导依赖 Schur 函数的行列式公式。设 $r=\ell(\lambda)\leq m$，Weyl/Jacobi–Trudi 理论给出主特化

$$
s_\lambda(1^m)
=
\prod_{1\leq i<j\leq m}
\frac{\lambda_i-\lambda_j+j-i}{j-i},
$$

其中不足的 $\lambda_i$ 补 $0$。把分子按杨图的格子重新分组，可以证明

$$
\prod_{1\leq i<j\leq m}
\frac{\lambda_i-\lambda_j+j-i}{j-i}
=
\prod_{(i,j)\in[\lambda]}
\frac{m+j-i}{h_\lambda(i,j)}.
$$

右边正是钩长—内容公式。这里涉及对称函数理论，超出本文组合主线，所以本文把行列式公式作为进阶入口，而不展开其全部代数背景。

### 7.6 Kostka 数的基本性质

若 $\mu=(\mu_1,\ldots,\mu_r)$ 是分拆，就在它后面补无限多个 $0$。定义**单项式对称函数** $m_\mu$ 为：让

$$
(\alpha_1,\alpha_2,\ldots)
$$

遍历 $(\mu_1,\ldots,\mu_r,0,0,\ldots)$ 的所有不同重排，对相应单项式求和：

$$
m_\mu=\sum_{\alpha}x_1^{\alpha_1}x_2^{\alpha_2}\cdots.
$$

每一项仍只有有限多个非零指数。例如

$$
m_{(2,1)}=x_1^2x_2+x_1^2x_3+x_2^2x_1+x_2^2x_3+x_3^2x_1+x_3^2x_2+\cdots.
$$

这里需要用到 Schur 函数的一个基本定理：$s_\lambda$ 对变量的任意有限置换保持不变。这个“对称性”不是直接改变量名字就能当作证明，因为表中数字的大小会影响行列条件。

一个标准的组合证明使用 **Bender–Knuth 对合**。固定相邻数字 $i,i+1$：先把同一列中成对出现的 $i$ 与 $i+1$ 固定。每一行中其余未配对的这些数字必形成一段
$i^a(i+1)^b$；把它改成 $i^b(i+1)^a$。这里 $i^a$ 是“连续 $a$ 个数字
$i$”的简写，不是数值乘方。

行条件保持是因为改写前后都先放 $i$、后放 $i+1$。再看列：一个未配对的
$i$ 若有下方格，下方数至少为 $i+2$，否则下方的 $i+1$ 会与它配对；所以即使该位置改成 $i+1$，仍严格小于下方。类似地，一个未配对的
$i+1$ 若有上方格，上方数至多为 $i-1$，否则上方的 $i$ 会与它配对；所以即使该位置改成 $i$，仍严格大于上方。其他列关系没有改变。故改写后仍是半标准杨表，再做一次会恢复原表。因此这给出一个双射，交换权中的
$m_i,m_{i+1}$ 而保持形状。任意有限置换都可分解成相邻交换，所以单项式系数只依赖指数序列排序后得到的分拆。

于是可以把相同指数类型的单项式合并，得到正确的 Kostka 展开

$$
\boxed{
s_\lambda=\sum_{\mu\vdash\lvert\lambda\rvert}K_{\lambda\mu}m_\mu.
}
$$

常用性质如下：

1. $K_{\lambda\mu}$ 是非负整数。
2. $K_{\lambda\lambda}=1$。唯一填法是第 $i$ 行全填 $i$。
3. 当 $\lambda,\mu\vdash n$ 时，
   $$
   K_{\lambda\mu}>0\quad\Longleftrightarrow\quad\lambda\unrhd\mu.
   $$

解释第 3 点的必要性：第 $i$ 行的每个数都至少为 $i$，因为它上方已有
$i-1$ 个严格更小的正整数。因此所有值不超过 $k$ 的格子只能位于前 $k$ 行。权为
$\mu$ 时，这类格子共有 $\mu_1+\cdots+\mu_k$ 个，所以

$$
\mu_1+\cdots+\mu_k\leq\lambda_1+\cdots+\lambda_k.
$$

这正是 $\lambda\unrhd\mu$。充分性可以通过逐步构造**水平条带**证明；水平条带指每一列至多有一个格子的斜形。这里把充分性作为 Kostka 数的进阶性质使用。

---

## 8. 行插入算法

RSK 的核心操作是把一个数字插入半标准杨表。

### 8.1 行插入的规则

把数字 $x$ 插入半标准杨表 $P$，记作

$$
P\leftarrow x.
$$

步骤如下：

1. 从第一行开始。
2. 在当前行寻找**最左边严格大于 $x$** 的数 $y$。
3. 如果不存在这样的 $y$，就在该行末尾添加 $x$，算法结束。
4. 如果存在，就用 $x$ 替换 $y$，称 $x$ 把 $y$ **顶出**（bump）；随后令 $x\leftarrow y$，到下一行重复。

为什么寻找的是“严格大于 $x$”而不是“大于等于 $x$”？因为我们采用“行弱增、列严格”的半标准约定。这个选择保证相等的数可以留在同一行，同时新形成的列仍然严格递增。

### 8.2 完整例子

向下表插入 $2$：

<table aria-label="插入 2 之前的半标准杨表" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">7</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">8</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">6</td>
  </tr>
</table>

- 第一行最左边大于 $2$ 的数是 $4$。用 $2$ 替换 $4$，把 $4$ 顶到第二行。
- 第二行最左边大于 $4$ 的数是 $5$。用 $4$ 替换 $5$，把 $5$ 顶到第三行。
- 第三行是 $6$，用 $5$ 替换 $6$，把 $6$ 顶到第四行。
- 第四行为空，把 $6$ 放进去。

结果为

<table aria-label="插入 2 之后的半标准杨表" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">7</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">8</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">6</td>
  </tr>
</table>

### 8.3 为什么插入后仍是半标准杨表

设一次插入经过第 $1,2,\ldots,r$ 行。记进入第 $i$ 行的数为
$z_i$，它在第 $c_i$ 列发生替换或追加。

如果发生替换，就把第 $c_i$ 列原来的数记为 $z_{i+1}$。算法寻找第一个严格大于 $z_i$ 的数，所以

$$
z_i<z_{i+1};
$$

$z_{i+1}$ 随后进入下一行。

**行条件。** 若 $z_i$ 替换 $z_{i+1}$，它左边的数都不大于
$z_i$，右边的数原来都不小于 $z_{i+1}>z_i$，所以该行仍弱递增。若 $z_i$ 直接追加到行末，则原行所有数都不大于 $z_i$，结论也成立。

**列条件。** 第一行没有上方格子。对 $i\geq2$，数 $z_i$ 是从上一行第
$c_{i-1}$ 列被顶下来的；替换它的数是 $z_{i-1}<z_i$。先证明

$$
c_i\leq c_{i-1}.
\tag{10}
$$

若第 $i$ 行原来存在第 $c_{i-1}$ 列，插入前的列严格性说明该格的数大于其上方原来的 $z_i$，所以本行第一个大于 $z_i$ 的位置不会晚于第 $c_{i-1}$ 列。若本行没有这一列，则本行长度小于 $c_{i-1}$；即使直接追加，新增列号也不超过 $c_{i-1}$。式 (10) 在两种情况下都成立。

上一行完成替换后仍弱递增，所以新放入的 $z_i$ 上方满足

$$
\text{上一行第 }c_i\text{ 列的数}
\leq
\text{上一行第 }c_{i-1}\text{ 列的数}
=z_{i-1}<z_i.
$$

若 $z_i$ 在本行替换了 $z_{i+1}$，并且第 $c_i$ 列的下方格存在，那么下一行尚未被处理；插入前的列严格性给出

$$
\text{下一行第 }c_i\text{ 列的数}>z_{i+1}>z_i.
$$

若替换位置下方没有格子，就不需要作下方比较。若 $z_i$ 追加成新格，则下一行长度不超过本行追加前的长度，因而新格下方也没有格子。列条件保持成立。

综上，插入后的各行仍弱递增、各列仍严格递增。最后一步一定是在某行末尾添加一格；若它不在第一行，式 (10) 保证它没有伸到上一行之外，而它的下方没有格子，所以它正是一个可添加格。第一行末尾新增格当然也可添加。形状恰好增加一格。

### 8.4 顶出路径引理

一次插入会在若干连续行中各访问一个格子。把每行发生替换或最终追加的位置连起来，称为这次插入的**顶出路径**。若路径在第 $i$ 行访问第 $c_i$ 列，式 (10) 已经证明

$$
c_{i+1}\leq c_i.
$$

所以一条路径从上往下时，列号只能不变或减小。

下面比较连续两次插入。先把 $x$ 插入表 $T$，再把 $x'$ 插入所得的表
$T\leftarrow x$。设第一次路径为

$$
(1,a_1),(2,a_2),\ldots,(r,a_r),
$$

第二次路径为

$$
(1,b_1),(2,b_2),\ldots,(s,b_s).
$$

两次产生的新格分别记为 $B=(r,a_r)$ 和 $B'=(s,b_s)$。

#### 情形一：$x\leq x'$

两条路径共同经过的每一行都满足

$$
b_i>a_i.
\tag{11}
$$

证明采用逐行归纳。设两次进入第 $i$ 行的数分别为 $u_i,v_i$。第一行有
$v_1=x'\geq x=u_1$。第一次操作后，第 $a_i$ 列及其左边的数都不大于
$u_i$；只要 $v_i\geq u_i$，第二次就不可能在这些位置顶出数，所以
$b_i>a_i$。若两条路径都继续，第二次在更右位置顶出的数不小于第一次顶出的数，于是 $v_{i+1}\geq u_{i+1}$，归纳继续成立。

如果第二条路径到达第 $r$ 行，第一次新增的第 $a_r$ 格已经是该行末格；由
$b_r>a_r$，第二次只能在它右边追加并结束。因此 $s\leq r$。再由第一条路径列号弱减，

$$
b_s>a_s\geq a_r.
$$

所以

$$
\boxed{x\leq x'\Longrightarrow s\leq r,\quad b_s>a_r.}
\tag{12}
$$

即第二个新格严格更靠右、弱靠上；“弱靠上”允许同一行。

#### 情形二：$x>x'$

在第一条路径经过的每一行中，

$$
b_i\leq a_i.
\tag{13}
$$

仍作逐行归纳。开始时 $v_1=x'<x=u_1$。第一次操作后，第 $a_i$ 列放着
$u_i>v_i$，所以第二次至迟在第 $a_i$ 列就会遇到一个严格大于 $v_i$ 的数，故
$b_i\leq a_i$。若 $b_i<a_i$，第二次顶出的数不大于 $u_i$；若
$b_i=a_i$，顶出的数就是 $u_i$。而第一次顶出的数满足
$u_{i+1}>u_i$，所以只要第一条路径还继续，就有
$v_{i+1}<u_{i+1}$，归纳继续成立。

到第 $r$ 行时，第一次把 $u_r$ 追加在第 $a_r$ 列。第二次进入此行的数满足
$v_r<u_r$，一定会在第 $a_r$ 列或更左处顶出一个数，不可能在这一行结束。因此
$s>r$。第二条路径自身的列号弱减，所以

$$
b_s\leq b_r\leq a_r.
$$

于是

$$
\boxed{x>x'\Longrightarrow s>r,\quad b_s\leq a_r.}
\tag{14}
$$

即第二个新格严格更靠下、弱靠左；“弱靠左”允许同一列。

这就是顶出路径比较引理。普通字的记录表 $Q$ 只记录互不相同的插入时刻，本来就是标准杨表；式 (12)、(14) 用于精确比较相邻两次插入的路径和新增格位置。

---

## 9. RSK 对应

RSK 是 Robinson–Schensted–Knuth correspondence 的缩写。它把一个序列转换成一对形状相同的杨表。

### 9.1 对一个字进行 RSK

设

$$
w=w_1w_2\cdots w_n
$$

是正整数构成的字（允许重复）。从两个空表开始：

$$
P_0=Q_0=\varnothing.
$$

对 $k=1,2,\ldots,n$：

1. 将 $w_k$ 行插入 $P_{k-1}$，得到 $P_k$；
2. 插入使形状新增一个格子；在 $Q_{k-1}$ 的对应位置填入 $k$，得到 $Q_k$。

最终记

$$
P(w)=P_n,
\qquad
Q(w)=Q_n.
$$

- $P(w)$ 称为**插入表**，保存字母的取值信息，是半标准杨表；
- $Q(w)$ 称为**记录表**，保存每个新格出现的时间，是标准杨表；
- 二者始终具有相同形状。

$P$ 的半标准性由第 8.3 节保证。每次插入都只增加一个可添加格，所以
$Q$ 记录的正是第 4.1 节的分拆增长链：第 $k$ 个新增格填 $k$，必然得到标准杨表。两张表在每一步给同一个新增格添内容，因而形状始终相同。

### 9.2 一个完整例子

对排列

$$
w=3,1,4,2,
$$

逐步操作：

**第 1 步：插入 $3$**

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div><strong>P</strong><table aria-label="第 1 步的插入表 P" style="border-collapse:collapse;"><tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td></tr></table></div>
  <div><strong>Q</strong><table aria-label="第 1 步的记录表 Q" style="border-collapse:collapse;"><tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td></tr></table></div>
</div>

**第 2 步：插入 $1$，$1$ 顶出 $3$**

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P</strong>
    <table aria-label="第 2 步的插入表 P" style="border-collapse:collapse;">
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td></tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td></tr>
    </table>
  </div>
  <div>
    <strong>Q</strong>
    <table aria-label="第 2 步的记录表 Q" style="border-collapse:collapse;">
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td></tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td></tr>
    </table>
  </div>
</div>

**第 3 步：插入 $4$，追加到第一行**

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P</strong>
    <table aria-label="第 3 步的插入表 P" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td></tr>
    </table>
  </div>
  <div>
    <strong>Q</strong>
    <table aria-label="第 3 步的记录表 Q" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td></tr>
    </table>
  </div>
</div>

**第 4 步：插入 $2$，它顶出 $4$，而 $4$ 追加到第二行**

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P</strong>
    <table aria-label="第 4 步的插入表 P" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
    </table>
  </div>
  <div>
    <strong>Q</strong>
    <table aria-label="第 4 步的记录表 Q" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
    </table>
  </div>
</div>

所以 $P,Q$ 的共同形状为 $(2,2)$。

### 9.3 排列情形

若 $w=\pi$ 是 $1,2,\ldots,n$ 的排列，所有插入值互不相同，因此 $P(\pi)$ 也是标准杨表。于是 RSK 给出映射

$$
\pi\longmapsto(P(\pi),Q(\pi)),
$$

其中 $P,Q$ 是一对形状相同的标准杨表。

### 9.4 逆行插入

要证明 RSK 是双射，必须能够从 $(P,Q)$ 恢复原序列。

对排列情形，执行：

1. 在 $Q$ 中找到当前最大标号 $k$。它必在可删除格中；删掉这个格。
2. 在 $P$ 中删掉同一格，并把其中的数记为当前携带值 $x$。
3. 若删掉的格就在第一行，则本轮输出 $x=\pi_k$，本轮结束。
4. 否则进入上一行，寻找**最右边严格小于 $x$** 的数 $y$；用 $x$ 替换它，再令 $x\leftarrow y$，继续上移一行。
5. 处理完第一行后，把最后携带出来的 $x$ 输出为 $\pi_k$。
6. 按 $k=n,n-1,\ldots,1$ 重复，便从后往前恢复整个排列。

步骤 4 的候选一定存在。设当前携带值 $x$ 来自下一行第 $c$ 列。上一行至少有第 $c$ 格，而且列严格性保证该格的数小于 $x$，所以这一行至少能找到一个严格小于 $x$ 的数。

为什么“最右边小于 $x$”准确撤销正向操作？看正向插入在某一行的一步：进入该行的数是 $y$，算法在第 $c$ 列找到第一个严格大于 $y$ 的数 $x$，把 $x$ 顶到下一行，并在第 $c$ 列留下 $y$。操作后：

- 第 $c$ 列及其左边的数都严格小于 $x$；
- 第 $c$ 列右边的数都不小于原来的 $x$。

因此第 $c$ 列恰是这一行中最右边严格小于携带值 $x$ 的位置。反向步骤会找到同一格：把 $x$ 放回去，并重新携带 $y$。从最后新增的格开始逐行上移，就按完全相反的顺序恢复每一次替换；若正向插入直接结束在第一行，步骤 3 也准确覆盖这个边界。故逆行插入确实是行插入的逆操作。

还要核对：从任意同形标准杨表对开始，反向过程中 $P$ 始终保持行、列严格递增，且剩余标签互不相同。注意第一轮输出的值通常不是 $n$，所以剩余
$P$ 的标签未必是 $1,\ldots,n-1$，按第 3.2 节定义不能继续称它为标准杨表。下面只使用“行列严格、标签互异”这两条性质。

设当前携带值 $x$ 来自下一行第 $c$ 列，在上一行选择的位置为第 $d$ 列。因为第 $c$ 列已经是候选，所以 $d\geq c$。把该处原值 $y$ 换成 $x$ 后：

- 行内左边都小于 $y<x$，右边由于 $d$ 是最右候选而都大于 $x$；
- 若上方格存在，它原来小于 $y$，所以仍小于 $x$；
- 若下方存在且 $d>c$，下方第 $d$ 列的数大于该行原来第 $c$ 列的
  $x$；若 $d=c$，下方格要么刚被删除，要么已经换成一个大于 $x$ 的携带值。

所以 $P$ 的行、列仍严格递增，标签也只是移动而不会重复。$Q$ 中删除最大标号所在的可删除格后仍是标准杨表。每轮结束后，$P,Q$ 仍同形，格子数同时减一；其中 $Q$ 标准，$P$ 使用所有尚未输出的排列值并保持行列严格。

### 9.5 RSK 双射定理

**定理（排列版 RSK）。** RSK 给出双射

$$
\boxed{
S_n
\longleftrightarrow
\bigsqcup_{\lambda\vdash n}
\operatorname{SYT}(\lambda)\times\operatorname{SYT}(\lambda).
}
$$

这里：

- $S_n$ 是所有 $n$ 元排列的集合；
- $\bigsqcup$ 表示不交并；
- 右边要求一对表具有相同形状 $\lambda$。

**证明。** 正向算法把每个排列变成一对同形标准杨表。由第 9.4 节，对任意同形标准杨表对都能逐轮执行逆行插入；每轮后 $Q$ 仍标准，$P$ 仍行列严格且标签互异，二者仍同形。整个过程只移动表中数字、每轮输出一个数字，最终输出
$1,\ldots,n$ 的一个排列。局部互逆证明保证把这些数字按恢复出的正序重新插入，会回到原来的表对。因此这个逆算法定义在右侧的每一对表上，并且与正向 RSK 双向互逆；映射既是单射又是满射。证毕。

对一般含重复数字的字，本文定义的 RSK 给出“半标准插入表 + 标准记录表”。

### 9.6 对称性

对排列 $\pi$，有著名性质

$$
\boxed{
P(\pi^{-1})=Q(\pi),
\qquad
Q(\pi^{-1})=P(\pi).
}
$$

直观上，把排列写成两行阵列

$$
\begin{pmatrix}
1&2&\cdots&n\\
\pi_1&\pi_2&\cdots&\pi_n
\end{pmatrix},
$$

求逆排列相当于交换上下两行再按上行排序。但这只能说明结论“看起来应该对称”，还不能作为证明。下面用增长图把对称性严格化。

#### 第一步：固定增长图的坐标

画一个 $n\times n$ 的方格阵列。增长图与杨图是两个不同对象：第 0.2 节的
$(i,j)$ 表示杨图的“第 $i$ 行、第 $j$ 列”，而本节的增长图坐标直接按下面的横轴、纵轴读取：

- 横坐标为 $i$，从左向右增加，表示排列中的位置；
- 纵坐标为 $j$，从下向上增加，表示排列元素的值；
- 增长图小格 $G_{i,j}$ 指横向第 $i$ 列、纵向第 $j$ 行的小格；
- 在 $G_{i,j}$ 中放一个叉，当且仅当 $\pi_i=j$。

为区分不同排列的增长图，用 $x^\pi_{i,j}$ 表示该格是否有叉：

$$
x^\pi_{i,j}=
\begin{cases}
1,&\pi_i=j,\\
0,&\pi_i\ne j.
\end{cases}
$$

上标 $\pi$ 只表示这个 $0/1$ 数来自排列 $\pi$，不是乘方。第一个下标
$i$ 始终是**横坐标（位置）**，第二个下标 $j$ 始终是**纵坐标（值）**。

把前缀 $\pi_1,\ldots,\pi_i$ 中所有大于 $j$ 的数删去，并保持剩余数的原顺序，所得字记为 $w^{(i,j)}$。在网格顶点 $(i,j)$ 标分拆

$$
\boxed{
\Lambda_{i,j}=\operatorname{shape}\bigl(P(w^{(i,j)})\bigr)
}
\qquad(0\leq i,j\leq n).
$$

也就是：只看前 $i$ 个位置，并且只保留不超过 $j$ 的值时，
$\Lambda_{i,j}$ 是插入表的形状。

$\Lambda$ 读作大写 Lambda，这里只是“顶点所标形状”的统一符号；它不是一张填了数的杨表。下标 $(i,j)$ 才说明具体是哪个顶点。

两条初始边界取值为

$$
\Lambda_{0,j}=\varnothing,\qquad
\Lambda_{i,0}=\varnothing.
$$

前者表示没有读入任何位置，后者表示不允许保留任何正整数。

下面的事实用于核对顶点标签。

**限制引理。** 对任意字 $w$，令 $w_{\leq j}$ 表示删去所有大于 $j$ 的字母后所得的字；令 $P(w)_{\leq j}$ 表示在 $P(w)$ 中删去所有大于 $j$ 的格子。则

$$
\boxed{P(w_{\leq j})=P(w)_{\leq j}.}
$$

右边剩下的格子仍组成杨图：若某格不超过 $j$，其左边的数不大于它、上边的数严格小于它，因此也都不超过 $j$。

**证明。** 按顺序插入 $w$ 的字母，并在每一步比较两边。若本次插入
$a>j$，它顶出的数严格大于 $a$，以后顶出的数还会更大，所以整个路径只移动大于 $j$ 的数，不影响限制后的表。若 $a\leq j$，完整表与限制表的顶出路径在遇到第一个大于 $j$ 的数以前完全相同；遇到该数时，限制表中这一行从该位置起已没有保留的数，所以当前数在那里追加。完整表此后继续移动的全是大于 $j$ 的数，也不影响限制后的表。对插入次数归纳，引理成立。

#### 第二步：增长图的局部规则

教程固定采用以下扫描顺序：

1. 令 $j=1,2,\ldots,n$，从下向上逐行扫描；
2. 对固定的 $j$，令 $i=1,2,\ldots,n$，从左向右扫描。

计算小格 $G_{i,j}$ 时，四个顶点固定记为

$$
\begin{array}{c|c}
\text{左上：}\beta=\Lambda_{i-1,j}
&
\text{右上：}\delta=\Lambda_{i,j}\\
\hline
\text{左下：}\alpha=\Lambda_{i-1,j-1}
&
\text{右下：}\gamma=\Lambda_{i,j-1}
\end{array}
$$

四个希腊字母依次读作 alpha、beta、gamma、delta；在本节分别固定表示左下、左上、右下、右上四个形状。

此时 $\alpha,\beta,\gamma$ 都已经算出，只有 $\delta$ 未知。这里每个希腊字母都只是一个**分拆，也就是形状**，不包含表格中的填数。

由于处理的是排列，每次横向或纵向扩大范围时最多加入一个元素，所以
$\beta/\alpha$ 与 $\gamma/\alpha$ 都是空形或恰有一个格。还有一个关键限制：

$$
x^\pi_{i,j}=1\Longrightarrow\alpha=\beta=\gamma.
$$

因为 $x^\pi_{i,j}=1$ 表示 $\pi_i=j$。数 $j$ 不会在前 $i-1$ 个位置中再次出现，所以对这段前缀，把上限从 $j-1$ 提到 $j$ 没有变化，即
$\beta=\alpha$；而在前 $i$ 个位置中按上限 $j-1$ 截断时，新来的 $j$ 又会被删去，即 $\gamma=\alpha$。

按下面四种互斥情况唯一确定 $\delta$：

1. **$\beta\ne\gamma$：**

   $$
   \delta=\beta\cup\gamma,
   \qquad
   (\beta\cup\gamma)_r=\max(\beta_r,\gamma_r).
   $$

   符号 $\beta_r,\gamma_r$ 是两个形状的第 $r$ 行长度。例如

   $$
   \beta=(3,1),\quad\gamma=(2,2)
   \quad\Longrightarrow\quad
   \beta\cup\gamma=(\max(3,2),\max(1,2))=(3,2).
   $$

   所以这里的 $\max$ 是按行取两个杨图并集的长度，不是在杨表填数中取最大值。

2. **$\alpha=\beta=\gamma$ 且 $x^\pi_{i,j}=0$：**

   $$
   \delta=\alpha.
   $$

3. **$\alpha=\beta=\gamma$ 且 $x^\pi_{i,j}=1$：**

   在 $\alpha$ 的第一行末尾添加一格，得到 $\delta$。

4. **$\beta=\gamma\ne\alpha$：**

   此时 $\beta/\alpha$ 恰有一格。若该格位于第 $r$ 行，就在
   $\beta$ 的第 $r+1$ 行末尾再添加一格，得到 $\delta$。

四种情况覆盖所有可能：若 $\beta\ne\gamma$ 就是第 1 种；若
$\beta=\gamma$，这个共同形状要么等于 $\alpha$，要么比 $\alpha$ 多一格。前者再由 $x^\pi_{i,j}$ 的 $0/1$ 分成第 2、3 种，后者就是第 4 种。

下面逐项证明这些规则确实给出 $\Lambda_{i,j}$。令

$$
T=P(\pi_1,\ldots,\pi_{i-1}),\qquad
T'=P(\pi_1,\ldots,\pi_i),\qquad a=\pi_i.
$$

对任意表 $U$，记 $U_{\leq q}$ 为删去所有大于 $q$ 的格子后留下的表。由限制引理，四个形状准确地说是

$$
\alpha=\operatorname{shape}(T_{\leq j-1}),\qquad
\beta=\operatorname{shape}(T_{\leq j}),
$$

$$
\gamma=\operatorname{shape}(T'_{\leq j-1}),\qquad
\delta=\operatorname{shape}(T'_{\leq j}).
$$

- **第 1 种。** 若只有 $\beta$ 比 $\alpha$ 多一格，这一格装着此前已有的
  $j$，而本次 $a>j$，故 $\delta=\beta$。若只有 $\gamma$ 多一格，说明
  $j$ 此前未出现且 $a<j$，故 $\delta=\gamma$。若两者都多一格但位置不同，
  $\beta/\alpha$ 是数字 $j$ 的旧位置，$\gamma/\alpha$ 是本次插入在
  “只保留小于 $j$ 的数”时产生的新格；位置不同说明顶出路径没有碰到
  $j$，两格都会保留。因此三种子情形统一写成
  $\delta=\beta\cup\gamma$。
- **第 2 种。** $\beta=\alpha$ 表示前缀中还没有 $j$；
  $\gamma=\alpha$ 表示本次没有插入小于 $j$ 的数。再由 $a\ne j$，只能有
  $a>j$，所以不超过 $j$ 的部分完全不变，$\delta=\alpha$。
- **第 3 种。** 此时 $a=j$，而此前没有 $j$。在只保留不超过 $j$ 的表中，
  $j$ 比所有已有数都大，行插入会把它追加到第一行末尾。
- **第 4 种。** $\beta/\alpha$ 是数字 $j$ 原来所在的格，设它在第 $r$ 行。
  等式 $\gamma=\beta$ 表示：插入某个 $a<j$ 后，这个原位置已经被一个小于
  $j$ 的数占据，所以顶出路径恰在第 $r$ 行把 $j$ 顶了下去。接着把 $j$
  插入第 $r+1$ 行。把这一行限制到不超过 $j$ 后，原先保留的数都小于
  $j$，所以 $j$ 位于这段保留部分的末尾；在完整表中，它会直接追加，或替换第一个大于 $j$ 的数。两种情况下，限制后的形状都在第 $r+1$ 行新增一格。后续被顶出的数全都大于 $j$，不再影响限制后的表。

因此四条规则都由行插入推出。反过来，每条规则都直接给出 $\delta$；从两条空边界按规定顺序逐格计算，得到的正是前面定义的所有
$\Lambda_{i,j}$。

#### 第三步：完整例子 $\pi=(2,3,1)$

三个叉位于

$$
(1,2),\qquad(2,3),\qquad(3,1).
$$

按上述顺序计算，全部顶点标签如下。表中列从左到右是
$i=0,1,2,3$，行从下到上是 $j=0,1,2,3$；为了符合页面阅读顺序，下面把较大的 $j$ 写在上面。

| $j\backslash i$ | $0$ | $1$ | $2$ | $3$ |
|---:|:---:|:---:|:---:|:---:|
| $3$ | $\varnothing$ | $(1)$ | $(2)$ | $(2,1)$ |
| $2$ | $\varnothing$ | $(1)$ | $(1)$ | $(1,1)$ |
| $1$ | $\varnothing$ | $\varnothing$ | $\varnothing$ | $(1)$ |
| $0$ | $\varnothing$ | $\varnothing$ | $\varnothing$ | $\varnothing$ |

例如右上角标签 $\Lambda_{3,3}=(2,1)$ 只告诉我们“最终形状有两行，行长为
$2,1$”，并没有告诉我们三格中分别填什么。具体的 $P,Q$ 要由整条边界上“每一步在哪个位置新增一格”恢复。

这个例子中四种规则都实际出现了：

- $G_{1,1}$：$\alpha=\beta=\gamma=\varnothing$ 且格内无叉，用第 2 条，得到 $\delta=\varnothing$；
- $G_{1,2}$：$\alpha=\beta=\gamma=\varnothing$ 且格内有叉，用第 3 条，得到 $\delta=(1)$；
- $G_{2,2}$：$\beta=(1)\ne\gamma=\varnothing$，用第 1 条，得到 $\delta=(1)$；
- $G_{3,2}$：$\beta=\gamma=(1)\ne\alpha=\varnothing$，用第 4 条，得到 $\delta=(1,1)$。

例如计算小格 $G_{3,2}$ 时，

$$
\alpha=\Lambda_{2,1}=\varnothing,\qquad
\beta=\Lambda_{2,2}=(1),\qquad
\gamma=\Lambda_{3,1}=(1),\qquad
x^\pi_{3,2}=0.
$$

这里 $\beta=\gamma\ne\alpha$，并且 $\beta/\alpha$ 的新增格位于第一行，所以使用第 4 条规则，在第二行再加一格：

$$
\delta=\Lambda_{3,2}=(1,1).
$$

#### 第四步：$P,Q$ 到底在标签表的哪里

先直接定位：

- **$Q$ 在最上面一行边界**，也就是固定 $j=n$，从左向右读取
  $\Lambda_{0,n},\Lambda_{1,n},\ldots,\Lambda_{n,n}$；
- **$P$ 在最右边一列边界**，也就是固定 $i=n$，从下向上读取
  $\Lambda_{n,0},\Lambda_{n,1},\ldots,\Lambda_{n,n}$。

要特别注意：标签表中没有哪一个 $\Lambda$ 本身就是 $P$ 或 $Q$。
$\Lambda$ 只保存形状；$P,Q$ 是根据相邻形状之间**新增格的位置**恢复出来的。

对本例 $n=3$，标签表的最上面一行就是

上边界从左到右是

$$
\Lambda_{0,3}=\varnothing
\subset(1)\subset(2)\subset(2,1).
$$

逐步比较相邻形状：

- $\varnothing\to(1)$ 新增格 $(1,1)$，填入位置编号 $i=1$；
- $(1)\to(2)$ 新增格 $(1,2)$，填入位置编号 $i=2$；
- $(2)\to(2,1)$ 新增格 $(2,1)$，填入位置编号 $i=3$。

所以得到记录表 $Q$：

<table aria-label="排列 2,3,1 的记录表 Q" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
  </tr>
</table>

标签表的最右边一列从下到上是

$$
\Lambda_{3,0}=\varnothing
\subset(1)\subset(1,1)\subset(2,1).
$$

再次逐步比较：

- $\varnothing\to(1)$ 新增格 $(1,1)$，填入数值 $j=1$；
- $(1)\to(1,1)$ 新增格 $(2,1)$，填入数值 $j=2$；
- $(1,1)\to(2,1)$ 新增格 $(1,2)$，填入数值 $j=3$。

所以得到插入表 $P$：

<table aria-label="排列 2,3,1 的插入表 P" style="border-collapse:collapse; margin:0.75em 0;">
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
  </tr>
  <tr>
    <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
  </tr>
</table>

这里可以严格核对两条边界。

沿上边界有 $j=n$。所有排列值都不超过 $n$，所以

$$
w^{(i,n)}=(\pi_1,\ldots,\pi_i).
$$

因此 $\Lambda_{i,n}$ 就是处理完前 $i$ 个数后的插入表形状；相邻形状新增的格子正是 $Q$ 中填写插入时刻 $i$ 的位置。故上边界编码 $Q$。

沿右边界有 $i=n$。限制引理给出

$$
P(w^{(n,j)})=P(\pi)_{\leq j}.
$$

排列的插入表 $P(\pi)$ 是标准杨表，数字 $j$ 恰好出现一次，所以
$\Lambda_{n,j}/\Lambda_{n,j-1}$ 正是 $P(\pi)$ 中装着 $j$ 的格子。依次在这些新增格中填入 $j=1,2,\ldots,n$，便恢复整张 $P$。故右边界编码 $P$。

可以记成一句话：

> **最上面一行从左向右读出 $Q$；最右边一列从下向上读出 $P$。**

#### 第五步：由坐标交换得到对称性

比较两张增长图时，暂时把顶点标签写成
$\Lambda^\pi_{i,j}$ 和 $\Lambda^{\pi^{-1}}_{i,j}$，上标只用于指出输入排列。对逆排列的方格阵列，有

$$
x^{\,\pi^{-1}}_{j,i}=1
\iff \pi^{-1}_j=i
\iff \pi_i=j
\iff x^{\,\pi}_{i,j}=1.
$$

所以从 $\pi$ 变成 $\pi^{-1}$，准确地说就是交换坐标
$(i,j)\leftrightarrow(j,i)$，即沿直线 $i=j$ 反射整个方格阵列。

在例子 $\pi=(2,3,1)$ 中，叉坐标
$(1,2),(2,3),(3,1)$ 交换后成为
$(2,1),(3,2),(1,3)$。按横坐标 $1,2,3$ 排列，纵坐标依次为
$3,1,2$，正是 $\pi^{-1}=(3,1,2)$。

局部规则也对交换坐标不变：

- 第 1 条中的 $\beta\cup\gamma$ 对交换 $\beta,\gamma$ 不变；
- 第 2、3、4 条都要求 $\beta=\gamma$，交换后条件和结果不变。

两条空边界也互相交换，所以从边界开始逐格计算可得

$$
\Lambda^{\pi^{-1}}_{j,i}=\Lambda^\pi_{i,j}.
$$

现在把两条边界上的坐标逐点对应起来。

原增长图上边界的顶点是 $(i,n)$。交换两个坐标后，

$$
(i,n)\longmapsto(n,i),
$$

它正好落在 $\pi^{-1}$ 的增长图的右边界。由上面的顶点标签关系，

$$
\Lambda^{\pi^{-1}}_{n,i}=\Lambda^\pi_{i,n}
\qquad(0\le i\le n).
$$

当 $i$ 从 $0$ 增加到 $n$ 时：

- 等式右边 $\Lambda^\pi_{i,n}$ 是原增长图的上边界形状链，它编码 $Q(\pi)$；
- 等式左边 $\Lambda^{\pi^{-1}}_{n,i}$ 是逆排列增长图的右边界形状链，它编码 $P(\pi^{-1})$。

两条形状链逐项相等，所以

$$
P(\pi^{-1})=Q(\pi).
$$

同理，原增长图右边界的顶点 $(n,j)$ 交换坐标后变成

$$
(n,j)\longmapsto(j,n),
$$

它落在 $\pi^{-1}$ 的增长图的上边界，并且

$$
\Lambda^{\pi^{-1}}_{j,n}=\Lambda^\pi_{n,j}
\qquad(0\le j\le n).
$$

这里左边的形状链编码 $Q(\pi^{-1})$，右边的形状链编码 $P(\pi)$，因此

$$
Q(\pi^{-1})=P(\pi).
$$

合起来就是

$$
\boxed{
P(\pi^{-1})=Q(\pi),\qquad
Q(\pi^{-1})=P(\pi).
}
$$

这就完成了证明。

> 核心只有一句：**求逆交换“位置”和“值”两个坐标；增长图的局部规则对交换坐标不变，所以编码 $P,Q$ 的两条边界交换。**这里交换的是两张表，不是把某一张表转置。

由此立即推出：

$$
\pi=\pi^{-1}
\quad\Longleftrightarrow\quad
P(\pi)=Q(\pi).
$$

正向由上面的交换公式直接得到。反向若 $P(\pi)=Q(\pi)$，则
$\pi^{-1}$ 与 $\pi$ 对应到同一个表对；由第 9.5 节 RSK 的单射性，
$\pi^{-1}=\pi$。

### 9.7 对合的不动点为什么等于奇数列数

这一节证明一个常用的精细性质。

**定理（Schützenberger）。** 设 $\pi\in S_n$ 是对合排列，也就是

$$
\pi=\pi^{-1}.
$$

满足 $\pi_i=i$ 的下标 $i$ 称为 $\pi$ 的**不动点**。由第 9.6 节，
$P(\pi)=Q(\pi)$；把这张共同的标准杨表记为 $P$，形状记为
$\lambda$。那么

$$
\boxed{
\#\{i:1\leq i\leq n,\ \pi_i=i\}
=
\#\{c\geq1:\lambda'_c\equiv1\pmod 2\}.
}
$$

这里 $\lambda'_c$ 是第 $c$ 列的高度。“奇数列”是指**列高为奇数**，不是列编号为奇数。例如形状
$\lambda=(4)$ 有四列，每列高度都是 $1$，所以它有四个奇数列；它唯一的一行长度为 $4$，是偶数。这也说明结论不能写成“奇数行数”。

下面不把这个结论当作黑箱，而是从增长图的局部规则推出它。

#### 第一步：把奇数列数写成一个容易追踪的量

设形状

$$
\lambda=(\lambda_1,\lambda_2,\ldots),
$$

并约定足够靠后的 $\lambda_r=0$。高度恰好为 $r$ 的列共有

$$
\lambda_r-\lambda_{r+1}
$$

个，因为有 $\lambda_r$ 列能够到达第 $r$ 行，其中
$\lambda_{r+1}$ 列还会继续到达第 $r+1$ 行。

记 $o(\lambda)$ 为 $\lambda$ 的奇数列数量。只把高度
$1,3,5,\ldots$ 的列加起来，得到

$$
\begin{aligned}
o(\lambda)
&=(\lambda_1-\lambda_2)
  +(\lambda_3-\lambda_4)
  +(\lambda_5-\lambda_6)+\cdots\\
&=\lambda_1-\lambda_2+\lambda_3-\lambda_4+\cdots.
\end{aligned}
$$

这个交错和有两个马上能检查的变化规律：

1. 若只在第一行增加一格，则 $o(\lambda)$ 增加 $1$；
2. 若同时在相邻的第 $r$ 行和第 $r+1$ 行各增加一格，则

   $$
   \Delta o=(-1)^{r-1}+(-1)^r=0,
   $$

   所以奇数列总数不变。

这里 $\Delta o$ 表示“变化后的 $o$ 减去变化前的 $o$”。第二条也可以直接从列高理解：若两个新格在同一列，该列高度从
$r-1$ 增加到 $r+1$，奇偶性不变；若它们在不同列，第 $r$ 行新格所在列的高度从
$r-1$ 变成 $r$，第 $r+1$ 行新格所在列的高度从 $r$ 变成
$r+1$。两列原高度奇偶相反，变化后仍一奇一偶，所以奇数列总数不变。

#### 第二步：只观察增长图的主对角线

沿用第 9.6 节的增长图标签。定义

$$
D_i=\Lambda^\pi_{i,i}\qquad(0\leq i\leq n).
$$

$D_i$ 是左下角 $i\times i$ 方块区域右上角的形状标签，并且

$$
D_0=\varnothing,\qquad D_n=\lambda.
$$

这里 $D_n=\lambda$ 是因为
$w^{(n,n)}=(\pi_1,\ldots,\pi_n)=\pi$，所以
$\Lambda^\pi_{n,n}$ 正是完整插入表的形状。

考虑主对角线上的小格 $G_{i,i}$。它的四个顶点是

$$
\alpha=\Lambda^\pi_{i-1,i-1}=D_{i-1},\qquad
\beta=\Lambda^\pi_{i-1,i},
$$

$$
\gamma=\Lambda^\pi_{i,i-1},\qquad
\delta=\Lambda^\pi_{i,i}=D_i.
$$

因为 $\pi=\pi^{-1}$，第 9.6 节的坐标交换公式给出

$$
\Lambda^\pi_{a,b}=\Lambda^\pi_{b,a}.
$$

特别地，

$$
\beta=\gamma.
$$

还要用到一个可以直接核对的格子数公式：

$$
\lvert\Lambda^\pi_{a,b}\rvert
=
\#\{t:1\leq t\leq a,\ \pi_t\leq b\}.
$$

等式右边是限制字 $w^{(a,b)}$ 的长度；每插入一个字母，杨表恰好增加一个格，所以它也等于左边形状的格子数。

因此在主对角线小格中，不会用到局部规则的
$\beta\ne\gamma$ 情形，只需检查下面三种可能。

#### 第三步：按 $\pi_i$ 与 $i$ 的关系分类

先说明这三种情况为什么覆盖全部可能。令 $j=\pi_i$。由于
$\pi=\pi^{-1}$，

$$
\pi_j=i.
$$

若 $j=i$，那么 $i$ 是不动点；若 $j\ne i$，那么 $i,j$ 互相交换，组成二元换位
$(i\,j)$。在二元换位中，要么当前的 $i$ 是较小端点，即 $\pi_i>i$；要么是较大端点，即 $\pi_i<i$。

**情况 1：$\pi_i=i$。**

此时排列矩阵的对角格 $G_{i,i}$ 中有叉，即

$$
x^\pi_{i,i}=1.
$$

值 $i$ 在前 $i-1$ 个位置中还没有出现，而新读入的
$\pi_i=i$ 又会被上限 $i-1$ 删去，所以

$$
w^{(i-1,i)}=w^{(i-1,i-1)},\qquad
w^{(i,i-1)}=w^{(i-1,i-1)}.
$$

因此 $\alpha=\beta=\gamma$。增长图第 3 条局部规则告诉我们：
$D_i$ 由 $D_{i-1}$ 在第一行末尾增加一格得到。

因此这一步同时发生两件事：

- 新出现一个不动点 $i$；
- $o(D_i)=o(D_{i-1})+1$。

**情况 2：$\pi_i>i$。**

记 $\pi_i=j$，于是 $j>i$。由于 $\pi$ 是对合，

$$
\pi_j=i.
$$

这表示二元换位 $(i\,j)$ 的两个叉位于 $(i,j)$ 与 $(j,i)$。当前只观察
$i\times i$ 区域，这两个叉都还没有进入该区域。因此

$$
w^{(i-1,i)}=w^{(i-1,i-1)},\qquad
w^{(i,i-1)}=w^{(i-1,i-1)};
$$

前一个等式是因为值 $i$ 要到位置 $j>i$ 才出现，后一个等式是因为新来的
$\pi_i=j>i$ 会被上限 $i-1$ 删去。于是

$$
\alpha=\beta=\gamma,\qquad x^\pi_{i,i}=0.
$$

由增长图第 2 条局部规则，

$$
D_i=D_{i-1}.
$$

这一步只是第一次遇到二元换位 $(i\,j)$ 的较小端点，既没有完成一个不动点，也没有改变奇数列数。

**情况 3：$\pi_i<i$。**

记 $\pi_i=j$，于是 $j<i$，并且对合条件给出 $\pi_j=i$。当区域从
$(i-1)\times(i-1)$ 扩大到 $i\times i$ 时，二元换位 $(j\,i)$ 的两个叉

$$
(j,i),\qquad(i,j)
$$

一起进入区域。

更准确地看四个顶点：

- 从 $\alpha=\Lambda^\pi_{i-1,i-1}$ 到
  $\beta=\Lambda^\pi_{i-1,i}$，新纳入的是较早位置 $j$ 上的值 $i$。字
  $w^{(i-1,i-1)}$ 正是从 $w^{(i-1,i)}$ 中删掉唯一的 $i$ 后所得；由限制引理，
  $\beta/\alpha$ 恰有一个格；
- 从 $\alpha$ 到 $\gamma=\Lambda^\pi_{i,i-1}$，新纳入的是新位置
  $i$ 上的值 $j$。准确地说，

  $$
  w^{(i,i-1)}=w^{(i-1,i-1)}\,j,
  $$

  所以行插入这个新字母后，$\gamma/\alpha$ 恰有一个格。

又因为 $\beta=\gamma$，这两个单格差实际上位于同一位置。设这个新增格位于第
$r$ 行。增长图第 4 条局部规则随后在第
$r+1$ 行再增加一格，得到 $\delta=D_i$。

因此从 $D_{i-1}$ 到 $D_i$，恰好在相邻的第 $r$、第 $r+1$ 行各增加一格。根据第一步，

$$
o(D_i)=o(D_{i-1}).
$$

这一步完成了一个二元换位，但没有增加不动点，奇数列数量也没有改变。

#### 第四步：把每一步相加

上面三种情况可以统一写成

$$
[\pi_i=i]
=
\begin{cases}
1,&\pi_i=i,\\
0,&\pi_i\ne i.
\end{cases}
$$

这个量称为条件 $\pi_i=i$ 的指示量。于是

$$
o(D_i)-o(D_{i-1})
=[\pi_i=i].
$$

从 $i=1$ 加到 $n$，中间项全部抵消：

$$
\begin{aligned}
o(\lambda)
&=o(D_n)-o(D_0)\\
&=\sum_{i=1}^n\bigl(o(D_i)-o(D_{i-1})\bigr)\\
&=\sum_{i=1}^n[\pi_i=i]\\
&=\#\{i:\pi_i=i\}.
\end{aligned}
$$

定理得证。

> 可以把整个证明记成：**对角叉单独进入，给第一行添一格，使奇数列数加一；一个二元换位的两个对称叉一起进入，给相邻两行各添一格，对奇数列数的贡献互相抵消。**

#### 一个完整小例子

取单行表示

$$
\pi=(1,3,2).
$$

它的循环分解是 $(1)(2\,3)$，所以唯一的不动点是 $1$。沿增长图主对角线得到

$$
D_0=\varnothing,\quad
D_1=(1),\quad
D_2=(1),\quad
D_3=(2,1).
$$

相应的奇数列数量依次为

$$
0,\quad1,\quad1,\quad1.
$$

- $i=1$ 是不动点，在第一行增加一格，奇数列数变成 $1$；
- $i=2$ 是二元换位 $(2\,3)$ 的较小端点，形状不变；
- $i=3$ 是二元换位的较大端点。此时主对角线小格的四个标签为

  $$
  \alpha=(1),\qquad
  \beta=\gamma=(2),\qquad
  \delta=(2,1).
  $$

  因而从 $\alpha$ 到 $\delta$ 正好在第 $1,2$ 行各增加一格，奇数列数保持为 $1$。

最终形状 $\lambda=(2,1)$ 的列长是

$$
\lambda'=(2,1),
$$

只有一列是奇数长度，正好对应唯一的不动点。

由定理立即得到：

1. 若对合有 $m$ 个不动点，则其 RSK 形状恰有 $m$ 个奇数列；
2. 无不动点对合对应的形状每一列都是偶数长度；
3. 因为所有列长之和是 $n$，所以

   $$
   n\equiv\#\{\text{奇数列}\}=m\pmod 2.
   $$

   第一处同余是因为每个偶数列对总格数的奇偶性贡献 $0$，每个奇数列贡献
   $1$。另一方面，若对合中有 $k$ 个二元换位，那么

   $$
   n=m+2k,
   $$

   所以从循环分解也得到同一个奇偶关系。

这个结论依赖 $\pi=\pi^{-1}$。一般排列可以含有三元或更长的循环，此时排列矩阵不关于主对角线对称，$P$ 与 $Q$ 也不必相等，奇数列数不再等于不动点数。

### 9.8 竞赛中常用的形状变换

设排列 $\pi=(\pi_1,\ldots,\pi_n)$ 的 RSK 形状为 $\lambda$。下面只说**形状**，不声称表中具体数字也只是简单转置。

| 对原排列的操作 | 新排列 | 新的 RSK 形状 |
|---|---|---|
| 倒转位置 | $(\pi_n,\ldots,\pi_1)$ | $\lambda'$ |
| 反转大小关系 | $(n+1-\pi_1,\ldots,n+1-\pi_n)$ | $\lambda'$ |
| 同时倒转位置和大小 | $(n+1-\pi_n,\ldots,n+1-\pi_1)$ | $\lambda$ |
| 求逆排列 | $\pi^{-1}$ | $\lambda$，并交换 $P,Q$ |

前两条为什么会转置？倒转位置或反转大小都会把“上升”与“下降”互换。更严格地，由第 11 节 Greene 定理，对任意 $k$，它们把 $k$ 条上升链覆盖数变成 $k$ 条下降链覆盖数，即把

$$
\lambda_1+\cdots+\lambda_k
$$

变成

$$
\lambda'_1+\cdots+\lambda'_k.
$$

所有前缀和都确定后，整个新形状只能是 $\lambda'$。同时做两次转置则回到 $\lambda$。

> 只用 LIS/LDS 只能证明第一行和第一列交换；要证明**整个形状**转置，需要 Greene 定理。

---

## 10. Schensted 定理：杨表与最长子序列

### 10.1 子序列不是子串

给定序列 $w_1,w_2,\ldots,w_n$，选择下标

$$
1\leq i_1<i_2<\cdots<i_k\leq n
$$

得到

$$
w_{i_1},w_{i_2},\ldots,w_{i_k},
$$

称为一个**子序列**。被选元素不必连续。

- 严格上升：$w_{i_1}<w_{i_2}<\cdots<w_{i_k}$；
- 弱上升：$w_{i_1}\leq w_{i_2}\leq\cdots\leq w_{i_k}$；
- 严格下降：$w_{i_1}>w_{i_2}>\cdots>w_{i_k}$；
- 弱下降：$w_{i_1}\geq w_{i_2}\geq\cdots\geq w_{i_k}$，也叫非增。

### 10.2 排列版 Schensted 定理

设排列 $\pi$ 经 RSK 得到的共同形状为

$$
\lambda=(\lambda_1,\lambda_2,\ldots),
$$

则

$$
\boxed{
\operatorname{LIS}(\pi)=\lambda_1,
\qquad
\operatorname{LDS}(\pi)=\lambda'_1=\ell(\lambda).
}
$$

也就是说：

- 第一行长度 = 最长严格上升子序列长度；
- 第一列长度 = 最长严格下降子序列长度。

### 10.3 第一行结论的证明

这其实就是你熟悉的 LIS 贪心。

处理完前 $t$ 个数后，设插入表第一行为

$$
b_1<b_2<\cdots<b_L.
$$

维持如下不变量：

> $b_j$ 是前 $t$ 个数中，所有长度为 $j$ 的严格上升子序列的末尾最小值。

初始为空时显然成立。插入新数 $x$ 时，RSK 在第一行找到第一个 $>x$ 的数并替换；因为排列元素互异，这等价于 LIS 算法中的 lower_bound，也就是在有序数组中寻找第一个 $\geq x$ 的位置。若找不到就把 $x$ 接在末尾。这个更新正是“最小末尾”不变量的标准转移：

- 被替换位置以前的最小末尾都小于 $x$，所以能接上 $x$；
- 该位置原值大于 $x$，换成 $x$ 只会让末尾更优；
- 更长的长度不会凭空出现，除非 $x$ 被追加到末尾。

因此第一行在每一步都与 LIS 的 tails 数组完全相同。最终第一行长度就是 LIS 长度：

$$
\operatorname{LIS}(\pi)=\lambda_1.
$$

### 10.4 第一列结论的证明

先固定一种读法。若杨表 $T$ 从上到下的各行为
$R_1,R_2,\ldots,R_r$，定义它的**行读字**为

$$
\operatorname{rw}(T)=R_rR_{r-1}\cdots R_1.
$$

也就是从最下面一行开始，每行从左到右读。

下面只需要两种局部变换：

$$
xzy\longleftrightarrow zxy
\qquad(x\leq y<z),
$$

$$
yxz\longleftrightarrow yzx
\qquad(x<y\leq z).
$$

由这些变换得到的等价关系记作 $\equiv_K$。第 13 节会系统介绍它；这里先证明本节需要的两个引理。

**引理 1：上述局部变换保持最长严格下降子序列长度。**

先看第一种变换。左边 $xzy$ 内能同时选取的两项下降对只有
$z,y$，这个下降对在右边 $zxy$ 中仍存在。右边多出的可能是选取
$z,x$；把其中的 $x$ 换成 $y$ 即可，因为 $z>y\geq x$。若这个
$x$ 后面还接着外部元素 $q$，原来有 $x>q$，于是仍有 $y>q$；替换不会破坏整条下降子序列。只选局部三项中的零项或一项时，位置跨不过区间边界，也不受影响。正、反两个方向使用同一论证，所以第一种变换保持 LDS。

第二种变换同理。$yxz$ 中的下降对 $y,x$ 在 $yzx$ 中仍存在；右边新出现的 $z,x$ 可把 $z$ 换成 $y$。由 $z\geq y>x$ 可知，若前面还有外部元素 $p>z$，也仍有 $p>y$。因此第二种变换也保持 LDS。

**引理 2：对任意字 $w$，有**

$$
w\equiv_K\operatorname{rw}(P(w)).
$$

先只看向一行

$$
R=a_1a_2\cdots a_k
$$

插入 $x$。若 $x$ 直接追加到行尾，$Rx$ 就是插入后的这一行。否则设
$y=a_j$ 是第一个严格大于 $x$ 的数。插入后该行变为

$$
R'=a_1\cdots a_{j-1}x\,a_{j+1}\cdots a_k,
$$

而 $y$ 被顶入下一行。连续使用第二种局部变换，可把末尾的 $x$ 向左移过
$a_k,a_{k-1},\ldots,a_{j+1}$；这是合法的，因为这些数都不小于
$y>x$。再连续使用第一种局部变换，把 $y$ 向左移过
$a_{j-1},\ldots,a_1$；这是合法的，因为这些数都不大于 $x<y$。于是

$$
Rx\equiv_K yR'.
$$

这句话恰好表示：修改后的这一行留在原处，被顶出的 $y$ 移到下一行继续插入。因为行读字把较低的行写在较高的行前面，可以从第一行开始沿整条顶出路径反复使用这个等价式，得到

$$
\operatorname{rw}(T)x
\equiv_K
\operatorname{rw}(T\leftarrow x).
$$

从空表开始，对 $w_1,w_2,\ldots,w_n$ 依次归纳，引理 2 成立。

现在设 $P(\pi)$ 有 $r=\ell(\lambda)$ 行。一方面，行读字的每个单独行块都从左到右弱递增；排列情形因元素互异而严格递增。无论哪种情形，一条严格下降子序列在每行至多取一个数：

$$
\operatorname{LDS}(\operatorname{rw}(P(\pi)))\leq r.
$$

另一方面，第一列从上到下严格递增；在行读字中从下到上读取第一列，恰好得到长度为 $r$ 的严格下降子序列。因此

$$
\operatorname{LDS}(\operatorname{rw}(P(\pi)))\geq r.
$$

两边合并，再用引理 1、2，就有

$$
\operatorname{LDS}(\pi)
=\operatorname{LDS}(\operatorname{rw}(P(\pi)))
=r
=\ell(\lambda)
=\lambda'_1.
$$

证毕。这个证明也允许输入中出现重复值，因此同时证明了下一节中的“第一列等于最长严格下降子序列长度”。

### 10.5 含重复元素时的严格/非严格区别

本文行插入寻找“第一个严格大于 $x$”的元素，所以对一般字 $w$：

$$
\boxed{
\lambda_1=\text{最长弱上升子序列长度},
}
$$

而

$$
\boxed{
\lambda'_1=\text{最长严格下降子序列长度}.
}
$$

第一行的更新正是最长弱上升子序列算法使用的 upper_bound：替换第一个
$>x$ 的末尾；第一列结论已经由第 10.4 节的同一套证明覆盖。

这是非常容易出错的地方。若改用“在每行寻找第一个 $\geq x$ 的元素”的插入约定，所得表是“行严格、列弱增”；此时第一行长度等于最长**严格上升**子序列长度，第一列长度等于最长**弱下降**子序列长度。

---

## 11. Greene 定理：从一条子序列推广到多条

Schensted 定理只解释了 $\lambda_1$ 和 $\lambda'_1$。Greene 定理解释整个形状。

### 11.1 定理

设排列 $\pi$ 的 RSK 形状为 $\lambda$。把一条子序列记成它使用的**位置集合**。对任意 $k\geq1$，有

$$
\boxed{
\lambda_1+\lambda_2+\cdots+\lambda_k
=
\max\{\lvert A_1\cup\cdots\cup A_t\rvert:
0\leq t\leq k,
A_1,\ldots,A_t\text{ 是两两不交的严格上升子序列的位置集合}\}.
}
$$

对下降子序列则有共轭形式

$$
\boxed{
\lambda'_1+\lambda'_2+\cdots+\lambda'_k
=
\max\{\lvert D_1\cup\cdots\cup D_t\rvert:
0\leq t\leq k,
D_1,\ldots,D_t\text{ 是两两不交的严格下降子序列的位置集合}\}.
}
$$

当 $t=0$ 时并集为空集、大小为 $0$。写“至多 $k$ 条”可以同时覆盖
$k>n$ 的边界。这里“两两不交”指所用的原序列位置互不相同，而不是数值集合不交。

当 $k=1$ 时，Greene 定理正好退化成 Schensted 定理。

### 11.2 直观理解

第一行记录“一条上升链最多能拿多少元素”；前两行总长度记录“两条互不相交的上升链最多能覆盖多少元素”；依此类推。杨图的整个轮廓因此编码了序列中所有多链结构，而不仅仅是 LIS/LDS 两个数。

### 11.3 证明思路

把排列位置视为一个偏序集：定义

$$
i\prec j
\quad\Longleftrightarrow\quad
i<j\text{ 且 }\pi_i<\pi_j.
$$

这个偏序中的链正是上升子序列，反链对应下降子序列。RSK 插入过程保持各阶 Greene 不变量；每插入一个元素，杨图增加一个格，同时能由顶出路径精确判断最多 $k$ 条链的可覆盖数是否增加。对插入次数归纳，可得其值恰为前 $k$ 行总长。下降版本可由共轭对偶或对反偏序应用同一论证得到。

完整的形式化证明需要建立“Knuth 等价保持 Greene 不变量”，再把任意字化到其插入表的行读字；第 13 节会定义 Knuth 等价。这通常作为代数组合课程中 RSK 的进阶定理。竞赛应用时，最重要的是准确掌握上述等式及严格/非严格约定。

### 11.4 Erdős–Szekeres 推论

若一个排列没有长度 $r+1$ 的上升子序列，也没有长度 $s+1$ 的下降子序列，则 RSK 形状满足

$$
\lambda_1\leq r,
\qquad
\ell(\lambda)\leq s.
$$

杨图最多有 $s$ 行，每行最多 $r$ 格，所以

$$
n=\lvert\lambda\rvert\leq rs.
$$

因此得到 **Erdős–Szekeres 定理**：

> 任意长度为 $rs+1$ 的互异实数序列，必含长度 $r+1$ 的严格上升子序列，或长度 $s+1$ 的严格下降子序列。

上面的证明先写成了排列语言。对互异实数序列，把最小值替换成 $1$、第二小值替换成 $2$，依次取秩，就得到一个排列；任意两项的大小关系不变，所以严格上升、严格下降子序列也原样保留。

这也是 RSK 最经典的应用之一。

---

## 12. 斜杨表与读字（选读）

### 12.1 斜标准/半标准杨表

设斜形 $\lambda/\mu$ 有

$$
N=\lvert\lambda/\mu\rvert
$$

个格子。

- **斜标准杨表**：把 $1,2,\ldots,N$ 各填一次；同一行中实际存在的格子从左到右严格递增，同一列中实际存在的格子从上到下严格递增。
- **斜半标准杨表**：每格填正整数；同一行中实际存在的格子从左到右弱递增，同一列中实际存在的格子从上到下严格递增。

“实际存在”表示只比较斜形中的格子，已经删掉的内层 $[\mu]$ 不参与比较。

斜标准杨表数常记作

$$
f^{\lambda/\mu}.
$$

普通钩长公式一般**不能**直接用于斜形。斜形计数有行列式公式、Naruse 钩长公式等更高级工具。

### 12.2 读字约定

把杨表转换成一个序列称为取它的**读字**。本文中的**行读字**固定沿用第 10.4 节的定义：从最下面一行到最上面一行，每行从左到右读，记为 $\operatorname{rw}(T)$。

其他资料还可能采用：

- 反行读字：从上到下，每行从右到左读；
- 列读字：按列读取。

不同教材可能使用不同约定。任何涉及读字、Knuth 关系或 Littlewood–Richardson 规则的论述，都必须先声明读法；不能只凭“读字”二字猜测。

### 12.3 Jeu de taquin（滑移）简介

Jeu de taquin（常译作“滑移”）用于把斜杨表整直。这里先只定义**标准斜杨表**上的一次内滑移。当前形状写成 $\lambda/\mu$：

1. 在 $[\mu]$ 中选择一个格 $u$：删去 $u$ 后 $[\mu]$ 仍是杨图，并且 $u$ 的右边或下边至少有一个格属于当前斜形。把 $u$ 当作空格；
2. 若右边、下边都有格子，比较两数并把较小者滑入空格；标准表中的两数不同；
3. 若只有一个邻格存在，就把该邻格滑入空格；
4. 空格随之移动，重复直到右边和下边都没有当前斜形中的格子；此时空格位于当前外层杨图的一个可删除格，删去它。

一次滑移没有删除任何数字：起始格 $u$ 被纳入斜形，终止格从外层形状删去，所以格子总数保持不变。不断重复，直到内层形状变为空分拆，便得到一张直形标准杨表，称为原表的**整直**。

关键定理是：对一个固定的标准斜杨表，反复选择可作内滑移的内边界空格，最终得到的直形标准杨表与这些内边界空格的选择顺序无关。这个结论称为整直定理；它与 RSK、Knuth 等价和 Littlewood–Richardson 系数密切相关。

---

## 13. Knuth 关系与插入表的不变量（选读）

### 13.1 Knuth 基本变换

在字中，对满足相应大小关系的三个相邻字母，可以作下列变换；它们已经在第 10.4 节的 LDS 证明中使用：

$$
xzy\ \longleftrightarrow\ zxy
\qquad(x\leq y<z),
$$

以及

$$
yxz\ \longleftrightarrow\ yzx
\qquad(x<y\leq z).
$$

由这些局部变换生成的等价关系称为 **Knuth 等价**，记作

$$
w\equiv_K w'.
$$

### 13.2 基本定理与证明结构

两个字具有相同的 RSK 插入表，当且仅当它们 Knuth 等价：

$$
\boxed{
P(w)=P(w')
\quad\Longleftrightarrow\quad
w\equiv_K w'.
}
$$

证明分成两向。

**从右向左。** Knuth 的局部插入引理断言：对任意初始半标准杨表 $T$，当
$x\leq y<z$ 时，依次插入

$$
x,z,y\quad\text{与}\quad z,x,y
$$

会得到同一张表；当 $x<y\leq z$ 时，依次插入

$$
y,x,z\quad\text{与}\quad y,z,x
$$

也会得到同一张表。证明是比较两边在第一行的替换位置，再把两边顶出的序列交给下一行归纳。因此在任意字的任意三个相邻位置作一次 Knuth 变换，都不改变最终插入表；连续作变换也不改变。

**从左向右。** 第 10.4 节已经完整证明

$$
w\equiv_K\operatorname{rw}(P(w)).
$$

若 $P(w)=P(w')=T$，那么

$$
w\equiv_K\operatorname{rw}(T)\equiv_K w'.
$$

第一向所用的局部插入引理是本节省略细节的进阶部分；第二向的化归过程已经在第 10.4 节逐步给出。因此本节的定理结论可以直接使用，但证明状态与前面的完整证明有所区别。

这说明：

- 插入表 $P$ 记录字在 Knuth 等价下的本质结构；
- 记录表 $Q$ 记录同一插入结构中元素到达的历史；
- Greene 不变量只依赖 $P$，所以 Knuth 等价的字拥有相同的各阶上升子序列覆盖数。

---

## 14. 常见计数结论汇总

### 14.1 固定形状的标准杨表数

$$
f^\lambda=\frac{\lvert\lambda\rvert!}{\prod_{u\in[\lambda]}h_\lambda(u)}.
$$

### 14.2 所有形状的平方和

$$
\sum_{\lambda\vdash n}(f^\lambda)^2=n!.
$$

### 14.3 所有形状的一次和

$$
\sum_{\lambda\vdash n}f^\lambda=I_n,
$$

其中对合数满足

$$
I_n=I_{n-1}+(n-1)I_{n-2}\qquad(n\geq2),
\qquad I_0=I_1=1.
$$

解释：在一个对合中，元素 $n$ 要么是不动点，剩余部分有 $I_{n-1}$ 种；要么与其余 $n-1$ 个元素之一构成二元换位，剩余部分有 $I_{n-2}$ 种。

还可以按不动点数量细分。对整数 $0\leq m\leq n$，令 $I_{n,m}$
表示恰有 $m$ 个不动点的 $n$ 元对合数，并令 $o(\lambda)$ 表示形状
$\lambda$ 的奇数列数量。第 9.5、9.6 节把对合与单张标准杨表一一对应，第
9.7 节又说明不动点数等于形状的奇数列数，因此

$$
\boxed{
I_{n,m}
=
\sum_{\substack{\lambda\vdash n\\o(\lambda)=m}}f^\lambda.
}
$$

若 $n-m$ 是奇数，则两边都是 $0$。若 $n-m=2k$，其中 $k\geq0$，先选择 $m$ 个不动点，再把其余 $2k$ 个元素两两配对，得到

$$
I_{n,m}
=\binom{n}{m}\frac{(2k)!}{2^k k!}
=\frac{n!}{m!\,2^k k!},
\qquad k=\frac{n-m}{2}.
$$

其中 $(2k)!$ 先把剩余元素排成一列，再把相邻两个元素分成一对；每一对内部交换不产生新换位，所以除以 $2^k$，而 $k$ 对之间重新排序也不产生新结果，所以再除以 $k!$。

### 14.4 限制 LIS/LDS 的排列计数

由 RSK，满足 $\operatorname{LIS}(\pi)\leq r$ 的排列数为

$$
\boxed{
\sum_{\substack{\lambda\vdash n\\\lambda_1\leq r}}(f^\lambda)^2.
}
$$

满足 $\operatorname{LDS}(\pi)\leq s$ 的排列数为

$$
\boxed{
\sum_{\substack{\lambda\vdash n\\\ell(\lambda)\leq s}}(f^\lambda)^2.
}
$$

同时满足两个限制时，只需对落在 $s\times r$ 矩形内的形状求和：

$$
\sum_{\substack{\lambda\vdash n\\\lambda_1\leq r,\ \ell(\lambda)\leq s}}
(f^\lambda)^2.
$$

### 14.5 两行矩形与 Catalan 数

$$
f^{(m,m)}=C_m=\frac1{m+1}\binom{2m}{m}.
$$

这里的 **Dyck 路**是从 $(0,0)$ 出发、恰走 $2m$ 步的格路：每步是上步
$U=(1,1)$ 或下步 $D=(1,-1)$，途中纵坐标始终不小于 $0$，最后到达
$(2m,0)$。

这给出了标准杨表与 Dyck 路的一种联系：读入数字 $1,2,\ldots,2m$，若数字在第一行记作上步，在第二行记作下步；列递增条件保证任意前缀中第一行数字数不少于第二行数字数，因此得到一条 Dyck 路。反向构造也唯一。

---

## 15. 容易混淆和出错的地方

### 15.1 分拆与有序分拆不同

$(1,3)$ 不满足非增条件，不是本文规范记法下的分拆；对应的无序拆分必须规范写成分拆 $(3,1)$。

### 15.2 杨图与杨表不同

- 杨图只有形状，没有数字；
- 杨表是在杨图中填数；
- 标准/半标准描述的是填数规则。

### 15.3 标准与半标准的递增规则不同

- 标准杨表：行严格、列严格，且 $1,\ldots,n$ 各一次；
- 本文半标准杨表：行弱增、列严格，允许重复。

### 15.4 钩不包含左边和上边

格子 $u$ 的钩只包含：自身、右边、下边。不要把整行整列都算进去。

### 15.5 内容可能是负数

内容是 $j-i$：当 $j=i$ 时为 $0$，当 $j>i$ 时为正，当 $j<i$ 时为负。

### 15.6 RSK 插入比较符号不能随意改

本文为了保持“行弱增、列严格”，寻找当前行第一个**严格大于**插入值的元素。若改为寻找第一个 $\geq x$，得到的是“行严格、列弱增”的表；此时第一行对应最长严格上升子序列，第一列对应最长弱下降子序列。

### 15.7 记录表记录的是时间，不是被顶出的值

第 $k$ 次插入在哪里新增长一个格，就在 $Q$ 的那个格子填 $k$。中途被顶出的数字不写进 $Q$。

### 15.8 Greene 定理要求子序列位置不交

多条上升子序列不能重复使用同一个原序列位置，否则前 $k$ 行总长的解释不成立。

### 15.9 普通钩长公式不能直接套斜形

$f^{\lambda/\mu}$ 一般不等于 $\lvert\lambda/\mu\rvert!$ 除以斜形中“看起来像钩长”的乘积。

---

## 16. 从零开始的建议学习顺序

### 第一阶段：只掌握对象

1. 会列出小整数的全部分拆；
2. 会由分拆画杨图，也会从杨图读出分拆；
3. 会求共轭分拆；
4. 能判断一个填数是否为标准/半标准杨表。

### 第二阶段：掌握标准杨表计数

1. 会找可添加格、可删除格；
2. 理解标准杨表与 Young 格路径的双射；
3. 会计算每格的钩长；
4. 能熟练使用钩长公式；
5. 理解分支递推为什么成立。

### 第三阶段：掌握 RSK

1. 不看答案完成一次行插入；
2. 能逐步构造 $P,Q$；
3. 能用逆行插入恢复排列；
4. 能解释为什么 $P,Q$ 形状相同；
5. 能用 Schensted 定理读出 LIS/LDS。

### 第四阶段：掌握进阶联系

1. Greene 定理与多条子序列；
2. RSK 对称性、对合以及不动点与奇数列的对应；
3. 半标准杨表、Kostka 数和 Schur 函数；
4. 斜杨表、Knuth 等价和 jeu de taquin。

---

## 17. 练习题

### 17.1 基础题

1. 写出 $6$ 的全部分拆。
2. 画出 $(5,3,3,1)$ 的杨图，并求其共轭分拆。
3. 找出 $(5,3,3,1)$ 的所有可添加格和可删除格。
4. 判断下表是否是标准杨表；若不是，说明违反哪条规则：

   <table aria-label="练习中待判断的杨表" style="border-collapse:collapse; margin:0.75em 0;">
     <tr>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">6</td>
     </tr>
     <tr>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
     </tr>
     <tr>
       <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
     </tr>
   </table>

5. 写出形状 $(2,1)$ 的全部标准杨表。

### 17.2 钩长题

1. 求 $f^{(3,2)}$。
2. 求 $f^{(3,3)}$，并与 $C_3$ 比较。
3. 求 $f^{(4,3,1)}$。
4. 用分支递推和钩长公式分别计算 $f^{(3,1)}$，核对结果。
5. 证明 $f^{\lambda'}=f^\lambda$。

### 17.3 RSK 题

1. 对排列 $2,5,1,4,3$ 完整计算 $P,Q$。
2. 从你得到的形状读出 LIS 和 LDS 长度，再直接在原排列中找出相应子序列。
3. 对字 $2,1,2,2,1$ 做 RSK，并核对第一行长度等于最长弱上升子序列长度。
4. 对第 9.2 节最后得到的表对执行逆 RSK，恢复排列。
5. 取 $\pi=(2,3,1)$，直接计算 $\pi^{-1}$ 两边的 RSK，验证
   $P(\pi^{-1})=Q(\pi)$ 与 $Q(\pi^{-1})=P(\pi)$。

### 17.4 综合题

1. 用 RSK 证明 $\sum_{\lambda\vdash n}(f^\lambda)^2=n!$。
2. 用 RSK 证明对合排列数等于 $\sum_{\lambda\vdash n}f^\lambda$。
3. 用杨图证明 Erdős–Szekeres 定理。
4. 证明形状 $(m,m)$ 的标准杨表与半长为 $m$ 的 Dyck 路一一对应。
5. 用 Greene 定理解释形状 $(4,2,1)$ 对“一条、两条、三条不交上升子序列”分别意味着什么。

---

## 18. 练习题简要答案

### 18.1 基础题答案

1. $6$ 的分拆共有 $11$ 个：
   $$
   (6),(5,1),(4,2),(4,1,1),(3,3),(3,2,1),(3,1,1,1),
   (2,2,2),(2,2,1,1),(2,1,1,1,1),(1^6).
   $$
2. $(5,3,3,1)'=(4,3,3,1,1)$。
3. 可添加格为
   $$
   (1,6),(2,4),(4,2),(5,1),
   $$
   可删除格为
   $$
   (1,5),(3,3),(4,1).
   $$
4. 是标准杨表。
5. 共两个：

   <div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
     <table aria-label="形状 (2,1) 的第一个标准杨表" style="border-collapse:collapse;">
       <tr>
         <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
         <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
       </tr>
       <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td></tr>
     </table>
     <table aria-label="形状 (2,1) 的第二个标准杨表" style="border-collapse:collapse;">
       <tr>
         <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
         <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
       </tr>
       <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td></tr>
     </table>
   </div>

### 18.2 钩长题答案

1. $f^{(3,2)}=5$。
2. $f^{(3,3)}=5=C_3$。
3. $f^{(4,3,1)}=70$。
4. $f^{(3,1)}=3$。
5. 转置给出双射；或观察对应格子的臂腿互换，钩长不变。

### 18.3 RSK 题答案

对 $2,5,1,4,3$，最终应得到

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P</strong>
    <table aria-label="排列 2,5,1,4,3 的插入表 P" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td></tr>
    </table>
  </div>
  <div>
    <strong>Q</strong>
    <table aria-label="排列 2,5,1,4,3 的记录表 Q" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td></tr>
    </table>
  </div>
</div>

共同形状为 $(2,2,1)$，所以 LIS 长度为 $2$，LDS 长度为 $3$。例如
$2,5$ 是长度 $2$ 的上升子序列，$5,4,3$ 是长度 $3$ 的下降子序列。

对字 $2,1,2,2,1$，最终得到

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P</strong>
    <table aria-label="字 2,1,2,2,1 的插入表 P" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      </tr>
    </table>
  </div>
  <div>
    <strong>Q</strong>
    <table aria-label="字 2,1,2,2,1 的记录表 Q" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">4</td>
      </tr>
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">5</td>
      </tr>
    </table>
  </div>
</div>

第一行长为 $3$；原字中的 $1,2,2$（位置 $2,3,4$）是一条长度 $3$ 的弱上升子序列。

对第 9.2 节的最终表对，逆插入按 $Q$ 中的 $4,3,2,1$ 依次输出

$$
2,4,1,3.
$$

这是从后往前的输出顺序，因此原排列为 $(3,1,4,2)$。

对 $\pi=(2,3,1)$，有 $\pi^{-1}=(3,1,2)$。第 9.6 节已经算出
$P(\pi)$ 的两行分别是 $(1,3)$、$(2)$，而 $Q(\pi)$ 的两行分别是
$(1,2)$、$(3)$。直接对 $(3,1,2)$ 插入得到：

<div style="display:flex; gap:2em; align-items:flex-start; margin:0.75em 0;">
  <div>
    <strong>P(π<sup>−1</sup>)</strong>
    <table aria-label="排列 3,1,2 的插入表" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td></tr>
    </table>
  </div>
  <div>
    <strong>Q(π<sup>−1</sup>)</strong>
    <table aria-label="排列 3,1,2 的记录表" style="border-collapse:collapse;">
      <tr>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">1</td>
        <td style="border:1px solid; width:2em; height:2em; text-align:center;">3</td>
      </tr>
      <tr><td style="border:1px solid; width:2em; height:2em; text-align:center;">2</td></tr>
    </table>
  </div>
</div>

左表正是 $Q(\pi)$，右表正是 $P(\pi)$，两张表恰好交换。

### 18.4 综合题答案

1. 排列版 RSK 把每个 $n$ 元排列对应到一对同形标准杨表。固定形状
   $\lambda$ 时，表对有 $(f^\lambda)^2$ 个；再对 $\lambda\vdash n$ 求和，便得到
   $$
   n!=\sum_{\lambda\vdash n}(f^\lambda)^2.
   $$
2. 对称性给出 $\pi=\pi^{-1}\iff P(\pi)=Q(\pi)$。因此固定形状
   $\lambda$ 的对合恰好由一张标准杨表决定，共 $f^\lambda$ 个；对形状求和得到
   $I_n=\sum_{\lambda\vdash n}f^\lambda$。
3. 若没有长度 $r+1$ 的严格上升子序列和长度 $s+1$ 的严格下降子序列，
   Schensted 定理给出 $\lambda_1\leq r$、$\ell(\lambda)\leq s$，所以
   $n=\lvert\lambda\rvert\leq rs$。取逆否命题即得长度 $rs+1$ 的结论。
4. 从 $1$ 到 $2m$ 依次读取标准杨表：数字在第一行就记上步，在第二行就记下步。
   前 $k$ 个数字所在格子总成杨图，所以任意前缀中上步不少于下步，最终两者各
   $m$ 步，得到 Dyck 路。反过来，按每一步的种类把步号填进第一行或第二行；
   行自然递增，而第 $j$ 个上步总早于第 $j$ 个下步，故第 $j$ 列也递增。两种构造互逆。
5. 对形状 $(4,2,1)$，Greene 定理给出：至多一条、两条、三条两两位置不交的
   严格上升子序列，最多分别覆盖
   $$
   4,\qquad4+2=6,\qquad4+2+1=7
   $$
   个位置；三个数都是可达到的最大值。

---

## 19. 一页速查

给定 $\lambda\vdash n$：

$$
[\lambda]=\{(i,j):1\leq i\leq\ell(\lambda),\ 1\leq j\leq\lambda_i\},
\qquad
\lambda'_j=\#\{i:\lambda_i\geq j\}.
$$

格子 $u=(i,j)$：

$$
h_\lambda(i,j)=\lambda_i-j+\lambda'_j-i+1,
\qquad
c(i,j)=j-i.
$$

标准杨表数：

$$
f^\lambda
=\frac{n!}{\prod_{u\in[\lambda]}h_\lambda(u)},
\qquad
f^\lambda=\sum_{u\in R(\lambda)}f^{\lambda-u}.
$$

半标准杨表（数字不超过 $m$）：

$$
\lvert\operatorname{SSYT}_m(\lambda)\rvert
=\prod_{u\in[\lambda]}\frac{m+c(u)}{h_\lambda(u)}.
$$

排列 $\pi$ 的 RSK 形状为 $\lambda$：

$$
\operatorname{LIS}(\pi)=\lambda_1,
\qquad
\operatorname{LDS}(\pi)=\lambda'_1.
$$

一般字、采用本文行插入规则：

$$
\lambda_1=\text{最长弱上升子序列长度},
\qquad
\lambda'_1=\text{最长严格下降子序列长度}.
$$

RSK 计数：

$$
\sum_{\lambda\vdash n}(f^\lambda)^2=n!,
\qquad
\sum_{\lambda\vdash n}f^\lambda=I_n.
$$

---

## 20. 后续学习方向

学完本文后，可以按以下路线继续：

1. **对称函数**：完全齐次对称函数、初等对称函数、Schur 函数、Jacobi–Trudi 恒等式、Cauchy 恒等式；
2. **斜杨表**：jeu de taquin、整直、Littlewood–Richardson 规则、Naruse 钩长公式；
3. **表示论**：对称群、Specht 模、不可约表示维数为何等于 $f^\lambda$；
4. **概率组合**：Plancherel 测度、随机排列的 LIS、Baik–Deift–Johansson 定理；
5. **算法与竞赛**：LIS、偏序链分解、RSK 形状维护、受限排列计数。

其中表示论能够解释为什么标准杨表会自然标记对称群不可约表示的基，而概率组合则说明杨图为何能描述随机排列的宏观形状。这些内容都建立在本文的分拆、钩长和 RSK 基础之上。
