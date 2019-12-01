#lang racket

(define (part1)
  (define input (file->string "data.txt"))

  (define total 0)
  (define (foo str)

    (for ([ln (in-list (string-split str "\n"))])
         (define realnum (string->number ln))
         (set! total (+ total (- (quotient realnum 3) 2)))
         ;; (printf "~a\n" ln)
      )
    (printf "the total is ~a\n" total)
  )

  (foo input)
  )


(define (part2)

  ;; get the input data
  (define input (file->string "data.txt"))

  ;; calculate the mass
  (define (mass n)
    (define res (- (quotient n 3) 2))
    (if (< res 0)
      0
      res)
    )

  ;; recursive way to calc the
  ;; fuel fuel mass
  (define (calc n acc)
    (if (= n 0)
      acc
      (let ([res (mass n)])
        (calc res (+ acc res))
        )
      )
    )

  ;; make the func nicer
  ;; acc always starts at zero
  (define (rcalc n)
    (calc n 0))

  ;; same loop as part1 mostly
  (define total 0)
    (for ([ln (in-list (string-split input "\n"))])
      (define realnum (string->number ln))

      ;; difference from part1
      ;; set total to accumulation of fuelfuel calc
      (set! total (+ total (rcalc realnum)))
      ;; (printf "~a\n" ln)
      )
    (printf "the total is ~a\n" total)

  )


(part1)
(part2)
