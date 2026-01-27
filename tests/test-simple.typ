#import "lib.typ": tasks

#set page(width: 12cm, height: auto, margin: 1cm)

=Test: Mixed indentation

Source with mixed indentation:
```
+ First
    + Second
  + Third
```

#tasks[
+ First
    + Second
  + Third
]

Expected: a) First, b) Second, c) Third in same grid
