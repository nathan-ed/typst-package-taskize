#import "@preview/taskize:0.2.11": tasks, tasks2, tasks3, tasks4, tasks-reset, tasks-setup, taskize-wrap-zone

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
    Version 0.2.8\
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
- Wrap zone to flow rows around reserved overlay space (QR codes, stamps)

== Installation

Import the package in your Typst document:

```typst
#import "@preview/taskize:0.2.11": tasks
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

=== Rigid content: tables, figures and fixed-size graphics

Most content adapts to a narrower column: text and table cells wrap, and an
image with no explicit width scales down. Auto-fit measures that adaptation to
decide how dense a layout can be.

Content given a fixed size cannot adapt: a table with fixed columns of short
cells, a `box` with an explicit `width`, an `image(..., width: 5cm)`. Such an
item keeps exactly the same height however narrow its column, and would
silently overflow into its neighbour. Auto-fit therefore also compares its
natural width against the column it would land in, and gives it the columns it
needs -- spanning them in `"fill"` mode, or lowering the column count for the
whole block in `"uniform"` mode.

#example(
  [```typst
  // Each table keeps its natural width: auto-fit packs
  // as many per row as actually fit, and no more.
  #let t(v) = table(
    columns: 4, align: center, inset: 4pt,
    [Souris], [$6$], [$9$], [$7$],
    [Prix], [], [$#v$], [],
  )
  #tasks(columns: "auto-fit")[
    + #t("31,5")
    + #t("45,5")
    + #t("14,4")
    + #t("8")
  ]
  ```],
  [
    #let t(v) = table(
      columns: 4, align: center, inset: 4pt,
      [Souris], [$6$], [$9$], [$7$],
      [Prix], [], [$#v$], [],
    )
    #tasks(columns: "auto-fit")[
      + #t("31,5")
      + #t("45,5")
      + #t("14,4")
      + #t("8")
    ]
  ]
)

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

=== What auto-fit measures, and what it costs

To measure an item, auto-fit has to lay it out. For text that is cheap. An
item that draws itself -- a CeTZ canvas, a plot -- is computed again for the
measurement, on every layout pass of the document, on top of being computed
for the page. Auto-fit therefore measures as little as it can:

- text and inline math are judged on their natural width alone;
- a `block` or `box` given both a fixed `width` and a fixed `height` is not
  laid out at all: its size is read from the call;
- nothing is measured when a single column is all there can be (one item, or
  `max-columns: 1`).

Wrap an expensive figure in a fixed-size container when you know its size, and
auto-fit costs no more than a fixed column count:

```typst
#tasks(columns: "auto-fit", max-columns: 4)[
  + #block(width: 4cm, height: 3cm, figure-a)
  + #block(width: 4cm, height: 3cm, figure-b)
]
```

A width or height given as a share of the available room (`50%`) does not
count as fixed, and such a container is measured like any other content.

Settings passed to `tasks` itself, or once with
`#let tasks = tasks.with(columns: "auto-fit")`, are known on the first layout
pass. Settings made with `tasks-setup` live in a state, which a document only
knows from its second pass on: the first one lays everything out with the
defaults, then again with the real settings. On a document full of figures,
the former spares a whole pass.

== Labels and Formats

#example(
  [```typst
  #tasks(label: "A)", ([Alpha], [Beta], [Gamma]))
  #tasks(label: "(1)", ([One], [Two], [Three]))
  #tasks(label: n => "Q" + str(n) + ":")[
    + What is 2 + 2?
    + What is the capital of France?
    + What color is the sky?
  ]
  ```],
  [
    #tasks(label: "A)", ([Alpha], [Beta], [Gamma]))
    #v(0.4em)
    #tasks(label: "(1)", ([One], [Two], [Three]))
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

== Answer Lines

Room to write in, under each task. The lines fill the column they land in,
so they follow the layout rather than a fixed width.

#example(
  [```typst
  #tasks(columns: 2, answer-lines: 2)[
    + Calculate $2 + 2$
    + Calculate $3 times 5$
  ]
  ```],
  [#tasks(columns: 2, answer-lines: 2)[
    + Calculate $2 + 2$
    + Calculate $3 times 5$
  ]]
)

`answer-line-style` picks how a line is drawn: `"dotted"` (default),
`"dashed"`, `"solid"`, or any stroke such as `(paint: gray, thickness: 0.6pt)`.
`answer-line-gap` separates the lines from one another, while
`answer-line-above` and `answer-line-below` separate the block from the task
above it and from whatever follows — `auto` leaves Typst's own block spacing
in place.

#example(
  [```typst
  #tasks(
    columns: 2,
    answer-lines: 3,
    answer-line-style: "solid",
    answer-line-gap: 1.6em,
    answer-line-above: 0.8em,
    answer-line-below: 1.4em,
  )[
    + Solve $x^2 = 9$
    + Expand $(x + 1)^2$
  ]
  ```],
  [#tasks(
    columns: 2,
    answer-lines: 3,
    answer-line-style: "solid",
    answer-line-gap: 1.6em,
    answer-line-above: 0.8em,
    answer-line-below: 1.4em,
  )[
    + Solve $x^2 = 9$
    + Expand $(x + 1)^2$
  ]]
)

Outside a task list, `answer-dots` draws the same lines anywhere and takes
the same options: `#answer-dots(3)` or
`#answer-dots(2, style: "solid", gap: 1.4em, above: 0.8em)`.

Each line fills the cell it lands in rather than a fixed length, so the lines
follow whatever layout the block ends up with: an item spanning two columns
gets a line twice as long, and auto-fit, vertical flow, adaptive row heights,
a nested `tasks` call, a wrap zone and Typst's own `#raw("#columns()")` each
keep their own widths. The lines are drawn under _every_ item, a full-row
`#raw("+ () instruction")` included — keep such a heading outside the `tasks`
call if it should not get one.

== Adaptive Row Heights

Rows containing tall inline math (display fractions, matrices, big
operators) normally report a height based on the font's text edges, not
the actual ink — so the math bleeds into the row-gutter and rows look
glued together. Pass `row-gutter: "auto"` (or `"adaptive"`) to size rows
by their true ink: the configured numeric gutter (default `0.6em`)
becomes the real visual gap, and rows with ordinary content keep exactly
the same spacing as before.

#example(
  [```typst
  #show math.frac: it => math.display(it)
  // ink bleeds into the gutter:
  #tasks(columns: 2)[
    + $1/2$
    + $3/4$
    + $5/6$
    + $7/8$
  ]
  // rows sized to true ink:
  #tasks(columns: 2, row-gutter: "auto")[
    + $1/2$
    + $3/4$
    + $5/6$
    + $7/8$
  ]
  ```],
  [
    #show math.frac: it => math.display(it)
    #tasks(columns: 2)[
      + $1/2$
      + $3/4$
      + $5/6$
      + $7/8$
    ]
    #v(0.5em)
    #tasks(columns: 2, row-gutter: "auto")[
      + $1/2$
      + $3/4$
      + $5/6$
      + $7/8$
    ]
  ]
)

It can be made the document default with `#tasks-setup(row-gutter: "adaptive")`;
an explicit numeric `row-gutter` on a `tasks` call still overrides it.

== Wrap Zone <wrap-zone>

Reserve a rectangular zone at the top right of the next `#tasks` call so its
rows flow around overlay content placed there independently — a QR code, a
stamp, a logo. Rows that would overlap the zone render in a narrowed column
beside it; once enough rows have passed to clear the zone's height, the
remaining rows return to full width. Only horizontal flow (the default)
supports this — vertical flow ignores a pending zone, since narrowing rows
would reorder the numbering.

Set the zone with the `taskize-wrap-zone` state before the `#tasks` call and
place the overlay content yourself (`tasks` only reserves the space, it does
not draw anything there):

#example(
  [```typst
  #taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
  #place(top + right, box(
    width: 2.4cm, height: 2.4cm,
    stroke: 0.5pt + luma(60%),
  )[QR code])

  #tasks(columns: 2)[
    + $2 + 3$
    + $5 - 1$
    + $4 times 2$
    + $9 div 3$
    + $7 + 6$
    + $12 - 4$
  ]
  ```],
  [
    #taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
    #place(top + right, box(
      width: 2.4cm, height: 2.4cm,
      stroke: 0.5pt + luma(60%),
    )[#align(center + horizon)[#text(size: 8pt, fill: luma(60%))[QR code]]])
    #tasks(columns: 2)[
      + $2 + 3$
      + $5 - 1$
      + $4 times 2$
      + $9 div 3$
      + $7 + 6$
      + $12 - 4$
    ]
  ]
)

The state is consumed automatically: the first `#tasks` call that flows
around it resets it to `none`, so later calls in the same document are
unaffected by a zone set earlier. Two ways to override the shared state on a
single call:

#table(
  columns: (1.2fr, 1fr, 1fr, 2.3fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Name*], [*Type*], [*Default*], [*Description*],
  [`wrap-zone` (parameter of `tasks()`)], [auto/none/dictionary], [auto], [`auto` honors the shared `taskize-wrap-zone` state (the common case); `none` ignores a pending zone even if one is set; `(width: <length>, height: <length>)` reserves an explicit zone for this call only, without reading or clearing the shared state],
  [`taskize-wrap-zone` (state)], [none/dictionary], [none], [Shared state read by `tasks()` when its own `wrap-zone` parameter is `auto`. Set it with `#taskize-wrap-zone.update((width:, height:))` before the call; it is reset to `none` once a `#tasks` call consumes it. This is the contract wrapper packages (e.g. exercise-bank) use to reserve space for content they overlay themselves],
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
  [row-gutter], [length/string], [0.6em], [Space between rows. `"auto"` (or `"adaptive"`) sizes rows to the true ink of their content — tall inline math (display fractions, matrices) no longer bleeds into the gutter — while keeping the configured numeric gutter as the visual gap],
  [max-columns], [int/auto], [auto], [Maximum column count tested by auto-fit; `auto` means up to the number of items],
  [auto-fit-mode], [string], ["fill"], [`"fill"` measures spans at their rendered width; `"uniform"` requires every item to fit one ordinary column],
  [auto-fit-tolerance], [length], [0.5pt], [Measurement tolerance for auto-fit wrap detection],
  [answer-lines], [int], [0], [Ruled lines drawn under each task, for exam sheets],
  [answer-line-gap], [length], [1.2em], [Spacing between those lines],
  [answer-line-style], [string/stroke], ["dotted"], [`"dotted"`, `"dashed"`, `"solid"`, or a stroke to draw the rules with],
  [answer-line-above], [length/auto], [auto], [Space between the task and its first answer line],
  [answer-line-below], [length/auto], [auto], [Space after the last answer line],
  [label-width], [auto/length], [auto], [Reserved width for labels],
  [label-align], [alignment], [right], [Label alignment],
  [label-baseline], [string/length], ["center"], [Vertical alignment of labels. With `"center"` (default), inline content (text, math) shares the same paragraph line as the label for true baseline alignment. Use `"top"`, `"bottom"`, or a length offset to override.],
  [label-weight], [string], ["regular"], [Font weight for labels],
  [indent-after-label], [length], [0.4em], [Space after label],
  [indent], [length], [0pt], [Left indentation of the block],
  [above], [length], [0.5em], [Space before the block],
  [below], [length], [0.5em], [Space after the block],
  [flow], [string], ["horizontal"], ["horizontal" or "vertical" flow],
  [wrap-zone], [auto/none/dictionary], [auto], [`auto` honors the shared `taskize-wrap-zone` state; `none` ignores a pending zone; `(width:, height:)` sets an explicit zone for this call only. See #link(<wrap-zone>)[Wrap Zone]],
)

// =============================================================================
// END
// =============================================================================
