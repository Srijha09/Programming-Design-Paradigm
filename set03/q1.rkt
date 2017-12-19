;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; simulation of a squash player practicing without an opponent

;; start with (simulation speed)
;; press space to start the game
;; press space during game to reset the game
;; use arrow keys to move the racket

(require rackunit)
(require "extras.rkt")

(require 2htdp/universe)
(require 2htdp/image)
(provide
 simulation
 initial-world
 world-ready-to-serve?
 world-after-tick
 world-after-key-event
 world-ball
 world-racket
 ball-x
 ball-y
 racket-x
 racket-y
 ball-vx
 ball-vy
 racket-vx
 racket-vy)

(check-location "03" "q1.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS:

;; dimensions of the canvas, in pixels
(define CANVAS-WIDTH 425)
(define CANVAS-HEIGHT 649)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define YELLOW-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT "yellow"))

;; dimensions of the ball and racket
(define BALL-RADIUS 3)
(define RACKET-WIDTH 47)
(define RACKET-HEIGHT 7)
(define RACKET-HALF-WIDTH 23.5)

;; constants to adjust the position of racket
(define RACKET-LEFT-WALL-ADJUSTED 24)
(define RACKET-RIGHT-WALL-ADJUSTED 402)

;; ball and racket image
(define BALL-IMAGE (circle BALL-RADIUS "solid" "black"))
(define RACKET-IMAGE (rectangle RACKET-WIDTH RACKET-HEIGHT "solid" "green"))

;; starting co-ordinates for ball and racket
(define X-START 330)
(define Y-START 384)

;; duration of pause
(define DURATION-OF-PAUSE 3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; REPRESENTATION:
;; A World is represented as a struct (ball racket paused? state timer speed)
;; with following fields:
;; ball : Ball  is the squash ball in the world
;; racket : Racket  is the racket in the world
;; paused? : Boolean  is the world paused?
;; state : State of the squash game
;; timer : PosInt is the timer used to measure 3 seconds
;; speed : PosReal is the speed of the simulation

;; IMPLEMENTATION:
(define-struct world (ball racket paused? state timer speed))

;; CONSTRUCTOR TEMPLATE:
;; (make-world Ball Racket Boolean State PosInt PosReal)

;; OBSERVER TEMPLATE:
;; world-fn : World -> ??
(define (world-fn w)
  (... (world-ball w)
       (world-racket w)
       (world-paused? w)
       (world-timer w)
       (world-speed w)))

;; Ball:

;; REPRESENTATION:
;; A Ball is represented as a struct (x y vx vy) 
;; with the following fields:
;; x, y : Integer  the position of the center of the ball
;; vx: Integer  the x-component of velocity of the ball
;; vy: Integer  the y-component of velocity of the ball

;; IMPLEMENTATION:
(define-struct ball (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-ball Integer Integer Integer Integer)

;; OBSERVER TEMPLATE:
;; ball-fn : Ball -> ??
(define (ball-fn b)
  (... (ball-x b)
       (ball-y b)
       (ball-vx b)
       (ball-vy b)))

;; Racket:

;; REPRESENTATION:
;; A Racket is represented as a struct (x y vx vy) 
;; with the following fields:
;; x, y : Integer  the position of the center of the racket
;; vx: Integer  the x-component of velocity of the racket
;; vy: Integer  the y-component of velocity of the racket

;; IMPLEMENTATION:
(define-struct racket (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-racket Integer Integer Integer Integer)

;; OBSERVER TEMPLATE:
;; racket-fn : Racket -> ??
(define (racket-fn b)
  (... (racket-x b)
       (racket-y b)
       (racket-vx b)
       (racket-vy b)))

;; State:

;; REPRESENTATION:
;; a State is represented by one of the following:
;; --"ready-to-serve"
;; --"rally"
;; INTERPRETATION:
;; -- ready-to-serve is the initial state where the racket
;; and the ball are stationary at the starting position.
;; -- rally state is the state when the ball starts moving.
(define READY-TO-SERVE "ready-to-serve")
(define RALLY "rally")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; help function for key events:

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ke)
  (key=? ke " "))

;; TESTS:
;; examples for testing
(define pause-key-event " ")
(define non-pause-key-event "q")
(begin-for-test
  (check-equal? (is-pause-key-event? pause-key-event) #true
                "the key pressed was space bar")
  (check-equal? (is-pause-key-event? non-pause-key-event) #false
                "the key pressed was not space bar"))

;; is-left-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a left arrow key pressed
(define (is-left-key-event? ke)
  (key=? ke "left"))

;; TESTS:
;; examples for testing
(define left-key-event "left")
(define non-left-key-event "q")
(begin-for-test
  (check-equal? (is-left-key-event? left-key-event) #true
                "the key pressed was left key")
  (check-equal? (is-left-key-event? non-left-key-event) #false
                "the key pressed was not left key"))

;; is-right-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a right arrow key pressed
(define (is-right-key-event? ke)
  (key=? ke "right"))

;; TESTS:
;; examples for testing
(define right-key-event "right")
(define non-right-key-event "q")
(begin-for-test
  (check-equal? (is-right-key-event? right-key-event) #true
                "the key pressed was right key")
  (check-equal? (is-right-key-event? non-right-key-event) #false
                "the key pressed was not right key"))

;; is-up-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a up key pressed
(define (is-up-key-event? ke)
  (key=? ke "up"))

;; TESTS:
;; examples for testing
(define up-key-event "up")
(define non-up-key-event "q")
(begin-for-test
  (check-equal? (is-up-key-event? up-key-event) #true
                "the key pressed was up key")
  (check-equal? (is-up-key-event? non-up-key-event) #false
                "the key pressed was not up key"))

;; is-down-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a down key pressed
(define (is-down-key-event? ke)
  (key=? ke "down"))

;; TESTS:
;; examples for testing
(define down-key-event "down")
(define non-down-key-event "q")
(begin-for-test
  (check-equal? (is-down-key-event? down-key-event) #true
                "the key pressed was down key")
  (check-equal? (is-down-key-event? non-down-key-event) #false
                "the key pressed was not down key"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; scene-with-ball : Ball Scene -> Scene
;; RETURNS: a scene like the given one but with the given
;;          ball painted on it.
;; STRATEGY: Use observer template on ball b
(define (scene-with-ball b s)
  (place-image
   BALL-IMAGE
   (ball-x b) (ball-y b) s))

;; scene-with-racket : Racket Scene -> Scene
;; RETURNS: a scene like the given one but with the given
;;          racket painted on it.
;; STRATEGY: Use observer template on racket r
(define (scene-with-racket r s)
  (place-image
   RACKET-IMAGE
   (racket-x r) (racket-y r) s))

;; TESTS:
;; images showing the racket and ball
;; checked visually
(define ball-at-start (place-image BALL-IMAGE X-START Y-START EMPTY-CANVAS))
(define racket-at-start (place-image RACKET-IMAGE X-START Y-START EMPTY-CANVAS))

(begin-for-test
  (check-equal? 
   (scene-with-ball (make-ball 330 384 0 0) EMPTY-CANVAS)
   ball-at-start
   "(scene-with-ball (make-ball 330 384 0 0) EMPTY-CANVAS)
    returned unexpected image or value")

  (check-equal?
   (scene-with-racket (make-racket 330 384 0 0) EMPTY-CANVAS)   
   racket-at-start
   "(scene-with-racket (make-racket 330 384 0 0) EMPTY-CANVAS)
    returned unexpected image or value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; is-paused-rally-state? : World -> Boolean
;; RETURNS : true iff the given World w is in paused rally state
(define (is-paused-rally-state? w)
  (and (world-paused? w) (string=? (world-state w) RALLY)))

;; world-to-scene : World -> Scene
;; RETURNS : a Scene that portrays the given world.
;; STRATEGY : if the world is in pause rally state return a scene
;;          with a ball, racket and yellow background.
;;           otherwise return a scene with a ball, racket and white
;;          background.
(define (world-to-scene w)
  (if (is-paused-rally-state? w)
      (scene-with-ball
       (world-ball w)
       (scene-with-racket
        (world-racket w)
        YELLOW-CANVAS))
      (scene-with-ball
       (world-ball w)
       (scene-with-racket
        (world-racket w)
        EMPTY-CANVAS))))

;; TESTS:
;;examples for test
(define world-in-pause-rally-state
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   RALLY
   0
   0))
(define pause-yellow-scene
  (scene-with-ball
   (make-ball X-START Y-START 0 0)
   (scene-with-racket
    (make-racket X-START Y-START 0 0)
    YELLOW-CANVAS)))
(define world-with-unpaused-rally
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #false
   RALLY
   0
   0))
(define usual-scene
  (scene-with-ball
   (make-ball X-START Y-START 0 0)
   (scene-with-racket
    (make-racket X-START Y-START 0 0)
    EMPTY-CANVAS)))

(begin-for-test
  (check-equal? (world-to-scene world-in-pause-rally-state)
                pause-yellow-scene
                "(world-to-scene world-in-pause-rally-state) returned
                 incorrect image)")

  (check-equal? (world-to-scene world-with-unpaused-rally)
                usual-scene
                "(world-to-scene world-with-unpaused-rally-unselected-racket)
                 returned incorrect image)"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ball-after-tick : Ball -> Ball
;; GIVEN: the state of the a ball b in an unpaused world
;; RETURNS: the state of the given ball after a tick.
;; STRATEGY: Use observer template on ball b
(define (ball-after-tick b)
  (cond
    [(> (+ (ball-x b) (ball-vx b)) CANVAS-WIDTH)
     (make-ball (- CANVAS-WIDTH (- (+ (ball-x b) (ball-vx b)) CANVAS-WIDTH))
                (ball-y b)
                (-(ball-vx b))
                (ball-vy b))]
    [(< (+ (ball-x b) (ball-vx b)) 0)
     (make-ball (+ (ball-x b) (-(ball-vx b)))
                (ball-y b)
                (-(ball-vx b))
                (ball-vy b))]
    [(< (+ (ball-y b) (ball-vy b)) 0)
     (make-ball (ball-x b)
                (-(+ (ball-y b) (ball-vy b)))
                (ball-vx b)
                (-(ball-vy b)))]
    [else
     (make-ball (+ (ball-x b) (ball-vx b))
                (+ (ball-y b) (ball-vy b))
                (ball-vx b)
                (ball-vy b))]))

;; TESTS:
(begin-for-test
  (check-equal? (ball-after-tick (make-ball 0 0 3 -9))
                (make-ball 0 9 3 9)
                "(ball-after-tick (make-ball 0 0 3 -9) did not
                return expected state")
  (check-equal? (ball-after-tick (make-ball 425 425 3 -9))
                (make-ball 422 425 -3 -9)
                "(ball-after-tick (make-ball 425 425 3 -9)) did not
                return expected state")
  (check-equal? (ball-after-tick (make-ball 0 10 -3 -9))
                (make-ball 3 10 3 -9)
                "(ball-after-tick (make-ball 0 10 3 -9)) did not
                return expected state"))

;; racket-beyond-right-wall? : Racket -> Boolean
;; RETURNS: true iff the racket goes beyound the right wall
(define (racket-beyond-right-wall? r)
  (> (+ (racket-x r) RACKET-HALF-WIDTH) CANVAS-WIDTH))

;; racket-beyond-left-wall? : Racket -> Boolean
;; RETURNS: true iff the racket goes beyound the left wall
(define (racket-beyond-left-wall? r)
  (< (- (racket-x r) RACKET-HALF-WIDTH) 0))

;; racket-after-tick : Racket -> Racket
;; GIVEN: the state of the a racket r in an unpaused world
;; RETURNS: the state of the given racket after a tick.
;; STRATEGY: Use observer template on racket r
(define (racket-after-tick r)
  (cond
    [(racket-beyond-left-wall? r)
     (make-racket RACKET-LEFT-WALL-ADJUSTED
                  (racket-y r)
                  0
                  0)]
    [(racket-beyond-right-wall? r)
     (make-racket RACKET-RIGHT-WALL-ADJUSTED
                  (racket-y r)
                  0
                  0)]
    [else (make-racket
           (+ (racket-x r) (racket-vx r))
           (+ (racket-y r) (racket-vy r))
           (racket-vx r)
           (racket-vy r))]))

;; TESTS:
;; examples for test
(define racket-right-wall
  (make-racket 420
               220
               0
               0))
(define racket-left-wall
  (make-racket 0
               220
               0
               0))
(define racket-middle
  (make-racket 220
               220
               0
               0))

#|(begin-for-test
  (check-equal? (racket-after-tick racket-right-wall)
                (make-racket 402 220 0 0)
                "(racket-after-tick racket-right-wall)
                  returned unexpected racket")
  (check-equal? (racket-after-tick racket-left-wall)
                (make-racket 24 220 0 0)
                "(racket-after-tick racket-left-wall)
                  returned unexpected racket")
  (check-equal? (racket-after-tick racket-middle)
                racket-middle
                "(racket-after-tick racket-left-wall)
                  returned unexpected racket"))|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start-timer : World -> World
;; GIVEN: a world w
;; RETURNS: a world in ready-to-serve state after 3 seconds
;; STRATEGY: if the timer is equal to 3 seconds, reset;
;;           increment timer, otherwise.
(define (start-timer w)
  (
   if(= (world-timer w) (/ DURATION-OF-PAUSE (world-speed w)))
     (make-world
      (make-ball X-START Y-START 0 0)
      (make-racket X-START Y-START 0 0)
      #true
      READY-TO-SERVE
      0
      (world-speed w))
         
     (make-world
      (world-ball w)
      (world-racket w)
      (world-paused? w)
      RALLY
      (+ (world-timer w) 1)
      (world-speed w))))

;; TESTS:
;; example for tests:
(define world-at-end-of-3seconds
  (make-world
   (make-ball 10 20 3 -9)
   (make-racket 34 12 0 0)
   #true
   RALLY
   30
   0.1))
(define beginning-world
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   READY-TO-SERVE
   0
   0.1))
(define world-before-end-of-3seconds
  (make-world
   (make-ball 10 20 3 -9)
   (make-racket 34 12 0 0)
   #true
   RALLY
   28
   0.1))
(define world-with-timer-incremented
  (make-world
   (make-ball 10 20 3 -9)
   (make-racket 34 12 0 0)
   #true
   RALLY
   29
   0.1))

(begin-for-test
  (check-equal? (start-timer world-at-end-of-3seconds) beginning-world
                "(start-timer WORLD-AT-END-OF-3SECONDS) returned
                 unexpected world")
  (check-equal? (start-timer world-before-end-of-3seconds)
                world-with-timer-incremented
                "(start-timer WORLD-AT-END-OF-3SECONDS) returned
                 unexpected world"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; racket-after-left-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          x component of velocity decremented and y-velocity
;;          incremented
;; STRATEGY: Use observer template on racket r
(define (racket-after-left-key-pressed r)
  (make-racket
   (racket-x r)
   (racket-y r)
   (- (racket-vx r) 1)
   (racket-vy r)))

;; racket-after-right-key-pressed : Racket KeyEvent -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          x component of velocity incremented
;; STRATEGY: Use observer template on racket r
(define (racket-after-right-key-pressed r)
  (make-racket
   (racket-x r)
   (racket-y r)
   (+ (racket-vx r) 1)
   (racket-vy r)))

;; racket-after-up-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          y-velocity decremented
;; STRATEGY: Use observer template on racket r
(define (racket-after-up-key-pressed r)
  (make-racket
   (racket-x r)
   (racket-y r)
   (racket-vx r)
   (- (racket-vy r) 1)))

;; racket-after-down-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          y-velocity incremented
;; STRATEGY: Use observer template on racket r
(define (racket-after-down-key-pressed r)
  (make-racket
   (racket-x r)
   (racket-y r)
   (racket-vx r)
   (+ (racket-vy r) 1)))

;; TESTS:
;; example for tests:
(define racket-before-key
  (make-racket 220
               220
               3
               5))
  
#|(begin-for-test
  (check-equal? (racket-after-left-key-pressed racket-before-key)
                (make-racket 223 225 2 5)
                "(racket-after-left-key-pressed racket-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-right-key-pressed racket-before-key)
                (make-racket 223 225 4 5)
                "(racket-after-right-key-pressed racket-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-up-key-pressed racket-before-key)
                (make-racket 223 225 3 4)
                "(racket-after-up-key-pressed racket-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-down-key-pressed racket-before-key)
                (make-racket 223 225 3 6)
                "(racket-after-left-key-pressed racket-before-key)
                 returned unexpected racket"))|#

; magic-math: Int Int PosReal Int Int -> Int
;; GIVEN: x and y coordinates of ball position(xb, yb)
;;        x and y coordinates of the either end of racket (xr, yr)
;;        ydelta, change in the y component of ball between the current
;;        and next tick
;; RETURNS: minimum or maximum possible position of x-component of ball
;;          after collision
;; STRATEGY: transcribe formula.
(define (magic-math xb yb xr yr ydelta)
  (if (= yr yb)
      0
      (+ (* (/ (- xr xb) (- yr yb)) ydelta) xb)))

;; TESTS:
(begin-for-test
  (check-equal? (magic-math 200 200 202 202 3) 203
                "the result should be 203")
  (check-equal? (magic-math 200 200 202 200 3) 0
                "the result should be 0"))

;; will-racket-ball-collide: Racket Ball -> Boolean
;; GIVEN: a racket r and ball b
;; RETURNS: retruns true iff the ball b and racket r collide
;; STRATEGY: transcribe formula.
(define (will-racket-ball-collide? r b)
  (let ((bt (ball-after-tick b))
        (min-x (magic-math (ball-x b) (ball-y b)
                           (- (racket-x r) RACKET-HALF-WIDTH)
                           (racket-y r) (ball-vy b)))
        (max-x (magic-math (ball-x b) (ball-y b)
                           (+ (racket-x r) RACKET-HALF-WIDTH)
                           (racket-y r) (ball-vy b))))
    (if (and
         (> (ball-x bt) min-x)
         (< (ball-x bt) max-x)
         (or
          (and (<= (ball-y b) (racket-y r)) (>= (ball-y bt) (racket-y r)))
          (and (>= (ball-y b) (racket-y r)) (<= (ball-y bt) (racket-y r)))))
        #true
        #false)))

;; TESTS:
(begin-for-test
  (check-equal? (will-racket-ball-collide?
                 (make-racket 202 202 0 0)
                 (make-ball 200 200 3 -9))
                #false
                "racket and ball should not collide")
  (check-equal? (will-racket-ball-collide?
                 (make-racket 202 195 0 0)
                 (make-ball 200 200 3 -9))
                #true
                "racket and ball should collide")
  (check-equal? (will-racket-ball-collide?
                 (make-racket 200 203 0 0)
                 (make-ball 200 200 3 3))
                #true
                "racket and ball should not collide"))

;; world-after-tick-check-racket-ball-collide: World -> World
;; GIVEN: a world w
;; RETURNS: if racket and ball have collided,
;;          world in the next tick;
;;          the given world w otherwise.
;; STRATEGY: Use observer template on world w
(define (world-after-tick-check-racket-ball-collide w)
  (if (will-racket-ball-collide? (world-racket w) (world-ball w))
      (make-world
       (make-ball(ball-x (world-ball w))
                 (- (ball-y (world-ball w)))
                 (ball-vx (world-ball w))
                 (ball-vy (world-ball w)))
       (make-racket
        (racket-x (world-racket w))
        (racket-y (world-racket w))
        (racket-vx (world-racket w))
        0)
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))
      w))

;; TESTS:
;; example for test:
(define world-with-collision
  (make-world
   (make-ball 200 200 3 -9)
   (make-racket 202 195 0 0)
   #false
   RALLY
   0
   0.1))

(define world-with-no-collision
  (make-world
   (make-ball 200 200 3 -9)
   (make-racket 202 202 0 0)            
   #false
   RALLY
   0
   0.1))   

(begin-for-test
  (check-equal? (world-after-tick-check-racket-ball-collide
                 world-with-collision)
                (make-world
                (make-ball 200 -200 3 -9)
                (make-racket 202 195 0 0)
                #false
                "rally"
                0
                0.1)
                "(world-after-tick-check-racket-ball-collide
                 world-with collision) returned unexpected world")

  (check-equal? (world-after-tick-check-racket-ball-collide
                 world-with-no-collision)
                 world-with-no-collision
                "(world-after-tick-check-racket-ball-collide
                 world-with collision) returned unexpected world"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MAIN FUNCTION:

;; simulation : PosReal -> World
;; GIVEN: the speed of the simulation, in seconds per tick
;;     (so larger numbers run slower)
;; EFFECT: runs the simulation, starting with the initial world
;; RETURNS: the final state of the world
;; EXAMPLES:
;;     (simulation 1) runs in super slow motion
;;     (simulation 1/24) runs at a more realistic speed
(define (simulation s)
  (big-bang (initial-world s)
            (on-tick world-after-tick s)
            (on-draw world-to-scene)
            (on-key world-after-key-event)))
          
;; initial-world : PosReal -> World
;; GIVEN: the speed of the simulation, in seconds per tick
;;     (so larger numbers run slower)
;; RETURNS: the ready-to-serve state of the world
;; EXAMPLE: (initial-world 1)
;; STRATEGY: Use observer template on world w
(define (initial-world s)
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   true
   "ready-to-serve"
   0
   s))

;; TESTS:
(begin-for-test
  (check-equal? (initial-world 0.1)
                beginning-world
                "(initial-world 0.1) returned unexpected world"))
          
;; world-ready-to-serve? : World -> Boolean
;; GIVEN: a world
;; RETURNS: true iff the world is in its ready-to-serve state
(define (world-ready-to-serve? w)
  (string=? (world-state w) "ready-to-serve"))

;; TESTS:
(begin-for-test
  (check-equal? (world-ready-to-serve? beginning-world)
                #true
                "beginning-world should be in ready-to-serve state")
  (check-equal? (world-ready-to-serve? world-in-pause-rally-state)
                #false
                "world-in-pause-rally-state should not be in
                 ready-to-serve state"))

;; world-after-tick : World -> World
;; GIVEN: any world that's possible for the simulation
;; RETURNS: the world that should follow the given world
;;     after a tick
;; STRATEGY: if the world is in paused and ready-to-serve state,
;;           return the same world w;
;;           if the world is in paused and rally state,
;;           start the timer;
;;           if the world is in unpaused and rally state,
;;           check for other possible scenarios.
(define (world-after-tick w)
  (cond
    [(and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
     w]
    [(and (world-paused? w) (string=? (world-state w) RALLY))
     (start-timer w)]
    [else
     (world-after-tick-check-racket-ball-collide
      (racket-hits-front-wall
       (ball-hits-back-wall (world-after-tick-in-rally w))))]))

;; TESTS:
(define world-in-paused-ready-to-serve
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   READY-TO-SERVE
   0
   0.1))

(define world-in-paused-rally
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   RALLY
   0
   0.1))

(define world-in-paused-rally-incremented-timer
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   RALLY
   1
   0.1))

(begin-for-test
  (check-equal? (world-after-tick world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-tick world-in-paused-ready-to-serve) returned
                 unexpected world")
  (check-equal? (world-after-tick world-in-paused-rally)
                world-in-paused-rally-incremented-timer
                "(world-after-tick world-in-paused-rally) returned
                 unexpected world")
  (check-equal? (world-after-tick world-with-collision)
                (make-world
                (make-ball 203 191 3 -9)
                (make-racket 202 195 0 0)
                #false
                "rally"
                0
                0.1)
                ""))
  

;; world-after-tick-in-rally : World -> World
;; GIVEN: a world w in unpaused rally state
;; RETURNS: the world that should follow the given world after a tick
;; STRATEGY: Use observer template on world w
(define (world-after-tick-in-rally w)
  (make-world
   (ball-after-tick (world-ball w))
   (racket-after-tick (world-racket w))
   (world-paused? w)
   (world-state w)
   (world-timer w)
   (world-speed w)))

;; TESTS:
(define world-in-rally-at-beginning
  (make-world
   (make-ball X-START Y-START 0 0)
   (make-racket X-START Y-START 0 0)
   #true
   RALLY
   1
   0.1))

(define world-in-rally-after-beginning
  (make-world
   (make-ball 330 384 0 0)
   (make-racket 330 384 0 0)
   #true
   RALLY
   1
   0.1))

(begin-for-test
  (check-equal? (world-after-tick-in-rally world-in-rally-at-beginning)
                world-in-rally-after-beginning
                "(world-after-tick-in-rally world-in-rally) returned
                  unexpected world"))

;; ball-hits-back-wall : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if the ball hits the
;;          back wall of canvas
;; STRATEGY: Use observer template on world w
(define (ball-hits-back-wall w)
  (if(> (ball-y (world-ball w)) CANVAS-HEIGHT)
     (make-world
      (world-ball w)
      (world-racket w)
      #true
      RALLY
      (world-timer w)
      (world-speed w))
     w))

;; TESTS:
;; examples for test:
(define world-with-ball-at-back-wall
  (make-world
   (make-ball 200 CANVAS-HEIGHT 3 2)
   (make-racket 300 300 2 1)
   #false
   RALLY
   0
   0.1))

(define world-with-ball
  (make-world
   (make-ball 200 200 3 2)
   (make-racket 300 300 2 1)
   #false
   RALLY
   0
   0.1))

#|(begin-for-test
  (check-equal? (ball-hits-back-wall world-with-ball-at-back-wall)
                (make-world
                 (make-ball 200 649 3 2)
                 (make-racket 300 300 2 1)
                 #true
                 "rally"
                 0
                 0.1)
                "(ball-hits-back-wall world-with-ball-at-back-wall) returned
                  unexpected world")
  (check-equal? (ball-hits-back-wall world-with-ball)
                world-with-ball
                "(ball-hits-back-wall world-with-ball) returned
                  unexpected world"))|#

;; racket-hits-front-wall : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if the racket hits the
;;          front wall of canvas
;; STRATEGY: Use observer template on world w
(define (racket-hits-front-wall w)
  (if (< (racket-y (world-racket w)) 0)
      (make-world
       (world-ball w)
       (world-racket w)
       #true
       RALLY
       (world-timer w)
       (world-speed w))
      w))

;; TESTS:
;; examples for test:
(define world-with-racket-at-front-wall
  (make-world
   (make-ball 200 300 3 2)
   (make-racket 300 -1 2 -1)
   #false
   RALLY
   0
   0.1))

(define world-with-racket
  (make-world
   (make-ball 200 200 3 2)
   (make-racket 300 300 2 1)
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (racket-hits-front-wall world-with-racket-at-front-wall)
                (make-world
                 (make-ball 200 300 3 2)
                 (make-racket 300 -1 2 -1)
                 #true
                 "rally"
                 0
                 0.1)
                "(racket-hits-front-wall world-with-racket-at-front-wall)
                  returned unexpected world")
  (check-equal? (racket-hits-front-wall world-with-racket)
                world-with-racket
                "(racket-hits-front-wall world-with-racket) returned
                  unexpected world"))

;; world-after-left-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if left key is pressed
;; STRATEGY: Use observer template on world w
(define (world-after-left-key-event w)
  (if (world-paused? w)
      w
      (make-world
       (world-ball w)
       (racket-after-left-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-right-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if right key is pressed
;; STRATEGY: Use observer template on world w
(define (world-after-right-key-event w)
  (if (world-paused? w)
      w
      (make-world
       (world-ball w)
       (racket-after-right-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-up-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if up key is pressed
;; STRATEGY: Use observer template on world w
(define (world-after-up-key-event w)
  (if (world-paused? w)
      w
      (make-world
       (world-ball w)
       (racket-after-up-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-down-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if down key is pressed
;; STRATEGY: Use observer template on world w
(define (world-after-down-key-event w)
  (if (world-paused? w)
      w
      (make-world
       (world-ball w)
       (racket-after-down-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; TESTS:
;; example for test:
(define world-before-key-event
  (make-world
   (make-ball 200 300 3 -9)
   (make-racket 100 200 2 2)
   #false
   RALLY
   0
   0.1))

#|(begin-for-test
  (check-equal? (world-after-left-key-event world-before-key-event)
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 1 2)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-left-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-left-key-event world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-left-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-right-key-event world-before-key-event)
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 3 2)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-right-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-right-key-event world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-right-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-up-key-event world-before-key-event)
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 2 1)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-up-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-up-key-event world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-up-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-down-key-event world-before-key-event)
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 2 3)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-down-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-down-key-event world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-down-key-event world-in-paused-ready-to-serve)
                 returned unexpected world"))|#

;; pause-toggle : World -> World
;; GIVEN: a world w
;; RETURNS: unpaused world in rally state if the world w is in paused
;;          and ready-to-serve state;
;;          paused world in rally state if the world w is in unpaused
;;          and rally state;
;;          the given world w otherwise.
;; STRATEGY: Check for conditions and use observer template on world w
(define (pause-toggle w)
  (cond
    [(and (string=? (world-state w) READY-TO-SERVE) (world-paused? w))
     (make-world
      (make-ball X-START Y-START 3 -9)
      (world-racket w)
      #false
      RALLY
      (world-timer w)
      (world-speed w))] 
    [(and (string=? (world-state w) RALLY) (not (world-paused? w)))
     (make-world
      (world-ball w)
      (world-racket w)
      #true
      RALLY
      (world-timer w)
      (world-speed w))]
    [else w]))

;; TESTS:
;; examples for test:
(define pause-ready-to-serve
  (make-world
   (make-ball 200 300 3 2)
   (make-racket 300 0 2 -1)
   #true
   READY-TO-SERVE
   0
   0.1))

(define not-paused-rally
  (make-world
   (make-ball 200 300 3 2)
   (make-racket 300 0 2 -1)
   #false
   RALLY
   0
   0.1))

(define paused-rally
  (make-world
   (make-ball 200 300 3 2)
   (make-racket 300 0 2 -1)
   #true
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (pause-toggle pause-ready-to-serve)
                (make-world
                 (make-ball 330 384 3 -9)
                 (make-racket 300 0 2 -1)
                 #false
                 "rally"
                 0
                 0.1)
                "(pause-toggle pause-ready-to-serve)
                  returned unexpected world")
  (check-equal? (pause-toggle not-paused-rally)
                (make-world
                 (make-ball 200 300 3 2)
                 (make-racket 300 0 2 -1)
                 #true
                 "rally"
                 0
                 0.1)
                "(pause-toggle not-paused-rally) returned
                  unexpected world")
  (check-equal? (pause-toggle paused-rally)
                paused-rally
                "(pause-toggle paused-rally) returned
                  unexpected world"))


;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a world and a key event
;; RETURNS: the world that should follow the given world
;;     after the given key event
;; STRATEGY: check for conditions and use helper functions
(define (world-after-key-event w kev)
  (cond
    [(is-pause-key-event? kev)
     (pause-toggle w)]
    [(is-left-key-event? kev)
     (world-after-left-key-event w)]
    [(is-right-key-event? kev)
     (world-after-right-key-event w)]
    [(is-up-key-event? kev)
     (world-after-up-key-event w)]
    [(is-down-key-event? kev)
     (world-after-down-key-event w)]
    [else w]))

;; TESTS:
  
#|(begin-for-test
  (check-equal? (world-after-key-event beginning-world " ")
                (make-world
                 (make-ball 330 384 3 -9)
                 (make-racket 330 384 0 0)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-key-event beginning-world space)
                 returned unexpected world ")
  (check-equal? (world-after-key-event world-before-key-event "left")
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 1 2)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-left-key-event world-before-key-event left)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "right")
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 3 2)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-right-key-event world-before-key-event right)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "up")
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 2 1)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-up-key-event world-before-key-event up)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "down")
                (make-world
                 (make-ball 200 300 3 -9)
                 (make-racket 102 202 2 3)
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-down-key-event world-before-key-event down)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "q")
                world-before-key-event
                "(world-after-down-key-event world-before-key-event q)
                 returned unexpected world"))|#
          
;; world-ball : World -> Ball
;; GIVEN: a world
;; RETURNS: the ball that's present in the world
;; STRATEGY: defined by DrRacket when a structure named world
;;           with field ball is created.
          
;; world-racket : World -> Racket
;; GIVEN: a world
;; RETURNS: the racket that's present in the world
;; STRATEGY: defined by DrRacket when a structure named world
;;           is created.
          
;; ball-x : Ball -> Integer
;; ball-y : Ball -> Integer
;; racket-x : Racket -> Integer
;; racket-y : Racket -> Integer
;; GIVEN: a racket or ball
;; RETURNS: the x or y coordinate of that item's position,
;;     in graphics coordinates
;; STRATEGY: defined by DrRacket when structures named ball and racket
;;           with fields x and y are created.
          
;; ball-vx : Ball -> Integer
;; ball-vy : Ball -> Integer
;; racket-vx : Racket -> Integer
;; racket-vy : Racket -> Integer
;; GIVEN: a racket or ball
;; RETURNS: the vx or vy component of that item's velocity,
;;     in pixels per tick
;; STRATEGY: defined by DrRacket when structures named ball and racket
;;           with fields vx and vy are created.

;; world-after-n-ticks : World Int -> World
(define (world-after-n-ticks w n)
  (if(= n 0) w
     (world-after-n-ticks (world-after-tick w) (- n 1))))

(define world-example
  (make-world
   (make-ball X-START Y-START 3 -9)
   (make-racket X-START Y-START 0 0)
   #false
   RALLY
   0
   0.1))

;; World with a racket with 3 speed in up direction after one tick.
(define WORLD-RACKET-WITH-3SPEED
  (world-after-key-event
   (world-after-key-event
    (world-after-key-event (world-after-tick world-example) "up") "up") "up"))

;; World with a racket with 9 speed in up direction after one tick.
(define WORLD-RACKET-WITH-9SPEED
  (world-after-key-event
   (world-after-key-event
    (world-after-key-event
     (world-after-key-event
      (world-after-key-event
       (world-after-key-event WORLD-RACKET-WITH-3SPEED "up")
       "up") "up") "up") "up") "up"))

(define WORLD-RACKET-WITH-6SPEED-63TICK
  (world-after-key-event
   (world-after-key-event
    (world-after-key-event
     (world-after-n-ticks WORLD-RACKET-WITH-3SPEED 62) "up") "up") "up"))

;; (ball-x (world-ball (world-after-n-ticks WORLD-RALLY-STATE 32)) => 424