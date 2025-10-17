=== 自然幂，上升幂和下降幂

在介绍斯特林数之前，我先介绍一下自然幂，上升幂和下降幂，因为斯特林数的性质和这三种幂紧密相关。

==== 自然幂符号及公式

$ m^n=product_(i=0)^(n-1) m $ 

==== 上升幂符号及公式

$ m^(overline(n))=product_(i=0)^(n-1)(m+i) $

==== 下降幂符号及其公式

$ m^(underline(n))=product_(i=0)^(n-1) (m-i) $

==== 上升幂和下降幂的转换

$ (-m)^(overline(n))=(-1)^n m^(underline(n)) $
$ (-m)^(overline(n))=(-1)^n m^(underline(n)) $

=== 第一类斯特林数

==== 介绍

第一类斯特林数（斯特林轮换数）$vec(n, m, delim: "[")$，表示将 $n$ 个两两不同的元素，划分成 $m$ 个互不区分的非空置换的方案数。

注：一个轮换是一个收尾相接的环形排列。两个可以通过旋转而互相得到的轮换是等价的（我们不认为两个可以通过翻转而相互得到的轮换等价）。

==== 递推式
$ vec(n, m, delim: "[") = vec(n-1, m-1, delim: "[")+(n-1)vec(n-1, m, delim: "[") $

边界为：$vec(n, 0, delim: "[")=[n=0]$。

运用组合意义证明：

- 新加入的元素独立作为一个置换，方案数为 $vec(n-1, m-1, delim: "[")}$ 。

- 新加入的元素加入现有的置换当中，因为对任意长度为 $l$ 的置换插入该置换的方案数为 $l$ ，当前置换总长为 $n-1$ ，所以方案数为 $(n-1)vec(n - 1, m, delim: "[")$ 。

根据加法原理，将两式相加即可得到递推式。

==== 性质

1. $ n! = sum_(i=0)^n vec(n, i, delim: "[") $

理解：对于一个排列 $P$ 我们可以将所有的 $(p_i, i)$ 连边，一个环则为一组轮换，每种排列一一每种置换。

2. $ m^(overline(n))=sum_(i=0)^n vec(n, i, delim: "[") m^i $


3. $ m^(underline(n))=sum_(i=0)^n (-1)^(n-i)vec(n, i, delim: "[") m^i $

==== 同一行第一类斯特林数的计算

考虑构造生成函数 $ F_n(x)=product_(i=0)^(n-1) (x+i)=product_(i=0)^(n)a_i x^i $ ，可以根据 $ m^(overline(n))=sum_(i=0)^n vec(n, i, delim: "[")m^i$ 得到其中的 $a_i=vec(n, i, delim: "[")$ 。

显然 $F_(2n)(x)^=F_n(x) F_n(x+n)$ 。

$  F(x+n)^n&=sum_(i=0)^n a_i(x+n)^i\ 
&=sum_(i=0)^n a_i sum_(j=0)^n binom(i, j) x^j n^{i-j}\ 
&=sum_(i=0)^n sum_(j=i)^n binom(j, i) x^i n^(j-i)
a_j\ 
&=sum_(i=0)^n sum_(j=i)^n (j!)/(i!(j-i)!) x^i n^(j-i)a_j\ 
&=sum_(i=0)^n 1/(i!) (sum_(j=i)^n a_j j! (n^(j-i))/((j-i)!)) x^i $



时间复杂度: $T(n)=T( n /2)+O(n log n)=O(n log n)$ 。

==== 同一列第一类斯特林数的计算

// ~~在路上了~~

=== 第二类斯特林数

==== 介绍

第二类斯特林数（斯特林子集数）$vec(n, m, delim: "{")$ ，表示将 $n$ 个两两不同的元素，划分为 $m$ 个互不区分的非空子集的方案数。

==== 递推式

$ vec(n, m, delim: "{")=vec(n-1, m-1, delim: "{")+m vec(n-1, m, delim: "{") $

边界为 $vec(n, 0, delim: "{")=[n=0]$。

运用组合意义证明：

- 将新元素单独放入一个子集，方案数为 $vec(n-1, m-1, delim: "{")$ 。

- 新将新元素放入一个现有的非空子集，方案数为 $m vec(n-1, m, delim: "{")$ 。

根据加法原理，将两式相加即可得到递推式。

==== 性质

1. $ m^n=sum_(i=0)^n vec(n, i, delim: "{")m^(underline(i)) $

2. $ m^n=sum_(i=0)^n (-1)^(n-i)vec(n, i, delim: "{")m^(overline(i)) $

==== 通项公式

$ vec(n, m, delim: "{")=sum_(i=0)^m ((-1)^(m-i)i^n)/(i!(m-i)!) $

证明：

我们用二项式反演。

令 $f_i$ 为表示将 $n$ 个两两不同的元素，划分为 $i$ 个互不相同的 *非空子集* 的方案数。

显然 $f_i=i!vec(n, i, delim: "{")$ 。

考虑令 $g_i$ 为表示将 $n$ 个两两不同的元素，划分为 $i$ 个互不相同的子集 *（可非空）* 的方案数。

显然 $g_i=n^i$ 。

我们考虑 $f_i$ 其实就是 $g_i$ 去掉所有的空子集，则我们只要钦定 $g_i$ 中那些是非空子集就可以写出 $f_i$ 和 $g_i$ 的关系了:
$ g_i=sum_(j=0)^i binom(i, j)f_j $ 

根据二项式反演：

$ 
f_i&=sum_(j=0)^i(-1)^(i-j)binom(i,j) g_j\ 
&=sum_(j=0)^i(-1)^(i-j)binom(i, j)j^n\ 
&=sum_(j=0)^i (i!(i-1)^(i-j)j^n)/(j!(i-j)!) $

$ vec(n, m, delim: "{")=(f_m)/(m!)=sum_(i=0)^m ((-1)^(m-i)i^n)/(i!(m-i)!) $

==== 同一行第二类斯特林数的计算


==== 同一列第二类斯特林数的计算

// ~~在路上了~~

=== 第三类斯特林数

==== 介绍

第三类斯特林数（拉赫数）$L(n, m)$，通常指无符号拉赫数 $L(n, m)$ ，表示将含有 $n$ 个元素的集合拆分为 $m$ 个非空线性有序子集的方法数目。

注： ${(1, 2, 3)}!= {(2, 3, 1)}$ ，${(1, 2), (3)}!= {(3), (1, 2)}$ 。

拉赫数可以通过上升幂与下降幂之间的转化来定义：

==== 无符号拉赫数

$
m^(overline(n))=sum_(i=0)^n L(n, i)m^(underline(i))
 $
$
m^(underline(n))=sum_(i=0)^n(-1)^(n-i)L(n, i)m^(overline(i))
 $

==== 有符号拉赫数

$
m^(overline(n))=(-1)^n sum_(i=0)^n L'(n, i)m^(underline(i))
 $
$
m^(underline(n))=sum_(i=0)^n (-1)^(i) L'(n, i)m^(overline(i))
 $

==== 通项公式

- 无符号拉赫数

$ L(n, m)=binom(n-1,m-1)(n!)/(m!) $

- 有符号拉赫数

$ L'(n, m)=(-1)^n L(n, m)=(-1)^n binom(n-1,m-1)(n!)/(m!) $

==== 递推式

由通项公式可得
$ L(n, m)&=(n-m+1)/(m(m-1)) L(n, m-1)\ &=(n+m-1)L(n-1, m)+L(n-1, m-1) $

边界：
$L(n, 0)=0$，$L(1, 1)=1$


=== 三类斯特林数总结

#image("jYZpd0.png")

=== 斯特林反演

#math.cancel("原来第一类斯特林数和第二类斯特林数之间还能进行反演")

==== 原理
由此我们就有两个非常对称的恒等式：
$ 
sum_(i=m)^n (-1)^(n-i)vec(n, i, delim: "{")vec(i, m, delim: "[")=[n=m]
 $
$
sum_(i=m)^n (-1)^(n-i)vec(n, i, delim: "[")vec(i, m, delim: "{")=[n=m]
 $
==== 反演形式

$ 
f_n=sum_(i=0)^n vec(n, i, delim: "{")g_i arrow.l.r.double g_n=sum_(i=0)^n (-1)^(n-i)vec(n, i, delim: "[") f_i
 $
$
f_n=sum_(i=0)^n vec(n, i, delim: "[")g_i arrow.l.r.double g_n=sum_(i=0)^n (-1)^(n-i)vec(n, i, delim: "{")f_i
 $
