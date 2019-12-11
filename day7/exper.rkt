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
(define (opoutput? n) (= n 4))
(define opoutput-len 2)
(define (opjmpiftrue? n) (= n 5))
(define opjmpiftrue-len 3)
(define (opjmpiffalse? n) (= n 6))
(define opjmpiffalse-len 3)
(define (oplessthan? n) (= n 7))
(define oplessthan-len 4)
(define (opequals? n) (= n 8))
(define opequals-len 4)

(define (is-not-zero n)
    (not (= n 0))
)

(struct cpuflags (inputblocked outputblocked) #:mutable)
(struct machine (memory ip terminated input output flags) #:mutable )

(define (repr m)
    (printf "ip is ~a\n" (machine-ip m))
    (printf "term is ~a\n" (machine-terminated m))
    (printf "memory is ~a\n" (machine-memory m))
    (printf "input is ~a\n" (machine-input m))
    (printf "output is ~a\n" (machine-output m))
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
        ;; mark the machine as input blocked
        ;; do nothing no input
        ;; this is really blocking since
        ;; we are not going to increment the ip
        (set-cpuflags-inputblocked! (machine-flags m) #t)
        ;; otherwise do some work
        (let ([arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m)))])
            ;; set the CPU flag back to off
            ;; we are no longer blocked by input
            (set-cpuflags-inputblocked! (machine-flags m) #f)

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

(define (handle-opoutput m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m))))

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

    (set-machine-output! m a1)
    (set-cpuflags-outputblocked! (machine-flags m) #t)
    (set-machine-ip! m (+ (machine-ip m) opoutput-len))
)
(define (handle-opjmpiftrue m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m))))
    (define arg2 (vector-ref (machine-memory m) (+ 2 (machine-ip m))))
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
    (if (is-not-zero a1)
        (set-machine-ip! m a2)
        (set-machine-ip! m (+ (machine-ip m) opjmpiftrue-len))
    )
)

(define (handle-opjmpiffalse m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-memory m) (+ 1 (machine-ip m))))
    (define arg2 (vector-ref (machine-memory m) (+ 2 (machine-ip m))))
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
    (if (= a1 0)
        (set-machine-ip! m a2)
        (set-machine-ip! m (+ (machine-ip m) opjmpiffalse-len))
    )
)
 
(define (handle-oplessthan m pm1 pm2 pm3)
    (printf "oplessthan called\n")
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
    (if (< a1 a2)
        (vector-set! (machine-memory m) output 1)
        (vector-set! (machine-memory m) output 0)
    )
    (set-machine-ip! m (+ (machine-ip m) (oplessthan-len)))
)

(define (handle-opequals m pm1 pm2 pm3)
    (define arg1 (vector-ref (machine-ip m) (+ 1 (machine-ip m))))
    (define arg2 (vector-ref (machine-ip m) (+ 2 (machine-ip m))))
    (define output (vector-ref (machine-ip m) (+ 3 (machine-ip m))))
    (define a1
        (cond
            [(= pm1 0)
                (vector-ref (machine-ip m) arg1)
            ]
            [(= pm1 1)
                arg1
            ]
        )
    )
    (define a2
        (cond
            [(= pm2 0)
                (vector-ref (machine-ip m) arg2)
            ]
            [(= pm2 1)
                arg2
            ]
        )
    )
    (if (= a1 a2)
        (vector-set! (machine-ip m) output 1)
        (vector-set! (machine-ip m) output 0)
    )
    (set-machine-ip! m (+ (machine-ip m) (oplessthan-len)))
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
                [(opoutput? opcode)
                    (handle-opoutput m pm1 pm2 pm3)
                ]
                [(opjmpiftrue? opcode)
                    (handle-opjmpiftrue m pm1 pm2 pm3)        
                ]
                [opjmpiffalse? opcode
                    (handle-opjmpiffalse m pm1 pm2 pm3)
                ]
                [(oplessthan? opcode)
                    (handle-oplessthan m pm1 pm2 pm3)
                ]
                [(opequals? opcode)
                    (handle-opequals m pm1 pm2 pm3)
                ]


            ) ;; end of cond

        ) ;; end  of match-let
    ) ;; end of _opcode let
)

(define (cycle m)
    (if (machine-terminated m)
        (println "warning: machine is terminated no action taken")
        ;; TODO:
        ;; do i need to block on input and output here?
        (run-cycle m)
    )
)

(define (make-computer)
    (machine (make-vector 1) ;; memory
     0 ;; instruction pointer 
     #f ;; terminated
     '() ;; input
     #f ;; output
     (cpuflags #f #f)
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

(define (test3)
    (define computer (make-computer))
    (define instr (make-vector 20))
    (define counter 0)
    (for ([i (list 3 15 4 15 99)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (set-machine-memory! computer instr)
    (add-input computer 42)
    (printf "current input  ~a\n" (machine-input computer))

    (cycle computer)
    (repr computer)
    (cycle computer)
    (repr computer)
)

(define (test4)
    (define computer (make-computer))
    (define instr (make-vector 20))
    (define counter 0)
    (for ([i (list 3 15 4 15 99)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (set-machine-memory! computer instr)
    (add-input computer 42)
    (printf "current input  ~a\n" (machine-input computer))

    ;; a way to run a machine until it terminates
    (define stopmachine #f)
    (for ([i (in-naturals)] #:break stopmachine)
        (if (machine-terminated computer)
            (let ([_ #t])
                (println "stopping machine")
                (set! stopmachine #t)
            )
            (let ([_ #t])
                (cycle computer)
                (repr computer)
            )
        )
    )
)

(define (test5)
    ;; TODO: this test is to make sure
    ;; a machine will block if there is no input
    ;; available to the machine
    (println "not done yet")
)

(define (unittest1)
    (define s "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
    (println s)
)

;; (test1)
;; (test2)
;; (test3)
(test4)