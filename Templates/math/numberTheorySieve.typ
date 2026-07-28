=== 筛法适用条件

杜教筛和 Min25 筛都用于求数论函数前缀和，但适用条件不同。

杜教筛依赖一个 Dirichlet 卷积式
$
  A * B = C
$
目标是求 $S_A(n)=sum_(i=1)^n A(i)$。由卷积可得
$
  S_C(n)=sum_(d=1)^n B(d) S_A(floor(n/d))
$
若 $B(1)=1$，移项得到
$
  S_A(n)=S_C(n)-sum_(d=2)^n B(d)S_A(floor(n/d))
$
因此只要 $A$ 可线性筛预处理，$S_B(l,r)$ 和 $S_C(n)$ 可快速求，递归中按 $floor(n/d)$ 整除分块并记忆化即可。

常见例子：
$
  mu * I = e, quad phi * I = op("id")
$
所以
$
  S_mu(n)=1-sum_(l=2)^n S_mu(floor(n/l))
$
$
  S_phi(n)=n(n+1)/2-sum_(l=2)^n S_phi(floor(n/l))
$

Min25 筛适合求积性函数前缀和，尤其是 $f(p)$ 能写成若干个容易求素数前缀和的形式，且 $f(p^k)$ 容易枚举。它不要求先找到像杜教筛那样的卷积恒等式，但需要按 $floor(n/i)$ 建块，并预处理 $sqrt(n)$ 内的素数。

经验上：

- 有简单卷积恒等式，例如 $mu, phi, mu dot op("id")_k$，优先考虑杜教筛。
- 只知道积性函数在素数和素数幂处的值，并且 $f(p)$ 形如 $p, p^2$ 等多项式，优先考虑 Min25 筛。
- 只需要 $sqrt(n)$ 以内的局部信息，或者要分解单个大整数，用线性筛或 Pollard-Rho，不必上前缀和筛。

=== 常见公式套路

本节只记录常见求和形态和分块端点，推公式时优先把贡献改写成 $sum f(i) floor(n/i)$ 或若干个根号项的乘积。

整除分块基础：
$
  t=floor(n/l), quad r=floor(n/t)
$
在 $i in [l,r]$ 上 $floor(n/i)=t$。若 $S_f(x)=sum_(i=1)^x f(i)$，则
$
  sum_(i=1)^n f(i) floor(n/i)
  = sum_(l) (S_f(r)-S_f(l-1)) floor(n/l)
$

最常用的两种特例：
$
  sum_(i=1)^n floor(n/i)
  = sum_(l) (r-l+1) floor(n/l)
$
$
  sum_(i=1)^n i floor(n/i)
  = sum_(l) ((l+r)(r-l+1))/2 floor(n/l)
$

按倍数贡献可以直接得到一些常见前缀：
$
  sum_(i=1)^n tau(i)=sum_(d=1)^n floor(n/d)
$
$
  sum_(i=1)^n sigma(i)=sum_(d=1)^n d floor(n/d)
$
$
  sum_(d=1)^n phi(d) floor(n/d)=n(n+1)/2
$

二维倍数计数同理。若 $n<=m$，则
$
  sum_(i=1)^n f(i) floor(n/i) floor(m/i)
  = sum_(l) (S_f(r)-S_f(l-1)) floor(n/l) floor(m/l)
$
其中 $r=min(floor(n/floor(n/l)), floor(m/floor(m/l)))$。

幂次分块常见于 $floor(n/i^k)$。令 $t=floor(n/l^k)$，同一段的右端点为
$
  r=floor((n/t)^(1/k))
$
于是
$
  sum_(i=1)^(floor(n^(1/k))) f(i) floor(n/i^k)
  = sum_(l) (S_f(r)-S_f(l-1)) floor(n/l^k)
$

根号项是幂次分块的反向写法。令 $t=floor(sqrt(n/l))$，则右端点为
$
  r=floor(n/t^2)
$
所以
$
  sum_(i=1)^n f(i) floor(sqrt(n/i))
  = sum_(l) (S_f(r)-S_f(l-1)) floor(sqrt(n/l))
$

多参数根号项同时出现时，每个参数给一个右端点，整段右端点取最小值。例如
$
  sum_(i=1)^N f(i) floor(sqrt(n/i)) floor(sqrt(m/i))
$
令
$
  t_1=floor(sqrt(n/l)), quad t_2=floor(sqrt(m/l))
$
则
$
  r=min(N, floor(n/t_1^2), floor(m/t_2^2))
$
贡献为
$
  (S_f(r)-S_f(l-1))t_1 t_2
$

平方自由数和幂自由数经常配合上面的幂次分块。常用恒等式：
$
  mu^2(n)=sum_(d^2|n) mu(d)
$
因此
$
  sum_(i=1)^n mu^2(i)=sum_(d=1)^(floor(sqrt(n))) mu(d) floor(n/d^2)
$
进一步，$k$ 次幂自由数示性函数可写成
$
  q_k(n)=sum_(d^k|n) mu(d)
$
于是
$
  sum_(i=1)^n q_k(i)=sum_(d=1)^(floor(n^(1/k))) mu(d) floor(n/d^k)
$

=== 贝尔级数

对积性函数 $f$ 和素数 $p$，贝尔级数定义为
$
  F_p(x)=sum_(i=0)^infinity f(p^i)x^i
$
它把 Dirichlet 卷积变成普通幂级数乘法：
$
  (f*g)_p(x)=F_p(x)G_p(x)
$

常见贝尔级数：
$
  e arrow.r 1, quad I arrow.r 1/(1-x), quad op("id")_k arrow.r 1/(1-p^k x)
$
$
  mu arrow.r 1-x, quad mu^2 arrow.r 1+x
$
$
  sigma_k arrow.r 1/((1-x)(1-p^k x))
$
$
  phi arrow.r (1-x)/(1-p x)
$

若 $D$ 完全积性，则点乘 $D$ 相当于把 $x$ 替换成 $D(p)x$：
$
  (f dot D)_p(x)=F_p(D(p)x)
$
例如
$
  (mu dot op("id")_k)_p(x)=1-p^k x
$
$
  (phi dot op("id")_k)_p(x)=(1-p^k x)/(1-p^(k+1)x)
$

贝尔级数适合用来猜和验证卷积恒等式：先在每个素数 $p$ 的幂次上写出普通生成函数，做乘除后再翻译回 Dirichlet 卷积。本文档不整理 powerful number。
