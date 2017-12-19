;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; GOAL: To convert temperature from Kelvin to Fahrenheit.

(require rackunit)
(require "extras.rkt")
(check-location "01" "q3.rkt")

;; DATA DEFINITIONS:
;; REPRESENTATION AND INTERPRETATION: 
;; A KelvinTemp is represented as Real,
;; measured in Kelvin.
;; A FahrenheitTemp is represented as Real,
;; measured in degrees fahrenheit.

;; CONTRACT:
;; kelvin-to-fahrenheit : KelvinTemp -> FahrenheitTemp

;; PURPOSE STATEMENT:
;; RETURNS : The equivalent temperature in degrees Fahrenheit given a temperature in Kelvin.

;; EXAMPLES:
;; (kelvin-to-fahrenheit 0) = -459.67
;; (kelvin-to-fahrenheit 273.15) = 32

;; DESIGN STRATEGY:
;; Transcribe Formula.

;; FUNCTION DEFINITION:
(provide kelvin-to-fahrenheit)
(define (kelvin-to-fahrenheit k)
        (+ (* k 9/5) -459.67))

;; TESTS:
(begin-for-test
  (check-equal? (kelvin-to-fahrenheit 0) -459.67
                "0 Kelvin should be -459.67 degrees Fahrenheit.")
  (check-equal? (kelvin-to-fahrenheit 273.15) 32
                "273.15 Kelvin should be 32 degrees Fahrenheit."))