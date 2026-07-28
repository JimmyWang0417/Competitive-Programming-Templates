=== 快速沃尔什变换

把下标看成 $n$ 位二进制向量，集合幂级数的对称差卷积为
$
  h_s = sum_(x op("xor") y = s) f_x g_y
$

Walsh 变换使用字符 $(-1)^(op("inner")(s,t))$ 对每一个频率 $s$ 求和：
$
  hat(f)_s = sum_t f_t (-1)^(op("inner")(s,t))
$
其中 $op("inner")(s,t)$ 表示二进制向量在 $F_2$ 上的内积。逆变换为
$
  f_s = 1 / 2^n sum_t hat(f)_t (-1)^(op("inner")(s,t))
$
因此要求底层环中 $2^n$ 可逆；在特征为 $2$ 的环上不能直接使用这个形式。

对称差卷积在 Walsh 变换下逐点相乘：
$
  hat(h)_s = hat(f)_s hat(g)_s
$
于是先对 $f,g$ 做 FWT，再逐点相乘，最后 IFWT，即可在 $O(n 2^n)$ 时间内求卷积。

=== 线性基与正交补

设 $V$ 是 $F_2^n$ 的线性子空间，$F_V(x)$ 是 $V$ 的示性函数，即 $x in V$ 时为 $1$，否则为 $0$。它的 Walsh 变换为
$
  hat(F_V)_y = sum_(x in V) (-1)^(op("inner")(x,y))
$

正交补定义为
$
  V^perp = {y | op("inner")(x,y)=0, forall x in V}
$
如果 $y in V^perp$，求和中每一项都是 $1$，所以
$
  hat(F_V)_y = |V| = 2^(op("rank")(V))
$
如果 $y$ 不在 $V^perp$，则存在 $u in V$ 使 $op("inner")(u,y)=1$。把每个 $x$ 与 $x op("xor") u$ 配对，两项符号相反并相互抵消，因此
$
  hat(F_V)_y = 0
$

这就是 FWT 为零的判定：
$
  hat(F_V)_y = 0 <=> y in.not V^perp
$
等价地，
$
  op("FWT")(F_V) = 2^(op("rank")(V)) F_(V^perp)
$
并且 $op("dim")(V) + op("dim")(V^perp) = n$。代码中的线性基若能求出正交补，就可以把「一个线性子空间的示性函数」在 FWT 后直接替换成「正交子空间的示性函数乘上 $2^r$」，无需枚举子空间中的所有元素。
