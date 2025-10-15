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
== min25筛
#raw(read("min25.hpp"), lang: "cpp");
== 万能欧几里得
#raw(read("euclidean.hpp"), lang: "cpp");
== Schreier-Sims
#raw(read("schreierSims.hpp"), lang: "cpp");
== 组合数学

== 群论
=== Burnside引理
等价类数量为 
$ 1/(|G|)sum_(g in G) X^g $ $X$ 表示 $g$ 变换下不动点的数量。
=== Pólya定理
染色方案数为 
$ 1/(|G|)sum_(g in G) m^(c(g))  $

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

== 特殊质数及其相关信息
#include "prime.typ"
