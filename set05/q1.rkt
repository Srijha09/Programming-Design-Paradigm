;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

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
   block?)

(check-location "05" "q1.rkt")

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

;; An ArithmeticExpressionList is either -
;; --empty
;; -- (cons ArithmeticExperssion ArithmeticExpressionList)

;; OBSERVER TEMPLATE:
;; arithmetic-expression-list-fn : ArithmeticExpressionList -> ??
#; (define (arithmetic-expression-list-fn aelist)
     (cond
       [(empty? aelist) ...]
       [else (... (arithmetic-expression-fn (first aelist))
                  (arithmetic-expression-list-fn (rest aelist)))]))

;; Variable:

;; REPRESENTATION:
;; A Variable is represented as a struct
;; (make-variable name)
;; INTERPRETATION:
;; name : String - is the name of variable (any string will do)

;; IMPLEMENTATION:
(define-struct variable (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-variable String)

;; OBSERVER TEMPLATE:
;; variable-fn : Variable -> ??
#; (define (variable-fn n)
     (... (variable-name n)))

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
  (make-variable v))
          
;; variable-name : Variable -> String
;; GIVEN: a variable
;; RETURNS: the name of that variable
;; EXAMPLE: (variable-name (var "x15")) => "x15"
;; STRATEGY: Defined by DrRacket when a structure named variable
;;           with field name is created

;; TESTS:
(begin-for-test
  (check-equal? (var "x15") (make-variable "x15")
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
;;             -> ArithmeticExpression
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
                                                             