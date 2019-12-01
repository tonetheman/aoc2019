#lang racket

(println "part2")

(define (calc n)
  ;; definition from problem
  (- (quotient n 3) 2))

;; a way to accumlate a list
;; of results
(define (listcalc n acc)
  (if (< n 0)
      ;; base case if accumulation is less than 0
      ;; just return it you are done
      acc 

      ;; otherwise recurse
      ;; pass the new number as n
      ;; pass a list with the new number stuck on the front
      ;; i calculated the number twice meh
      (listcalc (calc n) (cons (calc n) acc))
      )
  )

;; since accumlator is ugly
;; make a func that only takes
;; the number
(define (supercalc n)

  ;; filter out the numbers that are less than 0
  ;; add all the numbers all up
  (apply + (filter (lambda (n) (> n 0)) (listcalc n '())))
  )

;; sum everything
(apply +
;; map supercalc across the list
(map supercalc
    ;; cast to numbers
    (map string->number 
        ;; read the file into a list
        (file->lines "data.txt")
        
        ) ;; end of map string->number
) ;; end of map supercalc
) ;; end of apply
