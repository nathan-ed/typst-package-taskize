// An item whose first line is inline but which continues with a block (a
// nested tasks call, a figure, a table). The label must sit on the baseline of
// that first line, exactly as it does when the block is not there.
//
// This is the shape of a multiple-choice question: one line of text, then the
// block of answers. With a display fraction on that first line the line's
// ascent grows, the text baseline moves down, and the label used to stay at
// the top of the row.
//
// Page 1: the item with its block. Page 2: the same item without it, the
// reference. The check compares the label position between the two.
#import "/lib.typ": tasks

#set page(width: 13cm, height: 7cm, margin: 1cm)
#set text(size: 11pt)
#show math.frac: it => math.display(it)

#tasks(columns: 1, label: "1.", row-gutter: 1.2em)[
  + The solution of $4/x = -3$ is:

    #tasks(columns: 2, label: "A)", above: 0.4em, below: 0.4em)[
      + $-4/3$
      + $4/3$
    ]
]
#pagebreak()
#tasks(columns: 1, label: "1.", row-gutter: 1.2em)[
  + The solution of $4/x = -3$ is:
]
