#set page(width: 12cm, height: auto, margin: 1cm)

Raw test of what Typst parses:

#let content = [
+ First
    + Second
]

Type: #type(content)
Func: #content.func()

#if content.has("children") [
  Has children: #content.children.len()

  #for (i, child) in content.children.enumerate() [
    Child #i type: #child.func()
    #if child.func() == enum.item [
      Item body: #repr(child.body)

      Body has children: #child.body.has("children")
      #if child.body.has("children") [
        Body children count: #child.body.children.len()
      ]
    ]
  ]
]
