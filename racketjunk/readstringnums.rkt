#lang racket

;; example of possible input
(define a "10 20\n30 40\n")

;; this is the for loop
;; in-list takes the result of string-split and makes a stream
(for/list ([ln (in-list (string-split a "\n"))])

	  ;; each ln is printed and it is the values
	  ;; from each line in the file
	  (printf "ln is ~a\n" ln)

	  ;; then we call map and produce numbers
	  ;; for the string values and split on space
	  (map string->number (string-split ln " "))
  )
