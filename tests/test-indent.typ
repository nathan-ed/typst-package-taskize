#import "../lib.typ": tasks, tasks-setup

#set page(width: 15cm, height: auto, margin: 1cm)

= Indentation Independence Test

== Test 1: Normal indentation (baseline)

#tasks[
  + First item
  + Second item with more text
  + Third item
  + Fourth item
]

== Test 2: Extra indentation (should look identical to Test 1)

#tasks[
      + First item
      + Second item with more text
      + Third item
      + Fourth item
]

== Test 3: Mixed indentation (should look identical to Test 1)

#tasks[
+ First item
    + Second item with more text
  + Third item
      + Fourth item
]

== Test 4: No indentation (should look identical to Test 1)

#tasks[
+ First item
+ Second item with more text
+ Third item
+ Fourth item
]

== Test 5: Multiline items

#tasks[
  + First item that spans
    multiple lines with
    more content
  + Second item also
    with multiple lines
  + Third short item
  + Fourth item with
    even more lines
    that continue
    for a while
]

== Test 5b: Multiline without indentation (continuation lines)

#tasks[
  + First line
Second line continues
  + Another item
]

== Test 6: Math content

#tasks[
  + $x^2 + 2x + 1$
  + $(a + b)^2 = a^2 + 2a b + b^2$
  + $integral_0^1 x^2 dif x$
  + $lim_(x -> infinity) 1/x = 0$
]

== Test 7: Column spanning with various indentation

#tasks(columns: 3)[
  + Short
  + Short
  + Short
  +(2) This spans 2 columns
  + Another
  +() This spans all columns
  + Back to normal
]

== Test 8: Nested tasks with manual indentation

#tasks[
  + Parent item A
  + Parent item B
    #tasks(indent: 2em, label: "1)")[
      + Sub item 1
      + Sub item 2
      + Sub item 3
    ]
  + Parent item C
  + Parent item D
]

== Test 9: Different label formats

#tasks(label: "1)")[
  + Number one
  + Number two
  + Number three
]

#tasks(label: "A)")[
  + Letter A
  + Letter B
  + Letter C
]

== Test 10: Three columns

#tasks(columns: 3)[
  + A
  + B
  + C
  + D
  + E
  + F
  + G
  + H
  + I
]
