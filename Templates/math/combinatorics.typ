我们在推导的时候也可以适当使用 `EGF` 来方便我们求解。

=== 排列数
1. $ A_n^m=(n!)/((n-m)!) $
2. $ n A_(n-1)^(m-1)&=((n-1)! dot n)/((n-1-m+1)!)\ &=(n!)/((n-m)!)\ &=A_n^m $
3. $ m A_(n-1)^(m-1)+A_(n-1)^m &=(m(n-1)!)/((n-m)!)+((n-1)!)/((n-m-1)!)\ &=(m(n-1)!+(n-m)(n-1)!)/((n-m)!)\ &=(n!)/((n-m)!)\ &=A_n^m $
=== 组合数
1. $ C_n^m=(n!)/((n-m)!m!) $
2. $ C_n^m=C_(n-1)^m+C_(n-1)^(m-1) $
3. $ C_n^m=C_m^{n-m} $
4. $ sum_(i=0)^m C_(n+i)^i&=C_m^0+C_(m+1)^1+C_(m+2)^2+...+C_(m+r)^r\ &=C_m^1+C_(m+1)^1+C_(m+2)^2+...+C_(m+r)^r\ &=C_(m+2)^1+C_(m+2)^2+...+C_(m+r)^r\ &=C_(m+r+1)^r $
5. 设 $S_(n)^m=sum(i=0)^m C_n^i$,
则 $ S_n^(m+1)&=S_n^m+C_n^(m+1)\ S_(n+1)^m&=C_(n + 1)^0 + C_(n + 1)^1 + C_(n + 1)^ 2 + ... + C_(n + 1)^m\ &=C_(n)^0 + (C_n^0 + C_n^1) + (C_n^1 + C_n^2) + dots + (C_n^(m-1) + C_n^m)\ &=2S_n^m-C_n^m $ 
所以如果我们要求多个组合数的前缀和，我们可以类似于莫队的双指针的方式求
6. $ (x+y)^n=sum_(i=0)^n C_n^i x^i y^(n-i) $
7. $ sum_(i=0)^n C_n^i x^i=sum_(i=0)^n 1^(n-i)C_n^i x^i=(1+x)^n $
8. $ C_(m+n)^n=sum_(i=0)^(n)C_n^i C_m^i $
9. $ C_n^m= n/m C_(m-1)^(n-1) $
10. $ sum_(i=0)^n (C_n^i)^2=sum_(i=0)^n C_n^i C_(n)^(n-i)=C_(2n)^n $
=== 组合数反演
1. $ f(n)=sum_(i=0)^n (-1)^i C_n^i g(i) arrow.l.r.double g(n)=sum_(i=0)^n (-1)^i C_n^i f(i) $
2. $ f(n)=sum_(i=0)^n C_n^i g(i) arrow.l.r.double g(n)=sum_(i=0)^n (-1)^(n-i) C_n^i f(i) $
3. $ f(n)=sum_(i=n)^m C_i^n g(i) arrow.l.r.double g(n)=sum_(i=n)^m (-1)^(i-n)C_i^n f(i) $