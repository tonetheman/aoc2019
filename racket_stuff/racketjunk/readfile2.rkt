#lang racket

    (define input-str (file->string "test.txt"))


(define (test1 str)

    (for/list ([c (in-string str)])
        (printf "~a\n" c)
    )

  )

(test1 input-str)