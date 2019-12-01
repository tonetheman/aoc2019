#lang racket


(println "part1")
;; add it all up
(apply +
       ;; call the func that figures out the mass
  (map (lambda (n) (- (quotient n 3) 2))
       ;; force the list to become numbers
  (map string->number 
       ;; read the file into a list
       (file->lines "data.txt")))
       )
