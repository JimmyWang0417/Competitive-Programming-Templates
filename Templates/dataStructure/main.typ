= 数据结构
== 树状数组
#raw(read("fenwick.hpp"), lang : "cpp")
== 树链剖分
#raw(read("decomposition.hpp"), lang : "cpp");
== 吉司机的线段树
给出一个长度为 $n$ 的数列 $A$，同时定义一个辅助数组 $B$，$B$ 开始与 $A$ 完全相同。接下来进行了 $m$ 次操作，操作有五种类型，按以下格式给出：

- `1 l r k`：对于所有的 $i\in[l,r]$，将 $A_i$ 加上 $k$（$k$ 可以为负数）。
- `2 l r v`：对于所有的 $i\in[l,r]$，将 $A_i$ 变成 $min(A_i,v)$。
- `3 l r`：求 $sum_(i=l)^(r)A_i$。
- `4 l r`：对于所有的 $i in [l,r]$，求 $A_i$ 的最大值。
- `5 l r`：对于所有的 $i in [l,r]$，求 $B_i$ 的最大值。

在每一次操作后，我们都进行一次更新，让 $B_i arrow.l  max(B_i,A_i)$。

#raw(read("segmentTreeBeats.hpp"), lang : "cpp")
== 笛卡尔树
#raw(read("cartesianTree.hpp"), lang : "cpp");
== Link Cut Tree
#raw(read("linkCutTree.hpp"), lang : "cpp")
== Self-Adjusting Top Tree
#raw(read("topTree.hpp"), lang : "cpp")