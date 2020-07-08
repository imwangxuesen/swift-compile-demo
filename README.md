# swift-compile-demo
Swift编写,将Scheme语言转换成对应的C语言编译过程模拟demo

eg:

```
Input Code: (multiply (add 1.4,3))

Tokens: [swift_compile.JToken(type: "paren", value: "("), swift_compile.JToken(type: "char", value: "multiply"), swift_compile.JToken(type: "paren", value: "("), swift_compile.JToken(type: "char", value: "add"), swift_compile.JToken(type: "float", value: "1.4"), swift_compile.JToken(type: "paren", value: ","), swift_compile.JToken(type: "int", value: "3"), swift_compile.JToken(type: "paren", value: ")"), swift_compile.JToken(type: "paren", value: ")")] 

 CallExpression expression is CallExpression(multiply)
     CallExpression expression is CallExpression(add)
       NumberLiteral number type is NumberLiteral number is 1.4.
       None 
       NumberLiteral number type is NumberLiteral number is 3.
       
After transform AST: 
 
[
  {
    "params" : [

    ],
    "arguments" : [

    ],
    "callee" : {
      "type" : "None",
      "name" : ""
    },
    "intValue" : 0,
    "expressions" : [
      {
        "params" : [

        ],
        "arguments" : [
          {
            "params" : [

            ],
            "arguments" : [
              {
                "params" : [

                ],
                "arguments" : [

                ],
                "callee" : {
                  "type" : "None",
                  "name" : ""
                },
                "intValue" : 0,
                "expressions" : [

                ],
                "numberType" : "float",
                "floatValue" : 1.3999999761581421,
                "type" : "NumberLiteral",
                "name" : ""
              },
              {
                "params" : [

                ],
                "arguments" : [

                ],
                "callee" : {
                  "type" : "None",
                  "name" : ""
                },
                "intValue" : 3,
                "expressions" : [

                ],
                "numberType" : "int",
                "floatValue" : 0,
                "type" : "NumberLiteral",
                "name" : ""
              }
            ],
            "callee" : {
              "type" : "Identifier",
              "name" : "add"
            },
            "intValue" : 0,
            "expressions" : [

            ],
            "numberType" : "int",
            "floatValue" : 0,
            "type" : "CallExpression",
            "name" : ""
          }
        ],
        "callee" : {
          "type" : "Identifier",
          "name" : "multiply"
        },
        "intValue" : 0,
        "expressions" : [

        ],
        "numberType" : "int",
        "floatValue" : 0,
        "type" : "CallExpression",
        "name" : ""
      }
    ],
    "numberType" : "int",
    "floatValue" : 0,
    "type" : "ExpressionStatement",
    "name" : ""
  }
]


The code generated:
multiply(add(1.4,3))

```
