= 初始化与杂项
== 常用缺省源
#raw(read("io.hpp"), lang : "cpp")
== 哈希表（个人定制防卡加速版）
#raw(read("hashTable.hpp"), lang : "cpp")
== 模意义真分数还原
$ q equiv x/a (mod p), |a| <= A $

#raw(read("approx.hpp"), lang : "cpp")

== 位运算封装
=== 核心位操作函数

这些函数通常有对不同整数宽度（`int`, `long`, `long long`）的变体。函数名中的 `l` 代表 `long`，`ll` 代表 `long long`。

==== 前导零 (Count Leading Zeros)
计算从最高位（MSB）开始，连续为 0 的位数。如果输入为 0，结果是未定义的。

-   `int __builtin_clz (unsigned int x)`
-   `int __builtin_clzl (unsigned long x)`
-   `int __builtin_clzll (unsigned long long x)`

#strong("用途")：计算一个数的对数（log2），找到最高有效位（MSB）的位置。
#strong("示例")：`32 - __builtin_clz(x)` 可以快速得到存储 `x` 所需的最小位数，或者 `31 - __builtin_clz(x)` 得到 `x` 的以 2 为底的对数（对于 `x > 0`）。

==== 尾随零 (Count Trailing Zeros)
计算从最低位（LSB）开始，连续为 0 的位数。如果输入为 0，结果是未定义的。

-   `int __builtin_ctz (unsigned int x)`
-   `int __builtin_ctzl (unsigned long x)`
-   `int __builtin_ctzll (unsigned long long x)`

#strong("用途")：常用于位图算法，快速找到第一个被置 1 的位（从右向左）。
#strong("示例")：`__builtin_ctz(0b00010000)` 返回 `4`。

==== 位元计数 (Population Count / Popcount)
计算值为 1 的位的个数。

-   `int __builtin_popcount (unsigned int x)`
-   `int __builtin_popcountl (unsigned long x)`
-   `int __builtin_popcountll (unsigned long long x)`

#strong("用途")：计算汉明重量（Hamming Weight），在信息论、密码学、稀疏矩阵/数组中非常有用。
#strong("示例")：`__builtin_popcount(0b10101010)` 返回 `4`。

==== 奇偶校验 (Parity)
计算值的奇偶性，即所有位进行异或操作的结果（`popcount % 2`）。

-   `int __builtin_parity (unsigned int x)`
-   `int __builtin_parityl (unsigned long x)`
-   `int __builtin_parityll (unsigned long long x)`

#strong("用途")：简单的错误检测码。
#strong("示例")：`__builtin_parity(0b10101011)` 返回 `1` (因为有 5 个 '1'，5 % 2 = 1)。

==== 查找第一个置位 (Find First Set)
返回第一个（最低位）被置为 1 的位的索引，#strong("索引从 1 开始计数")。如果输入为 0，则返回 0。

-   `int __builtin_ffs (int x)`
-   `int __builtin_ffsl (long x)`
-   `int __builtin_ffsll (long long x)`

#strong("用途")：和 `ctz` 类似，但 `ffs` 对 0 输入是安全的，且索引从 1 开始。注意：`__builtin_ffs(x) = __builtin_ctz(x) + 1` (对于 `x != 0`)。
#strong("示例")：`__builtin_ffs(0b00010000)` 返回 `5`。

---

=== 高级位操作与字节序函数

==== 位反转 (Bit Reversal)
反转一个整数的所有位的顺序。

-   `unsigned int __builtin_bitreverse32 (unsigned int x)`
-   `unsigned long __builtin_bitreversel (unsigned long x)`
-   `unsigned long long __builtin_bitreversell (unsigned long long x)`

#strong("注意")：这个函数相对较新，在老版本的编译器中可能不支持。
#strong("用途")：在一些编解码、FFT 算法中会用到。

==== 字节序交换 (Endianness Swap)
反转一个整数内部的字节顺序。

-   `uint16_t __builtin_bswap16 (uint16_t x)`
-   `uint32_t __builtin_bswap32 (uint32_t x)`
-   `uint64_t __builtin_bswap64 (uint64_t x)`

#strong("用途")：在大端序（Big-Endian）和小端序（Little-Endian）系统之间进行数据转换。
#strong("示例")：`__builtin_bswap32(0x12345678)` 返回 `0x78563412`。


=== 重要说明

1.  #strong("输入为 0")：`__builtin_clz` 和 `__builtin_ctz` 在输入为 0 时的行为是#strong("未定义（Undefined）")。使用前务必确保参数不为零，或者使用 `__builtin_ffs` 来避免这个问题。

2.  #strong("性能")：这些函数的性能极高，通常对应一条特定的 CPU 指令（如 `POPCNT`, `LZCNT`, `TZCNT`）。在支持这些指令的 CPU 上，它们是最优选择。即使在不支持的 CPU 上，编译器也会提供一个高效的软件实现。

对于任何位级密集型的算法，熟练使用这些内置函数是大幅提升性能的关键手段之一。

=== 封装函数
#raw(read("bit.hpp"), lang : "cpp")
== makefile
#raw(read("makefile"), lang : "makefile")