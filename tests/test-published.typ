#import "@preview/taskize:0.2.5": tasks

#set page(width: 12cm, height: auto, margin: 1cm)

= Using Published Version

== Test 1: Normal indentation

#tasks[
  + First item
  + Second item with more text
  + Third item
  + Fourth item
]

== Test 2: Mixed indentation

#tasks[
+ First
    + Second
  + Third
]
