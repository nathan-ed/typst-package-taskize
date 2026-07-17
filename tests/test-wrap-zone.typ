// Test: wrap-zone flows task rows around a reserved top-right rectangle.
#import "../lib.typ": *

#set page(width: 12cm, height: auto, margin: 8mm)

#let zone-box(w, h) = place(top + right, box(
  width: w, height: h,
  stroke: 0.5pt + red,
)[#align(center + horizon)[#text(size: 7pt, fill: red)[zone]]])

= Rows flow around the zone, then return to full width
#v(0.5em)
#taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
#zone-box(2.4cm, 2.4cm)
#tasks(columns: 2)[
  + $2 + 3$
  + $5 - 1$
  + $4 times 2$
  + $9 div 3$
  + $7 + 6$
  + $12 - 4$
]

= State is consumed: a later call is unaffected by the same zone
#taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
#zone-box(2.4cm, 2.4cm)
#tasks(columns: 2)[
  + a
  + b
]
#tasks(columns: 2)[
  + c
  + d
  + e
  + f
]

= wrap-zone: none ignores a pending zone on a specific call
#taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
#zone-box(2.4cm, 2.4cm)
#tasks(columns: 2, wrap-zone: none)[
  + g
  + h
  + i
  + j
]

= Explicit wrap-zone dictionary overrides the shared state directly
#tasks(columns: 2, wrap-zone: (width: 3cm, height: 1.8cm))[
  + k
  + l
  + m
  + n
]

= Vertical flow ignores a pending zone (would reorder numbering)
#taskize-wrap-zone.update((width: 2.4cm, height: 2.4cm))
#zone-box(2.4cm, 2.4cm)
#tasks(columns: 2, flow: "vertical")[
  + o
  + p
  + q
  + r
]
