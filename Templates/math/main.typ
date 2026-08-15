= 数学
== ModInt
#raw(read("modint.hpp"), lang: "cpp")
== 矩阵类型
#raw(read("matrix.hpp"), lang: "cpp")
== 数论算法
1. 中国剩余定理
2. 卢卡斯定理
3. 离散对数（BSGS）
4. 二次剩余
#raw(read("numberTheory.hpp"), lang: "cpp")
== 多项式算法
=== 多项式模板
#raw(read("polynomial/poly.hpp"), lang: "cpp")
#include "fwt.typ"
=== FWT 代码
#raw(read("fwt.hpp"), lang: "cpp")
=== 线性基代码
#raw(read("linearBasis.hpp"), lang: "cpp")
#include "setPowerSeries.typ"
=== 复合集合幂代码
#raw(read("setPowerSeries.hpp"), lang: "cpp")

=== 牛顿多项式迭代

若 $G(F_(2n) (x)) equiv 0(mod x^(2n))$, 我们已经求出 $F_(n) (x)$ 满足 $G(F_(n) (x)) equiv 0(mod x^(n))$，则有
$ F_(2n)(x) equiv F_n(x)-(G(F_n (x)))/(G'(F_n (x))) (mod x^(2n)) $

=== 拉格朗日反演
设 $F(0)=0, F'(0) != 0$，$G(z)$ 是 $F(x)$ 的复合逆，即
$
  F(G(z)) = z, quad G(F(x)) = x
$
下面所有公式都把 $z$ 作为被取系数的外层变量，把 $x$ 作为代换后的内部变量。

==== 推导
使用形式留数 $[z^n]A(z)=op("Res")_z A(z)/z^(n+1)$，令 $z=F(x)$，则 $G(z)=x$ 且 $dif z = F'(x) dif x$。于是
$
  [z^n]H(G(z))
  = op("Res")_z H(G(z))/z^(n+1)
  = op("Res")_x H(x)F'(x)/(F(x))^(n+1)
  = [x^n]H(x)F'(x)(x/F(x))^(n+1)
$
这给出一种等价形式。

另一方面，形式导数的留数为 $0$，对 $H(x)/(F(x))^n$ 求导可得
$
  op("Res")_x (H'(x)/(F(x))^n - n H(x)F'(x)/(F(x))^(n+1)) = 0
$
因此当 $n > 0$ 时，
$
  [z^n]H(G(z))
  = 1/n op("Res")_x H'(x)/(F(x))^n
  = 1/n [x^(n-1)]H'(x)(x/F(x))^n
$

==== 普通拉格朗日反演
取 $H(x)=x$，有
$
  [z^n]G(z)=1/n [x^(n-1)](x/F(x))^n
$

==== 扩展拉格朗日反演
对任意形式幂级数 $H(x)$，有
$
  [z^n]H(G(z))=1/n [x^(n-1)]H'(x)(x/F(x))^n
$

==== 幂形式
取 $H(x)=x^k$，有
$
  [z^n](G(z))^k
  = k/n [x^(n-k)](x/F(x))^n
  = [x^(n-k)]F'(x)(x/F(x))^(n+1)
$
其中第二个等号来自推导中的等价形式，写成 $(G(z))^k$ 是为了明确表示函数值的 $k$ 次幂，而不是函数复合。

=== 多点求值与插值
#raw(read("polynomial/lagrange.hpp"), lang: "cpp")
=== 常系数线性递推
#raw(read("polynomial/linearRecurrence.hpp"), lang: "cpp")
== 自适应 Simpson 积分
#raw(read("Simpson.hpp"), lang: "cpp")

== Berlekamp-Massey 算法

该算法是求解给定序列最短递推式的算法。

#raw(read("berlekampMassey.hpp"), lang: "cpp");

== 筛法
#include "numberTheorySieve.typ"
=== Min25 筛代码
#raw(read("min25.hpp"), lang: "cpp");
=== 线性筛
#raw(read("sieve.hpp"), lang: "cpp");
=== 杜教筛
#raw(read("duSieve.hpp"), lang: "cpp");
== 万能欧几里得
#include "euclidean.typ"
#raw(read("euclidean.hpp"), lang: "cpp");
== Schreier-Sims
#raw(read("schreierSims.hpp"), lang: "cpp");
== 容斥和反演
=== min-max 容斥
$
  max_(i in S){a_i}=sum_(T subset.eq S, T != emptyset) (-1)^(abs(T)-1) min_(j in T){a_j} \
  min_(i in S){a_i}=sum_(T subset.eq S, T != emptyset) (-1)^(abs(T)-1) max_(j in T){a_j}
$
扩展 min-max 容斥
$
  limits(op("kthmax"))_(i in S){a_i}=sum_(T subset.eq S, abs(T) >= k) (-1)^(abs(T)-k) binom(abs(T) - 1, k - 1) min_(j in T){a_j} \
  limits(op("kthmin"))_(i in S){a_i}=sum_(T subset.eq S, abs(T) >= k) (-1)^(abs(T)-1) binom(abs(T) - 1, k - 1) max_(j in T){a_j}
$
=== 莫比乌斯反演
+ $ f(n)=sum_(d|n) g(d) arrow.l.r.double g(n)=sum_(d|n) mu(n/d)f(d) $
+ $ f(n)=sum_(n|d) g(d) arrow.l.r.double g(n)=sum_(n|d) mu(d/n)f(d) $
+ 其次，莫比乌斯反演并不仅限于加法，它实际上对于任何 Abel 群中的运算都成立．例如，它有如下的乘法形式：$f(n)=product_(d|n) g(d) arrow.l.r.double product_(d|n) f(d)^(mu(n/d))$
==== Dirichlet 前缀和
```cpp
for (int i = 1; i <= tot; ++i)
    for (int j = 1; prime[i] * j <= n; ++j)
        a[prime[i] * j] += a[j];
```

== 组合数学

#include "combinatorics.typ"

=== 排列数和组合数封装
#raw(read("comb.hpp"), lang: "hpp")

#include "stirling.typ"

=== Stirling 数代码
#raw(read("stirling.hpp"), lang: "cpp")

#include "youngTableaux.typ"

== 特殊数列
=== 斐波拉切数列
#include "fib.typ"

== 群论
=== Burnside引理
等价类数量为
$ 1/(|G|)sum_(g in G) X^g $ $X$ 表示 $g$ 变换下不动点的数量。
=== Pólya定理
染色方案数为
$ 1/(|G|)sum_(g in G) m^(c(g)) $

$m$ 表示可染颜色数，$c(g)$ 表示 $g$ 变换下环的数量。

== 博弈论
#include "gameTheory.typ"

== 质数
=== 质数检验与分解质因数
#raw(read("prime.hpp"), lang: "cpp")

#include "prime.typ"
