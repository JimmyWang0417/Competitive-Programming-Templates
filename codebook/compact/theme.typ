// 紧凑版模板来自队友的项目：
// https://github.com/chen-hongxuan/xcpc-codebook
// 版面结构保持一致；算法正文与代码只读取本仓库的 Templates/。

// ================================
// 可调排版参数
// ================================

#let default-config = (
  // 行距设置（最常调整）
  text-leading: 0.16em,
  code-leading: 0.16em,
  paragraph-spacing: 1.2pt,
  header-leading: 0pt,
  header-line-gap: 1pt,
  // 文本框间距与留白
  text-box-above: 1pt,
  text-box-below: 3pt,
  text-box-inset-x: 3pt,
  text-box-inset-y: 3pt,
  // 代码框间距与留白
  code-box-above: 1pt,
  code-box-below: 3pt,
  code-box-inset-x: 2pt,
  code-box-inset-y: 1.4pt,
)

// `main.typ` 可通过 layout 覆盖这些默认值；组件从状态中读取当前配置。
#let layout-state = state("compact-layout-config", default-config)

#let code-line(it, leading: 0pt, highlights: ()) = {
  // 紧凑版不显示行号；续行间距由参数显式控制。
  let body = if highlights.contains(it.number) {
    box(width: 100%, fill: rgb("e9fbfb"), it.body)
  } else {
    it.body
  }

  if it.number > 1 {
    v(leading)
  } else {
    none
  }
  body
}

#let code-file(path, lang: "cpp", highlights: ()) = context {
  let config = layout-state.get()
  show raw.line: it => code-line(
    it,
    leading: config.code-leading,
    highlights: highlights,
  )
  raw(read(path), lang: lang, block: true)
}

#let note-box(body) = context {
  let config = layout-state.get()
  block(
    width: 100%,
    breakable: true,
    stroke: 0.35pt + luma(145),
    inset: (x: config.text-box-inset-x, y: config.text-box-inset-y),
    above: config.text-box-above,
    below: config.text-box-below,
    body,
  )
}

#let codebook(
  title: "XCPC Standard Code Library",
  short-title: "XCPC Codebook",
  school: "Your University",
  team: "Your Team",
  members: ("Member A", "Member B", "Member C"),
  updated: datetime.today().display("[year]-[month]-[day]"),
  layout: (),
  body,
) = {
  layout-state.update(default-config + layout)
  context {
    let config = layout-state.get()

  set document(title: title, author: members)
  set text(
    font: (
      (name: "Libertinus Serif", covers: "latin-in-cjk"),
      "Noto Serif CJK SC",
    ),
    size: 7.2pt,
    lang: "zh",
  )
  set par(
    justify: false,
    leading: config.text-leading,
    spacing: config.paragraph-spacing,
  )
  set columns(gutter: 4.5mm)
  set heading(numbering: "1.1")
  set raw(tab-size: 2)

  show heading.where(level: 1): set text(size: 15pt, weight: "bold")
  show heading.where(level: 2): set text(size: 9.2pt, weight: "bold")
  show heading.where(level: 3): set text(size: 7.4pt, weight: "bold")
  show raw: set text(
    // GitHub runner 默认安装此字体，保持与原模板相同的等宽紧凑效果。
    font: "DejaVu Sans Mono",
    size: 6.15pt,
  )
  show raw.where(block: true): it => {
    show raw.line: line => code-line(line, leading: config.code-leading)
    block(
      width: 100%,
      breakable: true,
      stroke: 0.35pt + luma(145),
      inset: (x: config.code-box-inset-x, y: config.code-box-inset-y),
      above: config.code-box-above,
      below: config.code-box-below,
      it,
    )
  }
  let running-header = context {
    set par(leading: config.header-leading)
    stack(
      spacing: config.header-line-gap,
      [
        #set text(size: 6.3pt, fill: luma(45))
        #school
        #h(1fr)
        #short-title
        #h(1fr)
        Page #counter(page).display("1")
      ],
      line(length: 100%, stroke: 0.35pt + luma(45)),
    )
  }

  set page(
    paper: "a4",
    margin: (left: 8mm, right: 8mm, top: 12mm, bottom: 7mm),
    columns: 2,
    header-ascent: 25%,
    header: running-header,
  )

  page(
    paper: "a4",
    margin: 18mm,
    columns: 1,
    header: none,
    footer: none,
  )[
    #align(center)[
      #v(8mm)
      #text(size: 11pt, weight: "semibold")[#school]
      #v(20mm)
      #text(size: 28pt, weight: "bold")[#title]
      #v(5mm)
      #text(size: 12pt, fill: luma(80))[Printable Team Reference Document]
      #v(31mm)
      #rect(
        width: 112mm,
        height: 58mm,
        stroke: 0.8pt + luma(70),
        inset: 10mm,
      )[
        #align(left)[
          #text(size: 9pt, weight: "bold")[Team]\
          #text(size: 13pt)[#team]
          #v(6mm)
          #text(size: 9pt, weight: "bold")[Members]\
          #text(size: 10pt)[#members.join(" / ")]
        ]
      ]
      #v(1fr)
      #text(size: 7pt, fill: luma(100))[Last updated: #updated]
    ]
  ]

  counter(page).update(1)
  page(
    paper: "a4",
    margin: (left: 10mm, right: 10mm, top: 11mm, bottom: 8mm),
    columns: 2,
    header: none,
    footer: none,
  )[
    #set text(size: 8pt)
    #set par(leading: 0.3em)
    #heading(level: 1, numbering: none, outlined: false)[目录 / Contents]
    #outline(title: none, depth: 3, indent: 1em)
  ]

  counter(page).update(2)
  body
  }
}
