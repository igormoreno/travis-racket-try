;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |04|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)

; A Tick is positive Number
; Interpretation: the smallest time unit of the animation (typically 28 per second).

; A Time is a Number[0,127)
; Interpretation: a time in seconds up to 127 seconds,
; which is the time it takes for the traffic light to repeat.

; Conversion factor from ticks to seconds.
(define TICKS-PER-SECOND 28)

; Background of the scene.
(define BG (empty-scene 370 520 "black"))

; Border of the traffic light image.
(define GREY-CIRCLE (circle 75 "solid" "gray"))

; Color -> Image
; Helper function to make a traffic light circle image.
(define (mk-circle color)
  (overlay (circle 70 "solid" color) GREY-CIRCLE))

; Color -> Image
; Helper function to make a traffic light left arrow image.
(define (mk-arrow color)
  (overlay
    (beside (rotate 90 (triangle 60 "solid" color)) (rectangle 60 20 "solid" color))
    (mk-circle "black")
    GREY-CIRCLE))

; Possible traffic light images to turn left.
(define LEFT-RED-YELLOW     (above (mk-arrow  'red)   (mk-arrow  'yellow) (mk-circle 'black)))
(define LEFT-RED            (above (mk-arrow  'red)   (mk-circle 'black)  (mk-circle 'black)))
(define LEFT-YELLOW         (above (mk-circle 'black) (mk-arrow  'yellow) (mk-circle 'black)))
(define LEFT-GREEN          (above (mk-circle 'black) (mk-circle 'black)  (mk-arrow  'green)))

; Possible traffic light images to go straight.
(define STRAIGHT-RED-YELLOW (above (mk-circle 'red)   (mk-circle 'yellow) (mk-circle 'black)))
(define STRAIGHT-RED        (above (mk-circle 'red)   (mk-circle 'black)  (mk-circle 'black)))
(define STRAIGHT-YELLOW     (above (mk-circle 'black) (mk-circle 'yellow) (mk-circle 'black)))
(define STRAIGHT-GREEN      (above (mk-circle 'black) (mk-circle 'black)  (mk-circle 'green)))

; Number of seconds the traffic light remains in each state.
(define TIME-IN-STATE0 1)
(define TIME-IN-STATE1 15)
(define TIME-IN-STATE2 5)
(define TIME-IN-STATE3 1)
(define TIME-IN-STATE4 40)
(define TIME-IN-STATE5 5)
(define TIME-IN-STATE6 60)

; Total number of seconds from 0 to the end of each state.
(define END-STATE0 TIME-IN-STATE0)
(define END-STATE1 (+ END-STATE0 TIME-IN-STATE1))
(define END-STATE2 (+ END-STATE1 TIME-IN-STATE2))
(define END-STATE3 (+ END-STATE2 TIME-IN-STATE3))
(define END-STATE4 (+ END-STATE3 TIME-IN-STATE4))
(define END-STATE5 (+ END-STATE4 TIME-IN-STATE5))
(define END-STATE6 (+ END-STATE5 TIME-IN-STATE6))
(define TOTAL-PERIOD END-STATE6)

; Image Image -> Image
; Compose the full traffic light image.
(define (left+straight left straight) (overlay (beside left straight) BG))

; Number Number Number -> Boolean
; Return #true if a <= x < b and #false otherwise.
(define (between x a b) (and (>= x a) (< x b)))

; Time -> Image
; Given a Time return one of the possible traffic light images.
(define (traffic-light-state time)
  (cond [(between time 0          END-STATE0) (left+straight LEFT-RED-YELLOW STRAIGHT-RED)]
        [(between time END-STATE0 END-STATE1) (left+straight LEFT-GREEN      STRAIGHT-RED)]
        [(between time END-STATE1 END-STATE2) (left+straight LEFT-YELLOW     STRAIGHT-RED)]
        [(between time END-STATE2 END-STATE3) (left+straight LEFT-RED        STRAIGHT-RED-YELLOW)]
        [(between time END-STATE3 END-STATE4) (left+straight LEFT-RED        STRAIGHT-GREEN)]
        [(between time END-STATE4 END-STATE5) (left+straight LEFT-RED        STRAIGHT-YELLOW)]
        [(between time END-STATE5 END-STATE6) (left+straight LEFT-RED        STRAIGHT-RED)]))

; Tick -> Image
; Given a tick return one of the traffic light images.
; This function can be passed to (animate ...).
(define (traffic-light tick)
  (traffic-light-state (/ (modulo tick (* TOTAL-PERIOD TICKS-PER-SECOND)) TICKS-PER-SECOND)))

(check-expect (traffic-light 20) (left+straight LEFT-RED-YELLOW STRAIGHT-RED))
(check-expect (traffic-light 50) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 400) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 1000) (left+straight LEFT-RED STRAIGHT-GREEN))
(check-expect (traffic-light 9000) (left+straight LEFT-RED STRAIGHT-RED))
(check-expect (traffic-light 25000) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 100000) (left+straight LEFT-GREEN STRAIGHT-RED))

