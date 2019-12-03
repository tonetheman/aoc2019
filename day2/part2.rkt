#lang racket

;; (define s "1,9,10,3,2,3,11,0,99,30,40,50")
;;(define s "1,0,0,0,99")
;;(define s "2,3,0,3,99")
;;(define s "2,4,4,5,99,0")
;;(define s "1,1,1,4,99,5,6,0,99")

(define (run-program noun verb inp)

    (set! inp (list-set inp 1 noun))
    (set! inp (list-set inp 2 verb))
    (define (opcode1? n)
        (= n 1))
    (define (opcode2? n)
        (= n 2))
    (define (opcode99? n)
        (= n 99))
    (define (handleopcode1 ll ip)
        (let* ([pos1-index (list-ref ll (add1 ip))]
            [pos2-index (list-ref ll (+ ip 2))]
            [output-index (list-ref ll (+ ip 3))]
            [pos1-val (list-ref ll pos1-index)]
            [pos2-val (list-ref ll pos2-index)])
            ;;(printf "output index is ~a\n" output-index)
            ;;(printf "pos1 val and pos2 val ~a ~a\n" pos1-val pos2-val)
            (list-set ll output-index (+ pos1-val pos2-val))
        )
    )
    (define (handleopcode2 ll ip)
        (let* ([pos1-index (list-ref ll (add1 ip))]
            [pos2-index (list-ref ll (+ ip 2))]
            [output-index (list-ref ll (+ ip 3))]
            [pos1-val (list-ref ll pos1-index)]
            [pos2-val (list-ref ll pos2-index)])
            ;;(printf "output index is ~a\n" output-index)
            ;;(printf "pos1 val and pos2 val ~a ~a\n" pos1-val pos2-val)
            (list-set ll output-index (* pos1-val pos2-val))
        )
    )
    ;;(println inp)
    (define terminated #f)

    (for ([ip (in-range 0 (length inp) 4)]
        #:unless terminated)
        (define instr (list-ref inp ip))
        (cond
            [(opcode1? instr) (set! inp (handleopcode1 inp ip))]
            [(opcode2? instr) (set! inp (handleopcode2 inp ip))]
            [(opcode99? instr) (set! terminated #t)]
            [else (println "something went wrong")]
        )
        ;;(printf "end of current for inp ~a\n" inp)
    )
    ;;(println "final")
    ;;(println inp)
    ;;(printf "position 0 is ~a\n" (list-ref inp 0))
    (list-ref inp 0)
)



(define s (file->string "data.txt"))

(define inp
    (map string->number (string-split s ","))
)

(for ([noun 100])
    (for ([verb 100])
        (if (= (run-program noun verb inp) 19690720)
            (println (+ (* 100 noun) verb))
            '()
        )
    )
)
;;(println (run-program 12 2 inp))