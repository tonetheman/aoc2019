#lang racket

(define (opadd? n) (= n 1))
(define (opadd-len) 4)

(define (opmult? n) (= n 2))
(define (opmult-len) 4)

(define (opterm? n) (= n 99))
(define (opterm-len) 1)

;; new opcodes  or day 5
(define (opinput? n) (= n 3))
(define opinput-len 2)

(struct machine (memory ip terminated input) #:mutable )

(define (repr m)
    (printf "ip is ~a\n" (machine-ip m))
    (printf "term is ~a\n" (machine-terminated m))
    (printf "memory is ~a\n" (machine-memory m))
    (printf "input is ~a\n" (machine-input m))
)

(define (tranlate-opcode n)
    (define s (~r n #:min-width 5 #:pad-string "0"))
    (define opcode (string->number (substring s 3 5)))
    (define param1mode (string->number (substring s 2 3)))
    (define param2mode (string->number (substring s 1 2)))
    (define param3mode (string->number (substring s 0 1)))
    (list opcode param1mode param2mode param3mode)
)

;; not really the best way to do this
;; a convenience func
(define (add-input m n)
    (set-machine-input! m (cons n (machine-input m)))
)

(define (handle-opadd m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m))))
    (define arg2 (vector-ref (machine-memory m) (+ 2 (machine-ip m))))
    (define output (vector-ref (machine-memory m) (+ 3 (machine-ip m))))
    (define a1
        (cond
            [(= pm1 0)
                (vector-ref (machine-memory m) arg1)
            ]
            [(= pm1 1)
                arg1
            ]
        )
    )
    (define a2
        (cond
            [(= pm2 0)
                (vector-ref (machine-memory m) arg2)
            ]
            [(= pm2 1)
                arg2
            ]
        )
    )
    (vector-set! (machine-memory m) output (+ a1 a2))
    (set-machine-ip! m (+ (machine-ip m) (opadd-len)))
)

(define (handle-opmult m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m))))
    (define arg2 (vector-ref (machine-memory m) (+ 2 (machine-ip m))))
    (define output (vector-ref (machine-memory m) (+ 3 (machine-ip m))))
    ;; (printf "\t~a ~a ~a\n" arg1 arg2 output)
    (define a1
        (cond
            [(= pm1 0)
                (vector-ref (machine-memory m) arg1)
            ]
            [(= pm1 1)
                arg1
            ]
        )
    )
    (define a2
        (cond
            [(= pm2 0)
                (vector-ref (machine-memory m) arg2)
            ]
            [(= pm2 1)
                arg2
            ]
        )
    )
    (vector-set! (machine-memory m) output (* a1 a2))
    (set-machine-ip! m (+ (machine-ip m) (opmult-len)))
)

(define (handle-opinput m pm1 pm2 pm3)

    ;; THIS BLOCKS THE MACHINE UNTIL WE GET INPUT
    
    (if (empty? machine-input)
        #f ;; do nothing no input
            ;; this is really blocking since
            ;; we are not going to increment the ip
        (let ([arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m)))])
            ;; need to store the input variable
            ;; passed into the function
            ;; in this place in memory
            ;; take the first one
            (vector-set! (machine-memory m) arg1 (first (machine-input m)))
            ;; pop the first input out of the way
            ;; so that the next input will get the next
            ;; value
            (set-machine-input! m (rest (machine-input m)))
            ;;(set! input-to-program (rest input-to-program))
            ;; (printf "DBG: after opinput ~a\n" inp)   

            (set-machine-ip! m (+ (machine-ip m) opinput-len))

        ) ;; end of let
    ) ;; end of if
)


(define (run-cycle m)
    (let ([_opcode (vector-ref (machine-memory m) (machine-ip m))])
        (match-let ([(list opcode pm1 pm2 pm3) (tranlate-opcode _opcode)])
            (cond
                [(opadd? opcode)
                    (handle-opadd m pm1 pm2 pm3)
                ]

                [(opmult? opcode)
                    (handle-opmult m pm1 pm2 pm3)
                ]

                [(opterm? opcode)
                    (set-machine-terminated! m #t)
                    (set-machine-ip! m (+ (machine-ip m) (opterm-len)))
                ]
                [(opinput? opcode)
                    (handle-opinput m pm1 pm2 pm3)
                ]

            ) ;; end of cond

        ) ;; end  of match-let
    ) ;; end of _opcode let
)

(define (cycle m)
    (if (machine-terminated m)
        (println "warning: machine is terminated no action taken")
        (run-cycle m)
    )
)

(define (make-computer)
    (machine (make-vector 1) ;; memory
     0 ;; instruction pointer 
     #f ;; terminated
     '() ;; input
     )
)

(define (test1)
    (define computer (make-computer))
    (repr computer)

    (define instr (make-vector 100))
    (define counter 0)
    (for ([i (list 1 10 11 12 2 13 14 15 99 0 10 20 0 90 80 0)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )

   (set-machine-memory! computer instr) 

    (cycle computer) ;; add
    (repr computer)
    (cycle computer) ;; mult
    (repr computer)
    (cycle computer) ;; term
    (repr computer)

)

(define (test2)
    (define computer (make-computer))
    (define instr (make-vector 20))
    (define counter 0)
    (for ([i (list 3 15 3 16 99)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (set-machine-memory! computer instr)
    (add-input computer 42)
    (add-input computer 43)
    (printf "current input  ~a\n" (machine-input computer))
    
    (cycle computer)
    (repr computer)
    (cycle computer)
    (repr computer)
)

;; (test1)
(test2)