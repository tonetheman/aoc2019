#lang racket

(define s (file->string "data.txt"))
;; (define s "1,9,10,3,2,3,11,0,99,30,40,50")
;;(define s "1,1,1,4,99,5,6,0,99")

(define inp
    (list->vector (map string->number (string-split s ",")))
)

(define (opadd? n) (= n 1))
(define (opadd-len) 4)

(define (opmult? n) (= n 2))
(define (opmult-len) 4)

(define (opterm? n) (= n 99))
(define (opterm-len) 1)

(define (runprogram inp noun verb)
    (println inp)

    (vector-set! inp 1 noun)
    (vector-set! inp 2 verb)
    (println inp)
    
    
    (let loop ([ip 0])
        (if (> (vector-length inp) ip)
            (cond
                [(opadd? (vector-ref inp ip))
                    (printf "opadd is called ~a\n" ip)
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    (define arg2 (vector-ref inp (+ 2 ip)))
                    (define output (vector-ref inp (+ 3 ip)))
                    (printf "\t~a ~a ~a\n" arg1 arg2 output)
                    (vector-set! inp output (+ (vector-ref inp arg1) 
                        (vector-ref inp arg2)))
                    (loop (+ ip (opadd-len)))]
                [(opmult? (vector-ref inp ip))
                    (printf "opmult is called ~a\n" ip)
                    (define arg1 (vector-ref inp (+ 1 ip)))
                    (define arg2 (vector-ref inp (+ 2 ip)))
                    (define output (vector-ref inp (+ 3 ip)))
                    (printf "\t~a ~a ~a\n" arg1 arg2 output)
                    (vector-set! inp output (* (vector-ref inp arg1) 
                        (vector-ref inp arg2)))
                    (loop (+ ip (opmult-len)))]
                [(opterm? (vector-ref inp ip))
                    (printf "terminate!\n")
                    (loop (+ ip (opterm-len)))]
                [else (println "nope")]
            )
            #f
        )
    )
    (println inp)
    (printf "the output is ~a\n" (vector-ref inp 0))
)

(runprogram (vector-copy inp) 12 2)