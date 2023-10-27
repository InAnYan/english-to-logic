#lang racket


(require rackunit
         "english-logic.rkt")


(define (english->logic-test str should-expr . should-vars)
  (printf "-- Testing: ~v.~%" str)
  (let* [(res (english->logic str))
         (expr (first res))
         (vars (second res))]
    (printf "-- Result: ~a.~%" expr)
    (for-each (lambda (entry)
                (printf "     ~a = ~v;~%" (first entry) (second entry)))
              vars)
    (check-equal? (sublis expr vars) (sublis should-expr should-vars))
    (printf "~%")))


; Tests:
; 1. Vars can be anything.
; 2. Meaning of the vars is necessarry.
; 3. Rules of logic are not supported (like associativity of biimplication).


(define english->logic-tests
  '(["It is below freezing."
     p
     (p "it is below freezing")]

    ["It is not below freezing."
     (not p)
     (p "it is below freezing")]

    ["It is below freezing and it is snowing."
     (and p q)
     (p "it is below freezing")
     (q "it is snowing")]

    ["The kernel is functioning or the system is in interrupt mode."
     (or p q)
     (p "the kernel is functioning")
     (q "the system is in interrupt mode")]

    ["If you get 100% on the final, then you will get an A."
     (-> p q)
     (p "you get 100 on the final")
     (q "you will get an a")]

    ["The system is in multiuser state if and only if the system
      is operating normally."
     (<-> p q)
     (p "the system is operating normally")
     (q "the system is in multiuser state")]
    ; Biimplication associativity and tests.

    ["Hiking is not safe on the trail whenever grizzly bears
      have been seen in the area and berries are ripe along the trail."
     (-> (and p q) (not r))
     (p "grizzly bears have been seen in the area")
     (q "berries are ripe along the trail")
     (r "hiking is safe on the trail")]

    ["It is not below freezing and it is not snowing."
     (and (not p) (not q))
     (p "it is below freezing")
     (q "it is snowing")]

    ["Getting an A on the final and doing every exercise in this book
      is sufficient for getting an A in this class."
     (-> (and p q) r)
     (p "getting an a on the final")
     (q "doing every exercise in this book")
     (r "getting an a in this class")]

    ["You will get an A in this class if and only if you either do every
      exercise in this book or you get an A on the final."
     (<-> (or p q) r)
     (p "you do every exercise in this book")
     (q "you get an a on the final")
     (r "you will get an a in this class")]

    ["Hiking is not safe on the trail whenever grizzly bears have been
      seen in the area and berries are ripe along the trail."
     (-> (and p q) (not r))
     (p "grizzly bears have been seen in the area")
     (q "berries are ripe along the trail")
     (r "hiking is safe on the trail")]

    ["You can access the Internet from campus only if you are a computer
      science major or you are not a freshman."
     (-> p (or q (not r)))
     (p "you can access the internet from campus")
     (q "you are a computer science major")
     (r "you are a freshman")]

    ["You can see the movie only if you are over 18 years old or you
      have the permission of a parent."
     (-> p (or q r))
     (p "you can see the movie")
     (q "you are over 18 years old")
     (r "you have the permission of a parent")]

    ["The router can send packets to the edge system if the latest
      software release is installed."
     (-> p q)
     (p "the latest software release is installed")
     (q "the router can send packets to the edge system")]))


(define (sublis x lst)
  (cond
    [(assoc x lst)
     (assoc x lst)]
    [(list? x)
     (map (lambda (y)
            (sublis y lst))
          x)]
    [else x]))


(for-each (lambda (test)
            (apply english->logic-test test))
          english->logic-tests)

