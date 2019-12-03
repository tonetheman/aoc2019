#lang racket/base


;; function
(define (my-+ a b)
  (if (zero? a)
    b
    (my-+ (sub1 a) (add1 b)))
  )

;;
(define (my-* a b)
  (if (zero? a)
    b
    (my-* (sub1 a) (my-+ b b))
    )
  )


;; this lets you see the functions outside
;; of the module
(provide my-+
	 my-*
	 )
