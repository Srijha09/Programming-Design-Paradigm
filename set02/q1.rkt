;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(provide
 make-lexer
 lexer-token
 lexer-input
 initial-lexer
 lexer-stuck?
 lexer-shift
 lexer-reset)
(check-location "02" "q1.rkt")


;; DATA DEFINITIONS

;; REPRESENTATION:
;; A Lexer is represented as (token input) with the
;; following fields:
;; token : String   the token string of Lexer.
;;              (any string will do)
;; input : String   the input string of Lexer.
;;              (any string will do)

;; IMPLEMENTATION:
(define-struct lexer (token input))

;; CONSTRUCTOR TEMPLATE:
;; (make-lexer String String)

;; OBSERVER TEMPLATE:
;; lexer-fn : Lexer -> ??
(define (lexer-fn l)
  (... (lexer-token l)
       (lexer-input l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make-lexer : String String -> Lexer
;; GIVEN: two strings s1 and s2
;; RETURNS: a Lexer whose token string is s1
;;     and whose input string is s2
;; STRATEGY: Defined by Racket when a structure named lexer
;;           with fields token and input is created.

;; lexer-token : Lexer -> String
;; GIVEN: a Lexer
;; RETURNS: its token string
;; EXAMPLE:
;;     (lexer-token (make-lexer "abc" "1234")) =>  "abc"
;; STRATEGY: Defined by Racket when a structure named lexer
;;           with fields token and input is created.

;; lexer-input : Lexer -> String
;; GIVEN: a Lexer
;; RETURNS: its input string
;; EXAMPLE:
;;     (lexer-input (make-lexer "abc" "1234")) =>  "1234"
;; STRATEGY: Defined by Racket when a structure named lexer
;;           with fields token and input is created.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-lexer : String -> Lexer
;; GIVEN: an arbitrary string
;; RETURNS: a Lexer lex whose token string is empty
;;     and whose input string is the given string
;; STRATEGY: Use constructor template for Lexer.
(define (initial-lexer s)
  (make-lexer "" s))

;; TESTS:
(begin-for-test
           (check-equal? (initial-lexer "abc") (make-lexer "" "abc")
                         "Lexer should have empty token string
                          and 'abc' as input string")
           (check-equal? (initial-lexer "") (make-lexer "" "")
                         "Lexer should have empty token string
                          and empty input string"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; alphabet-digit? : String -> Boolean
;; GIVEN: a string s
;; RETURNS: true iff the string s begins with either a character
;;          or an integer.
;; EXAMPLES:
;;     (alphabet-digit? "abc") => true
;;     (alphabet-digit? "123") => true
;;     (alphabet-digit? "#13") => false
;; STRATEGY: Use string functions to check the first character
;;           of given string.         

(define (alphabet-digit? s)
  (or
   (string-alphabetic? (substring s 0 1))
   (string-numeric? (substring s 0 1))))

;; TESTS:
(begin-for-test
  (check-equal? (alphabet-digit? "abc") true
                "'a' is a character therefore the function should return true")
  (check-equal? (alphabet-digit? "123") true
                "'1' is an integer therefore the function should return true")
  (check-equal? (alphabet-digit? "#13") false
                "'#' is neither a character nor an integer
                 therefore the function should return false"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lexer-stuck? : Lexer -> Boolean
;; GIVEN: a Lexer
;; RETURNS: false if and only if the given Lexer's input string
;;     is non-empty and begins with an English letter or digit;
;;     otherwise returns true.
;; EXAMPLES:
;;     (lexer-stuck? (make-lexer "abc" "1234"))  =>  false
;;     (lexer-stuck? (make-lexer "abc" "+1234"))  =>  true
;;     (lexer-stuck? (make-lexer "abc" ""))  =>  true
;; STRATEGY: Cases on lexer-input.

(define (lexer-stuck? lexer)
  (if
   (= (string-length (lexer-input lexer)) 0)
   true
   (not (alphabet-digit? (lexer-input lexer)))))

;; TESTS:
(begin-for-test
  (check-equal? (lexer-stuck? (make-lexer "abc" "1234")) false
                "input string of Lexer is non-empty and begins with '1'
                 therefore it should not be stuck")
  (check-equal? (lexer-stuck? (make-lexer "abc" "+1234")) true
                "input string of Lexer is non-empty but begins with '+'
                 therefore it should be stuck")
  (check-equal? (lexer-stuck? (make-lexer "abc" "")) true
                "input string of Lexer is empty therefore it should be stuck"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove-first: String -> String
;; GIVEN: a String s
;; RETURNS: the String s with its first character removed
;; EXAMPLES:
;;     (remove-first "abc") => "bc"
;;     (remove-first " 13") => "13"
;;     (remove-first "#13") => "13"
;; STRATEGY: Extract all but the first character of
;;           given string as a substring.

(define (remove-first s)
  (substring s 1))

;; TESTS:
(begin-for-test
  (check-equal? (remove-first "abc") "bc"
                "String returned should be 'bc' after removing
                 the first character from 'abc'")
  (check-equal? (remove-first " 13") "13"
                "String returned should be '13' after removing
                 the first character from ' 13'")
  (check-equal? (remove-first "#13") "13"
                "String returned should be '13' after removing
                 the first character from '#13'"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lexer-shift : Lexer -> Lexer
;; GIVEN: a Lexer
;; RETURNS:
;;   If the given Lexer is stuck, returns the given Lexer.
;;   If the given Lexer is not stuck, then the token string
;;       of the result consists of the characters of the given
;;       Lexer's token string followed by the first character
;;       of that Lexer's input string, and the input string
;;       of the result consists of all but the first character
;;       of the given Lexer's input string.
;; EXAMPLES:
;;     (lexer-shift (make-lexer "abc" ""))
;;         =>  (make-lexer "abc" "")
;;     (lexer-shift (make-lexer "abc" "+1234"))
;;         =>  (make-lexer "abc" "+1234")
;;     (lexer-shift (make-lexer "abc" "1234"))
;;         =>  (make-lexer "abc1" "234")
;; STRATEGY: Cases on lexer-stuck?

(define (lexer-shift lexer)
  (if
   (lexer-stuck? lexer)
   (make-lexer
    (lexer-token lexer)
    (lexer-input lexer))
   
   (make-lexer
    (string-append (lexer-token lexer)
                   (substring (lexer-input lexer) 0 1))
    (remove-first(lexer-input lexer)))))

;; TESTS:
(begin-for-test
  (check-equal? (lexer-shift (make-lexer "abc" ""))
                (make-lexer "abc" "")
                "Lexer is stuck, should return the given Lexer.")
  (check-equal? (lexer-shift (make-lexer "abc" "+1234"))
                (make-lexer "abc" "+1234")
                "Lexer is stuck, should return the given Lexer.")
  (check-equal? (lexer-shift (make-lexer "abc" "1234"))
                (make-lexer "abc1" "234")
                "Lexer is not stuck, should not the given Lexer."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;; lexer-reset : Lexer -> Lexer
;; GIVEN: a Lexer
;; RETURNS: a Lexer whose token string is empty and whose
;;     input string is empty if the given Lexer's input string
;;     is empty and otherwise consists of all but the first
;;     character of the given Lexer's input string.
;; EXAMPLES:
;;     (lexer-reset (make-lexer "abc" ""))
;;         =>  (make-lexer "" "")
;;     (lexer-reset (make-lexer "abc" "+1234"))
;;         =>  (make-lexer "" "1234")
;; STRATEGY: Cases on lexer-input

(define (lexer-reset lexer)
  (if
   (= (string-length (lexer-input lexer)) 0)
   (make-lexer "" "")

   (make-lexer ""
               (remove-first(lexer-input lexer)))))

;; TESTS:
(begin-for-test
  (check-equal? (lexer-reset (make-lexer "abc" ""))
                (make-lexer "" "")
                "input string of the given Lexer is empty,
                 should return a Lexer with both fields empty.")
  (check-equal? (lexer-reset (make-lexer "abc" "+1234"))
                (make-lexer "" "1234")
                "input string of the given Lexer is not-empty,
                 should return a lexer with empty token field and
                 input field as input string with the first character
                 removed."))