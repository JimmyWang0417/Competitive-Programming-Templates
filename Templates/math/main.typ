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
#raw(read("polynomial.hpp"), lang: "cpp");
== Berlekamp-Massey 算法

该算法是求解给定序列最短递推式的算法。

#raw(read("berlekampMassey.hpp"), lang: "cpp");

== min25筛
#raw(read("min25.hpp"), lang: "cpp");
== 万能欧几里得
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

== 多项式与生成函数
=== 牛顿多项式迭代

若 $G(F_(2n) (x)) equiv 0(mod x^(2n))$, 我们已经求出 $F_(n) (x)$ 满足 $G(F_(n) (x)) equiv 0(mod x^(n))$，则有
$ F_(2n)(x) equiv F_n(x)-(G(F_n (x)))/(G'(F_n (x))) (mod x^(2n)) $

=== 拉格朗日反演
==== 普通拉格朗日反演
若 $G(F(x)) = x <=>F(G(x))=x$，则有
$ [x^n]G(x)=1/n [x^(n-1)](x/F(x))^n $
==== 扩展拉格朗日反演
$ [x^n]H(G(x))=1/n [x^(n-1)]H'(x)(x/F(x))^n $
==== 另类拉格朗日反演
$ [x^n]G^k (x)=[x^(n-k)]F'(x)(x/F(x))^(n+1) $
该式子有一个更一般的形式
$ [x^n]H(G^k (x))=[x^(n-k)]H(x)F'(x)(x/F(x))^(n+1) $

== 博弈论
#include "gameTheory.typ"

== 质数
=== 质数检验与分解质因数
#raw(read("prime.hpp"), lang: "cpp")

#include "prime.typ"
