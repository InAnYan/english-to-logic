#lang racket

(require racket/trace)

(provide translate-english-logic
         english->logic
         logic->string)

(define (translate-english-logic str)
  ((compose logic->string
           english->logic) str))

(define (english->logic str)
  ((compose extract-vars
           parse
           lexical-analysis) str))


(define (lexical-analysis str)
  ((compose delete-stop-words
           string-split
           string-downcase
           delete-punctuation) str))

(define (delete-punctuation str)
  (list->string
   (filter (complement char-punctuation?)
           (string->list str))))

(define stop-words '("either" "also"))

(define (delete-stop-words lst)
  (remove* stop-words lst))


(define (parse lst)
  (match lst
    [(list q ... "if" "and" "only" "if" p ...)
     (list '<-> (parse p) (parse q))]
    [(or (list "if" p ... "then" q ...)
         (list p ... "is" "sufficient" "for" q ...)
         (list q ... "whenever" p ...)
         (list p ... "only" "if" q ...)
         (list q ... "if" p ...))
     (list '-> (parse p) (parse q))]
    [(list p ... "or" q ...)
     (list 'or (parse p) (parse q))]
    [(or (list p ... "and" q ...)
         (list p ... "but" q ...))
     (list 'and (parse p) (parse q))]
    [(list part1 ... "not" part2 ...)
     (list 'not (parse (append part1 part2)))]
    [_
     (list 'var (string-join lst))]))


(define (extract-vars expr)
  (let [(vars (create-vars expr))]
    (list (replace-vars expr vars) vars)))

(define (create-vars expr)
  (assign-vars (remove-duplicates (filter string? (flatten expr)))))

(define logical-vars '(p q r s t))

(define (assign-vars strs)
  ;; The bad code.
  (zip logical-vars strs))

(define (replace-vars expr vars)
  (if (null? vars)
      expr
      (replace-vars (replace-var expr (first vars))
                    (rest vars))))

(define (replace-var expr var)
  (let [(var-sym (first var))
        (var-name (second var))]
    (if (and (logic-var? expr)
             (string=? (second expr) var-name))
        var-sym
        (if (list? expr)
            (map (lambda (part)
                   (replace-var part var))
                 expr)
            expr))))

(define (logic-var? expr)
  (and (list? expr)
       (not (null? expr))
       (eq? (first expr) 'var)))


(define (logic->string expr+var)
  (convert (first expr+var)))

(define (convert expr)
  (if (list? expr)
      (case (first expr)
        [(not) (unary-expr->string expr)]
        [(and) (binary-expr->string expr)]
        [(or) (binary-expr->string expr)]
        [(->) (binary-expr->string expr)]
        [(<->) (binary-expr->string expr)])
      (symbol->string expr)))

(define (binary-expr->string expr)
  (let ([op (first expr)])
    (string-append (expr-hand->string (second expr) op)
                   " "
                   (logic-op->string op)
                   " "
                   (expr-hand->string (third expr) op))))

(define (expr-hand->string hand op)
  (let ([parens (and (not (symbol? hand))
                     (< (get-precedence (first hand))
                        (get-precedence op)))])
    (string-append (if parens "(" "") (convert hand) (if parens ")" ""))))

(define (unary-expr->string expr)
  (let ([op (first expr)])
    (string-append (logic-op->string op)
                   (expr-hand->string (second expr) op))))

(define (binary-expr->string2 expr)
  (let ([left (second expr)]
        [op (first expr)]
        [right (third expr)])
    (string-append "(" (convert left) ")"
                   (logic-op->string op)
                   "(" (convert right) ")")))

(define logic-ops
  '([<-> "↔"]
    [-> "→"]
    [or "∨"]
    [and "∧"]
    [not "¬"]))

(define (logic-op->string op)
  (second (assoc op logic-ops)))

(define (get-precedence op)
  (index-where logic-ops
               (lambda (rule)
                 (eq? (first rule) op))))


(define (complement fn)
  (lambda (arg)
    (not (fn arg))))

(define (zip lst1 lst2)
  (cond
    [(null? lst1) null]
    [(null? lst2) null]
    [else (cons (list (first lst1) (first lst2))
                (zip (rest lst1) (rest lst2)))]))

