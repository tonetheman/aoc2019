#lang racket

;; read the file
(define input-str (file->string "boxes.txt"))

;; function
(define (string->boxes str)

    ;; go through the list
    (for/list ([ln (in-list (string-split str "\n"))])
        ;; split on the x
        (map string->number (string-split ln "x"))
    )

)

(define (box->paper box)
    (match-define (list a b) box)
    (+ a b)
)


(define a (string->boxes input-str))
(printf "~a\n" (map box->paper a))