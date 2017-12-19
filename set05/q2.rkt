;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
 block?
 variables-defined-by
 variables-used-by
 constant-expression?
 constant-expression-value
 )

(check-location "05" "q2.rkt")

;; An OperationName is represented as one of the following strings:
;;     -- "+"      (indicating addition)
;;     -- "-"      (indicating subtraction)
;;     -- "*"      (indicating multiplication)
;;     -- "/"      (indicating division)

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
;; value : Real - is the value of this literal

;; IMPLEMENTATION:
(define-struct literal (value))

;; CONSTRUCTOR TEMPLATE:
;; (make-literal Real)

;; OBSERVER TEMPLATE:
;; literal-fn : Literal -> ??
#; (define (literal-fn r)
     (... (literal-value r)))

;; Variable:

;; REPRESENTATION:
;; A Variable is represented as a struct
;; (make-variable name)
;; INTERPRETATION:
;; name : String - is the name of variable
;;                (consists of only letters and digits)

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
;; name : OperationName - is the name of operation

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
;; operator : ArithmeticExpression - is the operator expression of this call
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

;; ArithmeticExpressionList:

;; An ArithmeticExpressionList is either -
;; -- empty
;; -- (cons ArithmeticExperssion ArithmeticExpressionList)

;; OBSERVER TEMPLATE:
;; arithmetic-expression-list-fn : ArithmeticExpressionList -> ??
#; (define (arithmetic-expression-list-fn aelist)
     (cond
       [(empty? aelist) ...]
       [else (... (arithmetic-expression-fn (first aelist))
                  (arithmetic-expression-list-fn (rest aelist)))]))

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

;; An OperationExpression is one of
;;     -- an Operation
;;     -- a Block

;; OBSERVER TEMPLATE:
;; operation-expression-fn : OperationExpression -> ??
#; (define (operation-expression-fn exp)
     (cond ((operation? exp) ...)
           ((block? exp) ...)))

;; An ConstantExpression is one of
;;     -- a Literal
;;     -- a Call
;;     -- a Block

;; OBSERVER TEMPLATE:
;; constant-expression-fn : ConstantExpression -> ??
#; (define (arithmetic-expression-fn exp)
     (cond ((literal? exp) ...)
           ((call? exp) ...)
           ((block? exp) ...)))

;; StringList:

;; A StringList is one of
;; -- empty
;; -- (cons String StringList)

;; OBSERVER TEMPLATE:
;; string-list-fn : StringList -> ??
#; (define (string-list-fn s)
     (cond
       [(empty? s) ...]
       [else (... (first s)
                  (string-list-fn (rest s)))]))

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
;; STRATEGY: use constructor template for Call and Block on c and b

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

;; variables-used-in-call : ArithmeticExpression ArithmeticExpressionList
;;                     -> StringList
;; GIVEN: an arithmetic expression operator and
;;        a list of arithmetic expressions operands
;; RETURNS: a list of variable names defined by
;;          all blocks that occur within the expressions
;; EXAMPLE: (variables-used-in-call (block (var "a") (var "x") (op "+"))
;;                              (list (block (var "b") (lit 5) (var "x"))))
;;           => (list "x")
;; STRATEGY: use observer template for Call
(define (variables-used-in-call operator operands)
  (append (variables-used-by operator)
          (variables-used-in-call-list operands)))

;; variables-used-in-call-list : ArithmeticExpressionList -> StringList
;; GIVEN: a list of arithmetic expressions operands
;; RETURNS: a list of variable names defined by
;;          all blocks that occur within the list
;; EXAMPLE: (variables-used-in-call-list (list
;;                                        (block (var "a") (lit 1) (var "x"))
;;                                        (block (var "b") (var "p") (lit 2))
;;                                        (block (var "c") (var "q") (lit 1))))
;;          => (list "p" "q")
;; STRATEGY: use observer template for ArithmeticExpressionList on operands
(define (variables-used-in-call-list operands)
  (cond
    [(empty? operands) empty]
    [else (append (variables-used-by (first operands))
                  (variables-used-in-call-list (rest operands)))]))

;; variables-used-by : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables used in
;;     the expression, including variables used in a block
;;     on the right hand side of its definition or in its body,
;;     but not including variables defined by a block unless
;;     they are also used
;; EXAMPLE: 
;;     (variables-used-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "x" "y") or (list "y" "x")
;; STRATEGY: use observer template for ArithmeticExpression on exp
(define (variables-used-by exp)
  (remove-duplicates
   (cond
    [(literal? exp) empty]
    [(variable? exp) (cons (variable-name exp) empty)]
    [(operation? exp) empty]
    [(call? exp)
     (variables-used-in-call (call-operator exp) (call-operands exp))]
    [(block? exp)
     (append(variables-used-by (block-rhs exp))
            (variables-used-by (block-body exp)))])))

;; TESTS:
;; example for test:
(define block-var-used-x-y
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
  (check-equal? (variables-used-by block-var-used-x-y)
                (list "x" "y")
                "(variables-used-by block-var-used-x-y)
                  returned unexpected list"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-call : ArithmeticExpression -> Boolean
;; GIVEN: a Call expression exp
;; RETURNS: true iff exp satisfies the conditions for constant-expression
;; EXAMPLE: (check-call (call (call (op "+") 
;;                                  (list (lit 4) (lit 5)))
;;                                  (list (lit 4) (lit 5)))) => #true
;; STRATEGY: divide into cases
(define (check-call exp)
  (cond
    [(operation? exp) #true]
    [(block? exp)
      (if
      (operation? (block-body exp))
      #true
      (check-call (block-body exp)))]
    [else #false]))

;; check-call-operands: ArithmeticExpressionList -> Boolean
;; GIVEN: a Call operand
;; RETURNS: true iff all the elements of the list are constant-expression
;; EXAMPLE: (check-call-operands (list (lit 4) (lit 5))) => #true
;;          (check-call-operands (list (var "a") (lit 5))) => #false
;; STRATEGY: use observer teplate for ArithmeticExpression on operands
(define (check-call-operands operands)
  (cond
    [(empty? operands) #true]
    [else (and
           (constant-expression? (first operands))
           (check-call-operands (rest operands)))]))

;; check-block : Block -> Boolean
;; GIVEN: a Block expression
;; RETURNS: true iff all the expressions in block b are constant-expression
;; EXAMPLE: (check-block (block (var "z")
;;                              (call (op "*")
;;                              (list (var "x") (var "y")))
;;                              (op "+"))) => #false
;;          (check-block (block (var "x")
;;                              (var "y")
;;                              (call (call (op "+") 
;;                                          (list (lit 4) (lit 5)))
;;                                          (list (lit 4) (lit 5))))) => #true
;; STRATEGY: use observer template for Block on b
(define (check-block b)
  (constant-expression? (block-body b)))

;; constant-expression? : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only if the expression is a constant
;;     expression
;; EXAMPLES:
;;     (constant-expression?
;;      (call (var "f") (list (lit -3) (lit 44))))
;;         => false
;;     (constant-expression?
;;      (call (op "+") (list (var "x") (lit 44))))
;;         => false
;;     (constant-expression?
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (call (op "*")
;;                                (list (var "x") (var "y")))
;;                          (op "+"))
;;                   (list (lit 3)
;;                         (call (op "*")
;;                               (list (lit 4) (lit 5)))))))
;;         => true
;; STRATEGY: use observer template for ArithmeticExpression on exp
(define (constant-expression? exp)
  (cond
    [(call? exp)
     (and (check-call (call-operator exp))
          (check-call-operands (call-operands exp)))]
    [(block? exp) (check-block exp)]
    [(literal? exp) #true]
    [(variable? exp) #false]
    [(operation? exp) #false]))

;; TESTS:
(define constant-expression-example
  (block (var "x")
         (var "y")
         (call
          (block (var "z")
                 (call
                  (op "*")
                  (list (var "x")
                        (var "y")))
                 (op "+"))
          (list (lit 3)
                (call (op "*")
                      (list (lit 4)
                            (lit 5)))))))

(define constant-expression-example-2
  (block (var "x")
         (var "y")
         (call
          (block (var "z")
                 (call
                  (block (var "x")
                         (var "y")
                         (op "*"))
                  (list (var "x")
                        (var "y")))
                 (call (op "*")
                      (list (lit 4)
                            (lit 5))))
         (list (var "x")))))


(begin-for-test
  (check-equal? (constant-expression? constant-expression-example)
                #true
                "(constant-expression? constant-expression-example)
                  should be true")
  (check-equal? (constant-expression? (call (var "f") (list (lit -3) (lit 44))))
                #false
                "(call (var f) (list (lit -3) (lit 44)))
                 should be false")
  (check-equal? (constant-expression? (call (op "+") (list (var "x") (lit 44))))
                #false
                "(call (op +) (list (var x) (lit 44))
                 should be false")
  (check-equal? (constant-expression? (call (op "+") (list (op "+") (lit 44))))
                #false
                "(call (op +) (list (var x) (lit 44))
                 should be false")
  (check-equal? (constant-expression? constant-expression-example-2)
                #false
                "(constant-expression? constant-expression-example-2)
                  should be false"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; get-call-expression-value : Call -> Real
;; GIVEN: a Call expression c
;; RETURNS: the numerical value of the Call expression
;; EXAMPLE: (get-call-expression-value
;;                 (call (op "/") (list (lit 15) (lit 3)))) => 5
;; STRATEGY: use observer template for ArithmeticExpression on c
(define (get-call-expression-value c)
  (cond
    [(operation? (call-operator c)) (evaluate-call c)]
    [(block? (call-operator c))
     (evaluate-call (call (operation-in-block (call-operator c))
                          (call-operands c)))]))
     
;; evaluate-call : Call -> Real
;; GIVEN: a Call expression c
;; RETURNS: the numerical value of the Call expression
;; EXAMPLE: (evaluate-call (call (op "*") (list (lit 2) (lit 3)))) => 6
;; STRATEGY: use observer template for Operation on c
(define (evaluate-call c)
  (cond [(string=? (operation-name (call-operator c)) "+")
         (perform-addition (call-operands c))]
        [(string=? (operation-name (call-operator c)) "-")
         (perform-subtraction (call-operands c))]
        [(string=? (operation-name (call-operator c)) "*")
         (perform-multiplication (call-operands c))]
        [(string=? (operation-name (call-operator c)) "/")
         (perform-division (call-operands c))]))

;; operation-in-block : Block -> Operation
;; GIVEN: a Block b
;; RETURNS: the operation in body of Block b
;; EXAMPLE: (operation-in-block (block (var "z")
;;                                     (var "y")
;;                                     (block (var "z")
;;                                            (var "y")
;;                                            (op "+"))) => (op "+")
;; STRATEGY: divide into cases
(define (operation-in-block b)
  (cond
    [(operation? (block-body b)) (block-body b)]
    [else
     (operation-in-block (block-body b))]))
 
;; perform-addition : ArithmeticExpressionList -> Real
;; GIVEN: a list of ArithmeticExpression
;; RETURNS: addition of all the literals in the list
;; EXAMPLE: (perform-addition (list (lit 3) (lit 2))) => 5
;; STRATEGY: divide into cases and use helper functions
(define (perform-addition operands)
  (cond
    [(empty? operands) 0]
    [(literal? (first operands)) (+ (literal-value (first operands))
                                    (perform-addition (rest operands)))]
    [else (+ (constant-expression-value(first operands))
             (perform-addition (rest operands)))])) 

;; perform-subtraction : ArithmeticExpressionList -> Real
;; GIVEN: a list of ArithmeticExpression
;; RETURNS: subtraction of all the literals in the list
;; EXAMPLE: (perform-subtraction (list (lit 3) (lit 2))) => 1
;; STRATEGY: divide into cases and use helper functions
(define (perform-subtraction operands)
  (cond
    [(empty? operands) 0]
    [(literal? (first operands)) (- (literal-value (first operands))
                                    (perform-subtraction (rest operands)))]
    [else (- (constant-expression-value(first operands))
             (perform-subtraction (rest operands)))]))


;; perform-division : ArithmeticExpressionList -> Real
;; GIVEN: a list of ArithmeticExpression
;; RETURNS: division of all the literals in the list
;; EXAMPLE: (perform-division (list (lit 3) (lit 3))) => 1
;; STRATEGY: divide into cases and use helper functions
(define (perform-division operands)
  (cond
    [(empty? operands) 1]
    [(literal? (first operands)) (/ (literal-value (first operands))
                                    (perform-division (rest operands)))]
    [else (/ (constant-expression-value(first operands))
             (perform-division (rest operands)))]))

;; perform-multiplication : ArithmeticExpressionList -> Real
;; GIVEN: a list of ArithmeticExpression
;; RETURNS: multiplication of all the literals in the list
;; EXAMPLE: (perform-multiplication (list (lit 3) (lit 2))) => 6
;; STRATEGY: divide into cases and use helper functions
(define (perform-multiplication operands)
  (cond
    [(empty? operands) 1]
    [(literal? (first operands)) (* (literal-value (first operands))
                                    (perform-multiplication (rest operands)))]
    [else (* (constant-expression-value(first operands))
             (perform-multiplication (rest operands)))]))

;; constant-expression-value : ArithmeticExpression -> Real
;; GIVEN: an arithmetic expression
;; WHERE: the expression is a constant expression
;; RETURNS: the numerical value of the expression
;; EXAMPLES:
;;     (constant-expression-value
;;      (call (op "/") (list (lit 15) (lit 3))))
;;         => 5
;;     (constant-expression-value
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (call (op "*")
;;                                (list (var "x") (var "y")))
;;                          (op "+"))
;;                   (list (lit 3)
;;                         (call (op "*")
;;                               (list (lit 4) (lit 5)))))))
;;         => 23
;; STRATEGY: use obserever template for ConstantExpression on exp
(define (constant-expression-value exp)
  (cond [(call? exp) (get-call-expression-value exp)]
        [(block? exp) (constant-expression-value (block-body exp))]
        [(literal? exp) (literal-value exp)]))

;; TESTS:
;; example for test:
(define value-23
  (block (var "x")
         (var "y")
         (call (block (var "z")
                      (call (op "*")
                            (list (var "x") (var "y")))
                      (op "+"))
               (list (lit 3)
                     (call (op "*")
                           (list (lit 4) (lit 5)))))))

(define value-17
  (block (var "x")
         (var "y")
         (call (block (var "z")
                      (call (op "*")
                            (list (var "x") (var "y")))
                      (op "-"))
               (list (lit 37)
                     (call (op "*")
                           (list (lit 4) (lit 5)))))))

(define value-18
  (block (var "x")
         (var "y")
         (call (block (var "z")
                      (call (op "*")
                            (list (var "x") (var "y")))
                      (op "*"))
               (list (lit 2)
                     (call (op "+")
                           (list (lit 4) (lit 5)))))))

(define value-2
  (block (var "x")
         (var "y")
         (call (block (var "z")
                      (call (op "*")
                            (list (var "x") (var "y")))
                      (op "/"))
               (list (lit 40)
                     (call (op "*")
                           (list (lit 4) (lit 5)))))))

(define value-13
  (block (var "x")
         (var "y")
         (call (block (var "x")
                      (call (op "*")
                            (list (var "y") (var "z")))
                      (block
                       (var "y")
                       (var "x")
                       (block
                        (var "z")
                        (var "y")
                        (op "-"))))
               (list (lit 16) (lit 3)))))
  

(begin-for-test
  (check-equal? (constant-expression-value
                 (call (op "/") (list (lit 15) (lit 3)))) 5
                 "(constant-expression-value
                 (call (op /) (list (lit 15) (lit 3))))
                 should be 5")
  (check-equal? (constant-expression-value value-23) 23
                "(constant-expression-value value-23
                 should be 23")
  (check-equal? (constant-expression-value value-17) 17
                "(constant-expression-value value-17
                 should be 17")
  (check-equal? (constant-expression-value value-18) 18
                "(constant-expression-value value-18
                 should be 18")
  (check-equal? (constant-expression-value value-2) 2
                "(constant-expression-value value-2
                 should be 2")
  (check-equal? (constant-expression-value (lit 5)) 5
                "(constant-expression-value (lit-5)
                 should be 5")
  (check-equal? (constant-expression-value value-13) 13
                "(constant-expression-value value-13
                 should be 13"))                                         