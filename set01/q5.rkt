;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; GOAL: To calculate the number of years it would take
;;       a microprocessor to perform double precision
;;       addition operation on all legal inputs.

(require rackunit)
(require "extras.rkt")
(check-location "01" "q5.rkt")

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:
;; NUMBER-OF-OPERATIONS represents the total number of double
;; precision addition operations.
(define NUMBER-OF-OPERATIONS (expt 2 128))

;; CONTRACT:
;; years-to-test : FLOPS -> PosReal

;; PURPOSE STATEMENT:
;; GIVEN   : The speed of microprocessor in FLOPS.
;; RETURNS : The approximate number of 365-day years it
;;           would take for the microprocessor to test
;;           the double precision addition operation on
;;           all legal inputs.

;; EXAMPLES:
;; (years-to-test (expt 10 20)) = 107902830708
;; (years-to-test (expt 3 50)) = 15030385

;; DESIGN STRATEGY:
;; Transcribe Formula.
;; Calculate the number of operations done per year
;; and divide that to the total number of operations
;; to get the number of years required.

;; FUNCTION DEFINITION:
(provide years-to-test)
(define (years-to-test f)
  (/ NUMBER-OF-OPERATIONS (flopy f)))

;; TESTS:
(begin-for-test
  (check-= (years-to-test (expt 10 20)) 107902830708.06014 0.00001
                "A microprocessor with the speed of 10^20 FLOPS 
                 should take approximately 107902830708 years 
                 to test the double precision addition operation 
                 on all legal inputs.")
  (check-= (years-to-test (expt 3 50)) 15030384.89562 0.00001
                "A microprocessor with the speed of 3^50 FLOPS 
                 should take approximately 15030385 years to test
                 to test the double precision addition operation 
                 on all legal inputs."))