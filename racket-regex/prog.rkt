#lang racket

(let ([s "123 456 78 9"])
  (println "match")
  ;; px allows diff syntax
  ;; for regex
  (println (regexp-match #px"\\d+" s))


  (println "split")
  (println (regexp-split #rx" " s))

  (define P (regexp "(\\d+)"))
  (println "split with a compiled regex")
  (regexp-split P s)

  (define PS (regexp " "))
  (println "split with a compiled regex space")
  (regexp-split PS s)

  )


