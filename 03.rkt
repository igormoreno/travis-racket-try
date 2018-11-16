;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |03|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; String Number String Number -> String
; Given the names of two people and their heights, returns the name of the taller person.
; If they have the same height return the name of the first person.
(define (taller name1 height1 name2 height2)
  (if (>= height1 height2) name1 name2))

(check-expect (taller "Marco" 160 "Nate" 210) "Nate")
(check-expect (taller "Marco" 200 "Nate" 190) "Marco")
(check-expect (taller "Tereh" 200 "Nystrom" 200) "Tereh")
