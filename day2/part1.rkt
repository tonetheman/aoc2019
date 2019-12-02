#lang racket

(define s "1,9,10,3,2,3,11,0,99,30,40,50")
(define inp
    (map string->number (string-split s ","))
)

(define (opcode1? n)
    (= n 1))
(define (opcode2? n)
    (= n 2))
(define (opcode99? n)
    (= n 99))
(define (handleopcode1 ll ip)
    (println "opcode 1 add")
    (let ([pos1-val (list-ref ll (add1 ip))]
        [pos2-val (list-ref ll (+ ip 2))]
        [output-pos (list-ref ll (+ ip 3))])
        (printf "~a ~a ~a\n" pos1-val pos2-val output-pos)
    )
)

(for ([ip (in-range 0 (length inp) 4)])
    (define instr (list-ref inp ip))
    (cond
        [(opcode1? instr) (handleopcode1 inp ip)]
        [(opcode2? instr) (println "2")]
        [(opcode99? instr) (println "99")]
        [else (println "something went wrong")]
    )
)
