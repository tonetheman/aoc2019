#lang racket

(define s "R8,U5,L5,D3")

(define data (string-split s ","))
(printf "input data is ~a\n" data)
(struct pos (x y))

(define (moving-right? n) (char=? n #\R))
(define (moving-left? n) (char=? n #\L))
(define (moving-up? n) (char=? n #\U))
(define (moving-down? n) (char=? n #\D))

;; move in a direction
;; cp - current position
;; n - number of steps
;; direction
;; acc - accumlulator
(define (mm cp n direction acc)
    (printf "in mm cp is ~a\n" cp)
	(if (moving-right? direction)
		(let ([tmp '()])
			(for ([i n])
				(set! tmp (append (list (list i (pos-y cp)))  tmp))
			)
		tmp
		)
		#f
	)
)

(define (makepath-acc inp acc)
    (if (empty? inp)
        acc
        (begin
            (let ([cp (first inp)])
                (define dir-char (string-ref cp 0)) ;; direction
                (define dir-dist (string->number (substring cp 1))) ;; num steps
                (define current (first acc)) ;; this is the current position
                (if (moving-right? dir-char)
                    (begin
                        (printf "GOT R with dist ~a\n" dir-dist)
                        (let ([crud (mm cp dir-dist #\R #f)])
                            (printf "crud ~a\n" crud)
                        )
                    )
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

(makepath-acc data (list (pos 0 0)))

