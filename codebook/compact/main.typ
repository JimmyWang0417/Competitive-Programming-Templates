#import "theme.typ": codebook

// ================================
// 可直接调整的版式参数
// ================================
// 优先调整 text-leading / code-leading；它们分别控制普通文本和代码的行距。
#let layout = (
  text-leading: 0.16em,
  code-leading: 0.16em,
  paragraph-spacing: 1.2pt,
  header-leading: 0pt,
  header-line-gap: 1pt,
  // 文本框
  text-box-above: 1pt,
  text-box-below: 3pt,
  text-box-inset-x: 3pt,
  text-box-inset-y: 3pt,
  // 代码框
  code-box-above: 1pt,
  code-box-below: 3pt,
  code-box-inset-x: 2pt,
  code-box-inset-y: 1.4pt,
)

#show: codebook.with(
  title: "Jimmy Wang's XCPC Codebook",
  short-title: "XCPC Codebook",
  school: "Xi'an Jiaotong University",
  team: "Heart of Kirin King",
  members: ("wjr", "chx", "jyc"),
  layout: layout,
)

#include "../content.typ"
