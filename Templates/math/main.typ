= 数学

== 基础代数
=== ModInt
#raw(read("modint.hpp"), lang: "cpp", block: true)
=== 矩阵
#raw(read("matrix.hpp"), lang: "cpp", block: true)
=== 线性基
#raw(read("linear_basis.hpp"), lang: "cpp", block: true)

== 数论
=== 质数与因数分解
#raw(read("prime.hpp"), lang: "cpp", block: true)
#include "prime.typ"
#include "number_theory_note.typ"
=== 数论算法模板
#raw(read("number_theory.hpp"), lang: "cpp", block: true)
#include "number_theory_sieve.typ"
=== Min25 筛代码
#raw(read("min25.hpp"), lang: "cpp", block: true)
=== 线性筛
#raw(read("sieve.hpp"), lang: "cpp", block: true)
=== 杜教筛
#raw(read("du_sieve.hpp"), lang: "cpp", block: true)
#include "euclidean.typ"
#raw(read("euclidean.hpp"), lang: "cpp", block: true)
#include "inclusion_exclusion.typ"

== 多项式与线性递推
=== 多项式模板
#raw(read("polynomial/poly.hpp"), lang: "cpp", block: true)
#include "fwt.typ"
=== FWT 代码
#raw(read("fwt.hpp"), lang: "cpp", block: true)
#include "set_power_series.typ"
=== 集合幂级数代码
#raw(read("set_power_series.hpp"), lang: "cpp", block: true)
=== 多点求值与插值
#raw(read("polynomial/lagrange.hpp"), lang: "cpp", block: true)
=== 常系数线性递推
#raw(read("polynomial/linear_recurrence.hpp"), lang: "cpp", block: true)
#include "polynomial_notes.typ"
#include "berlekamp_massey_note.typ"

== 组合数学
#include "combinatorics.typ"
=== 排列数与组合数封装
#raw(read("comb.hpp"), lang: "hpp", block: true)
#include "stirling.typ"
=== Stirling 数代码
#raw(read("stirling.hpp"), lang: "cpp", block: true)
#include "young_tableaux.typ"

== 特殊数列
=== Fibonacci 数列
#include "fib.typ"

#include "group_theory.typ"
=== Schreier-Sims
#raw(read("schreier_sims.hpp"), lang: "cpp", block: true)

== 博弈论
#include "gameTheory.typ"

== 数值计算
=== 自适应 Simpson 积分
#raw(read("Simpson.hpp"), lang: "cpp", block: true)
