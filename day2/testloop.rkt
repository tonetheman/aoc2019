#lang racket

(define s (file->string "data.txt"))

(define inp
    (map string->number (string-split s ","))
)

(define (op inp ip action)
    (let ([arg1 (vector-ref inp (+ 1 ip))]
            [arg2 (vector-ref inp (+ 2 ip))]
            [output (vector-ref inp (+ 3 ip))]
            )
        (vector-set! inp output (action (vector-ref inp arg1) 
            (vector-ref inp arg2)))
    )
    #t
)

(define (cycle inp ip)
    ;; (printf "yup is called ~a\n" ip)
    (define opcode (vector-ref inp ip))
    ;; (printf "opcode is ~a\n" opcode)
    (cond 
        [(= opcode 99) #f]
        [(= opcode 1) (op inp ip +)]
        [(= opcode 2) (op inp ip *)]
        [else #f]
    )
)

(define (runprogram inplist noun verb)
    (define inp (list->vector inplist))
    ;;(println inp)
    (vector-set! inp 1 noun)
    (vector-set! inp 2 verb)

    ;; main processing loop
    ;; instruction pointer starts at 0
    (let loop ([ip 0])
        (cond [(cycle inp ip) (loop (+ ip 4))])
    )
    ;;(println inp)
    (vector-ref inp 0)
)

(module+ test
    (require rackunit)
    (check-equal? (runprogram inp 12 2) 5866663)
)

(module* main #f
    (println "part 1 answer below")
    (println (runprogram inp 12 2))
)
