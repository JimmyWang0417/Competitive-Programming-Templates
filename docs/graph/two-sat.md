# 2-SAT：蕴含图、配对反边与强连通分量

> 本文用于解释 2-SAT 建图和正确性；纸质速查见 [2-SAT 模板](../../Templates/graph/two_sat.typ)。

## 1. 问题形式

给定布尔变量 $x_0,x_1,\ldots,x_{n-1}$。一个**文字**是变量 $x_i$ 或它的否定 $\neg x_i$。2-SAT 公式是若干个二元析取子句的合取：

$$
(p_1\lor q_1)\land(p_2\lor q_2)\land\cdots\land(p_m\lor q_m),
$$

其中每个 $p_j,q_j$ 都是某个文字。目标是判断能否给所有变量赋真或假，使每个子句至少有一个文字为真，并在可满足时构造一组赋值。

代码中可以使用以下零基编号：

$$
\operatorname{id}(\neg x_i)=2i,
\qquad
\operatorname{id}(x_i)=2i+1.
$$

因此，编号为 $u$ 的文字取反后编号为 $u\mathbin{\mathtt{xor}}1$；Python 中同样可以写作 `u ^ 1`。

## 2. 一个子句为什么产生两条边

对子句 $(p\lor q)$：

- 若 $p$ 为假，为使子句成立，$q$ 必须为真，所以有 $\neg p\to q$；
- 若 $q$ 为假，为使子句成立，$p$ 必须为真，所以有 $\neg q\to p$。

于是

$$
(p\lor q)
\iff(\neg p\to q)
\iff(\neg q\to p),
$$

标准蕴含图显式加入

$$
\neg p\to q,
\qquad
\neg q\to p.
$$

这两条边互为逆否命题。一般地，只要加入 $u\to v$，就同时加入

$$
\neg v\to\neg u.
$$

注意这是**两端取反后反向**，不是普通反向边 $v\to u$，也不是 $\neg u\to\neg v$。

## 3. 逻辑上等价，为什么算法中仍不能省

单独的蕴含 $u\to v$ 与逆否命题 $\neg v\to\neg u$ 在逻辑上完全等价，所以补第二条边不会删去或增加任何可行赋值。

但强连通分量算法操作的是图上的**显式可达关系**。若省略逆否边，图搜索不会自动使用逻辑等价式，路径关系可能缺失。标准证明依赖下面的闭包性质：

$$
u\leadsto v
\Longrightarrow
\neg v\leadsto\neg u.
$$

它保证缩点 DAG 中每个分量 $C$ 都有一个互补分量 $\neg C$，并且所有边在取反后方向反转。SCC 判定和逆拓扑赋值都依赖这个对称结构。

### 3.1 省略配对边会误判的反例

考虑公式

$$
F=(x\lor y)
\land(x\lor\neg y)
\land(\neg x\lor y)
\land(\neg x\lor\neg y).
$$

它不可满足：

- 若 $x$ 为假，前两个子句分别强制 $y$ 为真、为假；
- 若 $x$ 为真，后两个子句分别强制 $y$ 为真、为假。

若错误地为每个子句只选择下面第一条蕴含：

$$
\neg x\to y,
\qquad
\neg x\to\neg y,
\qquad
x\to y,
\qquad
x\to\neg y,
$$

则图中没有从 $y$ 或 $\neg y$ 出发的边，也没有任何变量与其否定处于同一个 SCC。直接套用标准 SCC 判据会错误地报告“可满足”。补上每条边的逆否边后，矛盾路径才完整出现在图中。

## 4. SCC 判定

对完整蕴含图求强连通分量。公式可满足当且仅当

$$
\forall i,\qquad
\operatorname{SCC}(x_i)\ne\operatorname{SCC}(\neg x_i).
$$

必要性：若 $x_i$ 与 $\neg x_i$ 在同一个 SCC，则二者互相推出。无论给 $x_i$ 赋什么值，取真的一侧都会推出取假的一侧，产生矛盾。

充分性：把 SCC 缩成 DAG。互补操作把每个分量 $C$ 映到 $\neg C$，并反转 DAG 中的边。按逆拓扑序处理尚未赋值的一对 $(C,\neg C)$，令先遇到的分量为真、互补分量为假；所有从真分量推出的后继都已经得到兼容赋值，因此最终满足全部蕴含边。

Tarjan 或 Kosaraju 的分量编号方向可能不同，所以不要死记 `comp[x] < comp[!x]`。应先确认编号是拓扑序还是逆拓扑序。若 Tarjan 在 SCC 弹出时依次编号，即先编号汇点，则 `comp[true] < comp[false]` 时把变量设为真。

## 5. 常见约束

| 约束 | 2-CNF |
|---|---|
| $p$ 必须为真 | $(p\lor p)$ |
| $p\lor q$ | $(p\lor q)$ |
| $p\to q$ | $(\neg p\lor q)$ |
| $p=q$ | $(\neg p\lor q)\land(p\lor\neg q)$ |
| $p\ne q$ | $(p\lor q)\land(\neg p\lor\neg q)$ |
| $p,q$ 至多一个为真 | $(\neg p\lor\neg q)$ |

无论使用哪种语言，每个子句都必须加入完整的一对逆否边。

## 6. 复杂度与实现边界

蕴含图有 $2n$ 个点，每个二元子句产生两条边。Tarjan/Kosaraju 的时间与空间复杂度均为 $O(n+m)$。

2-SAT 只处理每个子句至多含两个文字的 CNF。一般 3-SAT 不能直接用相同方法化为线性规模蕴含图；不要把“一个条件推出另一个条件”的普通有向图未经验证就套入 2-SAT 判据。
