#import "@preview/taskize:0.2.7": tasks, tasks2, tasks3, tasks4, tasks-reset, tasks-setup

// =============================================================================
// DOCUMENT SETUP
// =============================================================================

#set page(margin: (x: 1.8cm, y: 2cm))
#set text(size: 10.5pt, font: "New Computer Modern")
#set heading(numbering: "1.")
#set par(justify: true)

#show raw.where(lang: "typst"): it => block(
  fill: luma(97%),
  radius: 3pt,
  inset: 8pt,
  stroke: 0.5pt + luma(85%),
)[#it]

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// Two-column example layout with code and preview
#let example(code, body) = block(breakable: false)[
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 6pt,
    align: (left + top, center + top),
    [
      #set text(size: 8.5pt)
      *Code*
      #v(0.3em)
      #code
    ],
    [
      *Preview*
      #v(0.3em)
      #box(
        width: 100%,
        inset: 6pt,
        radius: 3pt,
        stroke: 0.5pt + luma(85%),
        fill: luma(98%),
      )[
        #set text(size: 9pt)
        #body
      ]
    ],
  )
  #v(0.5em)
]

// =============================================================================
// TITLE PAGE
// =============================================================================

#align(center)[
  #v(2cm)
  #text(size: 28pt, weight: "bold")[taskize]
  #v(0.5em)
  #text(size: 16pt)[Typst Package]
  #v(1em)
  #text(size: 12pt, style: "italic")[Horizontal Columned Lists]
  #v(2cm)
  #line(length: 60%, stroke: 0.5pt)
  #v(1cm)
  #text(size: 11pt)[
    A compact list layout for exercises and multiple-choice questions\
    Version 0.2.7\
    Nathan Scheinmann
  ]
]

#pagebreak()

// =============================================================================
// TABLE OF CONTENTS
// =============================================================================

#outline(indent: 1em)

#pagebreak()

// =============================================================================
// INTRODUCTION
// =============================================================================

= Introduction

`taskize` is a Typst package for horizontal, columned task lists. Items flow left-to-right across columns, making it ideal for exercises, quizzes, and compact lists that need a tidy grid.

== Features

- Indentation-independent parsing
- Horizontal or vertical flow directions
- Flexible column counts and column spanning
- Auto-fit column selection for the densest no-wrap layout
- Multiple label formats and custom label functions
- Resume numbering across task blocks
- Fine-grained spacing and alignment controls

== Installation

Import the package in your Typst document:

```typst
#import "@preview/taskize:0.2.7": tasks
```

== Quick Start

#example(
  [```typst
  #tasks[
    + First item
    + Second item
    + Third item
    + Fourth item
  ]
  ```],
  [#tasks[
    + First item
    + Second item
    + Third item
    + Fourth item
  ]]
)

// =============================================================================
// BASIC USAGE
// =============================================================================

= Basic Usage

== Column Counts

Use `columns:` or shorthand functions (`tasks2`, `tasks3`, `tasks4`) for quick layouts.

#example(
  [```typst
  #tasks(columns: 3)[
    + Option A
    + Option B
    + Option C
    + Option D
    + Option E
    + Option F
  ]
  ```],
  [#tasks(columns: 3)[
    + Option A
    + Option B
    + Option C
    + Option D
    + Option E
    + Option F
  ]]
)

#example(
  [```typst
  #tasks3[
    + Item 1
    + Item 2
    + Item 3
    + Item 4
    + Item 5
    + Item 6
  ]
  ```],
  [#tasks3[
    + Item 1
    + Item 2
    + Item 3
    + Item 4
    + Item 5
    + Item 6
  ]]
)

== Auto-Fit Columns

Use `columns: "auto-fit"` to select the largest column count that does not
introduce a new item wrap or fixed-size content overflow. By default the
search goes up to the number of items, so no other option is needed;
use `max-columns:` only to cap the search.

#example(
  [```typst
  // No max-columns needed: auto-fit tries up to one
  // column per item and picks the densest layout.
  #tasks(columns: "auto-fit")[
    + Medium length task with detail
    + Short
    + Short
    + Short
  ]
  ```],
  [#tasks(columns: "auto-fit")[
    + Medium length task with detail
    + Short
    + Short
    + Short
  ]]
)

By default, auto-fit uses `auto-fit-mode: "fill"`: span items may use their
full row while later rows remain dense. Use `auto-fit-mode: "uniform"` when
every item must fit one ordinary column; in that mode, the column count is the
largest value where no item wraps when measured at one-column width, so a wide
span item can force the whole block to one column.
If an item already wraps in the one-column layout, auto-fit keeps one column,
because no no-wrap multi-column layout exists.

A wide item auto-spans to fill the row in `"fill"` mode, while
`"uniform"` keeps every item in one column and falls back to fewer columns
when the widest item no longer fits.

#example(
  [```typst
  // fill: wide instruction auto-spans; cities pack into 4 cols.
  #tasks(columns: "auto-fit", auto-fit-mode: "fill",
         max-columns: 4)[
    + Choose the correct answer for each question below.
    + Paris
    + London
    + Berlin
    + Rome
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"fill"`, max 4 — instruction spans full row; answers in 4 cols:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "fill", max-columns: 4)[
      + Choose the correct answer for each question below.
      + Paris
      + London
      + Berlin
      + Rome
    ]
  ]
)

#example(
  [```typst
  // uniform: instruction too wide for one column at 2+ cols;
  // auto-fit falls back to a single column.
  #tasks(columns: "auto-fit", auto-fit-mode: "uniform",
         max-columns: 4)[
    + Choose the correct answer for each question below.
    + Paris
    + London
    + Berlin
    + Rome
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"uniform"`, max 4 — instruction forces 1-column layout:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "uniform", max-columns: 4)[
      + Choose the correct answer for each question below.
      + Paris
      + London
      + Berlin
      + Rome
    ]
  ]
)

With medium-length items (shorter than the full row but still wider than
one narrow column), `"fill"` auto-spans and keeps the maximum column count
while `"uniform"` backs off to the column count where the item fits in one
column slot. The same difference applies with 2 or 3 columns.

#example(
  [```typst
  // fill, max 2: medium item auto-spans both cols (= full
  // row); two short items fill row 2 side by side.
  #tasks(columns: "auto-fit", auto-fit-mode: "fill",
         max-columns: 2)[
    + Medium length task with detail
    + Short
    + Short
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"fill"`, max 2 — medium item spans full row; shorts in 2 cols:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "fill", max-columns: 2)[
      + Medium length task with detail
      + Short
      + Short
    ]
  ]
)

#example(
  [```typst
  // uniform, max 2: medium item too wide for one col at 2
  // cols; auto-fit falls back to a single column.
  #tasks(columns: "auto-fit", auto-fit-mode: "uniform",
         max-columns: 2)[
    + Medium length task with detail
    + Short
    + Short
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"uniform"`, max 2 — medium item forces 1-column layout:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "uniform", max-columns: 2)[
      + Medium length task with detail
      + Short
      + Short
    ]
  ]
)

#example(
  [```typst
  // fill, max 3: medium item auto-spans; 3 cols.
  #tasks(columns: "auto-fit", auto-fit-mode: "fill",
         max-columns: 3)[
    + Medium length task
    + Short
    + Short
    + Short
  ]
  // uniform, max 3: medium item must fit one column;
  // backs off to 2 columns where it does.
  #tasks(columns: "auto-fit", auto-fit-mode: "uniform",
         max-columns: 3)[
    + Medium length task
    + Short
    + Short
    + Short
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"fill"` vs `"uniform"`, max 3 — fill gives 3 cols, uniform gives 2:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "fill", max-columns: 3)[
      + Medium length task
      + Short
      + Short
      + Short
    ]
    #v(0.5em)
    #tasks(columns: "auto-fit", auto-fit-mode: "uniform", max-columns: 3)[
      + Medium length task
      + Short
      + Short
      + Short
    ]
  ]
)

#example(
  [```typst
  // fill, max 4: medium item auto-spans; 4 cols.
  #tasks(columns: "auto-fit", auto-fit-mode: "fill",
         max-columns: 4)[
    + Medium length task
    + Short
    + Short
    + Short
  ]
  // uniform, max 4: medium item must fit one column;
  // backs off to 2 columns where it does.
  #tasks(columns: "auto-fit", auto-fit-mode: "uniform",
         max-columns: 4)[
    + Medium length task
    + Short
    + Short
    + Short
  ]
  ```],
  [
    #text(size: 8pt, style: "italic")[`"fill"` vs `"uniform"`, max 4 — fill gives 4 cols, uniform gives 2:]
    #v(0.3em)
    #tasks(columns: "auto-fit", auto-fit-mode: "fill", max-columns: 4)[
      + Medium length task
      + Short
      + Short
      + Short
    ]
    #v(0.5em)
    #tasks(columns: "auto-fit", auto-fit-mode: "uniform", max-columns: 4)[
      + Medium length task
      + Short
      + Short
      + Short
    ]
  ]
)

== Labels and Formats

#example(
  [```typst
  #tasks(label: "A)")[+ Alpha + Beta + Gamma]
  #tasks(label: "(1)")[+ One + Two + Three]
  #tasks(label: n => "Q" + str(n) + ":")[
    + What is 2 + 2?
    + What is the capital of France?
    + What color is the sky?
  ]
  ```],
  [
    #tasks(label: "A)")[+ Alpha + Beta + Gamma]
    #v(0.4em)
    #tasks(label: "(1)")[+ One + Two + Three]
    #v(0.4em)
    #tasks(label: n => "Q" + str(n) + ":")[
      + What is 2 + 2?
      + What is the capital of France?
      + What color is the sky?
    ]
  ]
)

== Column Spanning

Use `(N)` to span N columns or `()` to span all columns.

#example(
  [```typst
  #tasks(columns: 3)[
    + (2) Long statement spanning two columns
    + Short
    + () Full width note across all columns
    + Another
  ]
  ```],
  [#tasks(columns: 3)[
    + (2) Long statement spanning two columns
    + Short
    + () Full width note across all columns
    + Another
  ]]
)

== Flow Direction

Horizontal is default. Use `flow: "vertical"` to fill columns top-to-bottom.

#example(
  [```typst
  #tasks(columns: 2, flow: "vertical")[
    + a
    + b
    + c
    + d
    + e
    + f
  ]
  ```],
  [#tasks(columns: 2, flow: "vertical")[
    + a
    + b
    + c
    + d
    + e
    + f
  ]]
)

// =============================================================================
// CONFIGURATION
// =============================================================================

= Configuration

== Global Defaults

Use `tasks-setup()` to set defaults for the rest of the document.

#example(
  [```typst
  #tasks-setup(
    columns: 3,
    label-format: "1)",
    column-gutter: 1.2em,
    row-gutter: 0.7em,
    label-weight: "bold",
  )

  #tasks[
    + Item 1
    + Item 2
    + Item 3
    + Item 4
    + Item 5
    + Item 6
  ]
  ```],
  [
    #tasks-setup(
      columns: 3,
      label-format: "1)",
      column-gutter: 1.2em,
      row-gutter: 0.7em,
      label-weight: "bold",
    )

    #tasks[
      + Item 1
      + Item 2
      + Item 3
      + Item 4
      + Item 5
      + Item 6
    ]
  ]
)

== Resume Numbering

#example(
  [```typst
  #tasks[
    + First
    + Second
    + Third
  ]

  #tasks(resume: true)[
    + Fourth
    + Fifth
  ]

  #tasks-reset()
  #tasks[
    + Back to one
    + Two again
  ]
  ```],
  [
    #tasks[
      + First
      + Second
      + Third
    ]

    #tasks(resume: true)[
      + Fourth
      + Fifth
    ]

    #tasks-reset()
    #tasks[
      + Back to one
      + Two again
    ]
  ]
)

// =============================================================================
// PARAMETER REFERENCE
// =============================================================================

= Parameter Reference

The `tasks()` function supports the following parameters:

#table(
  columns: (1.4fr, 1fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [columns], [int/string], [2], [Number of columns, or `"auto-fit"` for the largest no-wrap count],
  [label], [string/function], ["a)"], [Label format shorthand],
  [label-format], [string/function], ["a)"], [Explicit label format],
  [start], [int], [1], [Starting number],
  [resume], [bool], [false], [Continue numbering from previous tasks],
  [column-gutter], [length], [1em], [Space between columns],
  [row-gutter], [length], [0.6em], [Space between rows],
  [max-columns], [int/auto], [auto], [Maximum column count tested by auto-fit; `auto` means up to the number of items],
  [auto-fit-mode], [string], ["fill"], [`"fill"` measures spans at their rendered width; `"uniform"` requires every item to fit one ordinary column],
  [auto-fit-tolerance], [length], [0.5pt], [Measurement tolerance for auto-fit wrap detection],
  [label-width], [auto/length], [auto], [Reserved width for labels],
  [label-align], [alignment], [right], [Label alignment],
  [label-baseline], [string/length], ["center"], [Vertical alignment of labels. With `"center"` (default), inline content (text, math) shares the same paragraph line as the label for true baseline alignment. Use `"top"`, `"bottom"`, or a length offset to override.],
  [label-weight], [string], ["regular"], [Font weight for labels],
  [indent-after-label], [length], [0.4em], [Space after label],
  [indent], [length], [0pt], [Left indentation of the block],
  [above], [length], [0.5em], [Space before the block],
  [below], [length], [0.5em], [Space after the block],
  [flow], [string], ["horizontal"], ["horizontal" or "vertical" flow],
)

// =============================================================================
// END
// =============================================================================
