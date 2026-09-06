#import "theme.typ": *

// ================================
// 可直接调整的版式参数
// ================================
// 优先调整 text-leading / code-leading；它们分别控制普通文本和代码的行距。
#let layout = (
  text-leading: 0.8em,
  code-leading: 0.5em,
  paragraph-spacing: 1.2em,
  header-leading: 0pt,
  footer-leading: 0pt,
  header-line-gap: 4pt,
  footer-line-gap: 2pt,
  // 文本框
  text-box-above: 0pt,
  text-box-below: 0pt,
  text-box-inset-x: 8pt,
  text-box-inset-y: 8pt,
  // 解答框
  solution-box-above: 0pt,
  solution-box-below: 1.0em,
  solution-box-inset-x: 8pt,
  solution-box-inset-y: 8pt,
  // 代码框
  code-box-above: 0pt,
  code-box-below: 0pt,
  code-box-inset-x: 0pt,
  code-box-inset-y: 0pt,
)

#show: project.with(
  title: "Jimmy Wangの 代码模板",
  author: "JimmyWang0417",
  date: auto,
  team: "麒麟王的心脏",
  members: ("wjr", "chx", "jyc"),
  layout: layout,
  abstract: [
    本文档整理了 Jimmy Wang の算法竞赛代码模板，并记录相关算法的性质与结论。
    #{
      set align(center + horizon)
      image("../../image/88D2DB2E657F7DB09DAB8A02818C9A60.jpg")
    }
  ],
  outlines: true,
    // keywords: ("算法竞赛", "代码模板", "算法分析"),
)
#show table: three-line-table

#include "../content.typ"
