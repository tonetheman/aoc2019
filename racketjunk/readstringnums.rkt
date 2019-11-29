#lang racket

;; example of possible input
(define a "10 20\n30 40\n")

(for/list ([ln (in-list (string-split a "\n"))])
	  (printf "ln is ~a\n" ln)
	  (map string->number (string-split ln " "))
  )
