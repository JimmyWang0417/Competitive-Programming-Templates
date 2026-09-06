=== Lyndon 分解
设字母表上有全序，以下出现的字符串均非空，字符串之间按字典序比较。真前缀或真后缀不包含原串自身与空串。

==== 等价刻画与直接推论
对字符串 $w$，以下条件等价：

+ $w$ 是 Lyndon 串。
+ $w$ 严格小于它的每个真后缀。
+ $w$ 严格小于它的每个非平凡循环移位。
+ 对任意分解 $w = u v$，都有 $u < v$。
+ 对任意分解 $w = u v$，都有 $u v < v u$。

因此，Lyndon 串一定是本原串，即不能写成某个更短字符串的整数次幂；它也不存在同时为真前缀和真后缀的非空字符串，即无 border。若 $|w| > 1$，则 $w$ 的首字符是其中的最小字符，并且严格小于末字符。

每个本原串的循环移位等价类中恰有一个 Lyndon 串，它就是其中字典序最小的循环移位。进一步地，任意字符串的最小循环移位都可唯一写成 $L^t$，其中 $L$ 是 Lyndon 串且 $t$ 是正整数；它本身是 Lyndon 串当且仅当 $t=1$。

==== 拼接结论

+ 若 $u,v$ 都是 Lyndon 串且 $u < v$，则 $u v$ 也是 Lyndon 串，并且
  $ u < u v < v, quad u v < v u. $
+ 若 $u,v$ 是不同的 Lyndon 串，则
  $ u < v arrow.l.r.double u v < v u. $
+ 若 $u,v$ 都是 Lyndon 串且 $u < v$，则对任意正整数 $a,b$，$u^a v^b$ 也是 Lyndon 串，并且
  $ u < u^a v^b < v. $
+ 更一般地，若 Lyndon 串 $L_1 <= L_2 <= dots <= L_k$ 且 $L_1 < L_k$，则 $L_1 L_2 dots L_k$ 是 Lyndon 串。

==== 极长 Lyndon 前后缀
设 $w$ 是长度大于 $1$ 的 Lyndon 串。

+ 令 $v$ 为 $w$ 的最长 Lyndon 真后缀，写成 $w = u v$，则 $u$ 也是 Lyndon 串且 $u < v$。这里的 $v$ 同时是 $w$ 的字典序最小真后缀，这称为 $w$ 的右标准分解。
+ 令 $u$ 为 $w$ 的最长 Lyndon 真前缀，写成 $w = u v$，则 $v$ 也是 Lyndon 串且 $u < v$。

==== 连续块的上升视角

这里的“上升”比较的是连续块的字典序，不是字符逐位单调，也不是从原串中跳着取出的上升子序列。

设 $w=B_1 B_2 dots B_k$，其中 $k>=2$，每个 $B_i$ 都是连续的 Lyndon 块。若

$ B_1 < B_2 < dots < B_k, $

则 $w$ 是 Lyndon 串。反过来，任意长度大于 $1$ 的 Lyndon 串都存在这样的严格上升连续块分解：取上面的任一种标准分解 $w=u v$，就得到两个 Lyndon 块 $u<v$。

因此可以把 Lyndon 串理解为“由若干个按位置排列、且字典序严格上升的连续 Lyndon 块组成”；其中“每块本身是 Lyndon 串”和“块必须连续”都不能省略。

==== Chen--Fox--Lyndon 分解
任意字符串 $w$ 都可以唯一地分解为

$ w = L_1 L_2 dots L_k, quad L_1 >= L_2 >= dots >= L_k, $

其中每个 $L_i$ 都是 Lyndon 串。进一步有：

+ $L_1$ 是 $w$ 的最长 Lyndon 前缀。
+ $L_k$ 是 $w$ 的字典序最小非空后缀。
+ $w$ 的最长 Lyndon 子串长度等于 $max_i |L_i|$。
+ 对任意因子边界，后缀 $L_i L_(i+1) dots L_k$ 的 Lyndon 分解恰为 $L_i,L_(i+1),dots,L_k$。
+ 合并相邻相同因子后，可唯一写成 $w = P_1^(e_1) P_2^(e_2) dots P_m^(e_m)$，其中 $P_1 > P_2 > dots > P_m$，且每个 $e_i$ 都是正整数。
+ 特别地，若 $L$ 是 Lyndon 串，则 $L^t$ 的 Lyndon 分解恰为连续 $t$ 个 $L$。

#raw(read("lyndon.hpp"), lang: "cpp", block: true)
