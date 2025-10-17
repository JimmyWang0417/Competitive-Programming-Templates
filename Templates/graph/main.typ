= 图论
== 最小环
#raw(read("minCycle.hpp"), lang: "cpp")
== 环计数
#raw(read("ringCount.hpp"), lang: "cpp")
== Johnson 多源最短路
#raw(read("johnson.hpp"), lang: "cpp")
== 欧拉路径
#raw(read("eulerTour.hpp"), lang: "cpp")
== tarjan（有向图/无向图）
#raw(read("tarjan.hpp"), lang: "cpp")
== 圆方树
#raw(read("blockForest.hpp"), lang: "cpp")
== 斯坦纳树
#raw(read("steinerTree.hpp"), lang: "cpp")
== 网络流


#include "networkFlow/main.typ"

=== 全局最小割算法（Stoer-Wagner）
#raw(read("stoerWagner.hpp"), lang: "cpp")

== 矩阵树定理
=== 无向图
设 $G$ 是一个有 $n$ 个顶点的无向图。定义度数矩阵 $D(G)$ 为

$ D_(i i)(G) = deg(i), D_(i j) = 0, i != j. $

设 $\#e(i,j)$ 为点 $i$ 与点 $j$ 相连的边数，并定义邻接矩阵 $A$ 为


$ A_(i j)(G)=A_(j i)(G)=\#e(i,j),\ i != j. $

定义 Laplace 矩阵（亦称 Kirchhoff 矩阵）$L$ 为 $L(G) = D(G) - A(G).$

记图 $G$ 的所有生成树个数为 $t(G)$，我们有：

$ t(G) = det L(G)_([n]\\{k},[n]\\{k}). $

=== 有向图

设 $G$ 是一个有 $n$ 个顶点的有向图。定义出度矩阵 $D^(o u t)(G)$ 为

$ D^(o u t)_(i i)(G) = deg^(o u t)(i), D^(o u t)_(i j) = 0, i != j. $

类似地定义入度矩阵 $D^(i n)(G)$。

设 $\#e(i,j)$ 为点 $i$ 指向点 $j$ 的有向边数，并定义邻接矩阵 $A$ 为

$ A_(i j)(G)=\#e(i,j), i!= j. $

定义出度 Laplace 矩阵 $L^(o u t)$ 为

$ L^(o u t)(G) = D^(o u t)(G) - A(G). $

定义入度 Laplace 矩阵 $L^(i n)$ 为

$ L^(i n)(G) = D^(i n)(G) - A(G). $

记图 $G$ 的以 $k$ 为根的所有根向树形图个数为 $t^(r o o t)(G,k)$。所谓根向树形图，是说这张图的基图是一棵树，所有的边全部指向父亲。我们有
$ t^(r o o t)(G,k) = det L^(o u t)(G)_([n]\\{k},[n]\\{k}). $


记图 $G$ 的以 $k$ 为根的所有叶向树形图个数为 $t^(l e a f)(G,k)$。所谓叶向树形图，是说这张图的基图是一棵树，所有的边全部指向儿子。我们有
$ t^(l e a f)(G,k) = det L^(i n)(G)_([n]\\{k},[n]\\{k}). $


== LGV引理

=== 引理说明
LGV 引理可以用来处理有向无环图上不相交路径计数等问题，仅适用于 #strong([有向无环图])。

$omega(P)$ 表示 $P$ 这条路径上所有边的边权之积。（路径计数时，可以将边权都设为 $1$）（事实上，边权可以为生成函数）

$e(u, v)$ 表示 $u$ 到 $v$ 的 #strong("每一条") 路径 $P$ 的 $omega(P)$ 之和，即 $ e(u, v)=sum_{P:u arrow v} omega(P) . $

起点集合 $A$，是有向无环图点集的一个子集，大小为 $n$。

终点集合 $B$，也是有向无环图点集的一个子集，大小也为 $n$。

一组 $A arrow B$ 的不相交路径 $S$：$S_i$ 是一条从 $A_i$ 到 $B_(sigma(S)_i)$ 的路径（$sigma(S)$ 是一个排列），对于任何 $i != j$，$S_i$ 和 $S_j$ 没有公共顶点。

$t(sigma)$ 表示排列 $sigma$ 的逆序对个数。

$
  M = mat(
    e(A_1,B_1), e(A_1,B_2), ..., e(A_1,B_n);
    e(A_2,B_1), e(A_2,B_2), ..., e(A_2,B_n);
    dots.v, dots.v, dots.down, dots.v;
    e(A_n,B_1), e(A_n,B_2), ..., e(A_n,B_n);
  )\
  det(M)=sum_(S:A arrow B)(-1)^(t(sigma(S))) product_(i=1)^n omega(S_i)
$


其中 $sum_(S:A arrow B)$ 表示满足上文要求的 $A arrow B$ 的每一组不相交路径 $S$。

=== 引理应用
我们可以发现，如果给出的图是 #strong([有向无环平面图]) 。

实际上引理右式等价于不相交路径计算的子集容斥。

所以我们可以通过这个引理处理平面图上不相交路径的计数。

=== 树哈希
使用函数 $f(x)$ 来解决树哈希问题。
$ f(u) equiv sum_(v in s o n_v)f(v) dot op("prime")(s i v e_v) $