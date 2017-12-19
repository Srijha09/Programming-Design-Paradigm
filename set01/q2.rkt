;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; GOAL: To convert furlongs into barleycorns.

(require rackunit)
(require "extras.rkt")
(check-location "01" "q2.rkt")

;; DATA DEFINITIONS:
;; REPRESENTATION AND INTERPRETATION: 
;; A FurlongLength is represented as PosReal,
;; measured in furlongs.
;; A BarleycornLength is represented as PosReal,
;; measured in barleycorns.
;; FURLONGS-IN-BARLEYCORN represents the number of
;; furlongs in one barleycorn.
(define FURLONGS-IN-BARLEYCORN (* 10 4 16.5 12 3))

;; CONTRACT:
;; furlongs-to-barleycorns : FurlongLength -> BarleycornLength

;; PURPOSE STATEMENT:
;; RETURNS : The equivalent number of barleycorns in a given furlong length.

;; EXAMPLES:
;; (furlongs-to-barleycorns 1) = 23760
;; (furlongs-to-barleycorns 999.99) = 23759762.4

;; DESIGN STRATEGY:
;; Transcribe Formula

;; FUNCTION DEFINITION:
(provide furlongs-to-barleycorns)
(define (furlongs-to-barleycorns x)
        (* FURLONGS-IN-BARLEYCORN x))

;; TESTS:
(begin-for-test
  (check-equal? (furlongs-to-barleycorns 1) 23760
                "1 furlong should be 23760 barleycorns.")
  (check-equal? (furlongs-to-barleycorns 999.99) 23759762.4
                "999 furlongs should be 23759762.4 barleycorns."))
  


