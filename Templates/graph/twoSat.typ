== 2-SAT

设布尔变量为 $x_0,dots,x_(n-1)$。每个变量拆成两个文字 $x_i,not x_i$；代码中可令 `id(x_i)=2*i+1`、`id(!x_i)=2*i`，于是文字 $u$ 的否定为 `u^1`。

=== 子句建图

对子句 $(p or q)$，若 $p$ 为假则 $q$ 必须为真，若 $q$ 为假则 $p$ 必须为真：
$
  (p or q)
  equiv (not p arrow.r q)
  and (not q arrow.r p).
$
因此加入两条边 $not p arrow.r q$、$not q arrow.r p$。强制 $p$ 为真等价于单位子句 $(p or p)$，加入 $not p arrow.r p$。

=== 为什么要连“反边”

对每条 $u arrow.r v$，必须同时显式加入逆否边 $not v arrow.r not u$。它是*两端取反再反向*，不是普通反向边 $v arrow.r u$。

逻辑上 $u arrow.r v$ 与其逆否命题完全等价，第二条边不改变可行赋值；但 SCC 算法只认识图上的显式可达关系，不会自动补出逻辑逆否。配对边保证
$
  u arrow.r^* v
  quad arrow.r.long quad
  not v arrow.r^* not u,
$
使缩点 DAG 的分量与其否定成对出现，SCC 判定和逆拓扑构造赋值的证明才成立。若每个子句只任取一条蕴含边，图可能漏掉矛盾；具体反例见 `docs/graph/two-sat.md`。

=== 判定与构造

建图后求强连通分量。公式可满足当且仅当
$
  forall i, op("SCC")(x_i) != op("SCC")(not x_i).
$
若同属一个 SCC，则两者互相推出，必然矛盾。否则按缩点 DAG 的逆拓扑序处理一对互补分量，先处理者取真、其互补分量取假；具体大小比较取决于 SCC 编号方向。若 Tarjan 在 SCC 弹出时依次编号，即“汇点在前”，则 `comp[true] < comp[false]` 时令变量为真。

时间、空间复杂度均为 $O(n+m)$，其中 $m$ 是蕴含图边数。
