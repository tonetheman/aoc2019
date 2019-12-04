#lang racket

(define lowend 134792)
(define hiend 675810)

(define (digits n . args)
  (let ((b (if (null? args) 10 (car args))))
    (let loop ((n n) (d '()))
      (if (zero? n) d
          (loop (quotient n b)
                (cons (modulo n b) d))))))

(define (has-eyes-orig ll)
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

;; not working :()
(define (has-eyes2 ll)
    (let ([d0 (list-ref ll 0)]
    [d1 (list-ref ll 1)]
    [d2 (list-ref ll 2)]
    [d3 (list-ref ll 3)]
    [d4 (list-ref ll 4)]
    [d5 (list-ref ll 5)])
        (if (= d0 d1) ;; 2 match in pos 0
            (if (= d1 d2)
                #f ;; part of a bigger group
                (if (= d1 d2) ;; 2 match in pos 1
                    (if (or (= d2 d3) (= d1 d0))
                        #f ;; part of bigger group
                        (if (= d2 d3) ;; 2 match in pos 2
                            (if (or (= d3 d4) (= d2 d1))
                                #f
                                (if (= d3 d4) ;; 2 match in pos 2
                                    (if (or (= d3 d2) (= d4 d5))
                                        #f
                                        (if (= d4 d5)
                                            (if (= d4 d3)
                                                #f
                                                #t
                                            )
                                            #f  
                                        )
                                    )
                                    #f
                                )
                            )
                            #f
                        )                       
                    )
                    #f
                )
            )
            #f
        )
    )
)

(define (has-eyes3 ll)
    (let ([d0 (list-ref ll 0)]
    [d1 (list-ref ll 1)]
    [d2 (list-ref ll 2)]
    [d3 (list-ref ll 3)]
    [d4 (list-ref ll 4)]
    [d5 (list-ref ll 5)])
    
        ;; pos 0 = pos 1
        (if (and (= d0 d1) (not (= d1 d2)))
            #t
            
            ;; pos 1 = pos 2
            (if (and (= d1 d2) (not (= d1 d0)) (not (= d2 d3)))
                #t
                (if (and (= d2 d3) (not (= d2 d1)) (not (= d3 d4)) )
                    #t
                    ;; pos 3 = pos 4
                    (if (and (= d3 d4) (not (= d3 d2)) (not (= d4 d5)))
                        #t
                        
                        (if (and (= d4 d5) (not (= d4 d3))  )
                            #t
                            #f
                        )

                    ) ;; end of pos 3 = pos 4
                )
            ) ;; end of pos 1 = pos 3

        ) ;; end pos 0 = pos 1


    );; end of let
) ;; end of has-eyes3



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


(define (part2)
    (define count 0)
    (for ([i (in-range lowend (+ hiend 1))])
        (if (always-incr (digits i))
            (if (has-eyes-orig (digits i))
                (if (has-eyes3 (digits i))
                    (begin
                        (println i)
                        (set! count (+ count 1))
                    )
                    #f
                )
                #f
            )
            #f
        )
    )
    (println count)
)

(part2)
;; GUESSED 1238 - too low

;;(define tt (list 1 3 5 5 6 7))
;;(printf "testing ~a\n" tt)
;;(has-eyes3 tt)

