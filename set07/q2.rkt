;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")

(provide
 lit
 literal-value
 var
 variable-name
 op
 operation-name
 call
 call-operator
 call-operands
 block
 block-var
 block-rhs
 block-body
 literal?
 variable?
 operation?
 call?
 block?
 undefined-variables
 well-typed?)

(check-location "07" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; A XList is either -
;; -- empty
;; -- (cons X XList)
;; where X can be an ArithmeticExpression, a String or a Variable.

;; OBSERVER TEMPLATE:
;; x-list-fn : XList -> ??
#; (define (x-list-fn xl)
     (cond
       [(empty? xl) ...]
       [else (... (x-fn (first xl))
                  (x-list-fn (rest xl)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; well-typed? : ArithmeticExpression -> Boolean
;; GIVEN: an arbitrary arithmetic expression
;; RETURNS: true if and only if the expression is well-typed
;; EXAMPLES:
;;     (well-typed? (lit 17))  =>  true
;;     (well-typed? (var "x"))  =>  false
;;
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "x")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "x"))))) => true
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "f")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "f"))))) => true
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "x")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "f"))))) => false
;; STRATEGY: initialize the invariant of get-expression-type
(define (well-typed? aexp)
  (not(string=? (get-expression-type aexp empty) "Error")))
  
;; get-expression-type : ArithmeticExpression VariableList -> Type
;; GIVEN: an ArithmeticExpression aexp and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before ArithmeticExpression aexp
;; RETURNS: the type of given ArithmeticExpression aexp
;; EXAMPLE:
;;     (get-expression-type
;;      (block (var "f")
;;             (op "+")
;;             (block (var "x")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "x")))) empty) => "Int"
;; STRATEGY: use observer template for ArithmeticExpression on aexp
(define (get-expression-type aexp vars)
  (cond
    [(literal? aexp) "Int"]
    [(operation? aexp) (get-operation-type aexp)]
    [(call? aexp) (get-call-type aexp vars)]
    [(block? aexp) (get-block-type aexp vars)]
    [(variable? aexp) (get-variable-type aexp vars)]))

;; get-operation-type : Operation -> Type
;; GIVEN: an Operation o
;; RETURNS: the type of operation o
;; EXAMPLE: (get-operation-type (op "*")) => "Op0"
;;          (get-operation-type (op "-")) => "Op1"
;; STRATEGY: use observer template for Operation on o
(define (get-operation-type o)
  (cond
    [(or (string=? (operation-name o) "+")
         (string=? (operation-name o) "*"))
     "Op0"]
    [(or (string=? (operation-name o) "-")
         (string=? (operation-name o) "/"))
     "Op1"]))

;; call-type-int? : Call VariableList -> Boolean
;; GIVEN: a Call c and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before Call c
;; RETURNS: true iff the type of call c is Int
;; EXAMPLE: (call-type-int? (call (op "-") (list)) empty) => #false
;;          (call-type-int? (call (op "-") (list (lit 5))) empty) => #true
;; STRATEGY: use template for Call and HOF andmap on c 
(define (call-type-int? c vars)
  (or
   (and
    (string=? (get-expression-type (call-operator c) vars) "Op0")
    (andmap (; ArithmeticExpression -> Boolean
             ; GIVEN: an ArithmeticExpression x
             ; RETURNS: true iff the type of its argument is Int
             lambda (x) (string=? (get-expression-type x vars) "Int"))
            (call-operands c)))
   (and
    (string=? (get-expression-type (call-operator c) vars) "Op1")
    (not (empty? (call-operands c)))
    (andmap (; ArithmeticExpression -> Boolean
             ; GIVEN: an ArithmeticExpression x
             ; RETURNS: true iff the type of its argument is Int
             lambda (x) (string=? (get-expression-type x vars) "Int"))
            (call-operands c)))))

;; get-call-type : Call VariableList -> Type
;; GIVEN: a Call c and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before Call c
;; RETURNS: the type of given Call c
;; EXAMPLE: (get-call-type (call (op "*")
;;                               (list (lit 5) (lit 5))) empty)
;;           => "Int"
;;          (get-call-type (call (op "*")
;;                               (list (lit 5) (var "a"))) empty)
;;           => "Error"
;; STRATEGY: divide into cases and use HOF andmap on call c
(define (get-call-type c vars)
  (if
   (call-type-int? c vars)
   "Int"
   "Error"))

;; get-block-type : Block VariableList -> Type
;; GIVEN: a Block b and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before Block b
;; RETURNS: the type of given Block b
;; EXAMPLE: (get-block-type (block (var "x")
;;                                 (op "*")
;;                                 (var "x")) empty) => "Op0"
;;          (get-block-type (block (var "x")
;;                                 (var "a")
;;                                 (var "x")) empty) => "Error"
;; STRATEGY: use observer template for Block on b
(define (get-block-type b vars)
  (if
   (string=? (get-expression-type (block-rhs b) vars) "Error")
   "Error"
   (get-block-body-type b vars)))

;; get-block-body-type : Block VariableList -> Type
;; GIVEN: a Block b and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before body of Block b
;; RETURNS: the type of given Block b
;; EXAMPLE: (get-block-body-type (block (var "x")
;;                                      (op "*")
;;                                      (block (var "y")
;;                                             (var "x")
;;                                             (op "-"))) empty) => "Op1"
;;          (get-block-body-type (block (var "x")
;;                                      (var "a")
;;                                      (var "x")) empty) => "Error"
;; STRATEGY: use observer template for Block on b
(define (get-block-body-type b vars)
  (get-expression-type (block-body b)
                       (cons
                        (make-variable
                         (variable-name (block-var b))
                         (get-expression-type (block-rhs b) vars)) vars)))

;; get-variable-type : Variable VariableList -> Type
;; GIVEN: a Variable v and a list of Variables vars
;; WHERE: vars is the list of all the Variables along with their types that have
;;        been defined before Variable v
;; RETURNS: the type of the Variable v if it has been defined already,
;;          Error otherwise
;; EXAMPLE: (get-variable-type (make-variable "v" "")
;;                             (list (make-variable "x" "Op0")
;;                                   (make-variable "v" "Int")
;;                                   (make-variable "a" "Error"))) => "Int"
;;          (get-variable-type (make-variable "v" "")
;;                             (list (make-variable "x" "Op0")
;;                                   (make-variable "y" "Int")
;;                                   (make-variable "a" "Op1"))) => "Error"
;; STRATEGY: use observer template for Variable on v
(define (get-variable-type v vars)
  (cond
    [(empty? vars) "Error"]
    [(string=? (variable-name v) (variable-name (first vars)))
     (variable-type (first vars))]
    [else
     (get-variable-type v (rest vars))]))

;; TESTS:
;; Examples for test:
(define example1-true
  (block (var "f")
         (op "+")
         (block (var "x")
                (call (var "f") (list))
                (call (op "*")
                      (list (var "x"))))))
(define example2-true
  (block (var "f")
         (op "+")
         (block (var "f")
                (call (var "f") (list))
                (call (op "*")
                      (list (var "f"))))))
(define example3-false
  (block (var "f")
         (op "+")
         (block (var "x")
                (call (var "f") (list))
                (call (op "*")
                      (list (var "f"))))))
(define example4-false
  (block (var "f")
         (op "+")
         (block (var "x")
                (call (op "/") (list))
                (call (op "*")
                      (list (var "f"))))))

(begin-for-test
  (check-equal? (well-typed? (lit 5)) #true
                "(lit 5) is a well typed expression")
  (check-equal? (well-typed? (var "x")) #false
                "(var x) is a not a well typed expression")
  (check-equal? (well-typed? (call (op "/") (list (lit 4) (lit 2)))) #true
                "(well-typed? (call (op /) (list (lit 4) (lit 2)))) is a well
                 typed expression")
  (check-equal? (well-typed? example1-true)
                #true
                "(well-typed? example1-true) is a well
                 typed expression")
  (check-equal? (well-typed? example2-true)
                #true
                "(well-typed? example2-true) is a well
                 typed expression")
  (check-equal? (well-typed? example3-false)
                #false
                "(well-typed? example3-true) is a not a
                 well typed expression")
  (check-equal? (well-typed? example4-false)
                #false
                "(well-typed? example4-true) is a not a
                 well typed expression"))