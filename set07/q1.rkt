;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 lit
 literal-value
 var
 variable-name
 make-variable
 variable-type
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
 undefined-variables)

(check-location "07" "q1.rkt")

;; An OperationName is represented as one of the following strings:
;;     -- "+"      (indicating addition)
;;     -- "-"      (indicating subtraction)
;;     -- "*"      (indicating multiplication)
;;     -- "/"      (indicating division)
;;
;; OBSERVER TEMPLATE:
;; operation-name-fn : OperationName -> ??
#; (define (operation-name-fn op)
     (cond ((string=? op "+") ...)
           ((string=? op "-") ...)
           ((string=? op "*") ...)
           ((string=? op "/") ...)))
          
;; An ArithmeticExpression is one of
;;     -- a Literal
;;     -- a Variable
;;     -- an Operation
;;     -- a Call
;;     -- a Block
;;
;; OBSERVER TEMPLATE:
;; arithmetic-expression-fn : ArithmeticExpression -> ??
#; (define (arithmetic-expression-fn exp)
     (cond ((literal? exp) ...)
           ((variable? exp) ...)
           ((operation? exp) ...)
           ((call? exp) ...)
           ((block? exp) ...)))

;; Literal:

;; REPRESENTATION:
;; A Literal is represented as a struct
;; (make-literal value)
;; INTERPRETATION:
;; value : Real - is a real number

;; IMPLEMENTATION:
(define-struct literal (value))

;; CONSTRUCTOR TEMPLATE:
;; (make-literal Real)

;; OBSERVER TEMPLATE:
;; literal-fn : Literal -> ??
#; (define (literal-fn r)
     (... (literal-value r)))

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

;; Variable:

;; REPRESENTATION:
;; A Variable is represented as a struct
;; (make-variable name type)
;; INTERPRETATION:
;; name : String - is the name of variable (any string will do)
;; type : Type - is the type of variable

;; IMPLEMENTATION:
(define-struct variable (name type))

;; CONSTRUCTOR TEMPLATE:
;; (make-variable String Type)

;; OBSERVER TEMPLATE:
;; variable-fn : Variable -> ??
#; (define (variable-fn n)
     (... (variable-name n)
          (variable-type n)))

;; Type:

;; A Type is represented as one of the following strings:
;;     -- "Op0"
;;     -- "Op1"
;;     -- "Int"
;;     -- "Error"
;;
;; OBSERVER TEMPLATE:
;; operation-name-fn : OperationName -> ??
#; (define (type-fn t)
     (cond ((string=? t "Op0") ...)
           ((string=? t "Op1") ...)
           ((string=? t "Int") ...)
           ((string=? t "Error") ...)))

;; Operation:

;; REPRESENTATION:
;; An Operation is represented as a struct
;; (make-operation name)
;; INTERPRETATION:
;; name : OperationName - is the name of Operation (any string will do)

;; IMPLEMENTATION:
(define-struct operation (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-operation OperationName)

;; OBSERVER TEMPLATE:
;; operation-fn : Operation -> ??
#; (define (operation-fn n)
     (... (operation-name n)))

;; Call:

;; REPRESENTATAION:
;; A Call is represented as a struct
;; (make-fcall operator operands)
;; INTERPRETATION:
;; operator : ArithmeticExpression - is an operator expression of this call
;; operands : ArithmeticExpressionList - is a list of operand expressions of
;;            this call

;; IMPLEMENTATION:
(define-struct fcall (operator operands))

;; CONSTRUCTOR TEMPLATE:
;; (make-operator ArithmeticExpression ArithmeticExpressionList)

;; OBSERVER TEMPLATE:
#; (define (fcall-fn c)
     (... (arithmetic-expression-fn (fcall-operator c))
          (arithmetic-expression-list-fn (fcall-operands c))))

;; Block:

;; REPRESENTATAION:
;; A Block is represented as a struct
;; (make-fblock var rhs body)
;; INTERPRETATION:
;; var : Variable - a variable defined by this block
;; rhs : ArithmeticExpression - the expression whose value will become 
;;       the value of the variable defined by this block
;; body : ArithmeticExpression - the expression whose value will become
;;        the value of the block expression

;; IMPLEMENTATION:
(define-struct fblock (var rhs body))

;; CONSTRUCTOR TEMPLATE:
;; (make-fblock Variable ArithmeticExpression ArithmeticExpression)

;; OBSERVER TEMPLATE:
;; fblock-fn -> ??
#; (define (fblock-fn v r b)
     (... (variable-fn v)
          (arithmetic-expression-fn r)
          (arithmetic-expression-fn b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lit : Real -> Literal
;; GIVEN: a real number
;; RETURNS: a literal that represents that number
;; EXAMPLE: (see the example given for literal-value,
;;          which shows the desired combined behavior
;;          of lit and literal-value)
;; STRATEGY: Use constructor template for Literal on l
(define (lit l)
  (make-literal l))

;; literal-value : Literal -> Real
;; GIVEN: a literal
;; RETURNS: the number it represents
;; EXAMPLE: (literal-value (lit 17.4)) => 17.4
;; STRATEGY: Defined by DrRacket when a structure named literal
;;           with field value is created

;; TESTS:
(begin-for-test
  (check-equal? (lit 17.4) (make-literal 17.4)
                "(lit 17.4) returned unexpected value")
  (check-equal? (literal-value (lit 17.4)) 17.4
                "(literal-value (lit 17.4)) returned unexpected value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; var : String -> Variable
;; GIVEN: a string
;; WHERE: the string begins with a letter and contains
;;     nothing but letters and digits
;; RETURNS: a variable whose name is the given string
;; EXAMPLE: (see the example given for variable-name,
;;          which shows the desired combined behavior
;;          of var and variable-name)
;; STRATEGY: Use constructor template for Variable on v
(define (var v)
  (make-variable v ""))
          
;; variable-name : Variable -> String
;; GIVEN: a variable
;; RETURNS: the name of that variable
;; EXAMPLE: (variable-name (var "x15")) => "x15"
;; STRATEGY: Defined by DrRacket when a structure named variable
;;           with field name is created

;; TESTS:
(begin-for-test
  (check-equal? (var "x15") (make-variable "x15" "")
                "(var x15) returned unexpected value")
  (check-equal? (variable-name (var "x15")) "x15"
                "(variable-name (var x15)) returned unexpected value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; op : OperationName -> Operation
;; GIVEN: the name of an operation
;; RETURNS: the operation with that name
;; EXAMPLES: (see the examples given for operation-name,
;;           which show the desired combined behavior
;;           of op and operation-name)
;; STRATEGY: Use constructor template for Operation on n
(define (op n)
  (make-operation n))
          
;; operation-name : Operation -> OperationName
;; GIVEN: an operation
;; RETURNS: the name of that operation
;; EXAMPLES:
;;     (operation-name (op "+")) => "+"
;;     (operation-name (op "/")) => "/"
;; STRATEGY: Defined by DrRacket when a structure named operation
;;           with field name is created

;; TESTS:
(begin-for-test
  (check-equal? (op "+") (make-operation "+")
                "(op +) returned unexpected value")
  (check-equal? (operation-name (op "+")) "+"
                "(operation-name (op +)) returned unexpected value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;; GIVEN: an operator expression and a list of operand expressions
;; RETURNS: a call expression whose operator and operands are as
;;     given
;; EXAMPLES: (see the examples given for call-operator and
;;           call-operands, which show the desired combined
;;           behavior of call and those functions)
;; STRATEGY: Use constructor template for Call
(define (call operator operands)
  (make-fcall operator operands))
          
;; call-operator : Call -> ArithmeticExpression
;; GIVEN: a call
;; RETURNS: the operator expression of that call
;; EXAMPLE:
;;     (call-operator (call (op "-")
;;                          (list (lit 7) (lit 2.5))))
;;         => (op "-")
;; STRATEGY: Use observer template for Call on c
(define (call-operator c)
  (fcall-operator c))
          
;; call-operands : Call -> ArithmeticExpressionList
;; GIVEN: a call
;; RETURNS: the operand expressions of that call
;; EXAMPLE:
;;     (call-operands (call (op "-")
;;                          (list (lit 7) (lit 2.5))))
;;         => (list (lit 7) (lit 2.5))
;; STRATEGY: Use observer template for Call on c
(define (call-operands c)
  (fcall-operands c))

;; TESTS:
(begin-for-test
  (check-equal? (call (op "-") (list (lit 7) (lit 2.5)))
                (make-fcall (make-operation "-")
                            (list (make-literal 7) (make-literal 2.5)))
                "(call (op -) (list (lit 7) (lit 2.5))) returned unexpected
                 value")
  (check-equal? (call-operator (call (op "-") (list (lit 7) (lit 2.5))))
                (op "-")
                "(call-operator (call (op -) (list (lit 7) (lit 2.5))))
                returned unexpected value")
  (check-equal? (call-operands (call (op "-") (list (lit 7) (lit 2.5))))
                (list (lit 7) (lit 2.5))
                "(call-operands (call (op -) (list (lit 7) (lit 2.5))))
                returned unexpected value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; block : Variable ArithmeticExpression ArithmeticExpression
;;             -> Block
;; GIVEN: a variable, an expression e0, and an expression e1
;; RETURNS: a block that defines the variable's value as the
;;     value of e0; the block's value will be the value of e1
;; EXAMPLES: (see the examples given for block-var, block-rhs,
;;           and block-body, which show the desired combined
;;           behavior of block and those functions)
;; STRATEGY: Use constructor template for Block
(define (block v e0 e1)
  (make-fblock v e0 e1))

;; block-var : Block -> Variable
;; GIVEN: a block
;; RETURNS: the variable defined by that block
;; EXAMPLE:
;;     (block-var (block (var "x5")
;;                       (lit 5)
;;                       (call (op "*")
;;                             (list (var "x6")))))
;;        => (var "x5")
;; STRATEGY: Use observer template for Block on b
(define (block-var b)
  (fblock-var b))
          
;; block-rhs : Block -> ArithmeticExpression
;; GIVEN: a block
;; RETURNS: the expression whose value will become the value of
;;     the variable defined by that block
;; EXAMPLE:
;;     (block-rhs (block (var "x5")
;;                       (lit 5)
;;                       (call (op "*")
;;                             (list (var "x6") (var "x7")))))
;;         => (lit 5)
;; STRATEGY: Use observer template for Block on b
(define (block-rhs b)
  (fblock-rhs b))
          
;; block-body : Block -> ArithmeticExpression
;; GIVEN: a block
;; RETURNS: the expression whose value will become the value of
;;     the block expression
;; EXAMPLE:
;;     (block-body (block (var "x5")
;;                        (lit 5)
;;                        (call (op "*")
;;                              (list (var "x6") (var "x7")))))
;;         => (call (op "*") (list (var "x6") (var "x7")))
;; STRATEGY: Use observer template for Block on b
(define (block-body b)
  (fblock-body b))

;; TESTS:
(begin-for-test
  (check-equal? (block-var (block (var "x5")
                                  (lit 5)
                                  (call (op "*")
                                        (list (var "x6")))))
                (var "x5")
                "(block-var (block (var x5)
                                  (lit 5)
                                  (call (op *)
                                        (list (var x6))))) returned
                unexpected result")
  (check-equal? (block-rhs (block (var "x5")
                                  (lit 5)
                                  (call (op "*")
                                        (list (var "x6") (var "x7")))))
                (lit 5)
                "(block-rhs (block (var x5)
                                  (lit 5)
                                  (call (op *)
                                        (list (var x6) (var x7))))) returned
                unexpected result")
  (check-equal? (block-body (block (var "x5")
                                   (lit 5)
                                   (call (op "*")
                                         (list (var "x6") (var "x7")))))
                (call (op "*")
                      (list (var "x6") (var "x7")))
                "(block-var (block (var x5)
                                  (lit 5)
                                  (call (op *)
                                        (list (var x6) (var x7))))) returned
                unexpected result"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          
;; literal?   : ArithmeticExpression -> Boolean
;; variable?  : ArithmeticExpression -> Boolean
;; operation? : ArithmeticExpression -> Boolean
;; call?      : ArithmeticExpression -> Boolean
(define (call? c)
  (fcall? c))
;; block?     : ArithmeticExpression -> Boolean
(define (block? b)
  (fblock? b))
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is (respectively)
;;     a literal, variable, operation, call, or block
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false

;; TESTS:
(begin-for-test
  (check-equal? (call? (call (op "-") (list (lit 7) (lit 2.5)))) #true
                "(call (op -) (list (lit 7) (lit 2.5))) should be true")
  (check-equal? (block? (block (var "x5")
                               (lit 5)
                               (call (op "*")
                                     (list (var "x6"))))) #true
                                                          "(block (var x5)
                                  (lit 5)
                                  (call (op *)
                                        (list (var x6)))) should be true"))

(define example (block (var "x")
                       (var "y")
                       (call (block (var "z")
                                    (var "x")
                                    (op "+"))
                             (list (block (var "x")
                                          (lit 5)
                                          (var "x"))
                                   (var "x")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; variables-in-call : ArithmeticExpression ArithmeticExpressionList
;;                     -> StringList
;; GIVEN: an arithmetic expression operator and
;;        a list of arithmetic expressions operands
;; RETURNS: a list of variable names defined by
;;          all blocks that occur within the expressions
;; EXAMPLE: (variables-in-call (block (var "a") (var "x") (op "+"))
;;                              (list (block (var "b") (lit 5) (var "x"))))
;;           => (list "a" "b")
;; STRATEGY: use observer template for Call
(define (variables-in-call operator operands)
  (append (variables-defined-by operator)
          (variables-in-call-list operands)))

;; variables-in-call-list : ArithmeticExpressionList -> StringList
;; GIVEN: a list of arithmetic expressions operands
;; RETURNS: a list of variable names defined by
;;          all blocks that occur within the list
;; EXAMPLE: (variables-in-call-list (list (block (var "a") (lit 1) (var "x"))
;;                                        (block (var "b") (lit 2) (var "y"))
;;                                        (block (var "c") (lit 3) (var "z"))))
;;          => (list "a" "b" "c")
;; STRATEGY: use observer template for ArithmeticExpressionList on operands
(define (variables-in-call-list operands)
  (cond
    [(empty? operands) empty]
    [else (append (variables-defined-by (first operands))
                  (variables-in-call-list (rest operands)))]))

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
  (cond
    [(empty? s) empty]
    [else (check-insert (first s) (remove-duplicates (rest s)))]))

;; variables-defined-by : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;     all blocks that occur within the expression, without
;;     repetitions, in any order
;; EXAMPLE:
;;     (variables-defined-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "x" "z") or (list "z" "x")
;; STRATEGY: use observer template for ArithmeticExpression on exp
(define (variables-defined-by exp)
  (remove-duplicates
   (cond
     [(literal? exp) empty]
     [(variable? exp) empty]
     [(operation? exp) empty]
     [(call? exp)
      (variables-in-call (call-operator exp) (call-operands exp))]
     [(block? exp)
      (append
       (cons (variable-name (block-var exp)) empty)
       (variables-defined-by (block-rhs exp))
       (variables-defined-by (block-body exp)))])))

;; TESTS:
;; example for test
(define block-var-x-z
  (block (var "x")
         (var "y")
         (call (block (var "z")
                      (var "x")
                      (op "+"))
               (list (block (var "x")
                            (lit 5)
                            (var "x"))
                     (var "x")
                     (lit 2)))))

(begin-for-test
  (check-equal? (variables-defined-by block-var-x-z)
                (list "z" "x")
                "(variables-defined-by block-var-x-z)
                  returned unexpected list"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; undefined-variables : ArithmeticExpression -> StringList
;; GIVEN: an arbitrary arithmetic expression
;; RETURNS: a list of the names of all undefined variables
;;     for the expression, without repetitions, in any order
;; EXAMPLE:
;;     (undefined-variables
;;      (call (var "f")
;;            (list (block (var "x")
;;                         (var "x")
;;                         (var "x"))
;;                  (block (var "y")
;;                         (lit 7)
;;                         (var "y"))
;;                  (var "z"))))
;;  => some permutation of (list "f" "x" "z")
;; STRATEGY: Initialize the invariant of all-undefined-variables
(define (undefined-variables aexp)
  (remove-duplicates(all-undefined-variables aexp empty)))

;; all-undefined-variables : ArithmeticExpression StringList
;;                           -> StringList
;; GIVEN: an arithmetic expression aexp and a list of string vars
;; WHERE: vars has the variables that are undefined before aexp
;; RETURNS: a list of string that contains the variables that are undefined in
;;          arithmetic expression aexp
;; EXAMPLE: (all-undefined-variables
;;           (call (var "f")
;;                 (list (block (var "x")
;;                              (var "x")
;;                              (var "x"))
;;                       (block (var "y")
;;                              (lit 7)
;;                              (var "y"))
;;                       (var "z"))))
;;           => (list "f" "x" "z")
;; STRATEGY: use observer template for ArithmeticExpression on aexp
(define (all-undefined-variables aexp vars)
  (cond
    [(literal? aexp) vars]
    [(operation? aexp) vars]
    [(variable? aexp) (variable-undefined-variables aexp vars)]
    [(call? aexp) (call-undefined-variables aexp vars)]
    [(block? aexp) (block-undefined-variables aexp vars)]))

;; variable-undefined-variables : Variable StringList -> StringList
;; GIVEN: a Variable v and a list of String vars
;; WHERE: vars has the variables that are undefined before Variable v
;; RETURNS: a list of string that contains the variables that are undefined
;;          along with Variable v
;; EXAMPLE: (variable-undefined-variables (var "x") (list "y" "z"))
;;           => (list "x" "y" "z")
;; STRATEGY: use observer template for Variable on v
(define (variable-undefined-variables v vars)
  (cons (variable-name v) vars))

;; call-undefined-variables : Call StringList -> StringList
;; GIVEN: a Call callexp and a list of String vars
;; WHERE: vars has the variables that are undefined before call callexp
;; RETURNS: a list of string that contains the variables that are undefined in
;;          Call callexp
;; EXAMPLE: (call-undefined-variables (call (var "x")
;;                                          (list (lit 5)
;;                                                (var "y"))) empty)
;;           => (list "x" "y")
;; STRATEGY: use observer template for Call on callexp and use simpler function
(define (call-undefined-variables callexp vars)
  (append (all-undefined-variables (call-operator callexp) vars)
          (call-operands-undefined-variables
           (call-operands callexp) vars)))

;; call-operands-undefined-variables : ArithmeticExpressionList StringList
;;                                      -> StringList
;; GIVEN: a list of arithmetic expressions operands and a list of String vars
;; WHERE: vars has the variables that are undefined before
;;        call-operands operands
;; RETURNS: a list of string that contains the variables that are undefined in
;;          arithmetic expression list operands
;; EXAMPLE: (call-operands-undefined-variables (list (var "a")
;;                                                   (lit 5)
;;                                                   (var "y")) empty)
;;           => (list "a" "y")
;; STRATEGY: use HOF foldr on operands
(define (call-operands-undefined-variables operands vars)
  (foldr all-undefined-variables vars operands))

;; block-undefined-variables : Block StringList -> StringList
;; GIVEN: a Block blockexp and a list of String vars
;; WHERE: vars has the variables that are undefined before block blockexp
;; RETURNS: a list of string that contains the variables that are undefined in
;;          Block blockexp
;; EXAMPLE: (block-undefined-variables (block (var "a")
;;                                            (var "x")
;;                                            (block (var "y")
;;                                                   (var "z")
;;                                                   (var "y"))) empty)
;;           => (list "x" "z")
;; STRATEGY: use helper function
(define (block-undefined-variables blockexp vars)
  (append
   (all-undefined-variables (block-rhs blockexp) vars)
   (block-body-undefined-variables blockexp vars)))

;; block-body-undefined-variables : Block StringList -> StringList
;; GIVEN: a Block b and a list of String vars
;; WHERE: vars has the variables that are undefined before block-body b
;; RETURNS: a list of string that contains the variables that are undefined in
;;          block-body of block b, with duplications
;; EXAMPLE: (block-body-undefined-variables (block (var "a")
;;                                                 (var "x")
;;                                                 (block (var "y")
;;                                                        (var "z")
;;                                                        (var "b")))
;;                                           (list "x"))
;;           => (list "z" "x" "b" "x")
;; STRATEGY: use HOF filter and helper function
(define (block-body-undefined-variables b vars)
  (local
    (; undefined? : String -> Boolean
     ; GIVEN: a String v
     ; RETURNS: true iff the String v is not a part of the list of all the
     ;          variables defined in block b
     (define (undefined? v)
       (not (member? v (variables-defined-by b)))))
    (filter undefined? (all-undefined-variables (block-body b) vars))))

;; TESTS:
;; Examples for test:
(define undefined-variables-z-x-f
  (call (var "f")
        (list (block (var "x")
                     (var "x")
                     (var "x"))
              (block (var "y")
                     (lit 7)
                     (var "y"))
              (var "z"))))

(define undefined-variables-z-a-b
  (call (var "b")
        (list (block (var "x")
                     (var "a")
                     (var "x"))
              (block (var "y")
                     (lit 7)
                     (op "*"))
              (var "z"))))
(begin-for-test
  (check-equal? (undefined-variables undefined-variables-z-x-f)
                (list "z" "x" "f")
                "(undefined-variables undefined-variables-z-x-f)
                  returned unexpected list")
  (check-equal? (undefined-variables undefined-variables-z-a-b)
                (list "z" "a" "b")
                "(undefined-variables undefined-variables-z-a-b)
                  returned unexpected list"))
