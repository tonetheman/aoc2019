#lang racket

(require 2htdp/batch-io)

;; reads from stdin not a filename
(define inp (read-lines 'stdin))

;; loop over the list
(for ([i inp])

     (printf "~a\n" i)
     
     ;; split the input on the space
     (define d (string-split i " "))

     ;; d is a pair, get the first element and convert to an int
     (define pt1 (string->number (car d)))

     ;; d is a pair get the rest of the list, get the first element of that
     ;; and convert it to an int
     (define pt2 (string->number (car (cdr d))))

     ;; print it all out
     (printf "~a -- ~a\n" pt1 pt2)
     )
