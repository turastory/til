#lang racket

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

(define (fact-iter n)
  (define (iter sum count n)
    (if (> count n)
        sum
        (iter (* sum count) (+ count 1) n)))
  (iter 1 1 n))

(define (fibo n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fibo (- n 1)) (fibo (- n 2))))))

(define (fibo-iter n)
  (define (iter a b count)
    (if (> count 0)
        (iter (+ a b) a (- count 1))
        b))
  (iter 1 0 n))