#lang racket

(define s "R8,U5,L5,D3")

(define data (string-split s ","))
(println data)

(define (makepath-acc inp acc)
    (define cp (first inp))
)

(makepath-acc data '(0 0))

