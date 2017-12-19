;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")

(provide tie
         defeated
         defeated?
         outranks
         outranked-by
         power-ranking)

(check-location "08" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Comparator:

;; A Comparator is represented as one of the following:
;; -- < (indicating less than)
;; -- > (indicating greater than)
;; -- = (indicating equal to)

(define EQUAL-TO =)
(define LESS-THAN <)
(define GREATER-THAN >)

;; OBSERVER TEMPLATE:
;; comparator-fn : Comparator -> ??
#; (define (comparator-fn comp)
     (cond ((equal? comp <) ...)
           ((equal? comp >) ...)
           ((equal? comp =) ...)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power-ranking : OutcomeList -> CompetitorList
;; GIVEN: a list of outcomes
;; RETURNS: a list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions, with competitor A
;;     coming before competitor B in the list if and only if
;;     the power-ranking of A is higher than the power ranking
;;     of B.
;; EXAMPLE:
;;     (power-ranking
;;      (list (defeated "A" "D")
;;            (defeated "A" "E")
;;            (defeated "C" "B")
;;            (defeated "C" "F")
;;            (tie "D" "B")
;;            (defeated "F" "E")))
;;  => (list "C"   ; outranked by 0, outranks 4
;;           "A"   ; outranked by 0, outranks 3
;;           "F"   ; outranked by 1
;;           "E"   ; outranked by 3
;;           "B"   ; outranked by 4, outranks 2, 50%
;;           "D")  ; outranked by 4, outranks 2, 50%
;; STRATEGY: use simpler function
(define (power-ranking olist)
  (get-power-ranking (get-all-competitors olist) olist))

;; get-power-ranking : CompetitorList OutcomeList -> CompetitorList
;; GIVEN: a list of competitor clist and a list of outcomes olist.
;; RETURNS: a list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions, with competitor A
;;     coming before competitor B in the list if and only if
;;     the power-ranking of A is higher than the power ranking
;;     of B.
;; EXAMPLE:
;;     (get-power-ranking
;;      (list (defeated "A" "D")
;;            (defeated "A" "E")
;;            (defeated "C" "B")
;;            (defeated "C" "F")
;;            (tie "D" "B")
;;            (defeated "F" "E")))
;;  => (list "C" "A" "F" "E" "B" "D")
;; STRATEGY: use simpler function
(define (get-power-ranking clist olist)
  (cond
    [(empty? clist) clist]
    [else
     (insert (first clist) (get-power-ranking (rest clist) olist) olist)]))

;; insert : Competitor CompetitorList -> CompetitorList
;; GIVEN: a competitor c, a list of competitors clist and a list of outcomes
;;        olist
;; RETURNS: a list of competitors with competitor c inserted at its position
;;          according to the power ranking
;; EXAMPLE: (insert "D" (list "B" "A" "C" "E" "F")
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E")))
;;          => (list "B" "A" "C" "E" "F" "D")
;; STRATEGY: divide into cases
(define (insert c clist olist)
  (cond
    [(empty? clist) (cons c clist)] 
    [(check-outranked-by? c LESS-THAN (first clist) olist)
     (cons c clist)]
    [(and
      (check-outranked-by? c EQUAL-TO (first clist) olist)
      (check-outranks? c GREATER-THAN (first clist) olist))
     (cons c clist)]
    [(and
      (check-outranked-by? c EQUAL-TO (first clist) olist)
      (check-outranks? c EQUAL-TO (first clist) olist)
      (check-non-losing-percentage? c LESS-THAN (first clist) olist))
     (cons c clist)]
    [(and
      (check-outranked-by? c EQUAL-TO (first clist) olist)
      (check-outranks? c EQUAL-TO (first clist) olist)
      (check-non-losing-percentage? c EQUAL-TO (first clist) olist)
      (string<? c (first clist)))
     (cons c clist)]
    [else 
     (cons (first clist) (insert c (rest clist) olist))]))

;; check-outranked-by? : Competitor Comparator Competitor OutcomeList
;; GIVEN: Competitors c and x, a comparator comparator and a list of
;;        outcomes olist
;; RETURNS: true iff the number of competitors outranked-by c and x satisfy
;;          the comparator operation
;; EXAMPLE: (check-outranked-by? "A" < "F"
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E"))) => #true
;; STRATEGY: transcribe formula
(define (check-outranked-by? c comparator x olist)
  (comparator (length (outranked-by c olist))
              (length (outranked-by x olist))))

;; check-outranks? : Competitor Comparator Competitor OutcomeList
;; GIVEN: Competitors c and x, a comparator comparator and a list of
;;        outcomes olist
;; RETURNS: true iff the number of competitors given by outranks c and x satisfy
;;          the comparator operation
;; EXAMPLE: (check-outranks? "C" > "A"
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E"))) => #true
;; STRATEGY: transcribe formula
(define (check-outranks? c comparator x olist)
  (comparator (length (outranks c olist))
              (length (outranks x olist))))

;; check-non-losing-percentage? : Competitor Comparator Competitor OutcomeList
;; GIVEN: Competitors c and x, a comparator comparator and a list of
;;        outcomes olist
;; RETURNS: true iff the non-losing percentage of c and x satisfy
;;          the comparator operation
;; EXAMPLE: (check-non-losing-percentage? "B" = "D"
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E"))) => #true
;; STRATEGY: transcribe formula
(define (check-non-losing-percentage? c comparator x olist)
  (comparator (/ (defeat-tie-count c olist)
                 (mention-count c olist))
              (/ (defeat-tie-count x olist)
                 (mention-count x olist))))

;; defeat-tie-count : Competitor Outcomelist -> NonNegInt
;; GIVEN: a competitor c and a list of outcomes olist
;; RETURNS: the number of outcomes in olist where c wins
;; EXAMPLE: (defeat-tie-count "A"
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E"))) => 2
;; STRATEGY: use HOF filter
(define (defeat-tie-count c olist)
  (length (filter (; Competitor -> Boolean
                   ; GIVEN: a competitor x
                   ; RETURNS: true iff x is defeated by c in outcomelist olist
                   lambda (x) (defeated? c x olist))
                  (get-all-competitors olist))))

;; mention-count : Competitor OutcomeList -> NonNegInteger
;; GIVEN: a competitor c and a list of outcomes olist
;; RETURNS: the number of outcomes in olist where c is mentioned
;; EXAMPLE: (mention-count "B"
;;                      (list (defeated "A" "D")
;;                            (defeated "A" "E")
;;                            (defeated "C" "B")
;;                            (defeated "C" "F")
;;                            (tie "D" "B")
;;                            (defeated "F" "E"))) => 2
;; STRATEGY: use HOF filter
(define (mention-count c olist)
  (length (filter (; Competitor -> Boolean
                   ; GIVEN: a competitor x
                   ; RETURNS: true iff x is mentioned in outcomelist olist
                   lambda (x) (mentioned? c x)) olist)))

;; mentioned? : Competitor Outcome -> Boolean
;; GIVEN: a competitor c and an outcome o
;; RETURNS: true iff the competitor c is mentioned in the outcome o
;; EXAMPLE: (mentioned? "A" (defeated "A" "B")) => #true
;; STRATEGY: use observer template for Outcome on o
(define (mentioned? c o)
  (cond
    [(defeat? o) (or
                  (string=? (defeat-c1 o) c)
                  (string=? (defeat-c2 o) c))]
    [(tied? o) (or
                (string=? (tied-c1 o) c)
                (string=? (tied-c2 o) c))]))

;; TESTS:
(begin-for-test
  (check-equal? (power-ranking
                 (list (defeated "A" "D")
                       (defeated "A" "E")
                       (defeated "C" "B")
                       (defeated "C" "F")
                       (tie "D" "B")
                       (defeated "F" "E")))
                (list "C" "A" "F" "E" "B" "D")
                "power ranking returned list with incorrect order")
  (check-equal? (power-ranking
                 (list (defeated "A" "D")
                       (defeated "A" "E")
                       (defeated "C" "B")
                       (defeated "C" "F")
                       (tie "D" "B")
                       (defeated "F" "E")
                       (defeated "B" "G")
                       (defeated "B" "H")))
                (list "C" "A" "F" "E" "D" "B" "G" "H")
                "power ranking returned list with incorrect order"))
