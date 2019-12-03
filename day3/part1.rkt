#lang racket

(define s "R8,U5,L5,D3")

(define data (string-split s ","))
(printf "input data is ~a\n" data)
(struct pos (x y))

(define (moving-right? n) (char=? n #\R))
(define (moving-left? n) (char=? n #\L))
(define (moving-up? n) (char=? n #\U))
(define (moving-down? n) (char=? n #\D))


(define (makepath-acc inp acc)
    (if (empty? inp)
        acc
        (begin
            (let ([cp (first inp)])
                (define dir-char (string-ref cp 0)) ;; direction
                (define dir-dist (string->number (substring cp 1))) ;; num steps
                (define current (first acc)) ;; this is the current position
                (if (moving-right? dir-char)
                    (printf "GOT R with dist ~a\n" dir-dist)
                    #f
                )
                (if (moving-left? dir-char)
                    #f
                    #f
                )
                (makepath-acc (rest inp) acc)
            )
        )
    )
    

    
)

(makepath-acc data (pos 0 0))

