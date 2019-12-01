#lang racket

(define input (file->string "data.txt"))

(define total 0)
(define (foo str)

  (for ([ln (in-list (string-split str "\n"))])
       (define realnum (string->number ln))
       (set! total (+ total (- (quotient realnum 3) 2)))
       (printf "~a\n" ln)
    )
  (printf "the total is ~a\n" total)
  )

(foo input)
