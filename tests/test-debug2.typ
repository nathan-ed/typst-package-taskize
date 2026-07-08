#import "../lib.typ": tasks

#set page(width: 12cm, height: auto, margin: 1cm)

Raw body test:

#let body = [
+ First
    + Second
  + Third
]

Body type: #type(body)
Body func: #body.func()

#if body.func() == enum [
  Children: #body.children.len()

  First child type: #body.children.at(0).func()
  First child body has children: #body.children.at(0).body.has("children")
]

Now render:
#tasks[
+ First
    + Second
  + Third
]
