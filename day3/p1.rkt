#lang racket

;; routines to help parse input
(define (moving-right? n) (char=? n #\R))
(define (moving-left? n) (char=? n #\L))
(define (moving-up? n) (char=? n #\U))
(define (moving-down? n) (char=? n #\D))

(define (gen-up startpos count)
  (define tmp '())
  (define x (first startpos))
  (define y (second startpos))
  (for ([i (in-range 1 (+ 1 count))])
    (define crud (list (list x (+ y i))))
    (set! tmp (append crud  tmp)))
    tmp
  )

(define (gen-down startpos count)
  (define tmp '())
  (define x (first startpos))
  (define y (second startpos))
    (for ([i (in-range 1 (+ count 1))])
    (define crud (list (list x (- y i))))
    (set! tmp (append crud  tmp)))
    tmp
  )

(define (gen-right startpos count)
  (define tmp '())
  (define x (first startpos))
  (define y (second startpos))
  (for ([i (in-range 1 (+ count 1))])
    (define crud (list (list (+ x i) y)))
    (set! tmp (append crud  tmp)))
    tmp
  )

(define (gen-left startpos count)
  (define tmp '())
  (define x (first startpos))
  (define y (second startpos))
    (for ([i (in-range 1 (+ count 1))])
    (define crud (list (list (- x i) y)))
    (set! tmp (append crud  tmp)))
    tmp
  )

(define (make-path data)
  (define bob (mutable-set))
  (define startpos (list 0 0))
  (set-add! bob startpos)
  (for ([step-data data])
    (let ([direction (string-ref step-data 0)]
      [stepcount (string->number (substring step-data 1))])
      (define res
        (cond
          [(moving-right? direction)
            (gen-right startpos stepcount)]
          [(moving-up? direction)
            (gen-up startpos stepcount)]
          [(moving-left? direction)
            (gen-left startpos stepcount)]
          [(moving-down? direction)
            (gen-down startpos stepcount)]
        ) ;; end of cond
      )
      (for ([i res])
        (set-add! bob i))
      (set! startpos (first res))
    )  ;; end of let
  ) ;; end of for
bob 
) ;; end of func

(define (string->list s)
  (define data (string-split s ","))
  data
)

(define (dist p1 p2)
  (+ (abs (- (first p1) (first p2)))
    (abs (- (second p1) (second p2)))
  )
)

(define (part1 s1 s2)
  (define data1 (string-split s1 ","))
  (define res1 (make-path data1))

  (define data2 (string-split s2 ","))
  (define res2 (make-path data2))

  (println "making points...")
  (set-intersect! res1 res2)
  
  (define lowest 999999999)
  (for ([i res1])
    (if (equal? i '(0 0))
      #f
      (let ([d (dist '(0 0) i)])
        (printf "~a ~a\n" i d)
        (if (< d lowest)
          (set! lowest d)
          #f
        )
        #f
      )
    )
  )
 
  (println "done")
  (println lowest)
  lowest
)

(define (test s1)
  (define data1 (string->list s1))
  (println data1)
  (define res1 (make-path data1))
  (println res1)
)

(define (tests)
  (test "R8,U5,L5,D3")
  (test "R1,D2")
  (test "L1,D2")
  (test "U1,D1")
  (test "U1,L2")
)

(define (get-file-input)
  (define in-port (open-input-file "data.txt"))
  (define line1 (string-normalize-spaces 
    (read-line in-port)))
  (define line2 (string-normalize-spaces 
    (read-line in-port)))
  (close-input-port in-port)
  (list line1 line2)
)

(define (test-file)
  (define res (get-file-input))
  (define line1 (first res))
  (define line2 (second res))
  (println line1)
  (println line2)
)

;; works
;; (part1 "R8,U5,L5,D3" "U7,R6,D4,L4")
;; (part1 "R75,D30,R83,U83,L12,D49,R71,U7,L72" "U62,R66,U55,R34,D71,R55,D58,R83")
;; (part1 "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51" "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
;; (test-file)

;; finally part1
(define fd (get-file-input))
(part1 (first fd) (second  fd))



