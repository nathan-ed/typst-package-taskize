// row-gutter: "auto" — rows sized to true ink, gutter honored.
#import "../lib.typ": tasks, tasks-setup

#set page(width: 12cm, height: auto, margin: 5mm)
#set text(size: 11pt)
#let dfrac(a, b) = math.display(math.frac(a, b))

= Fixed row-gutter (default 0.6em): dfrac ink bleeds into gutter
#tasks(columns: 2)[
  + $dfrac(1, 2)$
  + $dfrac(3, 4)$
  + $dfrac(5, 6)$
  + $dfrac(7, 8)$
]

= row-gutter: "auto": rows sized to true ink, same 0.6em gutter honored
#tasks(columns: 2, row-gutter: "auto")[
  + $dfrac(1, 2)$
  + $dfrac(3, 4)$
  + $dfrac(5, 6)$
  + $dfrac(7, 8)$
]

= row-gutter: "auto" with plain text items: spacing unchanged vs default
#tasks(columns: 2, row-gutter: "auto")[
  + un texte
  + un autre
  + encore un
  + dernier
]

= Set as document default via tasks-setup
#tasks-setup(row-gutter: "adaptive")
#tasks(columns: 2)[
  + $dfrac(1, 2) + dfrac(3, 4)$
  + $x + y$
  + $M = mat(1, 2; 3, 4)$
  + texte
]

= Explicit numeric row-gutter still overrides the adaptive default
#tasks(columns: 2, row-gutter: 2em)[
  + $dfrac(1, 2)$
  + $dfrac(3, 4)$
]
