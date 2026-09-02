= 字符串算法
== kmp
#raw(read("kmp.hpp"), lang : "cpp")
== exkmp（Z函数）
#raw(read("exkmp.hpp"), lang : "cpp")
== trie树
#raw(read("trie.hpp"), lang : "cpp")
== AC自动机
#raw(read("acam.hpp"), lang : "cpp")
== 后缀数组
#raw(read("sa.hpp"), lang : "cpp")
== 后缀自动机
#raw(read("sam.hpp"), lang : "cpp")
== 广义后缀自动机
#raw(read("exsam.hpp"), lang : "cpp")
== manacher
#raw(read("manacher.hpp"), lang : "cpp")
== 回文自动机
#raw(read("pam.hpp"), lang : "cpp")
== Lyndon 分解
lyndon串是该串原串是字典序最小的后缀串
我们在分析lyndon串性质的时候，可以把拆分看作原串划分成几个连续上升串，相邻最小值上升的合并在一起。
+ $u,v$ 是 Lyndon 串，且 $u<v$ ，$u v$ 也是 Lyndon 串
+ Lyndon 分解唯一 
+ 一个Lyndon串不能分成多个比原串更小的子序列（这几个子序列都满足字典序小于原串）。

#raw(read("lyndon.hpp"), lang : "cpp")