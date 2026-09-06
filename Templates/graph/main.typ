= 图论

== 遍历与连通性
=== 欧拉路径
#raw(read("euler_tour.hpp"), lang: "cpp", block: true)
=== Tarjan（有向图/无向图）
#raw(read("tarjan.hpp"), lang: "cpp", block: true)
=== 圆方树
#raw(read("block_forest.hpp"), lang: "cpp", block: true)

== 路径、环与支配
=== Johnson 多源最短路
#raw(read("johnson.hpp"), lang: "cpp", block: true)
=== 最小环
#raw(read("min_cycle.hpp"), lang: "cpp", block: true)
=== 环计数
#raw(read("ring_count.hpp"), lang: "cpp", block: true)
#include "dominator_tree.typ"

== 网络流、匹配与割
#include "network_flow/main.typ"
#include "dilworth.typ"
=== 全局最小割算法（Stoer-Wagner）
#raw(read("stoer_wagner.hpp"), lang: "cpp", block: true)

== 树上与特殊结构
=== 斯坦纳树
#raw(read("steiner_tree.hpp"), lang: "cpp", block: true)
#include "tree_hash.typ"

== 图计数与逻辑
#include "matrix_tree.typ"
#include "lgv.typ"
#include "two_sat.typ"
