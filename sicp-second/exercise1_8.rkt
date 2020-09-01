#lang racket

(define (cube-root x)
  (cube-root-iter 1.0 x))

(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x) x)))

(define (good-enough? guess x)
  (< (abs (- (* guess guess guess) x)) 0.001))

(define (improve y x)
  (define improved (/ (+ (/ x (* y y)) (* 2 y)) 3))
  (average y improved))

(define (average x y)
  (/ (+ x y) 2))