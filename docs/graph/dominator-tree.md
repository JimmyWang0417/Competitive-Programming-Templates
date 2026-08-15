# 支配树：Lengauer–Tarjan 算法教程

> 本文只讲 Lengauer–Tarjan 支配树算法及其必要前置。纸质速查见 [支配树模板](../../Templates/graph/dominatorTree.typ)，实现见 [`DominantTree` 结构体](../../Templates/graph/dominatorTree.hpp)。
>
> 本文按 [Lengauer–Tarjan 原论文](https://www.cs.princeton.edu/courses/archive/spring03/cs423/download/dominators.pdf) 核对定义、推导和复杂度；[OI Wiki 支配树页面](https://oi-wiki.org/graph/dominator-tree/) 中与 LT 有关的不准确表述不再沿用，正文直接给出修正后的版本。
>
> 本文不介绍删点法、数据流迭代、DAG 特例、后支配树和扩展应用。

## 阅读主线

$$
\text{支配与立即支配}
\to\text{DFS 树}
\to\text{半支配点}
\to\text{半支配点递推}
\to\text{LINK/EVAL}
\to\text{桶}
\to\text{正序修正}.
$$

若只想对应代码，依次阅读第 0、1、2、3、4、5、6、8、9 节。

---

## 0. 约定与符号

设有向图为

$$
G=(V,E),
$$

指定入口 $s$。只讨论从 $s$ 可达的点集

$$
R=\operatorname{Reach}(s).
$$

令 $N$ 为可达点数，$M$ 为两个端点都在 $R$ 中的边数，即

$$
N=|R|,
\qquad
M=|\{(x,y)\in E:x\in R,\ y\in R\}|.
$$

不可达点不属于支配树；否则“每条 $s$ 到该点的路径”会因为路径不存在而真空成立。

沿用 LT 原论文的约定，本文把有向路径写成顶点序列，允许顶点重复；要求不重复时明确称为“简单路径”。这一约定不改变支配关系，也不改变非根点最终取到的半支配点。

| 数学对象 | 代码对应 | 含义 |
|---|---|---|
| $u\mathrel{\operatorname{dom}}v$ | — | $u$ 支配 $v$ |
| $\operatorname{Dom}(v)$ | — | 支配 $v$ 的所有点 |
| $\operatorname{idom}(v)$ | `idom[v]` | $v$ 的立即支配点 |
| $T_D$ | — | 支配树 |
| $T_F$ | — | 从 $s$ 得到的 DFS 树 |
| $\operatorname{dfn}(v)$ | `dfn[v]` | $v$ 的 DFS 首次访问序 |
| $\operatorname{dfn}^{-1}(i)$ | `rk[i]` | DFS 序为 $i$ 的点 |
| $\operatorname{parent}_F(v)$ | `fa[v]` | $v$ 的 DFS 树父亲 |
| $u\prec_{\mathrm{dfn}}v$ | `dfn[u] < dfn[v]` | $u$ 比 $v$ 更早被 DFS 访问 |
| $u\preceq_{\mathrm{dfn}}v$ | `dfn[u] <= dfn[v]` | $u$ 不晚于 $v$ 被 DFS 访问 |
| $u\preceq_F v$ | — | $u$ 是 $v$ 的 DFS 树祖先，允许相等 |
| $u\prec_F v$ | — | $u$ 是 $v$ 的 DFS 树严格祖先 |
| $\operatorname{sdom}(v)$ | `sdom[v]` | $v$ 的半支配点 |
| $\operatorname{Pred}(v)$ | `H[v]` | $v$ 的可达前驱集合 |
| $\mathcal B(x)$ | `U[x]` | 半支配点为 $x$ 的待处理点组成的桶 |

全文用 $\prec_{\mathrm{dfn}}$、$\preceq_{\mathrm{dfn}}$ 表示 DFS 访问先后；裸的 $<$、$\le$ 只用于整数和下标。

公式只使用数学对象，例如 $\operatorname{sdom}(v)$、$\operatorname{parent}_F(v)$ 和 $\operatorname{dfn}^{-1}(i)$；实际数组名只在紧邻公式的代码对应说明中出现。

---

## 1. 必要前置：支配、立即支配与支配树

### 1.1 支配

对 $u,v\in R$，如果每一条从 $s$ 到 $v$ 的有向路径都经过 $u$，就称 $u$ **支配** $v$：

$$
u\mathrel{\operatorname{dom}}v.
$$

路径包含两个端点，所以：

$$
s\mathrel{\operatorname{dom}}v,
\qquad
v\mathrel{\operatorname{dom}}v.
$$

若 $u\ne v$，则称 $u$ 严格支配 $v$。

支配具有传递性：

$$
u\mathrel{\operatorname{dom}}v,
\quad
v\mathrel{\operatorname{dom}}w
\quad\Longrightarrow\quad
u\mathrel{\operatorname{dom}}w.
$$

### 1.2 同一点的支配点形成一条链

对固定目标 $w$，任取两个不同支配点 $u,v\in\operatorname{Dom}(w)$，必有

$$
u\mathrel{\operatorname{dom}}v
\quad\text{或}\quad
v\mathrel{\operatorname{dom}}u.
$$

**证明。** 取一条简单的 $s$ 到 $w$ 路径，$u,v$ 都会出现。不妨 $u$ 在 $v$ 之前。若 $u$ 不支配 $v$，存在一条避开 $u$ 的 $s$ 到 $v$ 路径；把它接上原路径从 $v$ 到 $w$ 的后缀，就得到一条避开 $u$ 的 $s$ 到 $w$ 路径，与 $u$ 支配 $w$ 矛盾。$\square$

因此可以把 $w$ 的支配点从根到 $w$ 排成

$$
s=d_0\mathrel{\operatorname{dom}}d_1
\mathrel{\operatorname{dom}}\cdots
\mathrel{\operatorname{dom}}d_k=w.
$$

### 1.3 立即支配点

对 $v\ne s$，立即支配点 $d=\operatorname{idom}(v)$ 是满足下列条件的严格支配点：

> $v$ 的每一个其他严格支配点都支配 $d$。

换句话说，它是支配链上紧挨着 $v$ 的前一个点。

立即支配点不是“原图中距离 $v$ 最近的支配点”；原图距离与定义无关。

因为固定目标的支配点形成有限链，所以每个非根可达点都有唯一的 `idom`。根的 `idom` 在数学上未定义；仓库代码只在数组槽中放置哨兵：

```cpp
idom[root] = 0;
```

### 1.4 支配树

对每个 $v\ne s$ 加入父边

$$
\operatorname{idom}(v)\to v.
$$

这些边构成以 $s$ 为根的支配树 $T_D$，并且

$$
u\mathrel{\operatorname{dom}}v
\quad\Longleftrightarrow\quad
u\text{ 是 }v\text{ 在 }T_D\text{ 中的祖先}.
$$

LT 算法的输出就是每个可达非根点的支配树父亲 `idom[v]`。

---

## 2. DFS 树与半支配点

### 2.1 DFS 树不是支配树

LT 算法先从 $s$ 做 DFS，按首次访问顺序编号；可达点的编号恰为

$$
\{\operatorname{dfn}(v):v\in R\}=\{1,2,\ldots,N\}.
$$

只有发现新顶点的边构成 DFS 树 $T_F$。数学上记其父亲为 $\operatorname{parent}_F(v)$，代码存于 `fa[v]`。

DFS 父亲通常不等于立即支配点。例如

$$
1\to2,
\quad1\to3,
\quad2\to4,
\quad3\to4.
$$

若 DFS 先走 $1\to2\to4$，则 `fa[4] = 2`；但路径 $1\to3\to4$ 绕开 $2$，所以

$$
\operatorname{idom}(4)=1.
$$

### 2.2 DFS 路径引理

**DFS 路径引理。** 若 $v\preceq_{\mathrm{dfn}}w$，则任意一条原图中从 $v$ 到 $w$ 的路径，都包含一个同时是 $v,w$ 的 DFS 树祖先的点。

这是半支配点证明使用的核心 DFS 性质。直观上，DFS 的递归区间彼此嵌套；路径若离开一个 DFS 子树，就必须经过已经发现的区域，从而在路径上遇到包住相关区间的共同祖先。

不能用“不同 DFS 子树之间没有边”代替这条引理，因为有向图完全可以有跨树边。

### 2.3 半支配点的定义

对可达非根点 $w$，考虑所有满足下列条件的原图路径：

$$
x=v_0\to v_1\to\cdots\to v_k=w,
\qquad k\ge1,
$$

并且所有内部点都晚于 $w$：

$$
\operatorname{dfn}(v_i)>\operatorname{dfn}(w),
\qquad1\le i<k.
$$

因此半支配点可以直接写成

$$
\operatorname{sdom}(w)
=
\underset{
\substack{
x=v_0\to v_1\to\cdots\to v_k=w,\ k\ge1\\
\operatorname{dfn}(v_i)>\operatorname{dfn}(w)\ (1\le i<k)
}
}{\arg\min}
\operatorname{dfn}(x).
$$

必须注意：

- 路径在原图中，不要求沿 DFS 树；
- 只限制内部点，不限制起点；
- 直接边 $x\to w$ 没有内部点，自动合法；
- 最小值按 `dfn`，不是按输入点编号；
- 数学上不定义根的 `sdom`，代码中的 `sdom[root] = root` 只是哨兵。

### 2.4 两个关键性质

DFS 父边

$$
\operatorname{parent}_F(w)\to w
$$

总是合法候选，因此

$$
\operatorname{sdom}(w)\prec_{\mathrm{dfn}}w.
$$

结合 DFS 路径引理还可以证明：

$$
\operatorname{sdom}(w)\prec_F w.
$$

另一方面，任何支配 $w$ 的点都在 DFS 树的根到 $w$ 路径上。把“根到 `sdom(w)` 的 DFS 树路径”和“半支配见证路径”拼起来，可以绕开 `sdom(w)` 与 $w$ 之间的所有严格 DFS 祖先。因此

$$
\operatorname{idom}(w)
\preceq_F
\operatorname{sdom}(w)
\prec_F w.
$$

`sdom(w)` 不一定真的支配 $w$；它只是求 `idom` 的中间量。

---

## 3. 按前驱扫描顺序写出半支配点递推

这一节先给数学公式，再说明代码如何保存公式中的量。

### 3.1 处理到 $u$ 时，LINK 路径上哪些值已经确定

算法按逆 DFS 序处理顶点。处理 $u$ 时，比 $u$ 晚的点已经求出半支配点，不晚于 $u$ 的点尚未求出，代码仍保留初始化值“自身”。用

$$
\sigma_u(x)=
\begin{cases}
\operatorname{sdom}(x),&u\prec_{\mathrm{dfn}}x,\\
x,&x\preceq_{\mathrm{dfn}}u
\end{cases}
$$

统一表示此刻顶点 $x$ 提供的候选值。$\sigma_u$ 只是描述算法当前状态，不是另一种半支配关系。

若前驱 $v$ 不早于 $u$，令 $a_u(v)$ 为 $v$ 的 DFS 祖先中“最深且不晚于 $u$”的一个：

$$
a_u(v)=
\underset{\preceq_F}{\max}
\{x\mid x\preceq_F v, x\preceq_{\mathrm{dfn}}u\}.
$$

这里的 $\max_{\preceq_F}$ 表示在根到 $v$ 的祖先链上取最深者。于是从 $a_u(v)$ 到 $v$ 的树路径，正好是此刻 `find` 所汇总的 LINK 路径；除 $a_u(v)$ 外，其余点都晚于 $u$。

### 3.2 每条前驱边的贡献

对每个可达前驱 $v\in\operatorname{Pred}(u)$，定义这条边对 $u$ 的候选为

$$
c_u(v)=
\begin{cases}
v,
&v\prec_{\mathrm{dfn}}u,\\[2mm]
\displaystyle
\underset{\preceq_{\mathrm{dfn}}}{\min}
\{\sigma_u(x)\mid a_u(v)\preceq_F x\preceq_F v\},
&u\preceq_{\mathrm{dfn}}v.
\end{cases}
\tag{1}
$$

半支配点就是所有前驱贡献中 DFS 序最小的一个：

$$
\operatorname{sdom}(u)
=
\underset{
x\in\{c_u(v)\mid v\in\operatorname{Pred}(u)\}
}{\arg\min}
\operatorname{dfn}(x).
\tag{2}
$$

式 (2) 直接返回候选顶点。代码只维护这个顶点的 DFS 序，因此使用下面的等价存储关系：

$$
\operatorname{dfn}(\operatorname{sdom}(u))
=
\min_{v\in\operatorname{Pred}(u)}
\operatorname{dfn}(c_u(v))
.
\tag{3}
$$

式 (1)、(2) 正好对应算法思路：先算每条前驱边的贡献，再按 DFS 序取 `argmin`。式 (3) 只解释代码为何能用一个整数保存这个结果。

### 3.3 两个分支为何正确

若 $v\prec_{\mathrm{dfn}}u$，单边路径 $v\to u$ 没有内部点，故 $v$ 本身就是合法候选。

若 $u\preceq_{\mathrm{dfn}}v$，LINK 路径上的候选有两类：

- $a_u(v)$ 本身；树路径 $a_u(v)\to_F\cdots\to_Fv$ 再接边 $v\to u$，所有内部点都晚于 $u$；
- 路径上某个晚点 $x$ 的 $\operatorname{sdom}(x)$；把 $x$ 的半支配见证路径、$x$ 到 $v$ 的 DFS 树路径和 $v\to u$ 拼接起来，仍得到 $u$ 的合法见证路径。

式 (1) 正是在这些候选中取最早者。若 $v=u$ 是自环，则 $a_u(v)=u$，LINK 路径只有 $u$，所以 $c_u(u)=u$；DFS 父边一定给出更早候选，自环不会成为非根点的答案。

反方向上，把 $u$ 的一条半支配见证路径按最后一条前驱边拆开，再使用 DFS 路径引理，起点必会落入式 (1) 的某个候选中。因此式 (2) 不会漏掉真正的半支配点。

### 3.4 三个公式怎样落到代码

对早前驱，式 (1) 的第一支直接对应 `dfn[v]`。对不早于 $u$ 的前驱，`find(v)` 汇总式 (1) 中的 LINK 路径；调用结束后，代码当前保存的 `sdom[minn[v]]` 就是 $c_u(v)$。局部变量 `res` 保存式 (3) 右侧的最小 DFS 序，`rk[res]` 再把它映回式 (2) 选中的顶点：

```cpp
find(v);
if (dfn[v] < dfn[u])
    res = min(res, dfn[v]);
else
    res = min(res, dfn[sdom[minn[v]]]);
sdom[u] = rk[res];
```

公式没有把 `res` 或 `minn` 当作数学定义；它们只是式 (1)～(3) 的存储方式。

---

## 4. LINK/EVAL 如何实现式 (1)

### 4.1 LINK：逆序加入 DFS 父边

求完 $\operatorname{sdom}(u)$ 后，算法加入

$$
\operatorname{LINK}(\operatorname{parent}_F(u),u).
\tag{4}
$$

代码只需

```cpp
par[u] = fa[u];
```

因为顶点按逆 DFS 序加入，当前 LINK 边构成 DFS 树的一片子森林；每次 EVAL 只沿所在分量代表元到查询点的唯一 DFS 祖先链聚合。路径压缩后，保存的指针可以越过若干祖先，不再逐边等于 DFS 父边。

### 4.2 EVAL：求路径上贡献最小的标签

对式 (1) 第二支中的前驱 $v$，定义 EVAL 标签 $e_u(v)$ 为 LINK 路径上的一个最优位置：

$$
e_u(v)
\in
\underset{a_u(v)\preceq_F x\preceq_F v}{\arg\min}
\operatorname{dfn}(\sigma_u(x)).
\tag{5}
$$

于是式 (1) 的第二支可以紧凑地写成

$$
c_u(v)=\sigma_u(e_u(v)).
\tag{6}
$$

式 (5) 允许代表元 $a_u(v)$ 参与比较，这一点与当前结构体一致；若代表元尚未逆序处理，它按 $\sigma_u(a_u(v))=a_u(v)$ 提供候选。

### 4.3 `find` 的数学不变量

令 $\pi(x)$ 表示当前压缩森林父指针，$b(x)$ 表示当前保留的最佳标签。它们在代码中分别存于 `par[x]` 和 `minn[x]`。递归处理完父侧路径后，`find` 做的合并是

$$
b(x)\leftarrow
\begin{cases}
b(\pi(x)),
&\sigma_u(b(\pi(x)))
  \prec_{\mathrm{dfn}}
  \sigma_u(b(x)),\\
b(x),&\text{否则},
\end{cases}
\tag{7}
$$

随后压缩一层：

$$
\pi(x)\leftarrow\pi(\pi(x)).
\tag{8}
$$

式 (7) 保留两段路径中贡献更早的标签，式 (8) 缩短祖先链；所以压缩不会丢掉式 (5) 的最优位置。对应代码为

```cpp
find(par[x]);
if (dfn[sdom[minn[x]]] > dfn[sdom[minn[par[x]]]])
    minn[x] = minn[par[x]];
return par[x] = par[par[x]];
```

`find(x)` 的返回值只是代表元；调用方真正使用的是调用后保存于 `minn[x]` 的 EVAL 标签。对早前驱也会调用一次 `find`，但此时该点尚未 LINK，立即返回自身。

---

## 5. 桶定理与立即支配点公式

### 5.1 桶的处理时机

求出 $\operatorname{sdom}(w)$ 并完成式 (4) 后，把 $w$ 放入

$$
\mathcal B(\operatorname{sdom}(w)).
$$

再令

$$
p=\operatorname{parent}_F(w),
$$

处理并清空 $\mathcal B(p)$。因此处理桶主人 $p$ 时，每个 $v\in\mathcal B(p)$ 都满足

$$
\operatorname{sdom}(v)=p,
$$

且从 $p$ 到 $v$ 的相关 DFS 树段已经全部 LINK。

代码中的

```cpp
for (auto v : U[u = fa[u]])
```

会把局部变量 `u` 从“本轮逆序处理的点 $w$”改成“桶主人 $p$”；逐行阅读时要特别注意这个含义变化。

### 5.2 桶阶段先得到一个暂定父亲

对 $v\in\mathcal B(p)$，相关 LINK 路径上除桶主人 $p$ 外的点都已求出半支配点。此时的 EVAL 标签满足

$$
e_p(v)
\in
\underset{p\prec_F x\preceq_F v}{\arg\min}
\operatorname{dfn}(\operatorname{sdom}(x)).
$$

集合非空，因为其中至少有 $v$。虽然 `find` 的代表元 $p$ 也参加内部比较，但 $\operatorname{sdom}(v)=p$ 已提供相同贡献，而式 (7) 在并列时保留当前标签，所以代表元不会改变这里的结果。

定义桶阶段的暂定父亲 $d(v)$：

$$
d(v)=
\begin{cases}
p,
&\operatorname{sdom}(e_p(v))=p,\\
e_p(v),
&\operatorname{sdom}(e_p(v))\prec_{\mathrm{dfn}}p.
\end{cases}
\tag{9}
$$

因为路径中包含 $v$ 且 $\operatorname{sdom}(v)=p$，EVAL 的贡献不可能晚于 $p$，所以式 (9) 已覆盖全部情况。

代码在 `find(v)` 后以 `minn[v]` 保存 $e_p(v)$，并把 $d(v)$ 暂存在 `idom[v]`：

```cpp
find(v);
if (u == sdom[minn[v]])
    idom[v] = u;
else
    idom[v] = minn[v];
```

这里第二支保存的是代理点，不是最终立即支配点。

### 5.3 立即支配点定理

LT 的桶定理给出

$$
\operatorname{idom}(v)=
\begin{cases}
d(v),
&d(v)=\operatorname{sdom}(v),\\
\operatorname{idom}(d(v)),
&d(v)\ne\operatorname{sdom}(v).
\end{cases}
\tag{10}
$$

下面补全这个结论的证明。令

$$
p=\operatorname{sdom}(v),
\qquad
e=e_p(v).
$$

由 $e$ 的定义，$\operatorname{sdom}(e)$ 是 DFS 树段

$$
p\prec_F x\preceq_F v
$$

上最早的半支配点。

#### 引理一：避开祖先会产生更早的半支配点

若 $q\prec_F t$，并且存在一条从 $s$ 到 $t$、避开 $q$ 的路径，则存在

$$
q\prec_F y\preceq_F t
$$

满足

$$
\operatorname{sdom}(y)\prec_{\mathrm{dfn}}q.
\tag{11}
$$

**证明。** 若存在避开 $q$ 的路径，则首先有 $q\ne s$；删去其中的环后仍有一条避开 $q$ 的简单路径 $P$。因为 $P$ 从 $s$ 出发，路径上一定有 DFS 序早于 $q$ 的点。令 $x$ 是 $P$ 上最后一个满足

$$
x\prec_{\mathrm{dfn}}q
$$

的点；令 $y$ 是 $x$ 之后第一个落在 DFS 树段

$$
q\prec_F y\preceq_F t
$$

上的点。这样的 $y$ 存在，因为终点 $t$ 就在这条树段上，而 $P$ 避开了 $q$。

把 $P$ 中从 $x$ 到 $y$ 的部分写成

$$
x=z_0\to z_1\to\cdots\to z_k=y.
$$

断言每个内部点都晚于 $y$。否则，设某个内部点 $z_i\preceq_{\mathrm{dfn}}y$。对路径 $z_i\to\cdots\to y$ 使用 DFS 路径引理，可以在这段路径上找到 $y$ 的一个 DFS 祖先 $z_j$。这里 $z_j\ne y$：否则 $y$ 也是 $z_i$ 的祖先，应有 $y\prec_{\mathrm{dfn}}z_i$，与假设矛盾。由 $x$ 的选取，$z_j$ 不早于 $q$；路径 $P$ 又避开 $q$，所以 $z_j\ne q$。由于 $q,z_j$ 都是 $y$ 的祖先，最终得到严格关系

$$
q\prec_F z_j\prec_F y.
$$

这说明路径在到达 $y$ 之前已经进入上述 DFS 树段，与 $y$ 的选取矛盾。

因此 $x\to\cdots\to y$ 满足半支配见证路径的内部点限制，从而

$$
\operatorname{sdom}(y)
\preceq_{\mathrm{dfn}}x
\prec_{\mathrm{dfn}}q.
$$

引理得证。$\square$

#### 引理二：DFS 祖先的立即支配点位置

若 $z\in R\setminus\{s\}$ 且 $z\preceq_F w$，则

$$
z\preceq_F\operatorname{idom}(w)
\quad\text{或}\quad
\operatorname{idom}(w)\preceq_F\operatorname{idom}(z).
\tag{12}
$$

**证明。** 任取严格位于 $\operatorname{idom}(z)$ 与 $z$ 之间的 DFS 祖先 $x$。它不支配 $z$：否则按立即支配点的定义，$x$ 必须支配 $\operatorname{idom}(z)$，从而 $x\preceq_F\operatorname{idom}(z)$，与 $\operatorname{idom}(z)\prec_Fx$ 矛盾。因此存在一条从 $s$ 到 $z$、避开 $x$ 的路径；再接上从 $z$ 到 $w$ 的 DFS 树路径，就得到一条避开 $x$ 的 $s$ 到 $w$ 路径。

所以 $\operatorname{idom}(w)$ 不可能严格落在 $\operatorname{idom}(z)$ 与 $z$ 之间。它在根到 $w$ 的 DFS 祖先链上，只能位于 $z$ 的下方，或位于 $\operatorname{idom}(z)$ 的上方，正好得到式 (12)。$\square$

#### 情况一：$\operatorname{sdom}(e)=p$

此时由于 $e$ 已在整段上取到最小值，对每个

$$
p\prec_F x\preceq_F v
$$

都有

$$
p\preceq_{\mathrm{dfn}}\operatorname{sdom}(x).
$$

若存在一条从 $s$ 到 $v$ 的路径避开 $p$，引理一会给出某个 $y$ 满足

$$
p\prec_F y\preceq_F v,
\qquad
\operatorname{sdom}(y)\prec_{\mathrm{dfn}}p,
$$

与 $e$ 的最小性矛盾。因此 $p$ 支配 $v$。

另一方面，第 2.4 节已经证明

$$
\operatorname{idom}(v)\preceq_F p.
$$

而 $p$ 是 $v$ 的严格支配点，它必须支配 $\operatorname{idom}(v)$，故 $p\preceq_F\operatorname{idom}(v)$。两式合并得到

$$
\operatorname{idom}(v)=p=d(v).
$$

#### 情况二：$\operatorname{sdom}(e)\prec_{\mathrm{dfn}}p$

$p$ 与 $\operatorname{sdom}(e)$ 都是 $e$ 的 DFS 祖先，因此它们在同一条祖先链上；结合 DFS 序可得

$$
\operatorname{idom}(e)
\preceq_F
\operatorname{sdom}(e)
\prec_F
p
\prec_F
e
\preceq_F
v.
\tag{13}
$$

先对 $e\preceq_F v$ 使用引理二。因为

$$
\operatorname{idom}(v)\preceq_F p\prec_F e,
$$

式 (12) 的第一种位置不可能发生，所以

$$
\operatorname{idom}(v)
\preceq_F
\operatorname{idom}(e).
\tag{14}
$$

下面证明 $\operatorname{idom}(e)$ 也支配 $v$。反设存在一条从 $s$ 到 $v$ 的路径避开

$$
q=\operatorname{idom}(e).
$$

由引理一，存在 $q\prec_F y\preceq_F v$ 满足

$$
\operatorname{sdom}(y)
\prec_{\mathrm{dfn}}q
\preceq_{\mathrm{dfn}}
\operatorname{sdom}(e).
\tag{15}
$$

若 $p\prec_F y\preceq_F v$，式 (15) 会说明 $y$ 的半支配点比 $e$ 更早，与 $e$ 在该树段上的最小性矛盾。因此 $y\preceq_F p$。

由引理一已有 $q\prec_F y$，再结合 $y\preceq_F p\prec_F e$，可知 $y$ 严格位于 $q$ 与 $e$ 之间。此时把下面三段连接起来：

1. 从 $s$ 到 $\operatorname{sdom}(y)$ 的 DFS 树路径；
2. $y$ 的半支配见证路径；
3. 从 $y$ 到 $e$ 的 DFS 树路径。

由式 (15)，$\operatorname{sdom}(y)$ 位于 $q$ 上方；半支配见证路径的内部点都晚于 $y$，第三段又完全位于 $y$ 下方，所以三段都不会经过 $q$。这就构造出一条避开 $q=\operatorname{idom}(e)$ 的 $s$ 到 $e$ 路径，与 $q$ 支配 $e$ 矛盾。因此不存在避开 $q$ 的 $s$ 到 $v$ 路径，即 $q=\operatorname{idom}(e)$ 支配 $v$。作为 $v$ 的严格支配点，$q$ 必须支配 $\operatorname{idom}(v)$，于是

$$
\operatorname{idom}(e)
\preceq_F
\operatorname{idom}(v).
\tag{16}
$$

式 (14)、(16) 合并得到

$$
\operatorname{idom}(v)=\operatorname{idom}(e).
$$

而式 (9) 的第二支正是 $d(v)=e$，所以两种情况合起来就是式 (10)。$\square$

### 5.4 正序实现

第二种情况下 $d(v)=e$。若 $e=v$，就有 $\operatorname{sdom}(e)=\operatorname{sdom}(v)=p$，应当进入式 (9) 的第一支，矛盾。因此 $e\prec_Fv$，从而

$$
d(v)\prec_{\mathrm{dfn}}v.
$$

所以按正 DFS 序处理 $v$ 时，$d(v)$ 的最终立即支配点已经确定。代码正是把式 (10) 写成

```cpp
if (idom[u] != sdom[u])
    idom[u] = idom[idom[u]];
```

---

## 6. Lengauer–Tarjan 完整流程

### 阶段一：DFS

从入口 `root` 做 DFS，得到数学上的 $\operatorname{dfn}$、$\operatorname{dfn}^{-1}$、$\operatorname{parent}_F$ 和可达点数 $N$；代码分别存于 `dfn`、`rk`、`fa`、`dfstime`。

### 阶段二：逆 DFS 序

对

$$
i=N,N-1,\ldots,2,
$$

令 $w=\operatorname{dfn}^{-1}(i)$，依次执行：

1. 对每个 $v\in\operatorname{Pred}(w)$ 计算式 (1) 的贡献；
2. 用式 (2) 求 $\operatorname{sdom}(w)$；
3. 执行 $\operatorname{LINK}(\operatorname{parent}_F(w),w)$；
4. 把 $w$ 加入 $\mathcal B(\operatorname{sdom}(w))$；
5. 令 $p=\operatorname{parent}_F(w)$，用式 (9) 处理并清空 $\mathcal B(p)$。

根不参加逆序循环。DFS 父边总能给出一个早前驱，故每个可达非根点的候选集合非空。

### 阶段三：正 DFS 序

对

$$
i=2,3,\ldots,N,
$$

令 $v=\operatorname{dfn}^{-1}(i)$，按式 (10) 把 $d(v)$ 修正成最终的 $\operatorname{idom}(v)$。循环结束后，立即支配点才全部确定。

---

## 7. 同时覆盖两个核心分支的算例

令入口为 $1$，邻接顺序为

```cpp
G[1] = {2, 4};
G[2] = {3, 5};
G[3] = {4};
G[4] = {5, 3};
```

DFS 树仍是链

$$
1\to2\to3\to4\to5,
$$

因此本例恰有 $\operatorname{dfn}(v)=v$；DFS 链上每个非根点的父亲是它左侧相邻点。

最终计算结果为：

| $v$ | $\operatorname{dfn}(v)$ | $\operatorname{parent}_F(v)$ | $\operatorname{sdom}(v)$ | $d(v)$ | $\operatorname{idom}(v)$ |
|---:|---:|---:|---:|---:|---:|
| 2 | 2 | 1 | 1 | 1 | 1 |
| 3 | 3 | 2 | 1 | 1 | 1 |
| 4 | 4 | 3 | 1 | 1 | 1 |
| 5 | 5 | 4 | 2 | 4 | 1 |

根不列入表中，因为它的 DFS 父亲、半支配点、暂定父亲和立即支配点在数学上均不定义；代码使用的哨兵值统一留到第 8 节说明。

### 7.1 式 (1) 的早前驱和 LINK 路径分支

逆序处理 $u=3$ 时，前驱为 $2,4$。早前驱 $2$ 给出

$$
c_3(2)=2.
$$

对晚前驱 $4$，当前代表元为 $a_3(4)=3$，LINK 路径是 $3\to_F4$。其中

$$
\sigma_3(3)=3,
\qquad
\sigma_3(4)=\operatorname{sdom}(4)=1,
$$

故

$$
c_3(4)=1,
\qquad
\operatorname{sdom}(3)
=\min_{\preceq_{\mathrm{dfn}}}\{2,1\}
=1.
$$

这一步确实使用了代码的 `else` 分支，而不是只靠早前驱。

### 7.2 式 (9) 的代理点和式 (10) 的修正

点 $5$ 满足 $\operatorname{sdom}(5)=2$，所以它进入 $\mathcal B(2)$。处理该桶时，EVAL 在 DFS 路径

$$
2\to_F3\to_F4\to_F5
$$

上比较半支配贡献。标签 $3,4$ 的贡献都等于 $1$；`find(4)` 只在父侧严格更优时才更新，因此并列时保留当前子侧标签 $4$，随后 `find(5)` 从父侧继承 $4$。于是

$$
e_2(5)=4,
\qquad
\operatorname{sdom}(e_2(5))
=\operatorname{sdom}(4)
=1
\prec_{\mathrm{dfn}}2.
$$

由式 (9)，桶阶段得到

$$
d(5)=4.
$$

它不是最终答案。正序阶段应用式 (10)：

$$
\operatorname{idom}(5)
=\operatorname{idom}(d(5))
=\operatorname{idom}(4)
=1.
$$

这个例子同时区分了 DFS 父亲、半支配点、桶阶段暂定父亲和最终立即支配点。

---

## 8. 数学对象与当前结构体的对应关系

本节只解释 [`DominantTree`](../../Templates/graph/dominatorTree.hpp)，不改代码和变量名。

| 数学对象或步骤 | 代码名 | 说明 |
|---|---|---|
| $G$ | `G` | 原图 |
| $\operatorname{Pred}(v)$ | `H[v]` | 反图给出的前驱表；扫描时跳过不可达前驱 |
| $\mathcal B(x)$ | `U[x]` | 尚未处理的半支配点桶；处理后立即清空 |
| $\operatorname{dfn}(v)$ | `dfn[v]` | 点到 DFS 序；不可达点为 0 |
| $\operatorname{dfn}^{-1}(i)$ | `rk[i]` | DFS 序到点 |
| $\operatorname{parent}_F(v)$ | `fa[v]` | DFS 树父亲 |
| $\pi(v)$ | `par[v]` | LINK/EVAL 森林中的当前压缩父指针 |
| $b(v)$、$e_u(v)$ | `minn[v]` | 平时保存状态标签 $b(v)$；本次 `find(v)` 结束后实现当前查询的 $e_u(v)$；存的是顶点，不是 DFS 序 |
| 式 (3) 中的数值最小值 | 局部变量 `res` | 扫描前驱所得的最小 DFS 序，随后由 `rk[res]` 映回顶点 |
| $\operatorname{sdom}(v)$ | `sdom[v]` | 已逆序处理的点为最终半支配点；未处理点暂为自身 |
| $d(v)$ | 桶阶段的 `idom[v]` | 可能是最终答案，也可能只是代理点 |
| $\operatorname{idom}(v)$ | 正序后的 `idom[v]` | 最终立即支配点 |
| $N$ | `dfstime` | 入口可达点数 |

构造函数严格按“建原图和反图 → 初始化 → DFS → 式 (1)～(9) 的逆序阶段 → 式 (10) 的正序阶段”执行。

结构体按 `1..n` 编号，构造函数默认 `root = 1`。根的数学半支配点和立即支配点均不定义；实现状态为

```cpp
dfn[root] = 1;
sdom[root] = root; // 初始化哨兵
idom[root] = 0;    // 根哨兵
```

不可达点也没有半支配点或立即支配点；其数组保持

```cpp
dfn[v] = 0;
sdom[v] = v; // 初始化残留
idom[v] = 0;
```

`G`、`H`、`U` 也都不是最终支配树；如需树邻接表，应在结构体外按最终 `idom` 建立。

---

## 9. 复杂度与实现边界

设输入总点数、总边数为 $n,m$，入口可达部分为 $N,M$。

当前结构体的 LINK 只有

```cpp
par[u] = fa[u];
```

并配合路径压缩，因此属于原论文的 **simple LINK/EVAL**。LT 主体复杂度为

$$
O((N+M)\log N),
$$

前驱阶段的顶层 `find` 次数等于“终点不是根且两端可达”的边数，至多为 $M$；每个可达非根点恰好离开一个桶，桶阶段恰有 $N-1$ 次顶层 `find`。因此顶层 EVAL 查询至多 $M+N-1$ 次；递归调用由 simple LINK/EVAL 的摊还分析计入。

所有点可达时常简写成

$$
O(M\log N).
$$

计入数组初始化和遍历全部输入边，整个构造函数为

$$
O\bigl(n+m+(N+M)\log N\bigr),
$$

空间复杂度为

$$
O(n+m).
$$

原论文的

$$
O(M\alpha(M,N))
$$

需要额外的 `size`、`child` 和平衡 LINK。当前结构体没有这些字段，不能写成逆 Ackermann 复杂度。

实现边界只有四点需要额外留意：

- 只读取可达非根点的最终 `idom`；根和不可达点的 0 都是实现哨兵；
- `find` 的返回值是代表元，EVAL 标签保存在 `minn`；
- 桶阶段写入的 `idom` 可能只是代理点，正序修正不能省；
- 递归 `dfs` 和 `find` 在极深图上有调用栈风险。

主要参考：

- [Lengauer–Tarjan 原论文](https://www.cs.princeton.edu/courses/archive/spring03/cs423/download/dominators.pdf)；
- [OI Wiki：支配树](https://oi-wiki.org/graph/dominator-tree/)；
- [纸质速查版](../../Templates/graph/dominatorTree.typ)；
- [`DominantTree` 结构体](../../Templates/graph/dominatorTree.hpp)。
