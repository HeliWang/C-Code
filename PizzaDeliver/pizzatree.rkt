;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname pizzatree) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; *****************************************************
;;   Heli Wang (20552080)
;;   CS 135 Fall 2014
;;   Assignment 07, Problem1
;; *****************************************************
(require "a7.rkt") 

;; *****************************************************
;; (out-of-ingredients? i-tree)  judges if there is at least
;;     one ingredient in i-tree with a quantity of zero
;; out-of-ingredients?: I-Tree -> Bool
;; Examples:
(check-expect (out-of-ingredients? sample-i-tree) false)
(check-expect (out-of-ingredients? sample-i-tree2) true)

;; useful constants for examples and tests
(define sample-i-tree2
  (make-i-node "pepperoni" 5000
               (make-i-node "onions" 0 
                            (make-i-node "mushrooms" 1500 empty empty)
                            empty)
               (make-i-node "tomatoes" 1
                            (make-i-node "sundried tomatoes" 100 empty empty)
                            empty)))
(define sample-i-tree3
  (make-i-node "pepperoni" 2500 empty empty))

(define (out-of-ingredients? i-tree)
  (cond [(empty? i-tree) false]
        [(= (i-node-quantity i-tree) 0) true]
        [else (or (out-of-ingredients? (i-node-left i-tree))
                  (out-of-ingredients? (i-node-right i-tree)))]))

;; Tests:
(check-expect (out-of-ingredients? sample-i-tree3) false)
(check-expect (out-of-ingredients? empty) false)


;; *****************************************************
;; (low-ingredients i-tree cutoff)  produces a list of strings that all of 
;;     the ingredients in i-tree have quantity strictly less than the value cutoff
;; low-ingredients: I-Tree Num -> (listof Str)
;; requires: cutoff >= 0
;; Examples:
(check-expect (low-ingredients sample-i-tree cutoffex1) cutoffex1result)
(check-expect (low-ingredients sample-i-tree2 cutoffex2) cutoffex2result)

;; useful constants for examples and tests
(define cutoffex1 75)
(define cutoffex1result (list "broccoli" "italian sausage" "tomatoes"))
(define cutoffex2 5000)
(define cutoffex2result 
  (list "mushrooms" "onions" "sundried tomatoes" "tomatoes"))
(define cutoffex3 5001)
(define cutoffex3result 
  (list "mushrooms" "onions" "pepperoni" "sundried tomatoes" "tomatoes"))

(define (low-ingredients i-tree cutoff)
  (cond [(empty? i-tree) empty]
        [else 
         (local 
           [(define low-ingredients-left (low-ingredients (i-node-left i-tree) cutoff))
            (define low-ingredients-right (low-ingredients (i-node-right i-tree) cutoff))]
           (cond [(< (i-node-quantity i-tree) cutoff)
                  (append low-ingredients-left
                          (cons (i-node-ingredient i-tree) low-ingredients-right))]
                 [else (append low-ingredients-left low-ingredients-right)]))]))
;; Tests:
(check-expect (low-ingredients sample-i-tree2 cutoffex3) cutoffex3result)
(check-expect (low-ingredients sample-i-tree2 0) empty)
(check-expect (low-ingredients empty cutoffex3) empty)

;; *****************************************************
;; (add-ingredient i-tree ingredient amount) add the ingredient with amount to i-tree.
;;     if ingredient already exists, update its quantity
;; add-ingredient: I-Tree Str Num -> I-Tree
;; requires: amount >= 0
;; Examples:
(check-expect (add-ingredient just-chicken "chicken" 20) 
              (make-i-node "chicken" 21 empty empty))
(check-expect (add-ingredient sample-i-tree4-without-onion "onions" 0) 
              sample-i-tree4)


;; useful constants for examples and tests
(define just-chicken (make-i-node "chicken" 1 empty empty))
(define sample-i-tree4
  (make-i-node "pepperoni" 5000
               (make-i-node "mushrooms" 1500 empty (make-i-node "onions" 0 empty empty))
               (make-i-node "tomatoes" 1
                            (make-i-node "sundried tomatoes" 100 empty empty)
                            empty)))
(define sample-i-tree2-without-mushrooms
  (make-i-node "pepperoni" 5000
               (make-i-node "onions" 0 
                            empty empty)
               (make-i-node "tomatoes" 1
                            (make-i-node "sundried tomatoes" 100 empty empty)
                            empty)))
(define sample-i-tree4-without-onion
  (make-i-node "pepperoni" 5000
               (make-i-node "mushrooms" 1500 empty empty)
               (make-i-node "tomatoes" 1
                            (make-i-node "sundried tomatoes" 100 empty empty)
                            empty)))

(define (add-ingredient i-tree ingredient amount)
  (cond [(empty? i-tree) (make-i-node ingredient amount empty empty)]
        [(equal? (i-node-ingredient i-tree) ingredient)
         (make-i-node ingredient 
                      (+ amount (i-node-quantity i-tree))
                      (i-node-left i-tree)
                      (i-node-right i-tree))]
        [(string<? ingredient (i-node-ingredient i-tree))
         (make-i-node (i-node-ingredient i-tree) 
                      (i-node-quantity i-tree)
                      (add-ingredient (i-node-left i-tree) ingredient amount)
                      (i-node-right i-tree))]
        [(string>? ingredient (i-node-ingredient i-tree))
         (make-i-node (i-node-ingredient i-tree) 
                      (i-node-quantity i-tree)
                      (i-node-left i-tree)
                      (add-ingredient (i-node-right i-tree) ingredient amount))]))
;; Tests:
(check-expect (add-ingredient sample-i-tree2-without-mushrooms "mushrooms" 1500) 
              sample-i-tree2)
(check-expect (add-ingredient empty "mushrooms" 1500) 
              (make-i-node "mushrooms" 1500 empty empty))

;; *****************************************************
;; (add-shipment i-tree shipment) update the current stocks i-tree with new shipment
;; add-ingredient: I-Tree (listof (list Str Num)) -> I-Tree
;; Examples:
(check-expect (add-shipment just-chicken '(("chicken" 20) ("onions" 10)))
              (make-i-node "chicken" 21 empty (make-i-node "onions" 10 empty empty)))
(check-expect (add-shipment empty shipment1)
              sample-i-tree2)

;; useful constants for examples and tests
(define shipment1 
  '(("pepperoni" 5000) ("onions" 0) ("mushrooms" 1500) ("tomatoes" 1)("sundried tomatoes" 100)))
(define shipment2
  '( ("onions" 0) ("mushrooms" 1500) ("tomatoes" 1)("sundried tomatoes" 100)))

(define (add-shipment i-tree shipment)
  (cond [(empty? shipment) i-tree]
        [else
         (add-shipment 
          (add-ingredient i-tree (first (first shipment)) (second (first shipment))) 
          (rest shipment))]))

;; Tests:
(check-expect (add-shipment (make-i-node "pepperoni" 5000 empty empty) shipment2) 
              sample-i-tree2)
(check-expect (add-shipment sample-i-tree2 empty) 
              sample-i-tree2)


;; *****************************************************
;; (accommodate? i-tree mypizza) judges if there are enough ingredients in i-tree to make mypizza
;; accommodate?: I-Tree Pizza -> Bool
;; Examples:
(check-expect (accommodate? sample-i-tree med-bt-pizza1) false)
(check-expect (accommodate? sample-i-tree med-bt-pizza2) true)
(check-expect (accommodate? sample-i-tree med-bt-pizza3) true)


;; useful constants for examples and tests
(define med-bt-pizza1 (make-pizza 'medium '("bacon" "tomatoes") empty))
(define med-bt-pizza2 (make-pizza 'small '("tomatoes") empty))
(define med-bt-pizza3 (make-pizza 'small '("tomatoes" "bacon") empty))
(define med-bt-pizza4 (make-pizza 'small '("tomatoes" "bacon") '("italian sausage" "italian sausage")))
(define med-bt-pizza5 (make-pizza 'large empty empty))
(define med-bt-pizza6 (make-pizza 'small empty '("italian sausage" "italian sausage")))

(define (accommodate? i-tree mypizza)
  (local [(define size (pizza-size mypizza))
          (define std-tops (pizza-std-tops mypizza))
          (define prm-tops (pizza-prm-tops mypizza))
          (define tops (append std-tops prm-tops))
          (define unitofsize (cond [(symbol=? size 'small) 1]
                                   [(symbol=? size 'medium) 1.5]
                                   [(symbol=? size 'large) 2]
                                   [(symbol=? size 'xl) 2]))
          
          ;; (accommodate-one-top? i-tree-in-onetop mytop) judges if there are enough 
          ;;    mytop(only one kind of top) in i-tree-in-onetop, if enough, return a new i-tree 
          ;;    after abstract the corresponding number of mytop, if not enough, return false
          ;; accommodate-one-top?: I-Tree Str -> (anyof false I-Tree)
          (define (accommodate-one-top? i-tree-in-onetop mytop)
            (cond [(empty? i-tree-in-onetop) false]
                  [(equal? (i-node-ingredient i-tree-in-onetop) mytop)
                   (cond 
                     [(>= (i-node-quantity i-tree-in-onetop) unitofsize)
                      (make-i-node (i-node-ingredient i-tree-in-onetop)
                                   (- (i-node-quantity i-tree-in-onetop) unitofsize)
                                   (i-node-left i-tree-in-onetop)
                                   (i-node-right i-tree-in-onetop))]
                     [else false])]
                  [(string<? mytop (i-node-ingredient i-tree-in-onetop))
                   (local [(define new-i-node-left
                             (accommodate-one-top? (i-node-left i-tree-in-onetop) mytop))]
                     (cond [(false? new-i-node-left) false] 
                           [else (make-i-node (i-node-ingredient i-tree-in-onetop)
                                              (i-node-quantity i-tree-in-onetop)
                                              new-i-node-left
                                              (i-node-right i-tree-in-onetop))]))]
                  [(string>? mytop (i-node-ingredient i-tree-in-onetop))
                   (local [(define new-i-node-right 
                             (accommodate-one-top? (i-node-right i-tree-in-onetop) mytop))]
                     (cond [(false? new-i-node-right) false]
                           [else  (make-i-node (i-node-ingredient i-tree-in-onetop)
                                               (i-node-quantity i-tree-in-onetop)
                                               (i-node-left i-tree-in-onetop)
                                               new-i-node-right)]))]))
          ;; (accommodate-tops? mytops i-tree-in-tops) judges if there are enough 
          ;;    tops of list "mytops" in i-tree-in-tops
          ;; accommodate-tops?: I-Tree (listof Str) -> Bool
          (define (accommodate-tops? mytops i-tree-in-tops)
            (cond [(empty? mytops) true]
                  [else (local [(define one-top-result
                                  (accommodate-one-top? i-tree-in-tops (first mytops)))]
                          (cond [(false? one-top-result) false]
                                [else (accommodate-tops? (rest mytops) one-top-result)]))]))]
    
    (accommodate-tops? tops i-tree)))

;; Tests:
(check-expect (accommodate? sample-i-tree med-bt-pizza4) true)
(check-expect (accommodate? sample-i-tree med-bt-pizza5) true)
(check-expect (accommodate? empty med-bt-pizza5) true)
(check-expect (accommodate? sample-i-tree med-bt-pizza6) true)