#let young-tableau(rows) = {
  stack(
    dir: ttb,
    spacing: -0.45pt,
    ..rows.map(row => align(left, grid(
      columns: row.len(),
      column-gutter: -0.45pt,
      ..row.map(entry => box(
        width: 1.55em,
        height: 1.55em,
        stroke: 0.45pt,
        align(center + horizon, str(entry)),
      )),
    ))),
  )
}

=== 杨表（Young tableaux）

==== 竞赛常用性质

设排列 $pi in S_n$ 经 RSK 得到同形标准杨表 $P(pi),Q(pi)$，共同形状为 $lambda ⊢ n$；记 $f^lambda$ 为形状 $lambda$ 的标准杨表数。

*子序列与形状：* Schensted 定理给出
$
  op("LIS")(pi)=lambda_1,
  quad op("LDS")(pi)=lambda_1^prime=ell(lambda).
$
即第一行、第一列长度分别是最长严格上升、严格下降子序列长度。对允许重复元素的一般字，结论取决于行插入的比较符号：

#align(center, table(
  columns: (1.05fr, 1.1fr, 1.25fr, 1.25fr),
  inset: 4pt,
  table.header([行内查找], [所得表], [$lambda_1$], [$lambda_1^prime$]),
  [首个 $>x$], [行弱、列严格], [最长弱上升], [最长严格下降],
  [首个 $>=x$], [行严格、列弱], [最长严格上升], [最长弱下降],
))

令 $U_k$（$D_k$）为至多 $k$ 条两两位置不交的严格上升（下降）子序列最多覆盖的位置数。Greene 定理为
$
  U_k=sum_(i=1)^k lambda_i,
  quad D_k=sum_(i=1)^k lambda_i^prime.
$
这里“不交”指不能重复使用原排列中的同一个位置；$k=1$ 即 Schensted 定理。因此长度为 $r s+1$ 的互异数列必有长度 $r+1$ 的严格上升子序列，或长度 $s+1$ 的严格下降子序列。

*排列计数：* RSK 是“排列与一对同形标准杨表”的双射，故
$
  lr(|{pi in S_n | op("shape")(pi)=lambda}|)=(f^lambda)^2,
  quad
  sum_(lambda ⊢ n) (f^lambda)^2=n!,
$
且满足 $op("LIS")(pi)<=r$、$op("LDS")(pi)<=s$ 的 $n$ 元排列数为
$
  sum_(lambda ⊢ n, lambda_1<=r, ell(lambda)<=s) (f^lambda)^2.
$

*对合排列：* 求逆会交换两张表：
$
  P(pi^(-1))=Q(pi),
  quad Q(pi^(-1))=P(pi).
$
所以 $pi=pi^(-1)$ 当且仅当 $P(pi)=Q(pi)$。固定 $lambda ⊢ n$ 时，RSK 形状为 $lambda$ 的对合恰与单张形状为 $lambda$ 的标准杨表一一对应，因此
$
  lr(|{pi in S_n | pi=pi^(-1), op("shape")(pi)=lambda}|)=f^lambda.
$
#block(breakable: false)[
  记 $I_n$ 为 $n$ 元对合排列数，则
  $
    I_n=sum_(lambda ⊢ n) f^lambda,
    quad
    I_n=I_(n-1)+(n-1)I_(n-2) space (n>=2),
    quad I_0=I_1=1.
  $
]
若对合 $pi$ 的 RSK 形状为 $lambda$，令 $o(lambda)$ 为 $lambda$ 中*列高为奇数*的列数，则
$
  lr(|{i | pi_i=i}|)=o(lambda).
$
这里数的是列高 $lambda_j^prime$ 为奇数的列，不是列编号为奇数。对 $0<=m<=n$，恰有 $m$ 个不动点的对合数满足
$
  I_(n,m)=sum_(lambda ⊢ n, o(lambda)=m) f^lambda.
$
若 $n-m=2k>=0$，则
$
  I_(n,m)=frac(n!,m! 2^k k!).
$
若 $n-m$ 为奇数，则 $I_(n,m)=0$。

*形状变换：* 下面只断言 RSK 形状，不表示表中数字作简单转置。

#align(center, table(
  columns: (1.2fr, 2fr, 1fr),
  inset: 4pt,
  table.header([操作], [新排列], [新形状]),
  [倒转位置], [$(pi_n,dots,pi_1)$], [$lambda^prime$],
  [反转大小], [$(n+1-pi_1,dots,n+1-pi_n)$], [$lambda^prime$],
  [两者同时做], [$(n+1-pi_n,dots,n+1-pi_1)$], [$lambda$],
  [求逆], [$pi^(-1)$（并交换 $P,Q$）], [$lambda$],
))

==== 约定与基本对象

统一采用*英式记法*：杨图左对齐，长行在上；行从上到下、列从左到右编号。设
$
  lambda=(lambda_1,lambda_2,dots,lambda_r) ⊢ n,
  quad lambda_1 >= lambda_2 >= dots >= lambda_r > 0.
$
约定 $i>r$ 时 $lambda_i=0$。第 $i$ 行有 $lambda_i$ 格，杨图、共轭分拆和可删除格分别为
$
  [lambda]={ (i,j) | 1<=i<=r, 1<=j<=lambda_i },
  quad lambda_j^prime=lr(|{i | lambda_i>=j}|),
$
$
  R(lambda)={ (i,lambda_i) | 1<=i<=r, lambda_i>lambda_(i+1) }.
$
其中 $lambda_j^prime$ 是第 $j$ 列高度。数学坐标从 $1$ 开始；代码若用 $0$ 下标需自行平移。

- *标准杨表（SYT）*：恰填入 $1,2,dots,n$ 各一次，行、列均严格递增。

- *半标准杨表（SSYT）*：填正整数，行弱递增、列严格递增。部分资料采用“行严格、列弱递增”，使用前必须先核对约定。

#align(center, grid(
  columns: (auto, auto),
  column-gutter: 3em,
  stack(
    dir: ttb,
    spacing: 0.3em,
    align(center, [*SYT*]),
    young-tableau(((1, 2, 5, 7), (3, 6), (4,))),
  ),
  stack(
    dir: ttb,
    spacing: 0.3em,
    align(center, [*SSYT*]),
    young-tableau(((1, 1, 2, 4), (2, 3), (4,))),
  ),
))

标准杨表中前 $k$ 个数占据的格子仍构成杨图；反过来，从空图开始每次添加一个合法格子的形状链唯一确定一张标准杨表。最大数必在一个可删除格中。

==== 钩长与计数

对 $u=(i,j)$，钩包含 $u$ 自身以及它右边、下边的格子。钩长与内容分别为
$
  h_lambda(i,j)=lambda_i-j+lambda_j^prime-i+1,
  quad c(i,j)=j-i.
$
若 $lambda ⊢ n$，形状为 $lambda$ 的标准杨表数 $f^lambda$ 满足
$
  f^lambda
  = frac(n!, product_(u in [lambda]) h_lambda(u)),
  quad
  f^lambda=sum_(u in R(lambda)) f^(lambda-u),
  quad f^emptyset=1,
$
其中 $R(lambda)$ 是可删除格集合。并且 $f^(lambda^prime)=f^lambda$。

对 $lambda=(4,2,1)$，钩长依次为 $(6,4,2,1),(3,1),(1)$，故
$f^((4,2,1))=7!/144=35$。两行形状还有
$
  f^((a,b))
  = frac(a-b+1,a+1) binom(a+b,b)
  = binom(a+b,b)-binom(a+b,b-1),
  quad a>=b>=1.
$
特别地，$f^((m,m))=1/(m+1) binom(2m,m)$ 是 Catalan 数。

若限制半标准杨表的填数均在 ${1,2,dots,m}$ 中，则钩长—内容公式为
$
  lr(|op("SSYT")_m(lambda)|)
  = product_(u in [lambda]) frac(m+c(u),h_lambda(u)).
$
上述钩长公式与钩长—内容公式只用于直形。模意义计算不能无条件写成“阶乘乘钩长积的逆元”：仅当分母可逆时才能直接除，否则应先约分或统计质因子指数；精确计数还要防止整数溢出。

==== 行插入、逆插入与 RSK

*行插入 $P arrow.l x$：*

1. 令当前携带值为 $x$，从第一行开始。
2. 在当前行二分找到最左边严格大于 $x$ 的数 $y$（`upper_bound`）。若不存在，则把 $x$ 追加到行末并结束。
3. 否则用 $x$ 替换 $y$，令 $x arrow.l y$，进入下一行重复。最终形状恰增加一个格。

该比较符号对应“行弱递增、列严格递增”；一条顶出路径向下时，访问的列号单调不增。

*逆行插入：* 删除一个可删除格并取出当前携带值 $x$；逐行向上，在上一行找最右边严格小于 $x$ 的数 $y$（`lower_bound(x)-1`），用 $x$ 替换它，再令 $x arrow.l y$。离开第一行时携带的值就是原插入值。

对正整数构成的字 $w=(w_1,dots,w_n)$，从 $P=Q=emptyset$ 开始。第 $k$ 步把 $w_k$ 行插入 $P$， 并在 $Q$ 的同一个新增格中填入 $k$。最终：

- $P(w)$ 是保存数值的半标准杨表，$Q(w)$ 是保存插入时刻的标准杨表；二者同形。

- 若 $w=pi$ 是排列，则 $P,Q$ 都是标准杨表，且排列与一对同形标准杨表之间为双射。

- 逆 RSK 按 $Q$ 中的 $k=n,n-1,dots,1$ 依次删除最大标号所在格，再对 $P$ 的对应格执行逆行插入，从后往前恢复 $w_k$。

#block(width: 100%, breakable: false)[
  例如 $pi=(3,1,4,2)$ 得到
  #align(center, grid(
    columns: (auto, auto),
    column-gutter: 3em,
    stack(
      dir: ttb,
      spacing: 0.3em,
      align(center, [$P$]),
      young-tableau(((1, 2), (3, 4))),
    ),
    stack(
      dir: ttb,
      spacing: 0.3em,
      align(center, [$Q$]),
      young-tableau(((1, 3), (2, 4))),
    ),
  ))
]

==== 实现提示

只求第一行长度时无需构造整张表：在 `tails` 数组上使用 `upper_bound` 求最长弱上升子序列，或使用 `lower_bound` 求最长严格上升子序列，时间 $O(n log n)$、空间 $O(n)$。按行存储并二分查找时，直接构造完整 $P,Q$ 或执行完整逆 RSK 的最坏时间为 $O(n^2)$，表本身占 $O(n)$ 空间。

易错点：钩不含左边和上边；$Q$ 记录新增格出现的时刻，不记录被顶出的值；逆 RSK 按 $n,n-1,dots,1$ 输出的是原字的倒序；改变行插入的比较符号会同时改变表的单调约定和最长子序列的严格性；只由 LIS/LDS 能确定第一行、第一列，确定整个形状需用 Greene 定理。
