# Agent 维护说明

## 斯特林数记号

- 第一类斯特林数统一写作方括号形式 $[n;m]$，源码调用 `stirlingFirst(n, m)`。
- 第二类斯特林数统一写作花括号形式 ${n;m}$，源码调用 `stirlingSecond(n, m)`。
- 两个记号函数集中定义在 `Templates/math/stirling.typ` 顶部；新增公式时应复用函数，避免直接重复配置 `math.vec` 的分隔符。

## 编译

在仓库根目录执行：

```sh
typst compile main.typ /tmp/competitive-programming-templates.pdf
```

本次使用 Typst 0.15.1 验证通过，生成的文档共 136 页。当前环境缺少 SimSun、SimHei、KaiTi、STZhongsong 和 Consolas，编译时会出现字体回退警告，但不影响 PDF 生成。

## 2026-07-28 修改记录

- 统一了第一类、第二类斯特林数在介绍、递推式、性质、通项公式和斯特林反演中的记号。
- 删除了第一类斯特林数组合证明中误写的多余右花括号。
- 将已不兼容 Typst 0.15.1 的 `plus.circle` 等价替换为 `⊕`。
- 修正无标签块公式样式对空标签的依赖，使整本模板能在 Typst 0.15.1 下编译。
