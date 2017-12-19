;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q1.rkt")

;; DATA DEFINITION:
;; REPRESENTATION AND INTERPRETATION: 
;; The Height of pyramid is represented as Real,
;; measured in meters.
;; The Length of one side of square bottom of pyramid is represented as Real,
;; measured in meters.
;; The Volume of pyramid is represented as Real,
;; measured in cubic meters.

;; CONTRACT:
;; pyramid-volume : Height Length -> Volume

;; PURPOSE STATEMENT:
;; RETURNS : The Volume of pyramid calculated using the Height
;;           and the Length of one side of square bottom of pyramid.

;; EXAMPLES:
;; (pyramid-volume 1 1) = 1/3
;; (pyramid-volume 10 20) = 2000/3

;; DESIGN STRATEGY:
;; Transcribe Formula

;; FUNCTION DEFINITION:
(provide pyramid-volume)
(define (pyramid-volume x h)
  (/ (* x x h) 3))

;; TESTS:
(begin-for-test
  (check-equal? (pyramid-volume 1 1) 1/3
                "The Volume of the pyramid with Height 1 meter and Length
                 of one side of square bottom of pyramid as 1 meter should
                 be 1/3 cubic meters.")
  (check-equal? (pyramid-volume 10 20) 2000/3
                "The Volume of the pyramid with Height 20 meter and Length
                 of one side of square bottom of pyramid as 10 meter should
                 be 2000/3 cubic meters."))
  
