;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; simulation of a squash player practicing without an opponent
;; with smooth drag and mutiple balls.

;; start with (simulation speed)
;; press space to start the game
;; press b to get more balls
;; press space during game to reset the game
;; use arrow keys/mouse drag to move the racket

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
 world-balls
 world-racket
 ball-x
 ball-y
 racket-x
 racket-y
 ball-vx
 ball-vy
 racket-vx
 racket-vy
 world-after-mouse-event
 racket-after-mouse-event
 racket-selected?)

(check-location "06" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS:

;; dimensions of the canvas, in pixels
(define CANVAS-WIDTH 425)
(define CANVAS-HEIGHT 649)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define YELLOW-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT "yellow"))

;; dimensions of the ball, blue dot and racket
(define BALL-RADIUS 3)
(define DOT-RADIUS 3)
(define RACKET-WIDTH 47)
(define RACKET-HEIGHT 7)
(define RACKET-HALF-WIDTH 23.5)

;; constants to adjust the position of racket
(define RACKET-LEFT-WALL-ADJUSTED 24)
(define RACKET-RIGHT-WALL-ADJUSTED 402)

;; ball and racket image
(define BALL-IMAGE (circle BALL-RADIUS "solid" "black"))
(define RACKET-IMAGE (rectangle RACKET-WIDTH RACKET-HEIGHT "solid" "green"))

;; blue circle that is displayed at the mouse position
(define DOT-IMAGE (circle DOT-RADIUS "solid" "blue")) 

;; starting co-ordinates for ball and racket
(define X-START 330)
(define Y-START 384)

;; starting velocity of the ball
(define VX-START 3)
(define VY-START -9)

;; duration of pause
(define DURATION-OF-PAUSE 3)

;; pixel radius for racket selection
(define PIXEL-RADIUS 25)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; REPRESENTATION:
;; A World is represented as a
;;         (make-world balls racket paused? state timer speed)
;; with following fields:
;; balls : BallList  is the list of squash balls in the world
;; racket : Racket  is the racket in the world
;; paused? : Boolean  is the world paused?
;; state : State of the squash game
;; timer : PosInt is the timer which can only go upto 3,
;;         measured in seconds
;; speed : PosReal is the speed of the simulation,
;;         measured in seconds per tick

;; IMPLEMENTATION:
(define-struct world (balls racket paused? state timer speed))

;; CONSTRUCTOR TEMPLATE:
;; (make-world balls Racket Boolean State PosInt PosReal)

;; OBSERVER TEMPLATE:
;; world-fn : World -> ??
#;(define (world-fn w)
    (... (world-balls w)
         (world-racket w)
         (world-paused? w)
         (world-state w)
         (world-timer w)
         (world-speed w)))

;; BallList:

;; A BallList is represented as a list of Ball(s)
;; CONSTRUCTOR TEMPLATES:
;; empty
;; (cons b blist)
;; -- WHERE
;;    b is a Ball
;;    blist is a BallList


;; OBSERVER TEMPLATE:
;; blist-fn : BallList -> ??
#;(define (balls-fn blist)
    (cond
      [(empty? blist) ...]
      [else (...
             ball-fn (first blist)
             (balls-fn (rest blist)))]))

;; Ball:

;; REPRESENTATION:
;; A Ball is represented as (make-ball x y vx vy) 
;; with the following fields:
;; x, y : Integer  the position of the center of the ball
;; vx: Integer  the x-component of velocity of the ball,
;;     measured as pixels per tick
;; vy: Integer  the y-component of velocity of the ball,
;;     measured as pixels per tick

;; IMPLEMENTATION:
(define-struct ball (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-ball Integer Integer Integer Integer)

;; OBSERVER TEMPLATE:
;; ball-fn : Ball -> ??
#;(define (ball-fn b)
    (... (ball-x b)
         (ball-y b)
         (ball-vx b)
         (ball-vy b)))

;; Racket:

;; REPRESENTATION:
;; A Racket is represented as (make-racket x y vx vy selected? mouse-info)
;; with the following fields:
;; x, y : Integer  the position of the center of the racket
;; vx: Integer  the x-component of velocity of the racket
;; vy: Integer  the y-component of velocity of the racket
;; selected? : Boolean describes whether or not the racket is selected
;; mouse-info : MouseInfo relative position of mouse from racket.

;; IMPLEMENTATION:
(define-struct racket (x y vx vy selected? mouse-info))

;; CONSTRUCTOR TEMPLATE:
;; (make-racket Integer Integer Integer Integer Boolean MouseInfo)

;; OBSERVER TEMPLATE:
;; racket-fn : Racket -> ??
#;(define (racket-fn b)
    (... (racket-x b)
         (racket-y b)
         (racket-vx b)
         (racket-vy b)
         (racket-selected? b)
         (racket-mouse-info b)))

;; MouseInfo:

;; REPRESENTATION:
;; A MouseInfo is represented as (make-mouse-info rx ry)
;; with the following fields:
;; rx, ry : Integer  stores the relative position of mouse from racket.

;; IMPLEMENTATION:
(define-struct mouse-info (rx ry))

;; CONSTRUCTOR TEMPLATE:
;; (make-mouse-info Integer Integer)

;; OBSERVER TEMPLATE:
;; mouse-info-fn : MouseInfo -> ??
#;(define (mouse-info-fn m)
    (... (mouse-info-rx m)
         (mouse-info-ry m)))

;; initial information for relative mouse co-ordinates
(define INITIAL-MOUSE-INFO
  (make-mouse-info 0 0))

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

;; OBSERVER TEMPLATE:
;; state-fn: State -> ??
#; (define (state-fn s)
     (cond ((string=? s "ready-to-serve") ...)
           ((string=? s "rally") ...)))

;; initial information for BallList
(define INITIAL-BALL-LIST (cons
                           (make-ball X-START Y-START 0 0)
                           empty))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; help function for key events:

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
;; EXAMPLE: (is-pause-key-event? " ") => #true
;;          (is-pause-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
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
;; EXAMPLE: (is-left-key-event? "left") => #true
;;          (is-left-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
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
;; EXAMPLE: (is-right-key-event? "right") => #true
;;          (is-right-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
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
;; EXAMPLE: (is-up-key-event? "up") => #true
;;          (is-up-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
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
;; EXAMPLE: (is-down-key-event? "down") => #true
;;          (is-down-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
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

;; is-b-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a 'b' key pressed
;; EXAMPLE: (is-b-key-event? "b") => #true
;;          (is-b-key-event? "x") => #false
;; STRATEGY: KeyEvent comparison
(define (is-b-key-event? ke)
  (or (key=? ke "b") (key=? ke "B")))

;; TESTS:
;; examples for testing
(define b-key-event "b")
(define non-b-key-event "q")
(begin-for-test
  (check-equal? (is-b-key-event? b-key-event) #true
                "the key pressed was b key")
  (check-equal? (is-b-key-event? non-b-key-event) #false
                "the key pressed was not b key"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; scene-with-ball : BallList Scene -> Scene
;; GIVEN: a list of balls blist and scene s
;; RETURNS: a scene like the given one but with the given
;;          balls painted on it.
;; EXAMPLE: (scene-with-ball INITIAL-BALL-LIST EMPTY-CANVAS) => ball-at-start
;; STRATEGY: Use HOF foldr on blist
#;(define (scene-with-ball blist s)
    (cond
      [(empty? blist) s]
      [else
       (place-image
        BALL-IMAGE
        (ball-x (first blist))
        (ball-y (first blist))
        (scene-with-ball (rest blist) s))]))

(define (scene-with-ball blist s)
  (foldr (; Ball Scene -> Scene
          ; GIVEN : a ball and a scene
          ; RETURNS : a scene like the given but ball placed on it
          lambda (x y) (place-image BALL-IMAGE (ball-x x)(ball-y x) y))
         s blist))

;; scene-with-mouse-dot : Racket Scene -> Scene
;; RETURNS : a scene like the given one but with a blue dot
;;           at the mouse position
;; EXAMPLE: (scene-with-mouse-dot
;;          (make-racket X-START Y-START 0 0 #true INITIAL-MOUSE-INFO)
;;          EMPTY-CANVAS) => dot-at-start
;; STRATEGY: Use observer template on racket r
(define (scene-with-mouse-dot r s)
  (place-image
   DOT-IMAGE
   (+ (racket-x r) (mouse-info-rx (racket-mouse-info r)))
   (+ (racket-y r) (mouse-info-ry (racket-mouse-info r)))
   s))

;; scene-with-racket : Racket Scene -> Scene
;; RETURNS: a scene like the given one but with the given
;;          racket painted on it.
;; EXAMPLE: (scene-with-racket
;;          (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
;;           EMPTY-CANVAS) => racket-at-start
;; STRATEGY: Use observer template on racket r
(define (scene-with-racket r s)
  (place-image
   RACKET-IMAGE
   (racket-x r) (racket-y r) s))

;; TESTS:

;; images showing the racket, ball and dot
;; checked visually
(define ball-at-start
  (place-image BALL-IMAGE X-START Y-START EMPTY-CANVAS))
(define racket-at-start
  (place-image RACKET-IMAGE X-START Y-START EMPTY-CANVAS))
(define dot-at-start
  (place-image DOT-IMAGE X-START Y-START EMPTY-CANVAS))

(begin-for-test
  (check-equal? 
   (scene-with-ball INITIAL-BALL-LIST EMPTY-CANVAS)
   ball-at-start
   "(scene-with-ball (make-ball X-START Y-START 0 0) EMPTY-CANVAS)
    returned unexpected image or value")

  (check-equal?
   (scene-with-racket
    (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO) EMPTY-CANVAS)   
   racket-at-start
   "(scene-with-racket (make-racket X-START Y-START 0 0) EMPTY-CANVAS)
    returned unexpected image or value")

  (check-equal?
   (scene-with-mouse-dot
    (make-racket X-START Y-START 0 0 #true INITIAL-MOUSE-INFO) EMPTY-CANVAS)   
   dot-at-start
   "(scene-with-mouse-dot X-START Y-START EMPTY-CANVAS)
    returned unexpected image or value"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; is-paused-rally-state? : World -> Boolean
;; RETURNS : true iff the given World w is in paused rally state
;; EXAMPLE: (is-paused-rally-state? world-in-pause-rally-state) => #true
;; STRATEGY: use observer template on world w
(define (is-paused-rally-state? w)
  (and (world-paused? w) (string=? (world-state w) RALLY)))

;; world-to-scene : World -> Scene
;; RETURNS : a Scene that portrays the given world.
;; EXAMPLE: (world-to-scene world-in-pause-rally-state)
;;           => pause-yellow-scene
;; STRATEGY : use observer template on world w
(define (world-to-scene w)
  (cond
    [(is-paused-rally-state? w)
     (scene-with-ball
      (world-balls w)
      (scene-with-racket
       (world-racket w)
       YELLOW-CANVAS))]
    [(racket-selected? (world-racket w))
     (scene-with-mouse-dot
      (world-racket w)
      (scene-with-ball
       (world-balls w)
       (scene-with-racket
        (world-racket w)
        EMPTY-CANVAS)))]
    [else
     (scene-with-ball
      (world-balls w)
      (scene-with-racket
       (world-racket w)
       EMPTY-CANVAS))]))

;; TESTS:
;;examples for test
(define unselected-racket-at-initial-pos
  (make-racket X-START
               Y-START
               0
               0
               #false
               (make-mouse-info 0 0)))
(define selected-racket-at-initial-pos
  (make-racket X-START
               Y-START
               0
               0
               #true
               (make-mouse-info 0 0)))
(define world-in-pause-rally-state
  (make-world
   INITIAL-BALL-LIST
   unselected-racket-at-initial-pos
   #true
   RALLY
   0
   0))
(define pause-yellow-scene
  (scene-with-ball
   INITIAL-BALL-LIST
   (scene-with-racket
    unselected-racket-at-initial-pos
    YELLOW-CANVAS)))
(define world-with-racket-selected
  (make-world
   INITIAL-BALL-LIST
   selected-racket-at-initial-pos
   #false
   RALLY
   0
   0))
(define scene-with-blue-dot
  (scene-with-mouse-dot
   selected-racket-at-initial-pos
   (scene-with-ball
    INITIAL-BALL-LIST
    (scene-with-racket
     selected-racket-at-initial-pos
     EMPTY-CANVAS))))
(define world-with-unpaused-rally-unselected-racket
  (make-world
   INITIAL-BALL-LIST
   unselected-racket-at-initial-pos
   #false
   RALLY
   0
   0))
(define usual-scene
  (scene-with-ball
   INITIAL-BALL-LIST
   (scene-with-racket
    unselected-racket-at-initial-pos
    EMPTY-CANVAS)))                                                       
                             
(begin-for-test
  (check-equal? (world-to-scene world-in-pause-rally-state)
                pause-yellow-scene
                "(world-to-scene world-in-pause-rally-state) returned
                 incorrect image)")

  (check-equal? (world-to-scene world-with-racket-selected)
                scene-with-blue-dot
                "(world-to-scene world-with-racket-selected) returned
                 incorrect image)")

  (check-equal? (world-to-scene world-with-unpaused-rally-unselected-racket)
                usual-scene
                "(world-to-scene world-with-unpaused-rally-unselected-racket)
                 returned incorrect image)"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; balls-after-tick : BallList -> BallList
;; GIVEN: a list of balls blist
;; RETURN : a list of balls blist after a tick
;; EXAMPLE: (balls-after-tick INITIAL-BALL-LIST
;;                            unselected-racket-at-initial-pos)
;;          => (list (make-ball 330 384 0 0))
;; STRATEGY: Use HOF map on blist
#;(define (balls-after-tick blist r)
    (cond
      [(empty? blist) empty]
      [else
       (append (cons (ball-after-tick(first blist) r) empty)
               (balls-after-tick(rest blist) r))]))

(define (balls-after-tick blist r)
  (map (; Ball -> Ball
        ; GIVEN: a Ball x
        ; RETURNS: the state of its argument after a tick
        lambda (x) (ball-after-tick x r)) blist))

;; TESTS:
(begin-for-test
  (check-equal? (balls-after-tick INITIAL-BALL-LIST
                                  unselected-racket-at-initial-pos)
                (list (make-ball 330 384 0 0))
                "(balls-after-tick INITIAL-BALL-LIST)
                 returned unexpected list"))

;; ball-hits-right-wall? : Ball -> Boolean
;; GIVEN: a ball b
;; RETURNS: true iff the given ball will hit the right wall in the next tick
;; EXAMPLE: (ball-hits-right-wall? (make-ball 425 425 3 -9)) => true
;; STRATEGY: transcribe formula
(define (ball-hits-right-wall? b)
  (> (+ (ball-x b) (ball-vx b)) CANVAS-WIDTH))

;; ball-hits-left-wall? : Ball -> Boolean
;; GIVEN: a ball b
;; RETURNS: true iff the given ball will hit the left wall in the next tick
;; EXAMPLE: (ball-hits-left-wall? (make-ball 0 30 -1 -9)) => true
;; STRATEGY: transcribe formula
(define (ball-hits-left-wall? b)
  (< (+ (ball-x b) (ball-vx b)) 0))

;; ball-hits-top-wall? : Ball -> Boolean
;; GIVEN: a ball b
;; RETURNS: true iff the given ball will hit the top wall in the next tick
;; EXAMPLE: (ball-hits-top-wall? (make-ball 425 0 3 -9)) => true
;; STRATEGY: transcribe formula
(define (ball-hits-top-wall? b)
  (< (+ (ball-y b) (ball-vy b)) 0))

;; ball-after-tick : Ball Racket-> Ball
;; GIVEN: the state of the a ball b and racket r in an unpaused world
;; RETURNS: the state of the given ball after a tick.
;; EXAMPLE: (ball-after-tick (make-ball 0 0 3 -9)
;;                            unselected-racket-at-initial-pos)
;;          => (make-ball 3 9 3 9)
;; STRATEGY: Use observer template on ball b
(define (ball-after-tick b r)
  (cond
    [(ball-hits-right-wall? b)
     (make-ball (- CANVAS-WIDTH (- (+ (ball-x b) (ball-vx b)) CANVAS-WIDTH))
                (ball-y b)
                (-(ball-vx b))
                (ball-vy b))]
    [(ball-hits-left-wall? b)
     (make-ball (+ (ball-x b) (-(ball-vx b)))
                (ball-y b)
                (-(ball-vx b))
                (ball-vy b))]
    [(ball-hits-top-wall? b)
     (make-ball (+ (ball-x b) (ball-vx b))
                (-(+ (ball-y b) (ball-vy b)))
                (ball-vx b)
                (-(ball-vy b)))]
    [(will-racket-ball-collide? r b)
     (ball-after-racket-ball-collision b r)]
    [else
     (make-ball (+ (ball-x b) (ball-vx b))
                (+ (ball-y b) (ball-vy b))
                (ball-vx b)
                (ball-vy b))]))

;; TESTS:
(begin-for-test
  (check-equal? (ball-after-tick (make-ball 0 0 3 -9)
                                 unselected-racket-at-initial-pos)
                (make-ball 3 9 3 9)
                "(ball-after-tick (make-ball 0 0 3 -9) did not
                return expected ball")
  (check-equal? (ball-after-tick (make-ball 425 425 3 -9)
                                 unselected-racket-at-initial-pos)
                (make-ball 422 425 -3 -9)
                "(ball-after-tick (make-ball 425 425 3 -9)) did not
                return expected ball")
  (check-equal? (ball-after-tick (make-ball 0 10 -3 -9)
                                 unselected-racket-at-initial-pos)
                (make-ball 3 10 3 -9)
                "(ball-after-tick (make-ball 0 10 3 -9)) did not
                return expected ball")
  (check-equal? (ball-after-tick (make-ball 100 100 3 -9)
                                 unselected-racket-at-initial-pos)
                (make-ball 103 91 3 -9)
                "(ball-after-tick (make-ball 100 100 3 -9)) did not
                return expected ball")
  (check-equal? (ball-after-tick
                 (make-ball 200 200 3 9)
                 (make-racket 202 202 0 0 #false (make-mouse-info 0 0)))
                (make-ball 200 200 3 -9)
                "(ball-after-tick
                 (make-ball 200 200 3 9)
                 (make-racket 202 202 0 0 #false (make-mouse-info 0 0))) did not
                return expected ball"))

;; ball-after-racket-ball-collision : Ball Racket -> Ball
;; GIVEN: the state of the a ball b and racket r in an unpaused world
;; RETURNS: the state of the given ball after collision
;; EXAMPLE: (ball-after-racket-ball-collision (make-ball 200 200 3 -9)
;;            (make-racket 202 195 0 0 #false (make-mouse-info 0 0)))
;;           => (make-ball 200 200 3 9)
;; STRATEGY: use observer template for ball on b
(define (ball-after-racket-ball-collision b r)
  (make-ball(ball-x b)
            (ball-y b)
            (ball-vx b)
            (-(racket-vy r)
              (ball-vy b))))

;; TESTS:
(define world-with-collision
  (make-world
   (list (make-ball 200 200 3 -9))
   (make-racket 202 195 0 0 #false (make-mouse-info 0 0))
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (ball-after-racket-ball-collision
                 (make-ball 200 200 3 -9)
                 (make-racket 202 195 0 0 #false (make-mouse-info 0 0)))
                (make-ball 200 200 3 9)
                "(ball-after-racket-ball-collision
                 (make-ball 200 200 3 -9)
                 (make-racket 202 195 0 0 #false (make-mouse-info 0 0)))
                 returned unexpected ball"))

;; racket-beyond-right-wall? : Racket -> Boolean
;; RETURNS: true iff the given racket goes beyond the right wall
;; EXAMPLE: (racket-beyond-right-wall?
;;           (make-racket 420 220 0 0 #false (make-mouse-info 0 0)))
;;           => #true
;; STRATEGY: check tentative position of racket r
(define (racket-beyond-right-wall? r)
  (and (> (+ (+ (racket-x r) (racket-vx r)) RACKET-HALF-WIDTH) CANVAS-WIDTH)
       (not(racket-selected? r))))

;; racket-beyond-left-wall? : Racket -> Boolean
;; RETURNS: true iff the given racket goes beyond the left wall
;; EXAMPLE: (racket-beyond-left-wall?
;;           (make-racket 0 220 0 0 #false (make-mouse-info 0 0)))
;;           => #true
;; STRATEGY: check tentative position of racket r
(define (racket-beyond-left-wall? r)
  (and (< (- (+ (racket-x r) (racket-vx r)) RACKET-HALF-WIDTH) 0)
       (not(racket-selected? r))))

;; racket-after-tick : World -> Racket
;; GIVEN: the state of the a racket r in an unpaused world
;; RETURNS: the state of the given racket after a tick.
;; EXAMPLE: (racket-after-tick unselected-racket-right-wall-world)
;;              => (make-racket 402 220 0 0 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r and HOF ormap
(define (racket-after-tick w)
  (cond
    [(racket-beyond-left-wall? (world-racket w))
     (make-racket RACKET-LEFT-WALL-ADJUSTED
                  (racket-y (world-racket w))
                  0
                  0
                  #false
                  INITIAL-MOUSE-INFO)]
    [(racket-beyond-right-wall? (world-racket w))
     (make-racket RACKET-RIGHT-WALL-ADJUSTED
                  (racket-y (world-racket w))
                  0
                  0
                  #false
                  INITIAL-MOUSE-INFO)]
    [(ormap (; Ball -> Boolean
             ; GIVEN: a Ball x
             ; RETURNS: true iff the racket and ball in its argument collide
             lambda (x) (will-racket-ball-collide?
                         (world-racket w) x)) (world-balls w))
     (make-racket (racket-x (world-racket w))
                  (racket-y (world-racket w))
                  0
                  0
                  (racket-selected? (world-racket w))
                  (racket-mouse-info (world-racket w)))]
    [(not(racket-selected? (world-racket w)))
     (make-racket
      (+ (racket-x (world-racket w)) (racket-vx (world-racket w)))
      (+ (racket-y (world-racket w)) (racket-vy (world-racket w)))
      (racket-vx (world-racket w))
      (racket-vy (world-racket w))
      #false
      INITIAL-MOUSE-INFO)]
    [else (world-racket w)]))

;; TESTS:
;; examples for test
(define selected-racket-world
  (make-world
   INITIAL-BALL-LIST
   (make-racket 220 220 0 0 #true (make-mouse-info 0 0))
   #true
   RALLY
   30
   0.1))
(define unselected-racket-right-wall-world
  (make-world
   INITIAL-BALL-LIST
   (make-racket 420 220 0 0 #false (make-mouse-info 0 0))
   #true
   RALLY
   30
   0.1))
(define unselected-racket-left-wall-world
  (make-world
   INITIAL-BALL-LIST
   (make-racket 0 220 0 0 #false (make-mouse-info 0 0))
   #true
   RALLY
   30
   0.1))
(define unselected-racket-world
  (make-world
   INITIAL-BALL-LIST
   (make-racket 200 220 0 0 #false (make-mouse-info 0 0))
   #true
   RALLY
   30
   0.1))
(define world-racket-ball-collision
  (make-world
   (list (make-ball 200 200 3 9))
   (make-racket 202 203 0.1 0.1 #false (make-mouse-info 0 0))
   #false
   RALLY
   0
   0.1))                 

(begin-for-test
  (check-equal? (racket-after-tick selected-racket-world)
                (make-racket 220 220 0 0 #true (make-mouse-info 0 0))
                "(racket-after-tick selected-racket) returned unexpected
                  racket")
  (check-equal? (racket-after-tick unselected-racket-right-wall-world)
                (make-racket 402 220 0 0 #false (make-mouse-info 0 0))
                "(racket-after-tick unselected-racket-right-wall)
                  returned unexpected racket")
  (check-equal? (racket-after-tick unselected-racket-left-wall-world)
                (make-racket 24 220 0 0 #false (make-mouse-info 0 0))
                "(racket-after-tick unselected-racket-left-wall)
                  returned unexpected racket")
  (check-equal? (racket-after-tick unselected-racket-world)
                (make-racket 200 220 0 0 #false (make-mouse-info 0 0))
                "(racket-after-tick unselected-racket)
                  returned unexpected racket")
  (check-equal? (racket-after-tick world-racket-ball-collision)
                (make-racket 202 203 0 0 #false (make-mouse-info 0 0))
                "(racket-after-tick world-racket-ball-collision)
                  returned unexpected racket"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start-timer : World -> World
;; GIVEN: a paused world w
;; RETURNS: a world in ready-to-serve state after the end of 3 seconds;
;;          otherwise, a world in rally state with timer incremented.
;; EXAMPLE: (start-timer world-before-end-of-3seconds)
;;           => world-with-timer-incremented
;; STRATEGY: if the timer is equal to 3 seconds, reset;
;;           increment timer, otherwise.
(define (start-timer w)
  (
   if(= (world-timer w) (/ DURATION-OF-PAUSE (world-speed w)))
     (make-world
      INITIAL-BALL-LIST
      (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
      #true
      READY-TO-SERVE 
      1
      (world-speed w))
         
     (make-world
      (world-balls w)
      (world-racket w)
      (world-paused? w)
      RALLY
      (+ (world-timer w) 1)
      (world-speed w))))

;; TESTS:
;; example for tests:
(define world-at-end-of-3seconds
  (make-world
   INITIAL-BALL-LIST
   (make-racket 34 12 0 0 #false INITIAL-MOUSE-INFO)
   #true
   RALLY
   30
   0.1))
(define beginning-world
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
   #true
   READY-TO-SERVE
   0
   0.1))
(define world-before-end-of-3seconds
  (make-world
   INITIAL-BALL-LIST
   (make-racket 34 12 0 0 #false INITIAL-MOUSE-INFO)
   #true
   RALLY
   28
   0.1))
(define world-with-timer-incremented
  (make-world
   INITIAL-BALL-LIST
   (make-racket 34 12 0 0 #false INITIAL-MOUSE-INFO)
   #true
   RALLY
   29
   0.1))

(begin-for-test
  (check-equal? (start-timer world-at-end-of-3seconds)
                (make-world
                 INITIAL-BALL-LIST
                 (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
                 #true
                 READY-TO-SERVE
                 1
                 0.1)
                "(start-timer WORLD-AT-END-OF-3SECONDS) returned
                 unexpected world")
  (check-equal? (start-timer world-before-end-of-3seconds)
                world-with-timer-incremented
                "(start-timer WORLD-AT-END-OF-3SECONDS) returned
                 unexpected world"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; racket-after-left-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          x component of velocity decremented
;; EXAMPLE: (racket-after-left-key-pressed racket-unselected-before-key)
;;           => (make-racket 220 220 2 5 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r
(define (racket-after-left-key-pressed r)
  (if (not(racket-selected? r))
      (make-racket
       (racket-x r)
       (racket-y r)
       (- (racket-vx r) 1)
       (racket-vy r)
       #false
       INITIAL-MOUSE-INFO)
      r))

;; racket-after-right-key-pressed : Racket KeyEvent -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          x component of velocity incremented
;; EXAMPLE: (racket-after-right-key-pressed racket-unselected-before-key)
;;           => (make-racket 220 220 4 5 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r
(define (racket-after-right-key-pressed r)
  (if (not(racket-selected? r))
      (make-racket
       (racket-x r)
       (racket-y r)
       (+ (racket-vx r) 1)
       (racket-vy r)
       #false
       INITIAL-MOUSE-INFO)
      r))

;; racket-after-up-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          y-velocity decremented
;; EXAMPLE: (racket-after-up-key-pressed racket-unselected-before-key)
;;           => (make-racket 220 220 3 4 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r
(define (racket-after-up-key-pressed r)
  (if (not(racket-selected? r))
      (make-racket
       (racket-x r)
       (racket-y r)
       (racket-vx r)
       (- (racket-vy r) 1)
       #false
       INITIAL-MOUSE-INFO)
      r))

;; racket-after-down-key-pressed : Racket -> Racket
;; RETURNS: a racket r just like the given one, but with the
;;          y-velocity incremented
;; EXAMPLE: (racket-after-down-key-pressed racket-unselected-before-key)
;;           => (make-racket 220 220 3 6 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r
(define (racket-after-down-key-pressed r)
  (if (not(racket-selected? r))
      (make-racket
       (racket-x r)
       (racket-y r)
       (racket-vx r)
       (+ (racket-vy r) 1)
       #false
       INITIAL-MOUSE-INFO)
      r))

;; TESTS:
;; example for tests:
(define racket-unselected-before-key
  (make-racket 220
               220
               3
               5
               #false
               (make-mouse-info 0 0)))

(define racket-selected-before-key
  (make-racket 220
               220
               3
               5
               #true
               (make-mouse-info 0 0)))
  
(begin-for-test
  (check-equal? (racket-after-left-key-pressed racket-unselected-before-key)
                (make-racket 220 220 2 5 #false (make-mouse-info 0 0))
                "(racket-after-left-key-pressed racket-unselected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-right-key-pressed racket-unselected-before-key)
                (make-racket 220 220 4 5 #false (make-mouse-info 0 0))
                "(racket-after-right-key-pressed racket-unselected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-up-key-pressed racket-unselected-before-key)
                (make-racket 220 220 3 4 #false (make-mouse-info 0 0))
                "(racket-after-up-key-pressed racket-unselected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-down-key-pressed racket-unselected-before-key)
                (make-racket 220 220 3 6 #false (make-mouse-info 0 0))
                "(racket-after-left-key-pressed racket-unselected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-left-key-pressed racket-selected-before-key)
                racket-selected-before-key
                "(racket-after-left-key-pressed racket-selected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-right-key-pressed racket-selected-before-key)
                racket-selected-before-key
                "(racket-after-right-key-pressed racket-selected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-up-key-pressed racket-selected-before-key)
                racket-selected-before-key
                "(racket-after-up-key-pressed racket-selected-before-key)
                 returned unexpected racket")
  (check-equal? (racket-after-down-key-pressed racket-selected-before-key)
                racket-selected-before-key
                "(racket-after-left-key-pressed racket-selected-before-key)
                 returned unexpected racket"))

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
            (on-key world-after-key-event)
            (on-mouse world-after-mouse-event)))
          
;; initial-world : PosReal -> World
;; GIVEN: the speed of the simulation, in seconds per tick
;;     (so larger numbers run slower)
;; RETURNS: the ready-to-serve state of the world
;; EXAMPLE: (initial-world 1) => beginning-world
;; STRATEGY: Use observer template on world w
(define (initial-world s)
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
   true
   READY-TO-SERVE
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
;; EXAMPLE: (world-ready-to-serve? beginning-world) => #true
;; STRATEGY: string comparison
(define (world-ready-to-serve? w)
  (string=? (world-state w) READY-TO-SERVE))

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
;; EXAMPLE: (world-after-tick world-in-paused-ready-to-serve)
;;           => world-in-paused-ready-to-serve
;; STRATEGY: divide into cases and use helper functions
(define (world-after-tick w)
  (cond
    [(and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
     w]
    [(and (world-paused? w) (string=? (world-state w) RALLY))
     (start-timer w)]
    [else
     (ball-hits-back-wall
      (world-after-tick-in-rally
       (racket-hits-front-wall
        w)))]))

;; TESTS:
(define world-in-paused-ready-to-serve
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
   #true
   READY-TO-SERVE
   0
   0.1))

(define world-in-paused-rally
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
   #true
   RALLY
   0
   0.1))

(define world-in-paused-rally-incremented-timer
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
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
                 (list (make-ball 203 191 3 -9))
                 (make-racket 202 195 0 0 #false INITIAL-MOUSE-INFO)
                 #false
                 "rally"
                 0
                 0.1)
                ""))
  
;; world-after-tick-in-rally : World -> World
;; GIVEN: a world w in unpaused rally state
;; RETURNS: the world that should follow the given world after a tick
;; EXAMPLE: (world-after-tick-in-rally world-in-rally-at-beginning)
;;           => world-in-rally-after-beginning
;; STRATEGY: Use observer template on world w
(define (world-after-tick-in-rally w)
  (make-world
   (balls-after-tick (world-balls w) (world-racket w))
   (racket-after-tick w)
   (world-paused? w)
   (world-state w)
   (world-timer w)
   (world-speed w)))

;; TESTS:
(define world-in-rally-at-beginning
  (make-world
   INITIAL-BALL-LIST
   (make-racket X-START Y-START 0 0 #false INITIAL-MOUSE-INFO)
   #true
   RALLY
   1
   0.1))

(define world-in-rally-after-beginning
  (make-world
   (list (make-ball 330 384 0 0))
   (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
   #true
   RALLY
   1
   0.1))

(begin-for-test
  (check-equal? (world-after-tick-in-rally world-in-rally-at-beginning)
                world-in-rally-after-beginning
                "(world-after-tick-in-rally world-in-rally) returned
                  unexpected world"))

;; last-ball-hits-back-wall : World -> Boolean
;; GIVEN: a world w
;; RETURNS: true iff the last ball in the world w has hit the back wall
;; EXAMPLE: (make-world empty
;;                     (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
;;                     #false
;;                     "rally"
;;                      0
;;                      0.1) => #true
;; STRATEGY: check if ball list in world w is empty
(define (last-ball-hits-back-wall w)
  (cond
    [(empty? (world-balls w)) #true]
    [else
     #false]))
     
;; ball-hits-back-wall : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if the ball hits the
;;          back wall of canvas
;; EXAMPLE: (ball-hits-back-wall world-with-ball)
;;           => world-with-ball
;; STRATEGY: Use observer template on world w
(define (ball-hits-back-wall w)
  (cond
    [(last-ball-hits-back-wall w)
     (make-world
      empty
      (world-racket w)
      #true
      RALLY
      (+ (world-timer w) 1)
      (world-speed w))]
    [(> (+ (ball-y (first (world-balls w))) (ball-vy (first (world-balls w))))
        CANVAS-HEIGHT)
     (make-world
      (rest (world-balls w))
      (world-racket w)
      #false
      RALLY
      (world-timer w)
      (world-speed w))]
    [else w]))

;; TESTS:
;; examples for test:
(define world-with-ball-at-back-wall
  (make-world
   (list (make-ball 200 CANVAS-HEIGHT 3 2))
   (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(define world-with-last-ball-at-back-wall
  (make-world
   empty
   (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(define world-with-ball
  (make-world
   (list (make-ball 200 200 3 2))
   (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (ball-hits-back-wall world-with-ball-at-back-wall)
                (make-world
                 empty
                 (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
                 #false
                 "rally"
                 0
                 0.1)
                "(ball-hits-back-wall world-with-ball-at-back-wall) returned
                  unexpected world")
  (check-equal? (ball-hits-back-wall world-with-last-ball-at-back-wall)
                (make-world
                 empty
                 (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
                 #true
                 "rally"
                 1
                 0.1)
                "(ball-hits-back-wall world-with-last-ball-at-back-wall)
                   returned unexpected world")
  (check-equal? (ball-hits-back-wall world-with-ball)
                world-with-ball
                "(ball-hits-back-wall world-with-ball) returned
                  unexpected world"))

;; racket-hits-front-wall : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if the racket hits the
;;          front wall of canvas
;; EXAMPLE: (racket-hits-front-wall world-with-racket-at-front-wall)
;;            =>  (make-world (list (make-ball 200 300 3 2))
;;                (make-racket 300 -1 2 -1 #true (make-mouse-info 2 3))
;;                #true
;;                "rally"
;;                0
;;                0.1)
;; STRATEGY: Use observer template on world w
(define (racket-hits-front-wall w)
  (if (< (racket-y (world-racket w)) 0)
      (make-world
       (world-balls w)
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
   (list (make-ball 200 300 3 2))
   (make-racket 300 -1 2 -1 #true (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(define world-with-racket
  (make-world
   (list (make-ball 200 200 3 2))
   (make-racket 300 300 2 1 #true (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (racket-hits-front-wall world-with-racket-at-front-wall)
                (make-world
                 (list (make-ball 200 300 3 2))
                 (make-racket 300 -1 2 -1 #true (make-mouse-info 2 3))
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
;; EXAMPLE: (world-after-left-key-event world-before-key-event)
;;             => (make-world
;;                (list (make-ball 200 300 3 -9))
;;                (make-racket 100 200 1 2 #false (make-mouse-info 0 0))
;;                #false
;;                "rally"
;;                0
;;                0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-left-key-event w)
  (if (and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
      w
      (make-world
       (world-balls w)
       (racket-after-left-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-right-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if right key is pressed
;; EXAMPLE: (world-after-right-key-event world-before-key-event)
;;            =>   (make-world
;;                 (list (make-ball 200 300 3 -9))
;;                 (make-racket 100 200 3 2 #false (make-mouse-info 0 0))
;;                 #false
;;                 "rally"
;;                 0
;;                 0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-right-key-event w)
  (if (and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
      w
      (make-world
       (world-balls w)
       (racket-after-right-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-up-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if up key is pressed
;; EXAMPLE: (world-after-up-key-event world-before-key-event)
;;             =>  (make-world
;;                 (list (make-ball 200 300 3 -9))
;;                 (make-racket 100 200 2 1 #false (make-mouse-info 0 0))
;;                 #false
;;                 "rally"
;;                 0
;;                 0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-up-key-event w)
  (if (and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
      w
      (make-world
       (world-balls w)
       (racket-after-up-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; world-after-down-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if down key is pressed
;; EXAMPLE: (world-after-down-key-event world-before-key-event)
;;           =>    (make-world
;;                 (list (make-ball 200 300 3 -9))
;;                 (make-racket 100 200 2 3 #false (make-mouse-info 0 0))
;;                 #false
;;                 "rally"
;;                 0
;;                 0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-down-key-event w)
  (if (and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
      w
      (make-world
       (world-balls w)
       (racket-after-down-key-pressed (world-racket w))
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; TESTS:
;; example for test:
(define world-before-key-event
  (make-world
   (list (make-ball 200 300 3 -9))
   (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (world-after-left-key-event world-before-key-event)
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 1 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-left-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-left-key-event world-in-paused-ready-to-serve)
                (make-world
                 (list (make-ball 330 384 0 0))
                 (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
                 #true
                 "ready-to-serve"
                 0
                 0.1)
                "(world-after-left-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-right-key-event world-before-key-event)
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 3 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-right-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-right-key-event world-in-paused-ready-to-serve)
                (make-world
                 (list (make-ball 330 384 0 0))
                 (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
                 #true
                 "ready-to-serve"
                 0
                 0.1)
                "(world-after-right-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-up-key-event world-before-key-event)
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 1 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-up-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-up-key-event world-in-paused-ready-to-serve)
                (make-world
                 (list (make-ball 330 384 0 0))
                 (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
                 #true
                 "ready-to-serve"
                 0
                 0.1)
                "(world-after-up-key-event world-in-paused-ready-to-serve)
                 returned unexpected world")
  (check-equal? (world-after-down-key-event world-before-key-event)
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 3 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-down-key-event world-before-key-event)
                 returned unexpected world")
  (check-equal? (world-after-down-key-event world-in-paused-ready-to-serve)
                (make-world
                 (list (make-ball 330 384 0 0))
                 (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
                 #true
                 "ready-to-serve"
                 0
                 0.1)
                "(world-after-down-key-event world-in-paused-ready-to-serve)
                 returned unexpected world"))


;; world-after-b-key-event : World -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow if b key is pressed
;; EXAMPLE: (world-after-b-key-event world-before-b-key-event)
;;           =>    (make-world
;;                 (list (make-ball 330 384 3 -9) (make-ball 200 300 3 -9))
;;                 (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
;;                 #false
;;                 "rally"
;;                 0
;;                 0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-b-key-event w)
  (if (and (world-paused? w) (string=? (world-state w) READY-TO-SERVE))
      w
      (make-world
       (append (cons (make-ball X-START Y-START VX-START VY-START) empty)
               (world-balls w))
       (world-racket w)
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))))

;; TESTS:
;; example for test:
(define world-before-b-key-event
  (make-world
   (list (make-ball 200 300 3 -9))
   (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
   #false
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (world-after-b-key-event world-before-b-key-event)
                (make-world
                 (list (make-ball 330 384 3 -9) (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-b-key-event world-before-b-key-event)
                returned unexpected world")
  (check-equal? (world-after-b-key-event world-in-paused-ready-to-serve)
                world-in-paused-ready-to-serve
                "(world-after-b-key-event world-in-paused-ready-to-serve)
                returned unexpected world"))

;; pause-toggle : World -> World
;; GIVEN: a world w
;; RETURNS: unpaused world in rally state if the world w is in paused
;;          and ready-to-serve state;
;;          paused world in rally state if the world w is in unpaused
;;          and rally state;
;;          the given world w otherwise.
;; EXAMPLE: (pause-toggle pause-ready-to-serve)
;;           =>    (make-world
;;                 (list (make-ball 330 384 3 -9))
;;                 (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
;;                 #false
;;                 "rally"
;;                 0
;;                 0.1)
;; STRATEGY: Check for conditions and use observer template on world w
(define (pause-toggle w)
  (cond
    [(and (string=? (world-state w) READY-TO-SERVE) (world-paused? w))
     (make-world
      (append (cons (make-ball X-START Y-START VX-START VY-START) empty)
              empty)
      (world-racket w)
      #false
      RALLY
      (world-timer w)
      (world-speed w))] 
    [(and (string=? (world-state w) RALLY) (not (world-paused? w)))
     (make-world
      (world-balls w)
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
   (list (make-ball 200 300 3 2))
   (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
   #true
   READY-TO-SERVE
   0
   0.1))

(define not-paused-rally
  (make-world
   (list (make-ball 200 300 3 2))
   (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
   #false
   RALLY
   0
   0.1))

(define paused-rally
  (make-world
   (list (make-ball 200 300 3 2))
   (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
   #true
   RALLY
   0
   0.1))

(begin-for-test
  (check-equal? (pause-toggle pause-ready-to-serve)
                (make-world
                 (list (make-ball 330 384 3 -9))
                 (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
                 #false
                 "rally"
                 0
                 0.1)
                "(pause-toggle pause-ready-to-serve)
                  returned unexpected world")
  (check-equal? (pause-toggle not-paused-rally)
                (make-world
                 (list (make-ball 200 300 3 2))
                 (make-racket 300 0 2 -1 #false (make-mouse-info 2 3))
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
;; EXAMPLE: Refer to test cases below
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
    [(is-b-key-event? kev)
     (world-after-b-key-event w)]
    [else w]))

;; TESTS:
  
(begin-for-test
  (check-equal? (world-after-key-event beginning-world " ")
                (make-world
                 (list (make-ball 330 384 3 -9))
                 (make-racket 330 384 0 0 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-key-event beginning-world space)
                 returned unexpected world ")
  (check-equal? (world-after-key-event world-before-key-event "left")
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 1 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-left-key-event world-before-key-event left)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "right")
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 3 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-right-key-event world-before-key-event right)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "up")
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 1 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-up-key-event world-before-key-event up)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "down")
                (make-world
                 (list (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 3 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-down-key-event world-before-key-event down)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-b-key-event "b")
                (make-world
                 (list (make-ball 330 384 3 -9) (make-ball 200 300 3 -9))
                 (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-down-key-event world-before-b-key-event down)
                 returned unexpected world")
  (check-equal? (world-after-key-event world-before-key-event "q")
                world-before-key-event
                "(world-after-down-key-event world-before-key-event q)
                 returned unexpected world"))
                   
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

;; magic-math: Int Int PosReal Int Int -> Int
;; GIVEN: x and y coordinates of ball position(xb, yb)
;;        x and y coordinates of the either end of racket (xr, yr)
;;        ydelta, change in the y component of ball between the current
;;        and next tick
;; RETURNS: minimum or maximum possible position of x-component of ball
;;          after collision
;; EXAMPLE: (magic-math 200 200 202 202 3) => 203
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

;; check-position : Ball Racket -> Boolean
;; GIVEN: a ball b and a racket r
;; RETURNS: true iff the ball's position in the previous tick does not
;;          lie on the 47-pixel line segment of the racket in the previous tick
;; EXAMPLE: (check-position (make-ball 200 200 3 -9)
;;                              (make-racket 198 198 0 0 #true
;;                                           (make-mouse-info 0 0))) => true
;; STRATEGY: numeric comparison
(define (check-position b r)
  (and
   (not(= (- (ball-y b) (ball-vy b)) (racket-y r)))
   (not
    (and
     (> (- (ball-x b) (ball-vx b)) (+ (racket-x r) RACKET-HALF-WIDTH))
     (< (- (ball-x b) (ball-vx b)) (- (racket-x r) RACKET-HALF-WIDTH))))))

;; TESTS:
(begin-for-test
  (check-equal? (check-position (make-ball 200 200 3 -9)
                                (make-racket 198 198 0 0 #true
                                             (make-mouse-info 0 0)))
                #true
                "(check-position (make-ball 200 200 3 -9)
                                (make-racket 198 198 0 0 #true
                                             (make-mouse-info 0 0)))
                should return true")
  (check-equal? (check-position (make-ball 250 200 3 -9)
                                (make-racket 200 198 0 0 #true
                                             (make-mouse-info 0 0)))
                #true
                "(check-position (make-ball 250 200 3 -9)
                                (make-racket 200 198 0 0 #true
                                             (make-mouse-info 0 0)))
                should return true"))

;; check-vy : Ball Racket -> Boolean
;; GIVEN: a ball b and a racket r
;; RETURNS: true iff vy component of the ball's velocity
;;          is either zero or positive.
;; EXAMPLE: (check-vy (make-ball 200 200 3 -9)
;;                        (make-racket 198 198 0 0 #true
;;                                     (make-mouse-info 0 0))) => #false
;; STRATEGY: numeric comparison
(define (check-vy b r)
  (>= (ball-vy b) 0))

;; TESTS:
(begin-for-test
  (check-equal? (check-vy (make-ball 200 200 3 -9)
                          (make-racket 198 198 0 0 #true
                                       (make-mouse-info 0 0)))
                #false
                "(check-position (make-ball 200 200 3 -9)
                                (make-racket 198 198 0 0 #true
                                             (make-mouse-info 0 0)))
                 should return false"))

;; is-intersecting? : Ball Racket -> Boolean
;; GIVEN: a ball b and a racket r
;; RETURNS: line that connects the ball's position in the previous tick
;;       with the first tentative position calculated for the ball in this tick
;;       intersects the 47-pixel line segment that represents the racket's new
;;       position for this tick.
;; EXAMPLE: (is-intersecting?
;;               (make-ball 200 200 3 -9)
;;               (make-racket 202 195 0 0 #false (make-mouse-info 0 0)))
;;           => #true
;; STRATEGY: use simpler functions
(define (is-intersecting? b r)
  (let ((bt (make-ball
             (+ (ball-x b) (+ (ball-vx b) (ball-vx b)))
             (+ (ball-y b) (+ (ball-vy b) (ball-vy b)))
             (ball-vx b)
             (ball-vy b)))
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
  (check-equal? (is-intersecting?
                 (make-ball 200 200 3 -9)
                 (make-racket 202 202 0 0 #false (make-mouse-info 0 0)))
                #false
                "racket and ball should not collide")
  (check-equal? (is-intersecting?
                 (make-ball 200 200 3 -9)
                 (make-racket 202 195 0 0 #false (make-mouse-info 0 0)))
                #true
                "racket and ball should collide")
  (check-equal? (is-intersecting?
                 (make-ball 200 200 3 3)
                 (make-racket 200 203 0 0 #false (make-mouse-info 0 0)))
                #true
                "racket and ball should not collide"))

;; will-racket-ball-collide? : Racket Ball -> Boolean
;; GIVEN: a racket r and ball b
;; RETURNS: retruns true iff the ball b and racket r collide
;; EXAMPLE: (will-racket-ball-collide?
;;               (make-racket 202 203 0 0 #false (make-mouse-info 0 0))
;;               (make-ball 200 200 3 9))
;;           => #true
;; STRATEGY: use simpler functions.
(define (will-racket-ball-collide? r b)
  (and
   (check-position b r)
   (check-vy b r)
   (is-intersecting? b r)))

;; TESTS:
(begin-for-test
  (check-equal? (will-racket-ball-collide?
                 (make-racket 202 203 0 0 #false (make-mouse-info 0 0))
                 (make-ball 200 200 3 9))
                #true
                "(will-racket-ball-collide?
                 (make-racket 202 203 0 0 #false (make-mouse-info 0 0))
                 (make-ball 200 200 3 9)) should return true"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-mouse-event : World Int Int MouseEvent -> World
;; GIVEN: a world, the x and y coordinates of a mouse event,
;;     and the mouse event
;; RETURNS: the world that should follow the given world after
;;     the given mouse event
;; EXAMPLE: (world-after-mouse-event unpaused-rally-world 100 100 "drag")
;;           =>  (make-world
;;               (list (make-ball 200 200 3 -9))
;;               (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
;;               #false
;;               "rally"
;;               0
;;               0.1)
;; STRATEGY: Use observer template on world w
(define (world-after-mouse-event w mx my mev)
  (if (and (not(world-paused? w)) (string=? (world-state w) RALLY))
      (make-world
       (world-balls w)
       (racket-after-mouse-event (world-racket w) mx my mev)
       (world-paused? w)
       (world-state w)
       (world-timer w)
       (world-speed w))
      w))

;; TESTS:
;; example for test:
(define unpaused-rally-world
  (make-world
   (list (make-ball 200 200 3 -9))
   (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
   #false
   RALLY
   0
   0.1))

(define world-with-no-collision
  (make-world
   (list (make-ball 200 200 3 -9))
   (make-racket 202 202 0 0 #false (make-mouse-info 0 0))            
   #false
   RALLY
   0
   0.1)) 

(begin-for-test
  (check-equal? (world-after-mouse-event unpaused-rally-world 100 100 "drag")
                (make-world
                 (list (make-ball 200 200 3 -9))
                 (make-racket 100 200 2 2 #false (make-mouse-info 0 0))
                 #false
                 "rally"
                 0
                 0.1)
                "(world-after-mouse-event unpaused-rally-world 100 100 drag)
                  returned unexpected world")
  (check-equal? (world-after-mouse-event paused-rally 100 100 "drag")
                paused-rally
                "(world-after-mouse-event paused-rally-world 100 100 drag)
                  returned unexpected world"))

;; racket-after-mouse-event : Racket Int Int MouseEvent -> Racket
;; GIVEN: a racket, the x and y coordinates of a mouse event,
;;        and the mouse event
;; RETURNS: the racket as it should be after the given mouse event
;; EXAMPLE: (racket-after-mouse-event
;;               racket-before-mouse-event 203 203 "button-down")
;;           => (make-racket 200 200 2 4 #true (make-mouse-info 3 3))
;; STRATEGY: check for conditions and use helper functions
(define (racket-after-mouse-event r mx my mev)
  (cond
    [(mouse=? mev "button-down") (racket-after-button-down r mx my)]
    [(mouse=? mev "drag") (racket-after-drag r mx my)]
    [(mouse=? mev "button-up") (racket-after-button-up r mx my)]
    [else r]))

;; TESTS:
;; example for tests:
(define racket-before-mouse-event
  (make-racket
   200
   200
   2
   4
   #true
   (make-mouse-info 203 203)))
   
(begin-for-test
  (check-equal? (racket-after-mouse-event
                 racket-before-mouse-event 203 203 "button-down")
                (make-racket 200 200 2 4 #true (make-mouse-info 3 3))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 button-down))
                  returned unexpected racket")
  (check-equal? (racket-after-mouse-event
                 racket-before-mouse-event 203 203 "drag")
                (make-racket 0 0 2 4 #true (make-mouse-info 203 203))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 drag))
                  returned unexpected racket")
  (check-equal? (racket-after-mouse-event
                 racket-before-mouse-event 203 203 "button-up")
                (make-racket 200 200 2 4 #false (make-mouse-info 0 0))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 button-down))
                  returned unexpected racket")
  (check-equal? (racket-after-mouse-event
                 racket-before-mouse-event 203 203 "enter")
                racket-before-mouse-event
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 enter))
                  returned unexpected racket"))

;; racket-after-button-down : Racket Int Int -> Racket
;; GIVEN:  a racket, the x and y coordinates of a mouse event
;; RETURNS: the racket as it should be after the button down mouse event
;; EXAMPLE: (racket-after-button-down
;;               selected-racket-before-mouse-event 203 203)
;;           => (make-racket 200 200 2 4 #true (make-mouse-info 3 3))
;; STRATEGY: Use observer template on racket r
(define (racket-after-button-down r mx my)
  (if (in-racket? r mx my)
      (make-racket
       (racket-x r)
       (racket-y r)
       (racket-vx r)
       (racket-vy r)
       #true
       (make-mouse-info  (- mx (racket-x r)) (- my (racket-y r))))
      r))

;; racket-after-drag : Racket Int Int -> Racket
;; GIVEN:  a racket, the x and y coordinates of a mouse event
;; RETURNS: the racket as it should be after the drag mouse event
;; EXAMPLE: (racket-after-drag
;;               selected-racket-before-mouse-event 203 203)
;;           => (make-racket 0 0 2 4 #true (make-mouse-info 203 203))
;; STRATEGY: Use observer template on racket r
(define (racket-after-drag r mx my)
  (if (racket-selected? r)
      (make-racket
       (- mx (mouse-info-rx (racket-mouse-info r)))
       (- my (mouse-info-ry (racket-mouse-info r)))
       (racket-vx r)
       (racket-vy r)
       #true
       (racket-mouse-info r))
      r))

;; racket-after-button-up : Racket Int Int -> Racket
;; GIVEN:  a racket, the x and y coordinates of a mouse event
;; RETURNS: the racket as it should be after the button up mouse event
;; EXAMPLE: (racket-after-button-up
;;               selected-racket-before-mouse-event 203 203)
;;           => (make-racket 200 200 2 4 #false (make-mouse-info 0 0))
;; STRATEGY: Use observer template on racket r
(define (racket-after-button-up r mx my)
  (if (racket-selected? r)
      (make-racket
       (racket-x r)
       (racket-y r)
       (racket-vx r)
       (racket-vy r)
       #false
       INITIAL-MOUSE-INFO)
      r))

;; TESTS:
;; example for tests:
(define selected-racket-before-mouse-event
  (make-racket
   200
   200
   2
   4
   #true
   (make-mouse-info 203 203)))

(define unselected-racket-x
  (make-racket
   100
   100
   2
   4
   #false
   (make-mouse-info 203 203)))

(define unselected-racket
  (make-racket 200 220 0 0 #false (make-mouse-info 0 0)))

(begin-for-test
  (check-equal? (racket-after-button-down
                 selected-racket-before-mouse-event 203 203)
                (make-racket 200 200 2 4 #true (make-mouse-info 3 3))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 button-down))
                  returned unexpected racket")
  (check-equal? (racket-after-button-down unselected-racket-x 203 203)
                unselected-racket-x
                "(racket-after-button-down unselected-racket 203 203)
                  returned unexpected racket")
  (check-equal? (racket-after-drag
                 selected-racket-before-mouse-event 203 203)
                (make-racket 0 0 2 4 #true (make-mouse-info 203 203))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 drag))
                  returned unexpected racket")
  (check-equal? (racket-after-button-up
                 selected-racket-before-mouse-event 203 203)
                (make-racket 200 200 2 4 #false (make-mouse-info 0 0))
                "(racket-after-mouse-event
                 (racket-before-mouse-event 203 203 button-down))
                  returned unexpected racket")
  (check-equal? (racket-after-button-up
                 unselected-racket 203 203)
                unselected-racket
                "(racket-after-button-down unselected-racket 203 203)
                  returned unexpected racket"))

;; in-racket? : Racket Int Int -> Boolean
;; GIVEN:  a racket, the x and y coordinates of a mouse event
;; RETURNS: true iff mouse pointer is within a certain pixel radius from
;;          the position of racket
;; EXAMPLE: (in-racket? racket-near-mouse 203 203) => #true
;; STRATEGY: transcribe formula (use equation of circle to check
;;           if the point lies inside the circle)
(define (in-racket? r mx my)
  (<
   (expt (+ (expt (- mx (racket-x r)) 2) (expt (- my (racket-y r)) 2)) 1/2)
   PIXEL-RADIUS))

;; TESTS:
;; examples for tests:
(define racket-near-mouse
  (make-racket
   200
   200
   2
   4
   #false
   (make-mouse-info 203 203)))

(define racket-not-near-mouse
  (make-racket
   100
   100
   2
   4
   #false
   (make-mouse-info 203 203)))

(begin-for-test
  (check-equal? (in-racket? racket-near-mouse 203 203)
                #true
                "mouse pointer at (203,203) is within 25 pixel radius
                 of racket at (200,200)")
  (check-equal? (in-racket? racket-not-near-mouse 203 203)
                #false
                "mouse pointer at (203,203) is not within 25 pixel radius
                 of racket at (100,100)"))
  
;; racket-selected? : Racket-> Boolean
;; GIVEN: a racket
;; RETURNS: true iff the racket is selected
;; STRATEGY: defined by DrRacket when a structure named
;;           racked with field selected? is created.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-balls : World -> BallList
;; GIVEN: a world
;; RETURNS: a list of the balls that are present in the world
;;          (but does not include any balls that have disappeared
;;          by colliding with the back wall)
;; STRATEGY: defined by DrRacket when a structure named world
;;           with field balls is created.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;