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
- Equality: A == B will evaluate both expression A and B and return their equality (as a boolean value).

## CLI
Cli commands can be used to interact with terminal IO.
A command is considered a function, and must therefore be called.
Here's an example of calling the exit command: exit().
The following commands are supported:
- exit: will terminate the programm after printing a wholesome good-bye message.
- clear: will clear the terminal window.
- help: will print some helpful info.

## Get started
- Ensure that you have the haskell ghc compiler installed.
- Download the prepacked binary.
- run CMD to execute.
