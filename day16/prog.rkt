#lang racket


(define (build-pat n)
    ;; base setup defined in prob
    (define base (list 0 1 0 -1))
    ;; holds the output
    (define tmp '())
    (for ([i n])
        (set! tmp (append tmp (list (first base))))
    )
    (for ([i n])
        (set! tmp (append tmp (list (second base))))
    )
    (for ([i n])
        (set! tmp (append tmp (list (third base))))
    )
    (for ([i n])
        (set! tmp (append tmp (list (fourth base))))
    )
    tmp
)

(define (parse-input inp)
    (define (m0 n) (- n (char->integer #\0)))
    ;; string->list returns list of char
    ;; char-> integer converts to int
    ;; m0 subtracts out the 0 value
    ;; to return the final list
    (map m0 (map char->integer (string->list inp)))
)

(define (crazy i current-pat)
    ;;(printf "\tcrazy called ~a ~a\n" i (length current-pat))
    ;;(printf "\tis i? ~a\n" (< i (- (length current-pat) 1)))
    (if (< i (- (length current-pat) 1))
        (list-ref (rest current-pat) (modulo i (length current-pat)))
        (list-ref current-pat (modulo (- i (- (length current-pat) 1)) (length current-pat)))
    )

)

(define (testcase inp current-position)
    (define current-pat (build-pat current-position))
    ;;(printf "the input string ~a\n" inp)
    ;;(printf "the position is ~a\n" current-position)
    ;;(printf "the current pat for pos is ~a\n" current-pat)
    (define final-res 0)
    (for ([i (in-naturals 0)]
        [iv inp])
        (define index (crazy i current-pat))
        ;;(printf "iv: ~a index: ~a result: ~a\n" iv 
        ;;    index
        ;;    (* iv index)
        ;;    )
        (set! final-res 
            (+ final-res (* iv index)))
    )

    (set! final-res (modulo (abs final-res) 10))

    (printf "final res is ~a\n" final-res)
    ;; take the last digit only
    final-res   
)

(define inp "12345678")
(define list-inp (parse-input inp))
(define tmp '())
(for ([i (in-naturals 1)]
    [iv list-inp])
    (define current-position i)
    (set! tmp (append tmp (list (testcase list-inp current-position))))
    )
(println tmp)