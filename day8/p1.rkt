#lang racket

(define w 25)
(define h 6)
(define ZERO (char->integer #\0))
(define layers (make-vector 100))

(define input (file->string "data.txt"))
(define input-data (make-vector 15000))
(define counter 0)
(for ([i input])
    (define res (- (char->integer i) ZERO))
    (vector-set! input-data counter res)
    (set! counter (add1 counter))
)

(define lowest 999999)
;; got 100 from math 15000/25 = 600 lines of pixels
;; 600/6 = 100 layers
(for ([i 100])
    (define ll (make-vector (* w h)))
    (for ([counter (* w h)])
        (vector-set! ll counter (vector-ref input-data (+ (* i (* 25 6)) counter)))
    )
    (vector-set! layers i ll)
    (define zc 0)
    (define onec 0)
    (define twoc 0)
    (for ([j ll])
        (if (= j 0)
            (set! zc (add1 zc))
            #f
        )
        (if (= j 1)
            (set! onec (add1 onec))
            #f
        )
        (if (= j 2)
            (set! twoc (add1 twoc))
            #f
        )
    )
    (if (< zc lowest)
        (set! lowest zc)
        #f
    )
    (printf "layer zc oc tc ~a ~a ~a ~a -- ~a\n" i zc onec twoc (* onec twoc))
)
(printf "lowest is ~a\n" lowest)

(define final-image (make-vector (* w h)))
(for ([i (* w h)])
    ;; current pixel index is i
    (define current-pixel-color 2) ;; transparent default
    (for ([j layers])
        (define current-pixel-in-layer (vector-ref j i))
        (cond
            [(= current-pixel-color 2) ;; current pixel is transparent
                (if (or (= current-pixel-in-layer 1) (= current-pixel-in-layer 0))
                    (set! current-pixel-color current-pixel-in-layer)
                    #f
                )
            ]
            [(= current-pixel-color 1)
                #f    
            ]
            [(= current-pixel-color 2)
                #f
            ]
        )
    )
    (vector-set! final-image i current-pixel-color)
)

(println final-image)
(define outf (open-output-file "test.ppm" #:mode 'text #:exists 'replace))
(printf "P3\n")
(printf "~a ~a\n" w h)
(println 1)
(define counter1 0)
(for ([i h])
    (for ([j w])
        (if (= 0 (vector-ref final-image counter1))
            (printf "0 0 0 ")
            (printf "1 1 1 ")
        )
        (set! counter1 (add1 counter1))
    )
    (printf "\n")
)
(close-output-port outf)