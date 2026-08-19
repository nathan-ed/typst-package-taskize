// An item whose first line is inline but which continues with a block (a
// figure, an image, a nested tasks call). The label must sit on the baseline
// of that first line, exactly as it does when the block is not there.
//
// The block is a scaled figure inside layout(), the shape MathALEA sheets use,
// and the grid has two columns: that is the case where the label used to be
// pushed to the top of the cell instead.
//
// Page 1: items with the trailing figure. Page 2: the same items without it,
// the reference. The check compares the label position between the two.
#import "/lib.typ": tasks

#set page(width: 18cm, height: 6cm, margin: 1cm)
#set text(size: 11pt)
#set par(leading: 0.6em)
#show math.frac: it => math.display(it)

#let fig = rect(width: 4cm, height: 5mm, fill: orange.lighten(60%))
#let figblock(body) = layout(size => {
  let natural = measure(body).width
  let f = calc.min(1.0, size.width / natural)
  box(scale(f * 100%, origin: top + left, reflow: true, body))
})

#tasks(columns: 2, label: (..n) => strong(numbering("1.", ..n)), start: 1)[
  + $2 dot.op frac(4, 5)$\
    #figblock(fig)
  + $4 dot.op frac(2, 3)$\
    #figblock(fig)
]
#pagebreak()
#tasks(columns: 2, label: (..n) => strong(numbering("1.", ..n)), start: 1)[
  + $2 dot.op frac(4, 5)$
  + $4 dot.op frac(2, 3)$
]
