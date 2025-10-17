我们设 $F_n$ 为斐波拉切数列第 $n$ 项,$A$ 是一个类斐波拉切数列

广义的斐波拉切数列：它仍然满足原斐波拉切数列的性质，不同的是下标的至于从正整数集变为整数集

1. $ forall n in ZZ,F_n=(((1+sqrt(5))/2)^n-((1-sqrt(5))/2)^n)/(sqrt(5)) $
2. $ F_(-n)=(-1)^(n+1)F_n $
3. $ forall n,m in ZZ,F_(n-1)F_(n+1)-F_n^2=(-1)^n $
4. $ forall n,m in ZZ,F_(n+m)=F_(n+1)F_m+F_n F_(m-1) $
5. $ forall n,m in ZZ,n|m arrow.l.r.double F_n|F_m $
6. $ forall n,m in ZZ,(F_n,F_m)=F_(\(n,m\)) $
7. $ sum_(i=1)^n F_i=sum_(i=1)^n (F_(i+2)-F_(i+1))=F_(n+2)-1 $
8. $ because forall n in [3, +infinity) inter ZZ,A_n=A_{n-1+1}=F_(n-1)A_2+F_(n-2)A_1\ therefore sum_(i=1)^n A_i=F_n A_1+(F_(n+1)-1)A_2 $
9. 任意的一个正整数，都可以分成若干个不相邻的、不同的几个斐波拉切数之和，且这种分解唯一。在某些题中我们可以利用这个性质对数找到对应的斐波拉切进制来计算。