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

; Image Image -> Image
; Compose the full traffic light image.
(define (left+straight left straight) (overlay (beside left straight) BG))

; Time -> Image
; Given a Time return one of the possible traffic light images.
(define (traffic-light-state time)
  (cond [(and (>= time 0)  (< time 1))   (left+straight LEFT-RED-YELLOW STRAIGHT-RED)]
        [(and (>= time 1)  (< time 16))  (left+straight LEFT-GREEN      STRAIGHT-RED)]
        [(and (>= time 16) (< time 21))  (left+straight LEFT-YELLOW     STRAIGHT-RED)]
        [(and (>= time 21) (< time 22))  (left+straight LEFT-RED        STRAIGHT-RED-YELLOW)]
        [(and (>= time 22) (< time 62))  (left+straight LEFT-RED        STRAIGHT-GREEN)]
        [(and (>= time 62) (< time 67))  (left+straight LEFT-RED        STRAIGHT-YELLOW)]
        [(and (>= time 67) (< time 127)) (left+straight LEFT-RED        STRAIGHT-RED)]))

; Tick -> Image
; Given a tick return one of the traffic light images.
; This function can be passed to (animate ...).
(define (traffic-light tick)
  (traffic-light-state (/ (modulo tick (* 127 TICKS-PER-SECOND)) TICKS-PER-SECOND)))

(check-expect (traffic-light 20) (left+straight LEFT-RED-YELLOW STRAIGHT-RED))
(check-expect (traffic-light 50) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 400) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 1000) (left+straight LEFT-RED STRAIGHT-GREEN))
(check-expect (traffic-light 9000) (left+straight LEFT-RED STRAIGHT-RED))
(check-expect (traffic-light 25000) (left+straight LEFT-GREEN STRAIGHT-RED))
(check-expect (traffic-light 100000) (left+straight LEFT-GREEN STRAIGHT-RED))

