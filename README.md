# Haskalc

Evaluate arithmetic expressions using null- and left-denotation. 
For the sake of simplicity, all numeric values are returned as a Double.

## Features
- Prefix expressions: -A will consider - as a prefix, instead of an infix operator.
- Infix expressions: A+B, A-B, A*B, A/B will resp. add, subtract, multiply, divide A resp. to, from, with B.
- Operator precedence: A+B\*C is equivalent to A+(B\*C) because prec(*) is greater than prec(+).
- Parenthesis: (A+B)*C will partially disregard the normal operator precedence,
  since parenthesis (also considered operator) have the highest operator precedence.
- Functions: Haskalc supports predefined functions. SQRT(A) yields the square root of A.

## Get started
- Ensure that you have the haskell ghc compiler installed.
- Download the prepacked binary.
- run CMD to execute.
