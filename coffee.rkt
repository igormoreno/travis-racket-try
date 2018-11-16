;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname coffee) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A Coin is one of:
; - '10-cents
; - '20-cents
; - '50-cents
; - '1-franc
; - '2-francs
; Interpretation: coins accepted by the machine.

; Template function on a Coin.
(define (function-on-coins c)
  (cond [(symbol=? c '10-cents) ...]
        [(symbol=? c '20-cents) ...]
        [(symbol=? c '50-cents) ...]
        [(symbol=? c '1-franc) ...]
        [(symbol=? c '2-francs) ...]))


; The MachineState is one of:
; - 'Idle
; - '10-cents-inserted
; - '20-cents-inserted
; - '30-cents-inserted
; - '40-cents-inserted
; - '50-cents-inserted
; - '60-cents-inserted
; - '70-cents-inserted
; - 'Paid
; Interpretation: The machine can either be in the 'Idle state, or in one of the
; states '10-cents-inserted, '20-cents-inserted, '30-cents-inserted,
; '40-cents-inserted, '50-cents-inserted, '60-cents-inserted, '70-cents-inserted,
; or 'Paid. The 'Idle state indicates that no coins have been inserted, the 'Paid
; state indicates that at least 80 cents have been inserted. The other states
; keep track of how much money has been inserted so far.

; Template function on a MachineState.
(define (function-on-states state)
  (cond [(symbol=? state 'Idle) ...]
        [(symbol=? state '10-cents-inserted) ...]
        [(symbol=? state '20-cents-inserted) ...]
        [(symbol=? state '30-cents-inserted) ...]
        [(symbol=? state '40-cents-inserted) ...]
        [(symbol=? state '50-cents-inserted) ...]
        [(symbol=? state '60-cents-inserted) ...]
        [(symbol=? state '70-cents-inserted) ...]
        [(symbol=? state 'Paid) ...]))


; MachineState -> MachineState
; Returns the next state of the machine when 10 cents is inserted.
(define (insert-10-cents state)
  (cond [(symbol=? state 'Idle) '10-cents-inserted]
        [(symbol=? state '10-cents-inserted) '20-cents-inserted]
        [(symbol=? state '20-cents-inserted) '30-cents-inserted]
        [(symbol=? state '30-cents-inserted) '40-cents-inserted]
        [(symbol=? state '40-cents-inserted) '50-cents-inserted]
        [(symbol=? state '50-cents-inserted) '60-cents-inserted]
        [(symbol=? state '60-cents-inserted) '70-cents-inserted]
        [(symbol=? state '70-cents-inserted) 'Paid]
        [(symbol=? state 'Paid) 'Paid]))

(check-expect (insert-10-cents 'Idle) '10-cents-inserted)
(check-expect (insert-10-cents '10-cents-inserted) '20-cents-inserted)
(check-expect (insert-10-cents '20-cents-inserted) '30-cents-inserted)
(check-expect (insert-10-cents '30-cents-inserted) '40-cents-inserted)
(check-expect (insert-10-cents '40-cents-inserted) '50-cents-inserted)
(check-expect (insert-10-cents '50-cents-inserted) '60-cents-inserted)
(check-expect (insert-10-cents '60-cents-inserted) '70-cents-inserted)
(check-expect (insert-10-cents '70-cents-inserted) 'Paid)
(check-expect (insert-10-cents 'Paid) 'Paid)


; MachineState Coin -> MachineState
; Returns the next state of the machine when a coin is inserted.
(define (insert-coin state coin)
  (cond [(symbol=? coin '1-franc) 'Paid]
        [(symbol=? coin '2-francs) 'Paid]
        [(symbol=? coin '10-cents) (insert-10-cents state)]
        [(symbol=? coin '20-cents) (insert-10-cents (insert-10-cents state))]
        [(symbol=? coin '50-cents) (insert-10-cents
                                     (insert-10-cents
                                       (insert-10-cents
                                         (insert-10-cents
                                           (insert-10-cents state)))))]))

(check-expect (insert-coin 'Idle '1-franc) 'Paid)
(check-expect (insert-coin 'Idle '2-francs) 'Paid)
(check-expect (insert-coin (insert-coin 'Idle '1-franc) '1-franc) 'Paid)
(check-expect (insert-coin 'Idle '20-cents) '20-cents-inserted)
(check-expect (insert-coin (insert-coin 'Idle '20-cents) '20-cents) '40-cents-inserted)
(check-expect (insert-coin (insert-coin 'Idle '50-cents) '50-cents) 'Paid)
(check-expect (insert-coin (insert-coin (insert-coin 'Idle '50-cents) '20-cents) '10-cents) 'Paid)

