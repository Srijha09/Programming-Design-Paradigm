;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; GOAL: To calculate the number of operations a
;;       microprocessor can perform in a year.

(require rackunit)
(require "extras.rkt")
(check-location "01" "q4.rkt")

;; DATA DEFINITIONS:
;; REPRESENTATION AND INTERPRETATION:
;; A FLOPS is represented as PosReal,
;; measured as the number of floating point operations
;; a microprocessor can perform per second.
;; A yearFLOPS is represented as PosReal,
;; measured as the number of floating point operations
;; a microprocessor can perform in one 365-day year.
;; DAYS-IN-A-YEAR represents the number of days in a year.
(define DAYS-IN-A-YEAR 365)
;; HOURS-IN-A-DAY represents the number of hours in a day.
(define HOURS-IN-A-DAY 24)
;; MINUTES-IN-AN-HOUR represents the number of minutes in an hour.
(define MINUTES-IN-AN-HOUR 60)
;; SECONDS-IN-A-MINUTE represents the number of seconds in a minute.
(define SECONDS-IN-A-MINUTE 60)

;; CONTRACT:
;; flopy : FLOPS -> yearFLOPS

;; PURPOSE STATEMENT:
;; RETURNS : The number of floating point operations a
;;           microprocessor can perform in one 365-day
;;           year, given the number of floating point
;;           operations it can perform per second(FLOPS).

;; EXAMPLES:
;; (flopy 0.5) = 15768000
;; (flopy 10) = 315360000

;; DESIGN STRATEGY:
;; Transcribe Formula.

;; FUNCTION DEFINITION:
(provide flopy)
(define (flopy f)
  (* DAYS-IN-A-YEAR HOURS-IN-A-DAY
     MINUTES-IN-AN-HOUR SECONDS-IN-A-MINUTE f))

;; TESTS:
(begin-for-test
  (check-equal? (flopy 0.5) 15768000
                "0.5 floating point operations per second
                 should be 15768000 floating point operations
                 per year.")
  (check-equal? (flopy 10) 315360000
                "10 floating point operations per second
                 should be 315360000 floating point operations
                 per year."))