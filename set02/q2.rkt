;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(provide
 initial-state
 next-state
 is-red?
 is-green?)
(check-location "02" "q2.rkt")

;; DATA DEFINITION :

;; Color:

;; a Color is represented by one of the following:
;; --"red"
;; --"green"
;; --"blank"
;; INTERPRETATION: self-evident

;; TEMPLATE :
;; color-fn : Color->??
;; (define (color-fn color)
;;  (cond
;;    [(string=? color "red") ...]
;;    [(string=? color "green") ...]
;;    [(string=? color "blank") ...]))

;; Timer:

;; A TimerState is represented a PositiveInteger
;; WHERE: 1 <= t <= 2*n
;; INTERPRETATION: time that has passed since the beginning of red state
;;                 measured in seconds,
;;                 resets to 1 after every 2*n seconds where n is the number
;;                 of seconds for which the traffic light initially remains red.
;; If t = n, then the color should change to green at the next second.
;; If t = 2*n - 3 then the color should change to blank at the next second.
;; If t = 2*n - 2 then the color should change to green at the next second.
;; If t = 2*n - 1 then the color should change to blank at the next second.
;; If t = 2*n then the color should change to red at the next second.

;; ChineseTrafficLight:

;; REPRESENTATION :
;; A ChineseTrafficLight is represented as (color timer n) with the
;; following fields:
;; color : Color represents the current color of traffic light.
;; timer : TimerState represents the current position of timer.
;; n : PosInt greater than 3 represents the interval for which 
;;     traffic light initially remains red.

;; IMPLEMENTATION :
(define-struct light (color timer n))

;; CONSTRUCTOR TEMPLATE:
;; (make-light Color TimerState PosInt)

;; OBSERVER TEMPLATE :
;; light-fn : ChineseTrafficLight -> ??
(define (light-fn c)
  (... (light-color l)
       (light-timer l)
       (light-n l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-state : PosInt -> ChineseTrafficSignal
;; GIVEN   : an integer n greater than 3
;; RETURNS : a representation of a Chinese traffic signal
;;     at the beginning of its red state, which will last
;;     for n seconds
;; EXAMPLE:
;;     (is-red? (initial-state 4))  =>  true
;; STRATEGY: Use constructor template for ChineseTrafficLight
(define (initial-state n)
  (make-light "red" 1 n))

;; TESTS:
(begin-for-test
  (check-equal? (is-red? (initial-state 4)) true
                "Chinese traffic light was not red")

  (check-equal? (initial-state 10) (make-light "red" 1 10)
                "Chinese traffic light was not properly created"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; timer-at-next-second : TimerState PosInt -> TimerState
;; GIVEN : A TimerState t and red state interval duration n
;; RETURNS : the TimerState at the next second
;; EXAMPLES:
;; (timer-at-next-second 5 20) = 6
;; (timer-at-next-second 20 10) = 1
;; STRATEGY: if t = 2*n then reset to 1, otherwise increment
(define (timer-at-next-second t n)
  (if (= t (+ n n))
      1
      (+ t 1)))

;; TESTS:
(begin-for-test
  (check-equal? (timer-at-next-second 5 20) 6
                "timer at next second should be 6")

  (check-equal? (timer-at-next-second 20 10) 1
                "timer at next second should be 1"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; color-at-next-second : Color TimerState PosInt -> Color
;; GIVEN: a Color c, TimerState t and red state interval duration n
;; RETURNS: the color of the traffic light at the next
;; second.
;; EXAMPLES:
;; (color-at-next-second "red" 4 4) = "green"
;; (color-at-next-second "green" 9 6) = "blank"
;; (color-at-next-second "blank" 12 7) = "green"
;; (color-at-next-second "green" 19 10) = "blank"
;; (color-at-next-second "blank" 12 6) = "red"
;; STRATEGY: cases on c : Color
;;           with nested
;;           cases on t: TimerState
(define (color-at-next-second c t n)
  (cond
    [(string=? c "red")
     (if (= t n) "green" "red")]
    [(string=? c "green")
     (if (or (= t (- (+ n n) 3)) (= t (- (+ n n) 1))) "blank"
         "green")]
    [(string=? c "blank")
     (cond
       [ (= t (- (+ n n) 2)) "green"]
       [ (= t (+ n n)) "red"])]))

;; TESTS:
(begin-for-test
  (check-equal? (color-at-next-second "red" 4 4) "green"
                "next color after red was not green")

  (check-equal? (color-at-next-second "green" 9 6) "blank"
                "next color after green was not blank")

  (check-equal? (color-at-next-second "blank" 12 7) "green"
                "next color after green was not blank")

  (check-equal? (color-at-next-second "green" 19 10) "blank"
                "next color after green was not blank")

  (check-equal? (color-at-next-second "blank" 12 6) "red"
                "next color after blank was not red"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; next-state : ChineseTrafficSignal -> ChineseTrafficSignal
;; GIVEN   : a representation of a traffic signal in some state
;; RETURNS : the state that traffic signal should have one
;;           second later
;; STRATEGY: Use constructor template for ChineseTrafficLight with
;;           simpler functions.
(define (next-state light)
  (make-light (color-at-next-second(light-color light)
                                   (light-timer light)
                                   (light-n light))
              (timer-at-next-second (light-timer light)
                                    (light-n light))
              (light-n light)))

;; TESTS:
(begin-for-test
  (check-equal? (next-state (make-light "red" 4 4))
                (make-light "green" 5 4)
                "next state after red should be green")

  (check-equal? (next-state (make-light "green" 7 5))
                (make-light "blank" 8 5)
                "next state after green should be blank")

  (check-equal? (next-state (make-light "blank" 10 6))
                (make-light "green" 11 6)
                "next state after blank should be green")

  (check-equal? (next-state (make-light "green" 13 7))
                (make-light "blank" 14 7)
                "next state after green should be blank")
  
  (check-equal? (next-state (make-light "blank" 16 8))
                (make-light "red" 1 8)
                "next state after blank should be red"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;; is-red? : ChineseTrafficSignal -> Boolean
;; GIVEN   : a representation of a traffic signal in some state
;; RETURNS : true if and only if the signal is red
;; EXAMPLES:
;;     (is-red? (next-state (initial-state 4)))  =>  true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state (initial-state 4)))))  =>  true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state (initial-state 4))))))  =>  false
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state
;;          (next-state (initial-state 4)))))))  =>  false
;; STRATEGY: Use observer template for ChineseTrafficLight
(define (is-red? light)
  (string=? (light-color light) "red"))

;; TESTS:
(begin-for-test
  (check-equal? (is-red? (initial-state 4)) true
                "color at the beginning should be red")

  (check-equal? (is-red? (next-state
                          (next-state
                           (next-state
                            (next-state
                             (initial-state 4)))))) false
                 "color after 4 seconds should not be red"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; is-green? : ChineseTrafficSignal -> Boolean
;; GIVEN   : a representation of a traffic signal in some state
;; RETURNS : true if and only if the signal is green
;; EXAMPLES:
;;     (is-green?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state (initial-state 4))))))  =>  true
;;     (is-green?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state
;;          (next-state (initial-state 4)))))))  =>  false
;; STRATEGY: Use observer template for ChineseTrafficLight
(define (is-green? light)
  (string=? (light-color light) "green"))

;; TESTS:
(begin-for-test
  (check-equal? (is-green? (next-state
                            (next-state
                             (next-state
                              (next-state
                               (initial-state 4)))))) true
                 "color after 4 seconds should be green")
  
  (check-equal? (is-green? (next-state
                            (next-state
                             (next-state
                              (next-state
                               (next-state
                                (initial-state 4))))))) false
                 "color after 4 seconds should not be green"))