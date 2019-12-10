#lang racket

(define (opadd? n) (= n 1))
(define (opadd-len) 4)

(struct machine (memory ip) #:mutable )

(define (repr m)
    (printf "ip is ~a\n" (machine-ip m))
    (printf "memory is ~a\n" (machine-memory m))
)

(define (tranlate-opcode n)
    (define s (~r n #:min-width 5 #:pad-string "0"))
    (define opcode (string->number (substring s 3 5)))
    (define param1mode (string->number (substring s 2 3)))
    (define param2mode (string->number (substring s 1 2)))
    (define param3mode (string->number (substring s 0 1)))
    (list opcode param1mode param2mode param3mode)
)

(define (cycle m)
    (let ([_opcode (vector-ref (machine-memory m) (machine-ip m))])
        (match-let ([(list opcode pm1 pm2 pm3) (tranlate-opcode _opcode)])
            (cond
                [(opadd? opcode)
                    (printf "opadd is called ~a\n" (machine-ip m))
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
                    (vector-set! (machine-memory m) output (+ a1 a2))
                    ;; TODO: need to SET machine-ip
                    (set-machine-ip! m (+ (machine-ip m) (opadd-len)))
                    ;; (loop (+ (machine-ip m) (opadd-len)))]
                ]
            )



        ) ;; end  of match-let
    ) ;; end of _opcode let
) ;; end of func


(define (test1)
    (define computer (machine (make-vector 1) 0))
    (repr computer)

    (define instr (make-vector 1000))
    (define counter 0)
    (for ([i (list 1 10 11 12 99 0 0 0 0 0 10 20 0 0 0 0)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )

   (set-machine-memory! computer instr) 

    (cycle computer)
    (repr computer)
)

(test1)