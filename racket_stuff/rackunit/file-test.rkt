#lang racket/base

(require rackunit
	 "file.rkt")


(check-equal? (my-+ 1 1) 2 "simple addition")
(check-equal? (my-* 1 2) 2 "simple mult")



