// Test: auto-fit column selection
#import "../lib.typ": *

#set page(width: 14cm, height: auto, margin: 8mm)

#let selector-defaults = (
  fmt: "a)",
  col-gut: 1em,
  lbl-width: auto,
  lbl-weight: "regular",
  indent-after: 0.4em,
  indent: 0pt,
  start-num: 1,
  mode: "fill",
  tolerance: 0.5pt,
)

#let test-box(width, height: 8mm, fill: luma(92%)) = box(
  width: width,
  height: height,
  rect(width: 100%, height: 100%, fill: fill, stroke: 0.6pt + gray),
)

#let test-figure(width, height: 7mm, caption: [small box]) = figure(
  test-box(width, height: height, fill: luma(90%)),
  caption: caption,
)

#layout(size => {
  let choose(
    items,
    max,
    mode: selector-defaults.mode,
    fmt: selector-defaults.fmt,
    col-gut: selector-defaults.col-gut,
    lbl-width: selector-defaults.lbl-width,
    lbl-weight: selector-defaults.lbl-weight,
    indent-after: selector-defaults.indent-after,
    indent: selector-defaults.indent,
    start-num: selector-defaults.start-num,
    tolerance: selector-defaults.tolerance,
  ) = _select-auto-fit-columns(
    items,
    max,
    fmt,
    col-gut,
    lbl-width,
    lbl-weight,
    indent-after,
    indent,
    start-num,
    mode,
    tolerance,
    size.width,
  )

  let short4 = (([A], 1), ([B], 1), ([C], 1), ([D], 1))
  let short6 = (([A], 1), ([B], 1), ([C], 1), ([D], 1), ([E], 1), ([F], 1))
  let medium4 = (([Medium length task with detail], 1), ([Evaluate slope at zero], 1), ([Short], 1), ([Short], 1))

  // --- Basic bounds --------------------------------------------------------

  assert(
    _is-auto-fit-columns("auto-fit"),
    message: "\"auto-fit\" should be recognized as auto-fit columns",
  )

  assert(
    _is-auto-fit-columns("fit"),
    message: "\"fit\" should remain a short alias for auto-fit columns",
  )

  assert(
    not _is-auto-fit-columns(4),
    message: "numeric column counts should not be treated as auto-fit",
  )

  assert(
    choose((), 4) == 1,
    message: "empty task lists should fall back to one column",
  )

  assert(
    choose((([A], 1),), 4) == 1,
    message: "single item should never choose more than one column",
  )

  assert(
    choose((([A], 1), ([B], 1)), 4) == 2,
    message: "two short items should choose two columns",
  )

  assert(
    choose(short4, 4) == 4,
    message: "short text should fit four columns",
  )

  assert(
    choose(short6, 3) == 3,
    message: "max-columns should cap short items at three",
  )

  assert(
    choose(short6, 2) == 2,
    message: "max-columns should cap short items at two",
  )

  assert(
    choose(short6, 0) == 1,
    message: "non-positive max-columns should be clamped to one",
  )

  assert(
    choose(short6, 6) == 6,
    message: "six very short items should fit six columns",
  )

  assert(
    choose(short6, auto) == choose(short6, 6),
    message: "max-columns: auto should behave like an explicit item-count maximum",
  )

  assert(
    choose(short6, auto) >= 6,
    message: "max-columns: auto should not be more restrictive than an explicit six",
  )

  // --- Wrapping prevention -------------------------------------------------

  assert(
    choose((([Medium length task with detail], 1), ([B], 1), ([C], 1), ([D], 1)), 4) == 2,
    message: "medium text should reduce to two columns",
  )

  assert(
    choose(medium4, 4) == 2,
    message: "two medium tasks should reduce to two columns",
  )

  assert(
    choose((([This item is intentionally extremely long, long enough to wrap even before the task block is split into columns, so auto-fit cannot find a no-wrap multi-column layout.], 1), ([B], 1)), 4) == 1,
    message: "already-wrapping content should stay at one column",
  )

  assert(
    choose(medium4, 4, col-gut: 2cm) == 1,
    message: "large column gutter should reduce available width",
  )

  assert(
    choose(medium4, 4, indent: 3cm) == 1,
    message: "large task indentation should reduce available width",
  )

  assert(
    choose(medium4, 4, lbl-width: 2cm) == 1,
    message: "fixed wide label column should reduce available width",
  )

  assert(
    choose(medium4, 4, fmt: n => "Question " + str(n) + ":") == 1,
    message: "long labels should be accounted for",
  )

  assert(
    choose((([Alpha], 1), ([Beta], 1), ([Gamma], 1), ([Delta], 1), ([Epsilon], 1), ([Zeta], 1)), 6, start-num: 98, fmt: "1)") <
      choose((([Alpha], 1), ([Beta], 1), ([Gamma], 1), ([Delta], 1), ([Epsilon], 1), ([Zeta], 1)), 6),
    message: "wide numeric labels near 100 should reduce the selected column count",
  )

  assert(
    choose(medium4, 4, indent-after: 1.2cm) <= choose(medium4, 4),
    message: "larger label gutter should never increase the selected column count",
  )

  assert(
    choose(medium4, 4, lbl-weight: "bold") <= choose(medium4, 4),
    message: "bold labels should be included in label-width measurement",
  )

  assert(
    choose(medium4, 4, fmt: "(i)") <= choose(medium4, 4),
    message: "roman labels should be measured before selecting columns",
  )

  assert(
    choose((([abcdefghij], 1), ([klmnopqrst], 1), ([uvwxyz], 1), ([short], 1)), 4, tolerance: 100pt) >=
      choose((([abcdefghij], 1), ([klmnopqrst], 1), ([uvwxyz], 1), ([short], 1)), 4),
    message: "larger tolerance should not select fewer columns",
  )

  assert(
    choose(((test-box(2.6cm), 1), ([B], 1), ([C], 1), ([D], 1)), 4) == 3,
    message: "a 2.6cm fixed item should fit three but not four columns",
  )

  assert(
    choose(((test-box(4.1cm), 1), ([B], 1), ([C], 1), ([D], 1)), 4) == 2,
    message: "a 4.1cm fixed item should fit two but not three columns",
  )

  // --- Math and explicit multiline content --------------------------------

  assert(
    choose((([$x+1$], 1), ([$2x-3$], 1), ([$sqrt(5)$], 1), ([$pi$], 1)), 4) == 4,
    message: "short inline math should fit four columns",
  )

  assert(
    choose((([$f'(0)$ for $f(x)=x^2+3x$], 1), ([$2x-3=0$], 1), ([Short], 1), ([Short], 1)), 4) == 2,
    message: "medium inline math/text should reduce to two columns",
  )

  assert(
    choose((([$integral_0^1 (x^2+3x+1) dif x$], 1), ([$lim_(x -> 0) sin(x) / x$], 1), ([Short], 1), ([Short], 1)), 4) < 4,
    message: "long inline math should reduce before formula wrapping",
  )

  assert(
    choose((([First line\ second line], 1), ([Short], 1), ([Short], 1)), 3) == 3,
    message: "explicit multiline content should be allowed if no new wrap is introduced",
  )

  assert(
    choose((([First line\ an intentionally longer second line], 1), ([Short], 1), ([Short], 1)), 3) < 3,
    message: "explicit multiline content should still reject newly wrapped lines",
  )

  assert(
    choose((([supercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocious], 1), ([Short], 1), ([Short], 1)), 3) == 1,
    message: "unbreakable words too wide for one-column layout should stay at one column",
  )

  assert(
    choose(((block(width: 2.2cm, height: 8mm, fill: luma(94%)), 1), ([Short], 1), ([Short], 1)), 3) == 3,
    message: "small block content should be allowed in three columns",
  )

  assert(
    choose(((block(width: 3.8cm, height: 8mm, fill: luma(94%)), 1), ([Short], 1), ([Short], 1), ([Short], 1)), 4) < 4,
    message: "wide block content should reduce selected columns",
  )

  // --- Fixed-size content and figures -------------------------------------

  assert(
    choose(((test-box(1.5cm), 1), ([B], 1), ([C], 1)), 4) == 3,
    message: "small fixed-size figure should keep three columns for three items",
  )

  assert(
    choose(((test-box(3cm), 1), ([B], 1), ([C], 1)), 4) < 4,
    message: "wide fixed-size figure should reduce the selected column count",
  )

  assert(
    choose(((test-box(8cm), 1), ([B], 1), ([C], 1)), 4) == 1,
    message: "very wide fixed-size figure should force one column",
  )

  assert(
    choose(((test-figure(2cm), 1), ([Text], 1), ([$a^2+b^2=c^2$], 1)), 3) == 3,
    message: "small figure blocks should not count intrinsic height as a new wrap",
  )

  assert(
    choose(((test-figure(2cm, height: 2.2cm), 1), ([Text], 1), ([$a^2+b^2=c^2$], 1)), 3) == 3,
    message: "tall figure blocks should not be mistaken for wrapping",
  )

  assert(
    choose(((test-figure(3.8cm), 1), ([Text], 1), ([$a^2+b^2=c^2$], 1), ([D], 1)), 4) < 4,
    message: "wide figure blocks should reduce selected columns",
  )

  assert(
    choose(((test-figure(1.8cm, caption: [a longer caption that would wrap in narrow columns]), 1), ([Text], 1), ([Short], 1)), 3) < 3,
    message: "figure captions should participate in wrap detection",
  )

  // --- Span modes ----------------------------------------------------------

  // In fill mode, a full-width span is measured as a row-wide item and does
  // not force later rows down to one column.
  assert(
    choose(((test-box(8cm), 64), ([A], 1), ([B], 1), ([C], 1), ([D], 1)), 4) == 4,
    message: "full-width span should be measured against its full span",
  )

  // In uniform mode, every item must fit one ordinary column. The same span
  // therefore forces the whole block to one column.
  assert(
    choose(((test-box(8cm), 64), ([A], 1), ([B], 1), ([C], 1), ([D], 1)), 4, mode: "uniform") == 1,
    message: "uniform mode should let a full-width span force one column",
  )

  assert(
    choose(((test-box(5cm), 2), ([A], 1), ([B], 1), ([C], 1), ([D], 1)), 4) == 4,
    message: "fill mode should measure a two-column span against two columns",
  )

  assert(
    choose(((test-box(5cm), 2), ([A], 1), ([B], 1), ([C], 1), ([D], 1)), 4, mode: "uniform") <
      choose(((test-box(5cm), 2), ([A], 1), ([B], 1), ([C], 1), ([D], 1)), 4),
    message: "uniform mode should measure a two-column span more strictly than fill mode",
  )

  assert(
    choose(((test-box(6cm), 2), ([A], 1), ([B], 1), ([C], 1)), 4) == 3,
    message: "fill mode should back off when a partial span is too wide at the max",
  )

  assert(
    choose(((test-box(6cm), 2), ([A], 1), ([B], 1), ([C], 1)), 4, mode: "uniform") == 1,
    message: "uniform mode should measure partial spans as one-column items",
  )

  assert(
    choose(((test-box(7cm), 9), ([A], 1), ([B], 1), ([C], 1)), 3) == 3,
    message: "fill mode should clamp oversized spans to the candidate column count",
  )

  assert(
    choose((([Span text fits two columns], 2), ([A], 1), ([B], 1), ([C], 1)), 4, mode: "uniform") <= choose((([Span text fits two columns], 2), ([A], 1), ([B], 1), ([C], 1)), 4),
    message: "uniform mode should never select more columns than fill mode for the same spans",
  )

  []
})

= Auto-fit Visual Cases

== Short items: should use four columns

#tasks(columns: "auto-fit", max-columns: 4)[
  + A
  + B
  + C
  + D
]

== Text: should reduce before wrapping

Forced four-column reference: the first two items wrap.

#tasks(columns: 4)[
  + Medium length task with detail
  + Evaluate slope at zero
  + Short
  + Short
]

Auto-fit with the same content backs off to the largest no-wrap layout.

#tasks(columns: "auto-fit", max-columns: 4)[
  + Medium length task with detail
  + Evaluate slope at zero
  + Short
  + Short
]

== Mixed text and math: should reduce before wrapping

Forced four-column reference:

#tasks(columns: 4)[
  + Find $f'(0)$ for $f(x)=x^2+3x$
  + Solve $2x-3=0$
  + Short
  + Short
]

Auto-fit:

#tasks(columns: "auto-fit", max-columns: 4)[
  + Find $f'(0)$ for $f(x)=x^2+3x$
  + Solve $2x-3=0$
  + Short
  + Short
]

== Math: compact expressions can stay dense

#tasks(columns: "auto-fit", max-columns: 4)[
  + $x+1$
  + $2x-3$
  + $sqrt(5)$
  + $pi$
]

== Explicit multiline content: already-multiline is allowed

#tasks(columns: "auto-fit", max-columns: 3)[
  + First line\
    second line
  + Short
  + Short
]

== Spans in fill mode: full-width row, then dense rows

#tasks(columns: "auto-fit", max-columns: 4)[
  +() #box(width: 8cm, height: 8mm, rect(width: 100%, height: 100%, stroke: 0.6pt + gray))
  + A
  + B
  + C
  + D
]

== Spans in uniform mode: full-width row forces all rows to one column

#tasks(columns: "auto-fit", max-columns: 4, auto-fit-mode: "uniform")[
  +() #box(width: 8cm, height: 8mm, rect(width: 100%, height: 100%, stroke: 0.6pt + gray))
  + A
  + B
  + C
  + D
]

== Fixed-size figures: too-wide cells force fewer columns

#tasks(columns: "auto-fit", max-columns: 4)[
  + #box(width: 3cm, height: 8mm, rect(width: 100%, height: 100%, fill: luma(92%), stroke: 0.6pt + gray))
  + #box(width: 2cm, height: 8mm, rect(width: 100%, height: 100%, fill: luma(92%), stroke: 0.6pt + gray))
  + Small
]

== Typst figure blocks: intrinsic height does not count as a new wrap

#tasks(columns: "auto-fit", max-columns: 3)[
  + #figure(
      box(width: 2cm, height: 7mm, rect(width: 100%, height: 100%, fill: luma(90%), stroke: 0.6pt + gray)),
      caption: [small box],
    )
  + Text
  + $a^2+b^2=c^2$
]

== Alias: `fit` should behave like `auto-fit`

#tasks(columns: "fit", max-columns: 4)[
  + A
  + B
  + C
  + D
]

== Max cap: many short items stay capped

#tasks(columns: "auto-fit", max-columns: 2)[
  + A
  + B
  + C
  + D
  + E
  + F
]

== Long content: forced four-column reference

#tasks(columns: 4)[
  + Differentiate $g(x)=x^3-2x+5$ and evaluate the derivative at the origin
  + Explain why the sign of $h(x)$ changes exactly once on the interval
  + Give the exact value of the area under the graph between the two roots
  + State the monotonicity intervals and justify every endpoint
]

== Long content: auto-fit backs off

#tasks(columns: "auto-fit", max-columns: 4)[
  + Differentiate $g(x)=x^3-2x+5$ and evaluate the derivative at the origin
  + Explain why the sign of $h(x)$ changes exactly once on the interval
  + Give the exact value of the area under the graph between the two roots
  + State the monotonicity intervals and justify every endpoint
]

== Already wrapping at one column: auto-fit stays at one

#tasks(columns: "auto-fit", max-columns: 4)[
  + This item is intentionally extremely long, long enough to wrap even before the task block is split into columns, so auto-fit cannot find a no-wrap multi-column layout.
  + B
]

== Long labels: label width participates in fitting

#tasks(columns: "auto-fit", max-columns: 4, label: n => "Question " + str(n) + ":")[
  + Medium length task with detail
  + Evaluate slope at zero
  + Short
  + Short
]

== Numeric labels near 100: wider labels reduce density

#tasks(columns: "auto-fit", max-columns: 6, label: "1)", start: 98)[
  + Alpha
  + Beta
  + Gamma
  + Delta
  + Epsilon
  + Zeta
]

== Wide gutters and indentation: less usable column width

#tasks(columns: "auto-fit", max-columns: 4, column-gutter: 1.4cm, indent: 1.2cm)[
  + Medium length task with detail
  + Evaluate slope at zero
  + Short
  + Short
]

== Fixed label width: no hidden overflow

#tasks(columns: "auto-fit", max-columns: 4, label-width: 1.8cm)[
  + Medium length task with detail
  + Evaluate slope at zero
  + Short
  + Short
]

== Partial span in fill mode: span can use two columns

#tasks(columns: "auto-fit", max-columns: 4)[
  +(2) #test-box(6cm)
  + A
  + B
  + C
]

== Partial span in uniform mode: same span forces ordinary columns

#tasks(columns: "auto-fit", max-columns: 4, auto-fit-mode: "uniform")[
  +(2) #test-box(6cm)
  + A
  + B
  + C
]

== Full span with long text: fill mode preserves dense later rows

#tasks(columns: "auto-fit", max-columns: 4)[
  +() This instruction spans the full task row, so the later short answers can still use the densest fitting layout.
  + A
  + B
  + C
  + D
]

== Full span with long text: uniform mode uses one ordinary column

#tasks(columns: "auto-fit", max-columns: 4, auto-fit-mode: "uniform")[
  +() This instruction spans the full task row, so the later short answers can still use the densest fitting layout.
  + A
  + B
  + C
  + D
]

== Tall figure: height alone should not reduce columns

#tasks(columns: "auto-fit", max-columns: 3)[
  + #test-figure(2cm, height: 2.2cm, caption: [tall box])
  + Text
  + $a^2+b^2=c^2$
]

== Wide figure: intrinsic width reduces columns

#tasks(columns: "auto-fit", max-columns: 4)[
  + #test-figure(3.8cm)
  + Text
  + $a^2+b^2=c^2$
  + D
]

== Figure captions: caption wrapping reduces columns

#tasks(columns: "auto-fit", max-columns: 3)[
  + #test-figure(1.8cm, caption: [a longer caption that would wrap in narrow columns])
  + Text
  + Short
]

== Mixed content: text, math, block, figure

#tasks(columns: "auto-fit", max-columns: 4)[
  + Solve $2x-3=0$ exactly
  + #test-box(2.6cm)
  + #test-figure(1.8cm, caption: [small graph])
  + Explain the sign of $f'(x)$ on the interval
]

== Explicit multiline: accepted when it does not create new wraps

#tasks(columns: "auto-fit", max-columns: 3)[
  + First line\
    second line
  + A
  + B
]

== Explicit multiline: longer second line backs off

#tasks(columns: "auto-fit", max-columns: 3)[
  + First line\
    an intentionally longer second line
  + A
  + B
]
