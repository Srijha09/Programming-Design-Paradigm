;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 inner-product
 permutation-of?
 shortlex-less-than?
 permutations)

(check-location "04" "q1.rkt")

;; inner-product : RealList RealList -> Real
;; GIVEN: two lists of real numbers
;; WHERE: the two lists have the same length
;; RETURNS: the inner product of those lists
;; EXAMPLES:
;;     (inner-product (list 2.5) (list 3.0))  =>  7.5
;;     (inner-product (list 1 2 3 4) (list 5 6 7 8))  =>  70
;;     (inner-product (list) (list))  =>  0
;; STRATEGY: use observer template for RealList on list1 and list2.
(define (inner-product list1 list2)
  (cond
    [(or (empty? list1) (empty? list2)) 0]
    [else (+
           (* (first list1) (first list2))
           (inner-product (rest list1) (rest list2)))]))

;; TESTS:
(begin-for-test
  (check-equal? (inner-product (list 2.5) (list 3.0)) 7.5
                "inner product of given two lists should be 7.5")
  (check-equal? (inner-product (list 1 2 3 4) (list 5 6 7 8)) 70
                "inner product of given two lists should be 70")
  (check-equal? (inner-product (list) (list)) 0
                "inner product of given two lists should be 0"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; is-in? : Int IntList -> Boolean
;; GIVEN: an integer element and IntList list2
;; RETURNS: true iff element is in list2
;; EXAMPLES: (is-in? 2 (list 1 2 3)) => #true
;;           (is-in? 2 (list 1 3 4)) => #false
;;           (is-in? 2 (list)) => #false
;; STRATEGY: use observer template for Intlist on list2
(define (is-in? element list2)
  (cond
    [(empty? list2) #false]
    [else (or
           (= element (first list2))
           (is-in? element (rest list2)))]))

;; TESTS:
(begin-for-test
  (check-equal? (is-in? 2 (list 1 2 3)) #true
                "(is-in? 2 (list 1 2 3)) should return true")
  (check-equal? (is-in? 2 (list 1 3 4)) #false
                "(is-in? 2 (list 1 3 4)) should return false")
  (check-equal? (is-in? 2 (list)) #false
                "(is-in? 2 (list)) should return false"))
 
;; permutation-of? : IntList IntList -> Boolean
;; GIVEN: two lists of integers
;; WHERE: neither list contains duplicate elements
;; RETURNS: true if and only if one of the lists
;;     is a permutation of the other
;; EXAMPLES:
;;     (permutation-of? (list 1 2 3) (list 1 2 3)) => true
;;     (permutation-of? (list 3 1 2) (list 1 2 3)) => true
;;     (permutation-of? (list 3 1 2) (list 1 2 4)) => false
;;     (permutation-of? (list 1 2 3) (list 1 2)) => false
;;     (permutation-of? (list) (list)) => true
;; STRATEGY: use observer template for Intlist on list1 and list2
(define (permutation-of? list1 list2)
  (if (= (length list1) (length list2))
      (cond
        [(and (empty? list1) (empty? list2)) #true]
        [else (or
               (is-in? (first list1) list2)
               (permutation-of? (rest list1) list2))])
      #false))

;; TESTS:
(begin-for-test
  (check-equal? (permutation-of? (list 1 2 3) (list 1 2 3)) #true
                "(permutation-of? (list 1 2 3) (list 1 2 3)) should be true")
  (check-equal? (permutation-of? (list 3 1 2) (list 1 2 3)) #true
                "(permutation-of? (list 3 1 2) (list 1 2 3)) should be true")
  (check-equal? (permutation-of? (list 3 1 2) (list 1 2 4)) #false
                "(permutation-of? (list 3 1 2) (list 1 2 4)) should be false")
  (check-equal? (permutation-of? (list 1 2 3) (list 1 2)) #false
                "(permutation-of? (list 1 2 3) (list 1 2)) should be false")
  (check-equal? (permutation-of? (list) (list)) #true
                "(permutation-of? (list) (list)) should be true"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; shortlex-less-than? : IntList IntList -> Boolean
;; GIVEN: two lists of integers
;; RETURNS: true if and only either
;;     the first list is shorter than the second
;;  or both are non-empty, have the same length, and either
;;         the first element of the first list is less than
;;             the first element of the second list
;;      or the first elements are equal, and the rest of
;;             the first list is less than the rest of the
;;             second list according to shortlex-less-than?
;; EXAMPLES:
;;     (shortlex-less-than? (list) (list)) => false
;;     (shortlex-less-than? (list) (list 3)) => true
;;     (shortlex-less-than? (list 3) (list)) => false
;;     (shortlex-less-than? (list 3) (list 3)) => false
;;     (shortlex-less-than? (list 3) (list 1 2)) => true
;;     (shortlex-less-than? (list 3 0) (list 1 2)) => false
;;     (shortlex-less-than? (list 0 3) (list 1 2)) => true
;; STRATEGY: use observer template for IntList on list1 and list2

(define (shortlex-less-than? list1 list2)
  (cond
    [(and (empty? list1) (empty? list2)) #false]
    [(< (length list1) (length list2)) #true]
    [(and (= (length list1) (length list2))
          (< (first list1) (first list2))) #true]
    [(and (= (length list1) (length list2))
          (= (first list1) (first list2)))
     (shortlex-less-than? (rest list1) (rest list2))]
    [else
     #false]))

;; TESTS:
(begin-for-test
  (check-equal? (shortlex-less-than? (list) (list)) #false
                "(shortlex-less-than? (list) (list)) should return false")
  (check-equal? (shortlex-less-than? (list) (list 3)) #true
                "(shortlex-less-than? (list) (list 3)) should return true")
  (check-equal? (shortlex-less-than? (list 3) (list)) #false
                "(shortlex-less-than? (list 3) (list)) should return false")
  (check-equal? (shortlex-less-than? (list 3) (list 3)) #false
                "(shortlex-less-than? (list 3) (list 3)) should return false")
  (check-equal? (shortlex-less-than? (list 3) (list 1 2)) #true
                "(shortlex-less-than? (list 3) (list 1 2)) should return true")
  (check-equal? (shortlex-less-than? (list 3 0) (list 1 2)) #false
                "(shortlex-less-than? (list 3 0) (list 1 2))
                 should return false")
  (check-equal? (shortlex-less-than? (list 0 3) (list 1 2)) #true
                "(shortlex-less-than? (list 0 3) (list 1 2))
                 should return true"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; permutations-start : IntList Int -> IntListList
;; GIVEN: a list of integers lst and the length len
;; RETURNS: a list of all permutations of list lst
;; EXAMPLES: (permutations-start (list 1 2 3) 2) =>
;;           (list (list 3 2 1) (list 2 3 1)
;;           (list 3 1 2) (list 2 1 3)
;;           (list 1 3 2) (list 1 2 3))
;; STRATEGY: use observer template for IntList on lst
(define (permutations-start lst len)
  (cond
    [(empty? lst) lst]
    [else
     (make-copy (permutations-start (rest lst) (- len 1)) (first lst) len)]))

;; make-copy : IntListList Int Int -> IntListList
;; GIVEN: a list of list of integers p, an integer elem and the length len
;; RETURNS: a list of list of integers with elem inserted at all positions
;; EXAMPLES: (make-copy (list (list 7 8 9)) 1 2) =>
;;           (list (list 7 8 1 9) (list 7 1 8 9) (list 1 7 8 9))
;; STRATEGY: use observer template for IntListList on p
(define (make-copy lst elem len)
  (cond
    [(empty? lst) (list (list  elem))]
    [(< len 0) (list)]
    [else
     (append
      (insert-list lst len elem)
      (make-copy lst elem (- len 1)))]))

;; insert-list : IntListList Int Int -> IntListList
;; GIVEN: a list of list of integers lst, an integer insert-pos
;;        and an integer elem-to-be-inserted
;; RETURNS: a list of list of integers with elem-to-be-inserted
;;         inserted at insert-pos
;; EXAMPLE: (insert-list (list (list 7 8 9)) 2 1) =>
;;          (list (list 7 8 1 9))
;; STRATEGY: use observer template for IntListList on lst
(define (insert-list lst insert-pos elem-to-be-inserted)
  (cond
    [(empty? lst) lst]
    [else
     (cons
      (insert-at (first lst) insert-pos elem-to-be-inserted)
      (insert-list (rest lst) insert-pos elem-to-be-inserted))]))

;; insert-at : IntList Int Int -> IntList
;; GIVEN: a list of integers lst, an integer pos and an integer elem
;; RETURNS: a list of integers with elem inserted at pos position
;; EXAMPLE: (insert-at (list 1 2 3) 2 6) => (list 1 2 6 3)
;; STRATEGY: use observer template for IntList on lst
(define (insert-at lst pos elem)
  (cond
    [(= pos 0) (cons elem lst)]
    [else
     (cons (first lst) (insert-at (rest lst) (- pos 1) elem))]))

;; sort-insert: IntList IntListList -> IntListList
;; GIVEN: an IntList n and a IntListList lst
;; RETURNS: a IntListList with n inserted at position according
;;          to shortlex order
;; EXAMPLE: (sort-insert (list 1 3 2) (list (list 1 2 3) (list 2 1 3)))
;;           => (list (list 1 2 3) (list 1 3 2) (list 2 1 3))
;; STRATEGY: use observer template for IntList on lst
(define (sort-insert n lst)
  (cond
    [(empty? lst) (cons n lst)] 
    [(shortlex-less-than? n (first lst)) (cons n lst)] 
    (else 
     (cons (first lst) (sort-insert n (rest lst))) )))

;; sort-permuatation: IntListList -> IntListList
;; GIVEN: a list of list of integers
;; RETURNS: a list of all permutations of that list,
;;          in shortlex order
;; EXAMPLE: (sort-permutataion (list
;;                             (list 1 2 3) (list 1 3 2)
;;                             (list 2 1 3) (list 2 3 1)
;;                             (list 3 1 2) (list 3 2 1))
;;          => (list (list 1 2 3) (list 1 3 2) (list 2 1 3)
;;             (list 2 3 1) (list 3 1 2) (list 3 2 1))
;; STRATEGY: use observer template for IntListList on lst
(define (sort-permutations lst)
  (cond
    [(empty? lst) lst]
    (else
     (sort-insert (first lst) (sort-permutations (rest lst))))))

;; permutations : IntList -> IntListList
;; GIVEN: a list of integers
;; WHERE: the list contains no duplicates
;; RETURNS: a list of all permutations of that list,
;;          in shortlex order
;; EXAMPLES:
;;     (permutations (list))  =>  (list (list))
;;     (permutations (list 9))  =>  (list (list 9))
;;     (permutations (list 3 1 2))
;;         =>  (list (list 1 2 3)
;;                   (list 1 3 2)
;;                   (list 2 1 3)
;;                   (list 2 3 1)
;;                   (list 3 1 2)
;;                   (list 3 2 1))
;; STRATEGY: use observer template for IntList on lst
(define (permutations lst)
  (cond
    [(empty? lst) (cons empty empty)]
    [else
     (sort-permutations(permutations-start lst (- (length lst) 1)))]))

;; TESTS:
(begin-for-test
  (check-equal? (permutations (list)) (list (list))
                "(permutations (list)) returned incorrect permutation")
  (check-equal? (permutations (list 9)) (list (list 9))
                "(permutations (list 9)) returned incorrect permutation")
  (check-equal? (permutations (list 1 2 3))
                (list (list 1 2 3)
                      (list 1 3 2)
                      (list 2 1 3)
                      (list 2 3 1)
                      (list 3 1 2)
                      (list 3 2 1))
                "(permutations (list 1 2 3)) returned incorrect permutations")
  (check-equal? (permutations (list))
                (list (list))
                "(permutations (list)) returned incorrect permutations"))
