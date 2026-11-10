// Answer line styles and spacing, one page each.
//
// p1 dotted (default), two lines
// p2 solid, three lines, explicit gap and separation above/below
// p3 dashed and a custom stroke, plus tasks-setup as document-wide default
// p4 answer-dots on its own, outside a task list
// p5 the lines follow the layout: spans, auto-fit, vertical flow, adaptive
//    rows, nesting, wrap zone, and inside Typst's own columns

#import "../lib.typ": tasks, tasks-setup, answer-dots

#set page(width: 14cm, height: auto, margin: 1cm)

*p1 — dotted (default)*
#tasks(columns: 2, answer-lines: 2)[
  + Calculate $2 + 2$
  + Calculate $3 times 5$
]

#pagebreak()
*p2 — solid, spaced*
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
Text after the block.

#pagebreak()
*p3 — dashed, custom stroke, and a document-wide default*
#tasks(columns: 1, answer-lines: 1, answer-line-style: "dashed")[
  + Justify your answer
]
#tasks(columns: 1, answer-lines: 1, answer-line-style: (paint: blue, thickness: 0.8pt))[
  + And again, in blue
]
#tasks-setup(answer-line-style: "solid", answer-line-above: 0.6em)
#tasks(columns: 2, answer-lines: 2)[
  + From tasks-setup
  + Also from tasks-setup
]

#pagebreak()
*p4 — standalone*
#answer-dots(3)
#answer-dots(2, style: "solid", gap: 1.4em, above: 0.8em)

#pagebreak()
*p5 — the lines follow the layout*

spans
#tasks(columns: 3, answer-lines: 1, answer-line-style: "solid", answer-line-above: 0.6em)[
  + () Instruction spanning all columns
  + one
  + two
  + three
  + (2) wide item
  + last
]

auto-fit
#tasks(columns: "auto-fit", answer-lines: 2, answer-line-style: "solid")[
  + $2+2$
  + $3+3$
  + $4+4$
]

vertical flow
#tasks(columns: 2, flow: "vertical", answer-lines: 1, answer-line-style: "dashed")[
  + a
  + b
  + c
  + d
]

adaptive row heights
#tasks(columns: 2, row-gutter: "auto", answer-lines: 2, answer-line-style: "solid")[
  + $x = frac(1,2)$
  + $y = frac(3,4)$
]

nested
#tasks(columns: 1)[
  + Outer question
    #tasks(columns: 2, answer-lines: 1, answer-line-style: "solid")[
      + sub a
      + sub b
    ]
]

wrap zone
#tasks(columns: 2, answer-lines: 1, answer-line-style: "solid", wrap-zone: (width: 3cm, height: 1.5cm))[
  + w1
  + w2
  + w3
  + w4
]

inside Typst's own columns (still solid: the tasks-setup call on p3 holds)
#columns(2)[
  #tasks(columns: 1, answer-lines: 2, answer-line-style: "solid")[
    + First
    + Second
  ]
  #colbreak()
  #tasks(columns: 1, answer-lines: 2)[
    + Third
    + Fourth
  ]
]
