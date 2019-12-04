#lang racket

(define s "R8,U5,L5,D3")

(define data (string-split s ","))
(printf "input data is ~a\n" data)

(define (moving-right? n) (char=? n #\R))
(define (moving-left? n) (char=? n #\L))
(define (moving-up? n) (char=? n #\U))
(define (moving-down? n) (char=? n #\D))

(define (generate-up-steps startpos direction stepcount)
    (define tmp '())
    (define x (first (first startpos)))
    (define y (second (first startpos)))

    (for ([i (in-range 1 stepcount)])
        (define crud (list (list x (+ y i))))
        (set! tmp (append crud tmp))
    )
    (printf "UP: ~a\n" tmp)
    tmp
)
(define (generate-down-steps startpos direction stepcount)
    (define tmp '())
    (define x (first (first startpos)))
    (define y (second (first startpos)))

    (for ([i stepcount])
        (define crud (list (list x (- y i))))
        (set! tmp (append crud tmp))
    )
    tmp
)

(define (generate-right-steps startpos direction stepcount)
    (define tmp '())
    (define x (first (first startpos)))
    (define y (second (first startpos)))
    (for ([i (in-range 1 stepcount)])
        (define crud (list (list (+ i x) y)))
        (set! tmp (append crud  tmp))
    )
    (printf "RIGHT: ~a\n" tmp)
    tmp
)
(define (generate-left-steps startpos direction stepcount)
    (define tmp '())
    (define x (first (first startpos)))
    (define y (second (first startpos)))
    (for ([i stepcount])
        (define crud (list (list (- i x) y)))
        (set! tmp (append crud tmp))
    )
    tmp
)

;; start at zero
(define startpos (list '(0 0)))

;; (println startpos)
(for ([step-data data])
    (let ([direction (string-ref step-data 0)]
            [stepcount (string->number (substring step-data 1))])
        ;; (printf "~a\n" step-data)
        ;; (printf "~a\n" direction)
        (cond
            [(moving-right? direction)
            (set! startpos (append (generate-right-steps startpos direction stepcount) startpos))
            ;;(printf "startpos is ~a\n" startpos)
            #f
            ]
            [(moving-left? direction)
            (set! startpos (append (generate-left-steps startpos direction stepcount) startpos))
            ;;(printf "startpos is ~a\n" startpos)
            #f
            ]

            [(moving-up? direction)
            (set! startpos (append (generate-up-steps startpos direction stepcount) startpos))
            ;;(printf "startpos is ~a\n" startpos)
            #f
            ]
            [(moving-down? direction)
            (set! startpos (append (generate-down-steps startpos direction stepcount) startpos))
            ;;(printf "startpos is ~a\n" startpos)
            #f
            ]
        )
    )
)

(println startpos)

;;(makepath-acc data startpos)

