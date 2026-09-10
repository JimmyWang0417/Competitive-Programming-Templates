# Johnson 与 Prüfer 说明补充设计

## 目标

补全 Johnson 多源最短路的说明，指出势能重标在最小费用流中的用法；新增 Prüfer 序列的简短说明和常用计数结论。

正文使用直白、可核对的表述，不使用口号式总结，也不把术语当作解释。

## 现状

- `Templates/graph/johnson.hpp` 只有边权重标的核心片段，没有说明势能如何得到、如何还原距离，也没有写适用条件和复杂度。
- `Templates/graph/network_flow/min_cost_flow.hpp` 当前使用 SPFA 求最短路，没有使用势能加 Dijkstra。新增说明不能让读者误以为现有代码已经采用 Johnson 重标。
- 仓库没有 Prüfer 序列、Cayley 公式或给定度数的带标号树计数公式。
- `Templates/graph/matrix_tree.typ` 中的矩阵树定理可以计算一般图的生成树数量，但没有介绍 Prüfer 序列对应的双射和度数性质。

## 文件改动

### `Templates/graph/johnson.typ`

新建 Johnson 说明并嵌入现有 `johnson.hpp`。内容包括：

1. 处理对象是允许负边、但不允许负环的有向图。
2. 增加超级源点，用 Bellman--Ford 求势能 `h`。
3. 把边权改为 $w'(u,v)=w(u,v)+h(u)-h(v)$，并说明该边权非负。
4. 从每个源点运行 Dijkstra，再按 $d(u,v)=d'(u,v)-h(u)+h(v)$ 还原原图距离。
5. 二叉堆实现的时间复杂度写成 $O(nm+n(m+n)\log n)$，空间复杂度不包含答案矩阵时为 $O(n+m)$，保存全部答案时为 $O(n^2+m)$。
6. 明确 `johnson.hpp` 只展示重标片段，`dis` 需要先存好势能。
7. 增加稳定的 Typst 标签，供费用流小节引用。

### `Templates/graph/network_flow/main.typ`

在费用流代码之后增加一段说明：

- 逐次最短增广路可以使用与 Johnson 相同的势能重标；
- 残量边使用约化费用 $c'(u,v)=c(u,v)+p(u)-p(v)$；
- 在约化费用非负时，可以用 Dijkstra 求下一条最短增广路；
- 当前仓库实现使用 SPFA，这段文字介绍的是另一种实现方式；
- 引用 Johnson 小节的势能重标说明。

这里写“使用 Johnson 的势能重标”，不写“把 Johnson 算法直接用于网络流”。

### `Templates/graph/prufer.typ`

新增纸质速查内容，不增加 C++ 实现。内容包括：

1. Prüfer 序列适用于顶点编号为 $1,2,\ldots,n$ 的带标号树，序列长度为 $n-2$。
2. 编码：反复删除编号最小的叶子，并记录它的邻点，直到剩两个点。
3. 解码：各点初始度数为其出现次数加一；反复连接当前编号最小的度数为一的点与序列首项，删去该项并更新度数；最后连接余下两点。
4. 使用小根堆时，编码和解码均为 $O(n\log n)$。
5. 带标号树与长度为 $n-2$、每项属于 $[1,n]$ 的序列一一对应。
6. 点 $i$ 的度数等于它在序列中的出现次数加一。
7. Cayley 公式：$n$ 个带标号点组成的树共有 $n^(n-2)$ 棵。
8. 给定正度数 $d_1,\ldots,d_n$ 且 $\sum_i d_i=2n-2$ 时，满足这些度数的带标号树共有
   $\frac{(n-2)!}{\prod_i(d_i-1)!}$ 棵；条件不满足时数量为零。

内容根据 OI Wiki 的 Prüfer 页面核对，但重新组织和表述，不复制原文。

### `Templates/graph/main.typ`

- 用 `#include "johnson.typ"` 替换原来的 Johnson 标题与裸代码嵌入。
- 在“树上与特殊结构”中加入 `#include "prufer.typ"`。

## 校验

1. 运行仓库现有的 Typst 构建命令，确认新增公式、标签和引用可以编译。
2. 搜索生成文本或源文件，确认 Johnson、Prüfer、Cayley 和费用流引用均已出现。
3. 检查 `git diff`，确认没有改动算法实现，也没有覆盖用户已有修改。
