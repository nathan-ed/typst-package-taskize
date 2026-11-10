// Auto-fit lays items out as little as it can. These checks pin down the
// shortcuts it takes, each of which must give the answer a full measurement
// would give:
//   - a block or box of fixed size is sized from its fields, never laid out;
//   - a single item, or a cap of one column, measures nothing;
//   - text and inline math are judged on their natural width.
// The last section proves the "never laid out" part: the item would fail the
// compilation if it were.
#import "../lib.typ": *
#import "../lib.typ": _auto-fit, _fixed-size

#set page(width: 16cm, height: auto, margin: 1cm)
#set text(size: 10pt)

#let fit(items, max, mode, width) = _auto-fit(
  items.map(item => if type(item) == array { item } else { (item, 1) }),
  max, "a)", 1em, auto, "regular", 0.4em, 0pt, 1, mode, 0.5pt, width,
)

#context {
  // -- fixed-size containers ------------------------------------------------
  assert.eq(_fixed-size(block(width: 3cm, height: 2cm)[x]), (width: 3cm.to-absolute(), height: 2cm.to-absolute()))
  assert.eq(_fixed-size([ #box(width: 2em, height: 1em) ]), (width: 20pt, height: 10pt))
  assert.eq(_fixed-size(block(width: 50%, height: 2cm)), none)
  assert.eq(_fixed-size(block(width: 3cm)[x]), none)
  assert.eq(_fixed-size([texte #box(width: 2em, height: 1em)]), none)

  // Same decisions as a shape of the same size that does get measured
  for width in (120pt, 200pt, 300pt, 400pt) {
    for w in (40pt, 70pt, 110pt, 250pt) {
      for mode in ("uniform", "fill") {
        let fixed = fit(range(5).map(_ => block(width: w, height: 30pt)), 4, mode, width)
        let measured = fit(range(5).map(_ => rect(width: w, height: 30pt)), 4, mode, width)
        assert.eq(fixed, measured, message: "fixed block vs rect, " + mode + repr((width, w)))
      }
    }
  }

  // -- nothing to decide ----------------------------------------------------
  assert.eq(fit(([seul],), 4, "uniform", 400pt).cols, 1)
  assert.eq(fit(([a], [b], [c]), 1, "fill", 400pt).cols, 1)

  // -- inline items ---------------------------------------------------------
  assert.eq(fit(($a$, $b$, $c$, $d$), 4, "uniform", 400pt).cols, 4)
  assert.eq(fit(($a$, lorem(30), $c$), 4, "uniform", 400pt).cols, 1)
  let spans = fit(($a$, [une phrase nettement plus longue que les autres items], $c$, $d$), 4, "fill", 300pt)
  assert.eq(spans.cols, 4)
  assert(spans.spans.at(1) > 1 and spans.spans.at(0) == 1)

  // -- never laid out -------------------------------------------------------
  // `bomb` fails the compilation as soon as it is laid out.
  let bomb = context panic("laid out")
  // fixed size: sized from the fields
  assert.eq(fit(range(4).map(_ => block(width: 60pt, height: 30pt, bomb)), 4, "uniform", 400pt).cols, 4)
  // a single column is all there can be
  assert.eq(fit((bomb,), 4, "uniform", 400pt).cols, 1)
  // a cheap item already rules out more than one column
  assert.eq(fit((lorem(40), bomb), 4, "uniform", 400pt).cols, 1)
}

Auto-fit: les raccourcis de mesure donnent les bons résultats.
