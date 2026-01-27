#import "lib.typ": tasks

#set page(width: 12cm, height: auto, margin: 1cm)

= Debug Test

Body structure test:

#let test-body = [
  + First
  + Second
  + Third
]

Type: #type(test-body)

Func: #test-body.func()

Has children: #test-body.has("children")

#if test-body.func() == enum [
  It's an enum!
  Children count: #test-body.children.len()
]

Now with tasks:

#tasks[
  + First
  + Second
  + Third
]
