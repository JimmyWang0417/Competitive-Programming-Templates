=== 容斥和反演
==== min-max 容斥
$
  max_(i in S){a_i}=sum_(T subset.eq S, T != emptyset) (-1)^(abs(T)-1) min_(j in T){a_j} \
  min_(i in S){a_i}=sum_(T subset.eq S, T != emptyset) (-1)^(abs(T)-1) max_(j in T){a_j}
$
扩展 min-max 容斥
$
  limits(op("kthmax"))_(i in S){a_i}=sum_(T subset.eq S, abs(T) >= k) (-1)^(abs(T)-k) binom(abs(T) - 1, k - 1) min_(j in T){a_j} \
  limits(op("kthmin"))_(i in S){a_i}=sum_(T subset.eq S, abs(T) >= k) (-1)^(abs(T)-1) binom(abs(T) - 1, k - 1) max_(j in T){a_j}
$
==== 莫比乌斯反演
+ $ f(n)=sum_(d|n) g(d) arrow.l.r.double g(n)=sum_(d|n) mu(n/d)f(d) $
+ $ f(n)=sum_(n|d) g(d) arrow.l.r.double g(n)=sum_(n|d) mu(d/n)f(d) $
+ 其次，莫比乌斯反演并不仅限于加法，它实际上对于任何 Abel 群中的运算都成立．例如，它有如下的乘法形式：$f(n)=product_(d|n) g(d) arrow.l.r.double product_(d|n) f(d)^(mu(n/d))$
===== Dirichlet 前缀和
```cpp
for (int i = 1; i <= tot; ++i)
    for (int j = 1; prime[i] * j <= n; ++j)
        a[prime[i] * j] += a[j];
```
