#lang racket

(require "intcodes.rkt")

(define (runonetest list-input instr)
    (define program-inputs (list (first list-input) 0))
    (set! list-input (rest list-input))
    (define p1-output (runprogram (vector-copy instr) program-inputs))
    (printf "p1 output ~a\n" p1-output)

    (define program-inputs2 (list (first list-input) p1-output))
    (set! list-input (rest list-input))
    (define p2-output (runprogram (vector-copy instr) program-inputs2))
    (printf "p2 output ~a\n" p2-output)
    ;;(println instr)

    (define program-inputs3 (list (first list-input) p2-output))
    (set! list-input (rest list-input))    
    (define p3-output (runprogram (vector-copy instr) program-inputs3))
    (printf "p3 output ~a\n" p3-output)

    (define program-inputs4 (list (first list-input) p3-output))
    (set! list-input (rest list-input))    
    (define p4-output (runprogram (vector-copy instr) program-inputs4))
    (printf "p4 output ~a\n" p4-output)

    (define program-inputs5 (list (first list-input) p4-output))
    (set! list-input (rest list-input))    
    (define p5-output (runprogram (vector-copy instr) program-inputs5))
    (printf "p5 output ~a\n" p5-output)
    p5-output
)

(define (test1)
    (runonetest (list 4 3 2 1 0))
)

(define (test2)
    (define instr (make-vector 1000))
    (define counter 0)
    (for ([i (list 3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (println instr)

    (define maxvalue -1)
    (define v #f)
	(define mylist (permutations (list 0 1 2 3 4)))
	(for ([i mylist])
        (define current-value (runonetest i instr))
		(println current-value)
        (if (> current-value maxvalue)
            (begin
                (set! maxvalue current-value)
                (set! v i)
                #f
            )
            #f
        )
	)
    (printf "max value: ~a ~a\n" maxvalue v)
)


(define (part1)
    (define s (file->string "data.txt"))
    (define inp
        (list->vector (map string->number (string-split s ","))))
    (define maxvalue -1)
    (define v #f)
	(define mylist (permutations (list 0 1 2 3 4)))
	(for ([i mylist])
        (define current-value (runonetest i inp))
		(println current-value)
        (if (> current-value maxvalue)
            (begin
                (set! maxvalue current-value)
                (set! v i)
                #f
            )
            #f
        )
	)
    (printf "max value: ~a ~a\n" maxvalue v)
)
    
    
(part1)



;;(test2)
