#lang racket

(println "part2")

(define (calc n)
  (- (quotient n 3) 2))

(define (listcalc n acc)
  (if (< n 0)
      acc
      (listcalc (calc n) (cons (calc n) acc))
      )
  )

(define (supercalc n)
  (apply + (filter (lambda (n) (> n 0)) (listcalc n '())))
  )

(apply +
(map supercalc
    (map string->number 
        ;; read the file into a list
        (file->lines "data.txt")
        
        ) ;; end of map string->number
) ;; end of map supercalc
) ;; end of apply
