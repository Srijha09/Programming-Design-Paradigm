;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 tie
 tied?
 defeat?
 defeated
 defeat-c1
 defeat-c2
 tied-c1
 tied-c2
 defeated?
 get-all-competitors
 outranks
 outranked-by)

(check-location "08" "q1.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; Competitor

;; A Competitor is represented as a String (any string will do).

;; Outcome:

;; An Outcome is one of
;;     -- a Tie
;;     -- a Defeat
;;
;; OBSERVER TEMPLATE:
;; outcome-fn : Outcome -> ??
#; (define (outcome-fn o)
     (cond ((tie? o) ...)
           ((defeat? o) ...)))

;; Tie:

;; REPRESENTATION:
;; A Tie is represented as a struct
;; (make-tied c1 c2)

;; INTERPRETATION:
;; A Tie represents a tie (draw) between c1 and c2 where
;; c1 : Competitor - the name of first competitor
;; c2 : Competitor - the name of second competitor

;; IMPLEMENTATION:
(define-struct tied (c1 c2))

;; CONSTRUCTOR TEMPLATE:
;; (make-tied Competitor Competitor)

;; OBSERVER TEMPLATE:
;; tied-fn : Tie -> ??
#; (define (tied-fn t)
     (... (tied-c1 t)
          (tied-c2 t)))

;; Defeat:

;; REPRESENTATION:
;; A Defeat is represented as a struct
;; (make-defeat c1 c2)

;; INTERPRETATION:
;; A Defeat represents the outcome of a contest in which
;; competitor c1 wins and c2 loses where
;; c1 : Competitor - the name of first competitor
;; c2 : Competitor - the name of second competitor

;; IMPLEMENTATION:
(define-struct defeat (c1 c2))

;; CONSTRUCTOR TEMPLATE:
;; (make-defeat Competitor Competitor)

;; OBSERVER TEMPLATE:
;; defeat-fn : Defeat -> ??
#; (define (defeat-fn d)
     (... (defeat-c1 d)
          (defeat-c2 d)))

;; A XList is either -
;; -- empty
;; -- (cons X XList)
;; where X can be an Outcome or a Competitor.

;; OBSERVER TEMPLATE:
;; x-list-fn : XList -> ??
#; (define (x-list-fn xl)
     (cond
       [(empty? xl) ...]
       [else (... (x-fn (first xl))
                  (x-list-fn (rest xl)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tie : Competitor Competitor -> Tie
;; GIVEN: the names of two competitors
;; RETURNS: an indication that the two competitors have
;;     engaged in a contest, and the outcome was a tie
;; EXAMPLE: (see the examples given below for defeated?,
;;     which shows the desired combined behavior of tie
;;     and defeated?)
;; STRATEGY: use constructor template for Tie
(define (tie c1 c2)
  (make-tied c1 c2))

;; defeated : Competitor Competitor -> Defeat
;; GIVEN: the names of two competitors
;; RETURNS: an indication that the two competitors have
;;     engaged in a contest, with the first competitor
;;     defeating the second
;; EXAMPLE: (see the examples given below for defeated?,
;;     which shows the desired combined behavior of defeated
;;     and defeated?)
;; STRATEGY: use constructor template for Defeat
(define (defeated c1 c2)
  (make-defeat c1 c2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; defeated? : Competitor Competitor OutcomeList -> Boolean
;; GIVEN: the names of two competitors and a list of outcomes
;; RETURNS: true if and only if one or more of the outcomes indicates
;;     the first competitor has defeated or tied the second
;; EXAMPLES:
;;     (defeated? "A" "B" (list (defeated "A" "B") (tie "B" "C")))
;;  => true
;;
;;     (defeated? "A" "C" (list (defeated "A" "B") (tie "B" "C")))
;;  => false
;;
;;     (defeated? "B" "A" (list (defeated "A" "B") (tie "B" "C")))
;;  => false
;;
;;     (defeated? "B" "C" (list (defeated "A" "B") (tie "B" "C")))
;;  => true
;;
;;     (defeated? "C" "B" (list (defeated "A" "B") (tie "B" "C")))
;;  => true
;; STRATEGY: use HOF ormap and simpler function
(define (defeated? c1 c2 olist)
  (ormap (; Outcome -> Boolean
          ; GIVEN: an outcome x
          ; RETURNS: true iff outcome x implies competitor c1 has defeated
          ;          competitor c2
          lambda (x) (check-defeated? c1 c2 x)) olist))

;; check-defeated? Competitor Competitor Outcome -> Boolean
;; GIVEN: the names of two competitors and an outcome
;; RETURNS: an indication that the two competitors have
;;          engaged in a contest, with the first competitor
;;          defeating the second
;; EXAMPLES: (defeated? "A" "B" (list (defeated "A" "B"))) => #true
;;           (defeated? "A" "B" (list (tie "A" "B"))) => #true
;;           (defeated? "A" "B" (list (tie "B" "A"))) => #true
;;           (defeated? "A" "C" (list (defeated "C" "A"))) => #false
;; STRATEGY: use observer template for Outcome on o
(define (check-defeated? c1 c2 o)
  (cond
    [(defeat? o) (equal? (defeated c1 c2) o)]
    [(tied? o) (or
                (equal? (tie c1 c2) o)
                (equal? (tie c2 c1) o))]))

;; TESTS:
(begin-for-test
  (check-equal? (defeated? "A" "B" (list (defeated "A" "B") (tie "B" "C")))
                #true
                "B is defeated by A")
  (check-equal? (defeated? "A" "C" (list (defeated "A" "B") (tie "B" "C")))
                #false
                "C is not defeated by A")
  (check-equal? (defeated? "B" "A" (list (defeated "A" "B") (tie "B" "C")))
                #false
                "A is not defeated by B")
  (check-equal? (defeated? "B" "C" (list (defeated "A" "B") (tie "B" "C")))
                #true
                "C is defeated by B")
  (check-equal? (defeated? "C" "B" (list (defeated "A" "B") (tie "B" "C")))
                #true
                "B is defeated by C"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-insert : String StringList -> StringList
;; GIVEN: a String elem and a StringList lst
;; RETURNS: a StringList with elem inserted if it wasn't in the list
;; EXAMPLE: (check-insert "a" (list "a" "b" "a")) => (list "a" "b" "a")
;;          (check-insert "c" (list "a" "b" "a")) => (list "a" "b" "a" "c")
;; STRATEGY: use observer template for StringList on lst
(define (check-insert elem lst)
  (cond
    [(empty? lst) (cons elem lst)]
    [(string=? elem (first lst)) lst]
    [else (cons (first lst) (check-insert elem (rest lst)))]))
  
;; remove-duplicates : StringList -> StringList
;; GIVEN: a list of strings
;; RETURNS: a list of strings with duplicates removed
;; EXAMPLE: (list "a" "b" "a") => (list "a" "b")
;; STRATEGY: use observer template for StringList on s
(define (remove-duplicates s)
  (if
   (empty? s) empty
   (check-insert (first s) (remove-duplicates (rest s)))))

;; get-all-competitors : OutcomeList -> CompetitorList
;; GIVEN: a list of outcomes outcomelist
;; RETURNS: a list of all the competitors mentioned in the outcomelist
;;          without duplicates
;; EXAMPLE: (get-all-competitors (list (defeated "A" "B")
;;                                     (tie "C" "D") (defeated "B" "A")))
;;          => (list "B" "A" "D" "C")
;; STRATEGY: initialize the invariant of get-competitors
(define (get-all-competitors outcomelist)
  (remove-duplicates
   (get-competitors 0 outcomelist empty)))

;; get-competitors : NonNegInt OutcomeList CompetitorList -> CompetitorList
;; GIVEN: a non negative integer p, a list of outcomes outcomelist and a
;;        list of competitors competitorlist
;; WHERE: competitorlist has the competitors that have been encountered
;;        in outcomelist
;; RETURNS: a list of all the competitors mentioned in the outcomelist
;; EXAMPLE: (get-competitors 0 (list (defeated "A" "B")
;;                                   (tie "C" "D") (defeated "B" "A")) empty)
;;          => (list "C" "D" "A" "B")
;; STRATEGY: divide into cases and recur on outcomelist
;; HALTING MEASURE: (- (length outcomelist) p)
(define (get-competitors p outcomelist competitorlist)
  (remove-duplicates
   (cond
     [(= p (length outcomelist)) competitorlist]
     [(defeat? (list-ref outcomelist p))
      (get-competitors (+ p 1) outcomelist (cons
                                            (defeat-c1 (list-ref outcomelist p))
                                            (cons
                                             (defeat-c2
                                               (list-ref outcomelist p))
                                             competitorlist)))]
     [(tied? (list-ref outcomelist p))
      (get-competitors (+ p 1) outcomelist (cons
                                            (tied-c1 (list-ref outcomelist p))
                                            (cons
                                             (tied-c2
                                              (list-ref outcomelist p))
                                             competitorlist)))])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; outranks : Competitor OutcomeList -> CompetitorList
;; GIVEN: the name of a competitor and a list of outcomes
;; RETURNS: a list of the competitors outranked by the given
;;     competitor, in alphabetical order
;; EXAMPLES:
;;     (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
;;  => (list "B" "C")
;;
;;     (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
;;  => (list "A" "B")
;;
;;     (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
;;  => (list "B" "C")
;; STRATEGY: initialize the invariant of check-outranks
(define (outranks c olist)
  (sort 
   (check-outranks c 0 olist
                   (get-all-competitors olist)
                   (get-all-competitors olist)
                   empty)
   string<?))

;; check-outranks : Competitor NonNegInt OutcomeList CompetitorList
;;                  CompetitorList CompetitorList -> CompetitorList
;; GIVEN: a competitor c, a non negative integer p, a list of outcomes olist,
;;        three lists of competitors competitorlist, finalcompetitorlist (non-
;;        decreasing) and clist
;; WHERE: clist has all the competitors that have been outranked by c
;; RETURNS: a list of the competitors outranked by the given competitor c
;; EXAMPLE: (check-outranks "B" 0 (list (defeated "A" "B")
;;                                      (defeated "B" "A"))
;;                                (list "A" "B") (list "A" "B") empty)
;;          => (list "A" "B")
;; STRATEGY: recur on (rest competitorlist)
;; HALTING MEASURE: (- (length finalcompetitorlist) p)
(define (check-outranks c p olist competitorlist finalcompetitorlist clist)
  (remove-duplicates
   (cond
     [(empty? competitorlist) clist]
     [(= p (length finalcompetitorlist)) clist]
     [(defeated? c (first competitorlist) olist)
      (get-outranks c p olist competitorlist finalcompetitorlist clist)]
     [else
      (check-outranks c p olist (rest competitorlist)
                      finalcompetitorlist clist)])))

;; get-outranks : Competitor NonNegInt OutcomeList CompetitorList
;;                CompetitorList CompetitorList -> CompetitorList
;; GIVEN: a competitor c, a non negative integer p, a list of outcomes olist,
;;        three lists of competitors competitorlist, finalcompetitorlist (non-
;;        decreasing) and clist
;; WHERE: clist has all the competitors that have been outranked by c
;; RETURNS: a list of the competitors outranked by the given competitor c
;; EXAMPLE: (get-outranks "B" 0 (list (defeated "A" "B")
;;                                      (defeated "B" "A"))
;;                                (list "A" "B") (list "A" "B") empty)
;;          => (list "B" "A")
;; STRATEGY: append the competitors outranked 
(define (get-outranks c p olist competitorlist finalcompetitorlist clist)
  (append
   (check-outranks (first competitorlist)
                   (+ p 1)
                   olist
                   finalcompetitorlist
                   finalcompetitorlist
                   (cons (first competitorlist) clist))
   (check-outranks c
                   p
                   olist
                   (rest competitorlist)
                   finalcompetitorlist
                   clist)))

;; TESTS:
(begin-for-test
  (check-equal? (outranks "D" (list (defeated "A" "B") (tie "B" "C")))
                (list)
                "D does not outrank any other competitor")
  (check-equal? (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
                (list "B" "C")
                "A outranks B and C")
  (check-equal? (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
                (list "A" "B")
                "B outranks A and B")
  (check-equal? (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
                (list "B" "C")
                "C outranks B and C"))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; outranked-by : Competitor OutcomeList -> CompetitorList
;; GIVEN: the name of a competitor and a list of outcomes
;; RETURNS: a list of the competitors that outrank the given
;;     competitor, in alphabetical order
;; NOTE: it is possible for a competitor to outrank itself
;; EXAMPLES:
;;     (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
;;  => (list)
;;
;;     (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
;;  => (list "A" "B")
;;
;;     (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
;;  => (list "A" "B" "C")
;; STRATEGY: initialize the invariant of get-outranked-by
(define (outranked-by c olist)
  (sort (get-outranked-by c 0 olist
                          (get-all-competitors olist)
                          (get-all-competitors olist)
                          empty) string<?))

;; get-outranked-by : Competitor OutcomeList CompetitorList CompetitorList
;;                    -> CompetitorList
;; GIVEN: a competitor c, a list of outcomes olist and two
;;        lists of competitors competitorlist and clist
;; WHERE: clist has all the competitors that outrank c
;; RETURNS: a list of the competitors that outrank competitor c
;; EXAMPLE: (get-outranked-by "C" (list (defeated "A" "B") (tie "B" "C"))
;;                            (list "A" "B" "C") (list "A" "B" "C"))
;;           => (list "A" "B" "C")
;; STRATEGY: divide into cases and recur on (rest competitorlist)
;; HALTING MEASURE: (- (length finalcompetitorlist) p)
(define (get-outranked-by c p olist competitorlist finalcompetitorlist clist)
  (remove-duplicates 
   (cond
     [(= p (length finalcompetitorlist)) clist]
     [(empty? competitorlist) clist]
     [(member? c (outranks (first competitorlist) olist))
      (get-outranked-by c
                        (+ p 1)
                        olist
                        (rest competitorlist)
                        finalcompetitorlist
                        (cons (first competitorlist) clist))]
     [else (get-outranked-by c
                             p
                             olist
                             (rest competitorlist)
                             finalcompetitorlist
                             clist)])))

;; TESTS:
(begin-for-test
  (check-equal? (outranked-by "D" (list (defeated "A" "B") (tie "B" "C")))
                (list)
                "D is not outranked by any other competitor")
  (check-equal? (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
                (list)
                "A is not outranked by any other competitor")
  (check-equal? (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
                (list "A" "B")
                "B is outranked by A and B")
  (check-equal? (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
                (list "A" "B" "C")
                "C is outranked-by A, B and C"))