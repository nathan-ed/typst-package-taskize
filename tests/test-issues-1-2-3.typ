// Reported behaviours, one page each.
//
// p1 (#2) a bare + inside an item is text, not a new item: "What is 2 + 2?"
//         stays one item and is not repeated
// p2 (#2) an array spells out a list written on one line
// p3 (#3) label: "enum" follows the document's enum numbering
// p4 (#3) a nested tasks call takes the next level of the pattern
// p5 (#1) answer-lines draws dotted lines to write on
#import "/lib.typ": tasks, answer-dots

#set page(width: 12cm, height: 4cm, margin: 0.6cm)
#set enum(numbering: "1) a)")

#tasks(columns: 1, label: "a)")[
  + What is 2 + 2?
]
#pagebreak()
#tasks(columns: 3, label: "a)", ([One], [Two], [Three]))
#pagebreak()
#tasks(columns: 2, label: "enum")[
  + First
  + Second
]
#pagebreak()
#tasks(columns: 1, label: "enum")[
  + Outer question:

    #tasks(columns: 2, label: "enum")[
      + inner one
      + inner two
    ]
]
#pagebreak()
#tasks(columns: 2, label: "a)", answer-lines: 2)[
  + Question one
  + Question two
]
