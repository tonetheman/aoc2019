#lang racket

(define lowend 134792)
(define hiend 675810)

(define (digits n . args)
  (let ((b (if (null? args) 10 (car args))))
    (let loop ((n n) (d '()))
      (if (zero? n) d
          (loop (quotient n b)
                (cons (modulo n b) d))))))

(define (has-eyes ll)
    (let ([d0 (list-ref ll 0)]
    [d1 (list-ref ll 1)]
    [d2 (list-ref ll 2)]
    [d3 (list-ref ll 3)]
    [d4 (list-ref ll 4)]
    [d5 (list-ref ll 5)])
        (if (= d0 d1)
            #t
            (if (= d1 d2)
                #t
                (if (= d2 d3)
                    #t
                    (if (= d3 d4)
                        #t
                        (if (= d4 d5)
                            #t
                            #f
                        )
                    )
                )
            )
        )
    
    )
)

(define (always-incr ll)
    (let ([d0 (list-ref ll 0)]
    [d1 (list-ref ll 1)]
    [d2 (list-ref ll 2)]
    [d3 (list-ref ll 3)]
    [d4 (list-ref ll 4)]
    [d5 (list-ref ll 5)])
        (if (<= d0 d1)
            (if (<= d1 d2)
                (if (<= d2 d3)
                    (if (<= d3 d4)
                        (if (<= d4 d5)
                            #t
                            #f
                        )
                        #f
                    )
                    #f
                )
                #f
            )
            #f
        )
    )
)


(define count 0)
(for ([i (in-range lowend hiend)])
    (if (always-incr (digits i))
        (if (has-eyes (digits i))
            (set! count (+ count 1))
            #f
        )
        #f
    )
)
(println count)