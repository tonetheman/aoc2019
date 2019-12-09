#lang racket

(require "intcodes.rkt")

(define (test2)
	(define mylist (permutations (list 0 1 2 3 4)))
	(for ([i mylist])
		(println i)
	)
)

(define (test1)
    (define instr (make-vector 1000))
    (define counter 0)

    (for ([i (list 3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    ;;(println instr)
    (define program-inputs (list 4 0))
    (define p1-output (runprogram (vector-copy instr) program-inputs))
    (printf "p1 output ~a\n" p1-output)

    (define program-inputs2 (list 3 p1-output))
    (define p2-output (runprogram (vector-copy instr) program-inputs2))
    (printf "p2 output ~a\n" p2-output)
    ;;(println instr)

    (define program-inputs3 (list 2 p2-output))
    (define p3-output (runprogram (vector-copy instr) program-inputs3))
    (printf "p3 output ~a\n" p3-output)

    (define program-inputs4 (list 1 p3-output))
    (define p4-output (runprogram (vector-copy instr) program-inputs4))
    (printf "p4 output ~a\n" p4-output)

    (define program-inputs5 (list 0 p4-output))
    (define p5-output (runprogram (vector-copy instr) program-inputs5))
    (printf "p5 output ~a\n" p5-output)
)

;; (test1)
(test2)
