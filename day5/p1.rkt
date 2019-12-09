#lang racket

(define (opadd? n) (= n 1))
(define (opadd-len) 4)

(define (opmult? n) (= n 2))
(define (opmult-len) 4)

(define (opterm? n) (= n 99))
(define (opterm-len) 1)

;; new opcodes for day 5
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

(define (tranlate-opcode n)
    (define s (~r n #:min-width 5 #:pad-string "0"))
    ;;(println s)
    ;;(println (string-length s))
    (define opcode (string->number (substring s 3 5)))
    (define param1mode (string->number (substring s 2 3)))
    (define param2mode (string->number (substring s 1 2)))
    (define param3mode (string->number (substring s 0 1)))
    (printf "\topecode is ~a\n" opcode)
    (printf "\tparam1mode is ~a\n" param1mode)
    (printf "\tparam2mode is ~a\n" param2mode)
    (printf "\tparam3mode is ~a\n" param3mode)
    (list opcode param1mode param2mode param3mode)
)

;;(define (runprogram inp noun verb)
(define (runprogram inp input-to-program)
 
    (printf "the program input is set to ~a\n" input-to-program)
    ;; this should be set with opcode 4
    (define output-to-program #f)

    (let loop ([ip 0])
        (if (> (vector-length inp) ip)
            (let ([_opcode (vector-ref inp ip)])
                (match-let ([(list opcode pm1 pm2 pm3) (tranlate-opcode _opcode)])

                    (cond
                        [(opadd? opcode)
                            ;; (printf "opadd is called ~a\n" ip)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (define arg2 (vector-ref inp (+ 2 ip)))
                            (define output (vector-ref inp (+ 3 ip)))
                            ;; (printf "\t~a ~a ~a\n" arg1 arg2 output)
                            (define a1
                                (cond
                                    [(= pm1 0)
                                        (vector-ref inp arg1)
                                    ]
                                    [(= pm1 1)
                                        arg1
                                    ]
                                )
                            )
                            (define a2
                                (cond
                                    [(= pm2 0)
                                        (vector-ref inp arg2)
                                    ]
                                    [(= pm2 1)
                                        arg2
                                    ]
                                )
                            )
                            (vector-set! inp output (+ a1 a2))
                            (loop (+ ip (opadd-len)))]
                        [(opmult? opcode)
                            ;; (printf "opmult is called ~a\n" ip)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (define arg2 (vector-ref inp (+ 2 ip)))
                            (define output (vector-ref inp (+ 3 ip)))
                            ;; (printf "\t~a ~a ~a\n" arg1 arg2 output)
                            (define a1
                                (cond
                                    [(= pm1 0)
                                        (vector-ref inp arg1)
                                    ]
                                    [(= pm1 1)
                                        arg1
                                    ]
                                )
                            )
                            (define a2
                                (cond
                                    [(= pm2 0)
                                        (vector-ref inp arg2)
                                    ]
                                    [(= pm2 1)
                                        arg2
                                    ]
                                )
                            )
                            (vector-set! inp output (* a1 a2))
                            (loop (+ ip (opmult-len)))]
                        [(opterm? opcode)
                            ;;(printf "terminate!\n")
                            ;; this is a cheat to push the ip way out
                            ;; that way the machine will stop
                            (loop (+ ip (vector-length inp)))]
                        [(opinput? opcode)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (printf "opinput called ~a\n" arg1)
                            ;; need to store the input variable
                            ;; passed into the function
                            ;; in this place in memory
                            (vector-set! inp arg1 input-to-program)
                            (printf "DBG: after opinput ~a\n" inp)         
                            (loop (+ ip opinput-len))
                        ]
                        [(opoutput? opcode)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (printf "op output called ~a\n" arg1)
                            (set! output-to-program (vector-ref inp arg1))
                            (loop (+ ip opoutput-len))
                        ]
                        [(opequals? opcode)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (define arg2 (vector-ref inp (+ 2 ip)))
                            (define output (vector-ref inp (+ 3 ip)))
                            (define a1
                                (cond
                                    [(= pm1 0)
                                        (vector-ref inp arg1)
                                    ]
                                    [(= pm1 1)
                                        arg1
                                    ]
                                )
                            )
                            (define a2
                                (cond
                                    [(= pm2 0)
                                        (vector-ref inp arg2)
                                    ]
                                    [(= pm2 1)
                                        arg2
                                    ]
                                )
                            )
                            (if (= a1 a2)
                                (vector-set! inp output 1)
                                (vector-set! inp output 0)
                            )
                            (loop (+ ip opequals-len))
                        ]

                        [(oplessthan? opcode)
                            (define arg1 (vector-ref inp (+ 1 ip)))
                            (define arg2 (vector-ref inp (+ 2 ip)))
                            (define output (vector-ref inp (+ 3 ip)))
                            (define a1
                                (cond
                                    [(= pm1 0)
                                        (vector-ref inp arg1)
                                    ]
                                    [(= pm1 1)
                                        arg1
                                    ]
                                )
                            )
                            (define a2
                                (cond
                                    [(= pm2 0)
                                        (vector-ref inp arg2)
                                    ]
                                    [(= pm2 1)
                                        arg2
                                    ]
                                )
                            )
                            (if (< a1 a2)
                                (vector-set! inp output 1)
                                (vector-set! inp output 0)
                            )
                            (loop (+ ip oplessthan-len))
                        ]


                        [else (println "nope")]
                    )









                ) ;; end of match-let
            ) ;; end of let
            #f
        ) ;; end of if
    ) ;; end of let loop

    ;; return what is at pos 0
    ;; as output
    ;; (vector-ref inp 0)
    (printf "the output variable is set to ~a\n" output-to-program)
)

(define (oldpart1)
    (define s (file->string "data.txt"))
    ;; (define s "1,9,10,3,2,3,11,0,99,30,40,50")
    ;;(define s "1,1,1,4,99,5,6,0,99")

    (define inp
        (list->vector (map string->number (string-split s ",")))
    )
    (runprogram (vector-copy inp) 12 2)
)


(define (oldpart2)
    (define s (file->string "data.txt"))

    (define inp
        (list->vector (map string->number (string-split s ",")))
    )

    (for ([noun 100])
        (for ([verb 100])
            (if (= (runprogram (vector-copy inp) noun verb) 19690720)
                (println (+ (* 100 noun) verb))
                '()
            )
        )
    )
)

(define param-mode-position 0)
(define param-mode-immediate 1)

(define (mk-znum n)
    (~r n #:min-width 5 #:pad-string "0")
)

(define (get-opcode n)
    (let ([snum (mk-znum n)])
        (printf "snum: ~a\n" snum)
        (define opcode (substring snum 3))
        (printf "opcode: ~a\n" opcode)
        (define modeparam1 (substring snum 2 3))
        (define modeparam2 (substring snum 1 2))
        (define modeparam3 (substring snum 0 1))
        (printf "params: ~a ~a ~a\n" modeparam1 modeparam2 modeparam3)
    )
)

;; (part2)
(define (old-part2)
    (define s "1101,100,-1,4,0")
    (define inp (list->vector (map string->number (string-split s ","))))
    (runprogram (vector-copy inp) 1 1)
    (get-opcode 12302)
)


(define (testopcode3)
    (define instr (make-vector 100))
    (vector-set! instr 0 3)
    (vector-set! instr 1 10)
    (vector-set! instr 2 99)
    (runprogram instr 80)
    (println instr)
)

(define (testopcode4)
    (define instr (make-vector 100))
    (vector-set! instr 0 3) ;; take input
    (vector-set! instr 1 10) ;; store in 10
    (vector-set! instr 2 4) ;; set output var
    (vector-set! instr 3 0) ;; to whatever is in 0
    (vector-set! instr 4 99) ;; terminate
    (println "program passed in")
    (println instr)
    (runprogram instr 80)
    (println instr)
)

(define (test-tranop)
    (tranlate-opcode 1002)
    (match-let ([(list opcode p1 p2 p3) (tranlate-opcode 12345)])
        (println opcode)
        (println p3)
    )
)

(define (test5)
    (define instr (make-vector 100))
    (define counter 0)
    (for ([i (list 1002 4 3 4 33)])
        (vector-set! instr counter i)
        (set! counter (+ counter 1))
    )
    (println instr)
    (runprogram instr 0)
)

(define (test6)
    (define instr (make-vector 100))
    (define counter 0)
    (for ([i (list 1101 100 -1 4 0 99)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (runprogram instr 0)
    (println instr)
)

(define (part1)
    (define s (file->string "data.txt"))
    (define inp
        (list->vector (map string->number (string-split s ",")))
    )
    (println inp)
    (runprogram (vector-copy inp) 1)
)

(define (test7)
    (define instr (make-vector 100))
    (define counter 0)
    (for ([i (list 3 9 8 9 10 9 4 9 99 -1 8)])
        (vector-set! instr counter i)
        (set! counter (add1 counter))
    )
    (println instr)
    (runprogram instr 8)
    (println instr)
)


(test7)