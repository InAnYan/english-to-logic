# English to logic translator
A simple translator written in Racket.

The program supports:
- Logic variables.
- Conjunction.
- Disjunction.
- Implication.
- Biimplication.

It does not support:
- Predicates or open statements.
- Quantifiers.

The program has some critical flaws that are discussed in file `notes.txt`.

## Algorithm
**Input**: an English sentence as a string.
**Output**: a pair of a logic expression (using prefix notation) and an association list of a logic variable and its string.
1. Downcase the input
2. Remove punctuation.
3. Split string into words (or tokens) by whitespace.
4. (Parsing) Recursively extract logic operators.
5. Assign variable names to `var`s and create an output.

## Parsing algorithm
- The programms assumes that logical expression is written in infix notation in natural language and the precedence of logical operators is the same as in natural language.
- The parsing is organized as a set of rules (written in `match` form).
- The negation written in natural language is assumed to contain the word `not`. So it will be extracted.
- Every logical variable is converted into `'(var "...")`. It will be replaced by a symbol later.
For the details view the source code.
