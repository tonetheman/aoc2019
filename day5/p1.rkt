#lang racket

(define (opadd? n) (= n 1))
(define (opadd-len) 4)

(define (opmult? n) (= n 2))
(define (opmult-len) 4)

(define (opterm? n) (= n 99))
(define (opterm-len) 1)

(define (opinput? n) (= n 3))
(define opinput-len 2)

(define (opoutput? n) (= n 4))
(define opoutput-len 2)

(define (runprogram inp noun verb)
 
    ;;(vector-set! inp 1 noun)
    ;;(vector-set! inp 2 verb)
    
    (let loop ([ip 0])
        (if (> (vector-length inp) ip)
            (cond
                [(opadd? (vector-ref inp ip))
                    ;; (printf "opadd is called ~a\n" ip)
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    (define arg2 (vector-ref inp (+ 2 ip)))
                    (define output (vector-ref inp (+ 3 ip)))
                    ;; (printf "\t~a ~a ~a\n" arg1 arg2 output)
                    (vector-set! inp output (+ (vector-ref inp arg1) 
                        (vector-ref inp arg2)))
                    (loop (+ ip (opadd-len)))]
                [(opmult? (vector-ref inp ip))
                    ;; (printf "opmult is called ~a\n" ip)
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    (define arg2 (vector-ref inp (+ 2 ip)))
                    (define output (vector-ref inp (+ 3 ip)))
                    ;; (printf "\t~a ~a ~a\n" arg1 arg2 output)
                    (vector-set! inp output (* (vector-ref inp arg1) 
                        (vector-ref inp arg2)))
                    (loop (+ ip (opmult-len)))]
                [(opterm? (vector-ref inp ip))
                    ;;(printf "terminate!\n")
                    ;; this is a cheat to push the ip way out
                    ;; that way the machine will stop
                    (loop (+ ip (vector-length inp)))]
                [(opinput? (vector-ref inp ip))
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    #f
                ]
                [(opoutput? (vector-ref inp ip))
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    #f                
                ]
                [else (println "nope")]
            )
            #f
        )
    )
    ;; return what is at pos 0
    ;; as output
    (vector-ref inp 0)
)

(define (part1)
    (define s (file->string "data.txt"))
    ;; (define s "1,9,10,3,2,3,11,0,99,30,40,50")
    ;;(define s "1,1,1,4,99,5,6,0,99")

    (define inp
        (list->vector (map string->number (string-split s ",")))
    )
    (runprogram (vector-copy inp) 12 2)
)


(define (part2)
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

;; (part2)

(define s "1101,100,-1,4,0")
(define inp (list->vector (map string->number (string-split s ","))))
(runprogram (vector-copy inp) 1 1)