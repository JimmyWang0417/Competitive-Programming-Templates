=== 集合幂级数复合

集合幂级数把每个集合 $S subset.eq [n]$ 对应到一个系数 $f_S$。最常用的乘法是子集卷积：
$
  (f*g)_S = sum_(T subset.eq S) f_T g_(S without T)
$
其中 $S without T$ 表示从 $S$ 中删去 $T$ 后的补集。这个乘法等价于把集合拆成两个不交的有标号部分。

设普通形式幂级数
$
  F(x)=sum_(k>=0) a_k x^k
$
集合幂级数 $G$ 满足 $G_emptyset=0$。则集合幂复合定义为
$
  F(G)=sum_(k=0)^n a_k G^k
$
其中幂使用子集卷积。因为 $G_emptyset=0$，大小为 $m$ 的集合只会受到 $k<=m$ 的项影响。

最直接的计算方式是维护
$
  P_0 = delta_emptyset, quad P_(k+1)=P_k * G
$
然后把 $a_k P_k$ 加入答案。若每次卷积用快速子集卷积，复杂度约为 $O(n^3 2^n)$；若只需要特殊函数，例如 $op("exp"), op("ln"), op("inv"), op("pow")$，可以用集合幂级数的微分方程或牛顿迭代，把复杂度压到若干次子集卷积。

==== 快速子集卷积

按集合大小分层做 zeta 变换。令
$
  hat(f)_(k,S)=sum_(T subset.eq S, abs(T)=k) f_T
$
则子集卷积在 zeta 后变成按大小的一维卷积：
$
  hat(h)_(k,S)=sum_(i=0)^k hat(f)_(i,S)hat(g)_(k-i,S)
$
最后对每一层做逆 zeta 变换。复杂度为 $O(n^2 2^n)$。

==== 使用条件

- 系数环需要支持加减乘；若要做 $op("inv"), op("ln"), op("exp")$，还需要相关常数可逆。
- 做复合时必须有 $G_emptyset=0$，否则常数项会带来无限级数贡献，必须额外处理普通幂级数截断。
- 若只做异或卷积，用 FWT；若做不交集合拆分，用快速子集卷积，两者不是同一个乘法。

=== 一维 Bostan-Mori

设
$
  R(x)=P(x)/Q(x)=sum_(i>=0) a_i x^i
$
要求 $a_n=[x^n]R(x)$，其中 $Q(0) != 0$。令
$
  Q^-(x)=Q(-x)
$
则
$
  R(x)=P(x)Q^-(x)/(Q(x)Q^-(x))
$
注意分母
$
  Q(x)Q(-x)
$
只含偶次项，因为把 $x$ 换成 $-x$ 后它不变。

令
$
  A(x)=P(x)Q^-(x), quad B(x)=Q(x)Q^-(x)
$
由于 $B(x)$ 只有偶次项，可以写成 $B(x)=C(x^2)$。若 $n$ 为偶数，只需要 $A(x)$ 的偶次项；若 $n$ 为奇数，只需要 $A(x)$ 的奇次项：
$
  [x^n] A(x)/B(x)
  =
  cases(
    [x^(n/2)] A_("even")(x)/C(x), "n 为偶数",
    [x^((n-1)/2)] A_("odd")(x)/C(x), "n 为奇数",
  )
$
其中
$
  A_("even")(x)=sum_i [x^(2i)]A(x) x^i, quad
  A_("odd")(x)=sum_i [x^(2i+1)]A(x) x^i
$
这样每一步把下标 $n$ 减半，递归 $O(log n)$ 层。若多项式乘法复杂度为 $M(d)$，总复杂度约为 $O(M(d)log n)$。

模板里的 `bostanMori(n, F, G)` 正是这个过程：`H=G(-x)`，然后把 `F*H` 按 `n` 的奇偶抽项，把 `G*H` 抽偶项，递归求 `n/2`。

=== 二维 Bostan-Mori

设
$
  R(x,y)=P(x,y)/Q(x,y)
$
需要求 $[x^n]R(x,y)$ 或 $[x^n y^m]R(x,y)$。把 $y$ 方向的多项式看成系数环元素：
$
  P(x,y)=sum_i P_i(y)x^i, quad Q(x,y)=sum_i Q_i(y)x^i
$
然后在 $x$ 方向执行普通 Bostan-Mori：
$
  Q^-(x,y)=Q(-x,y)
$
若 $n$ 为偶数取 $P Q^-$ 的偶次项，否则取奇次项；分母取 $Q Q^-$ 的偶次项。重复 $O(log n)$ 次后得到一个关于 $y$ 的多项式。

模板中的 `vpoly` 就是这种表示：外层 `vector` 是 $x$ 的次数，内层 `poly` 是 $y$ 的系数。`bostanMori(n, vpoly F, vpoly G)` 返回 $[x^n]F/G$ 这一整个 $y$ 多项式；若只要 $[x^n y^m]$，再取返回多项式的第 $m$ 项即可。

使用时要保证 $Q(0,0)$ 可逆，并且内层多项式已经按需要的 $y$ 次数截断。
