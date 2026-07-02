// Test: label baseline vs content with tall inline math (fractions, vectors)
#import "../lib.typ": *

#set page(width: 14cm, height: auto, margin: 8mm)
#let dfrac(num, den) = math.display(math.frac(num, den))

= Fractions (the 3m2-exo-105 case)

#tasks(columns: 2)[
  + $f(x) = -dfrac(2, x^2 + 3)$, $x_0 = -1$
  + $f(x) = dfrac(x^2 + 2 x + 2, 3 x - 1)$, $x_0 = 0$
]

= Plain text (reference: should be unchanged)

#tasks(columns: 2)[
  + $f(x) = 2x + 3$
  + Simple text item
]

= Vectors

#tasks(columns: 2)[
  + $arrow(v) = vec(1, 2, 3)$
  + $arrow(w) = vec(-1, 0)$
]

= Multiline / wrapping content

#tasks(columns: 2)[
  + A long item with wrapping text that should continue on a second line below, and the label must stay on the first line: $dfrac(1, 2)$
  + $x = 5$
]

= Block equation in single column (correction style)

#tasks(columns: 1)[
  + $
      t : y &= f(-1) + f'(-1)(x + 1) \
      &= -dfrac(2, (-1)^2 + 3) + dfrac(4 dot (-1), ((-1)^2 + 3)^2)(x + 1)
    $
  + $x = 3$
]
