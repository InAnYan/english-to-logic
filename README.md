# English to logic translator

```plain
-- Testing: "If you get 100% on the final, then you will get an A.".
-- Result: p → q.
     p = "you get 100 on the final";
     q = "you will get an a";

-- Testing: "Hiking is not safe on the trail whenever grizzly bears have been seen in the area and berries are ripe along the trail.".
-- Result: p ∧ q → ¬r.
     p = "grizzly bears have been seen in the area";
     q = "berries are ripe along the trail";
     r = "hiking is safe on the trail";
```

AI system that translates English sentences to simple boolean logic. 

## Features

- The program supports:
  - Logic variables.
  - Conjunction.
  - Disjunction.
  - Implication.
  - Biimplication.
- Simple and fast rule-based parsing.
- Extensively tested and evaluated (for flaws, refer to [notes file](notes.txt)).

It does not support:
- Predicates or open statements.
- Quantifiers.

## How to Run this Project

[`english-to-logic.rkt`](english-to-logic.rkt) is a library intended to be integrated into other projects.

You can run [`english-to-logic-test.rkt`](english-to-logic-test.rkt):

```sh
racket english-to-logic-test.rkt
```

This command will present you different sentences and the results of the translation.

## How this Project is Implemented.

**Input**: an English sentence as a string.
**Output**: a pair of a logic expression (using prefix notation) and an association list of a logic variable and its string.

1. Downcase the input
2. Remove punctuation.
3. Split string into words (or tokens) by whitespace.
4. (Parsing) Recursively extract logic operators.
5. Assign variable names to `var`s and create an output.

### Parsing algorithm

- The programms assumes that logical expression is written in infix notation in natural language and the precedence of logical operators is the same as in natural language.
- The parsing is organized as a set of rules (written in `match` form).
- The negation written in natural language is assumed to contain the word `not`. So it will be extracted.
- Every logical variable is converted into `'(var "...")`. It will be replaced by a symbol later.

For the details view the source code.
