#lang racket

(struct pos (x y))

(define (mm n direction acc)
	(if (char=? direction #\R)
		(let ([tmp '()])
			(for ([i 3])
				(set! tmp (append (list (list i i))  tmp))
			)
		tmp
		)
		#f
	)
)

(define acc #f)
(println (mm 3 #\R acc))
