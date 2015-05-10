;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname repeated) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; *****************************************************
;; (fs-pathable? mydir) judges whether mydir is pathable or not
;; fs-pathable?: (listof Str) -> Bool

(define (repeat? lostr passed)
  (cond [(empty? lostr) true]
        [(member? (first lostr) passed) false]
        [else (repeat? (rest lostr) (cons (first lostr) passed))]))

(repeat? (list "a" "b" ) empty)
(repeat? (list "a" "a" "b" ) empty)

(member? "a"  (list "a" "b" ))