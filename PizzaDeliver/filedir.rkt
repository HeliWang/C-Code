;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname filedir) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; *****************************************************
;;   Heli Wang (20552080)
;;   CS 135 Fall 2014
;;   Assignment 07, Problem2
;; *****************************************************
(require "a7.rkt") 

;; A FileSystem is a:
;; * Dir

;; A FileDir is one of:
;; * File
;; * Dir

;; (define-struct file (name size timestamp))
;; A File is a (make-file Str Nat Nat)

;; (define-struct dir (name contents))
;; A Dir (directory) is a (make-dir Str (listof FileDir))

;; Template functions for File, Dir, FileDir and (listof FileDir):
;; myfilefn: File -> Any
(define (myfilefn myfile)
  (...(file-name myfile)...
      (file-size myfile)...
      (file-timestamp myfile)...))

;; mydirfn: Dir -> Any
(define (mydirfn mydir)
  (...(dir-name mydir)...
      (mylofiledirfn (dir-contents mydir))...)) 

;; myfiledirfn: FileDir -> Any
(define (myfiledirfn myfiledir)
  (cond [(file? myfiledir) (myfilefn myfiledir)]
        [(dir? myfiledir) (mydirfn myfiledir)]))

;; mylofiledirfn: (listof FileDir) -> Any
(define (mylofiledirfn mylofiledir)
  (cond [(empty? mylofiledir) (.....)]
        [else (.....(myfiledirfn (first myfiledir))
                    ......(mylofiledirfn (rest mylofiledir))...)]))

;; useful constants for examples and tests
(define file1 (make-file "oldfile" 1000 5))
(define file2 (make-file "newfile" 1000 55555555))
(define dir0 (make-dir "empty-dir" empty))
(define dir1 (make-dir "dir-onefile" (list file1)))
(define dir2 (make-dir "dir-twofiles" (list file1 file2)))
(define dir3 (make-dir "dir-threesubdirs" (list dir1 dir1 dir1)))
(define dir4 (make-dir "dir-emptysubdir" (list dir0)))
(define fs1 (make-dir "rootdir" (list file1 dir0 dir1 dir2 dir3 file2)))
(define fs2 (make-dir "u" (list file2 dir0 dir1)))
(define fs3 (make-dir "rootdir" (list file1 file1 dir0 dir1 dir1 dir2 dir3 file2)))
;; *****************************************************
;; (filedir-timestamp myfiledir)
;; filedir-timestamp: FileDir -> (anyof Nat false)

(check-expect (filedir-timestamp dir3) 5)
(check-expect (filedir-timestamp dir4) false)

(define (filedir-timestamp myfiledir)
  (cond [(file? myfiledir) (file-timestamp myfiledir)]
        [(dir? myfiledir)
         (local 
           ;; (lofiledir-timestamp mylofiledir) produces the timestamp of mylofiledir
           ;; lofiledir-timestamp: (listof FileDir) -> (anyof Nat false)
           [(define (lofiledir-timestamp mylofiledir)
              (cond 
                [(empty? mylofiledir) false]
                [else (local 
                        ;; (bigger-timestamp timestamp1 timestamp2)  produces the bigger timestamp of timestamp1 timestamp2
                        ;;    note: false < anyof nat timestamp
                        ;; (anyof Nat false) (anyof Nat false) -> (anyof Nat false)
                        [(define (bigger-timestamp timestamp1 timestamp2)
                           (cond [(false? timestamp1) timestamp2]
                                 [(false? timestamp2) timestamp1]
                                 [else (max timestamp1 timestamp2)]))]
                        (bigger-timestamp (filedir-timestamp (first mylofiledir))
                                          (lofiledir-timestamp (rest mylofiledir))))]))]
           (lofiledir-timestamp (dir-contents myfiledir)))]))

(define size-newfile 55555555)
(check-expect (filedir-timestamp dir2) size-newfile)
(check-expect (filedir-timestamp dir0) false)


;; *****************************************************
;; (bigger-files mydir size) produces a list of file names that appear in mydir
;;    whose size is strictly greater than the given size
;; bigger-files: FileSystem Nat -> (listof Str)
;; Examples:
(check-expect (bigger-files sample-fs sample-fs-filtersize3)
              '("daft-punk-lose-yourself-to-dance.mp3"))
(check-expect (bigger-files sample-fs (sub1 sample-fs-filtersize3))
              '("rhcp-under-the-bridge.mp3" "daft-punk-lose-yourself-to-dance.mp3"))


(define (bigger-files mydir size)
  (local 
    ;; bigger-files-lofiledir mylofiledir):produces a list of file names that appear in mylofiledir
    ;;    whose size is strictly greater than the given size 
    ;; bigger-files-lofiledir: (listof FileDir) -> (listof Str)
    [(define (bigger-files-lofiledir mylofiledir)
       (cond [(empty? mylofiledir) empty]
             [else (append (bigger-files-filedir (first mylofiledir))
                           (bigger-files-lofiledir (rest mylofiledir)))]))
     ;; (bigger-files-filedir myfiledir):produces a list of file names that appear in myfiledir
     ;;    whose size is strictly greater than the given size 
     ;; bigger-files-filedir: FileDir -> (listof Str)
     (define (bigger-files-filedir myfiledir)
       (cond [(file? myfiledir) 
              (cond 
                [(> (file-size myfiledir) size) (list (file-name myfiledir))]
                [else empty])]
             [(dir? myfiledir) (bigger-files myfiledir size)]))]
    (bigger-files-lofiledir (dir-contents mydir))))

;; useful constants for examples and tests
(define sample-fs-filtersize1 3297000)
(define sample-fs-filtersize2 329700000)
(define sample-fs-filtersize3 10184000)

;; Tests:
(check-expect (bigger-files sample-fs sample-fs-filtersize2)
              '())
(check-expect (bigger-files sample-fs sample-fs-filtersize1)
              '("doctor.jpg" "rhcp-under-the-bridge.mp3" "u2-one.mp3"
                             "katy-perry-roar.mp3" "daft-punk-lose-yourself-to-dance.mp3"))
(check-expect (bigger-files (make-dir "empty" empty) sample-fs-filtersize3)
              '())

;; *****************************************************
;; (filedir-type mydir path) indicates 'file if what the path refer to is a File, or 'dir if it is a Dir, 
;;    or error info when get error, all in mydir
;; filedir-type: FileSystem (listof Str) -> (anyof Sym Str)
;; Examples:
(check-expect (filedir-type fs2 (list "dir-onefile" "newfile")) "FileDir not found: newfile")
(check-expect (filedir-type fs2 (list "newfile" "anything"))
              "Found a File but expecting a Dir: newfile")

(define (filedir-type mydir path)
  (local
    ;; (lofiledir-type mylofiledir path): indicates 'file if what the path refer to is a File, or 'dir if it is a Dir, 
    ;;    or error info when get error, all in mylofiledir
    ;; lofiledir-type: (listof FileDir) -> Any
    [(define (lofiledir-type mylofiledir path)
       (cond 
         [(empty? path) 'dir]
         [(empty? mylofiledir) (string-append "FileDir not found: " (first path))]
         [else (local 
                 [(define currentresult (myfiledir-type (first mylofiledir) (first path)))]
                 (cond [(equal? currentresult 'file)
                        (cond [(empty? (rest path)) 'file]
                              [else (string-append "Found a File but expecting a Dir: " (first path))])]
                       [(equal? currentresult 'dir)
                        (filedir-type (first mylofiledir) (rest path))] ;; open the dir
                       [else (lofiledir-type (rest mylofiledir) path)]))])) ;; continus search on the same level
     ;; (myfiledir-type myfiledir firstofpath) on condition that the name of myfiledir and firstofpath are the same 
     ;;   indicates 'file if myfiledir is a File, or 'dir if it is a Dir, or error info when get error
     ;; myfiledir-type: FileDir -> Any
     (define (myfiledir-type myfiledir firstofpath)
       (cond [(file? myfiledir) 
              (cond 
                [(not (equal? (file-name myfiledir) firstofpath))
                 (string-append "FileDir not found: " firstofpath)]
                [else 'file])]
             [(dir? myfiledir)
              (cond 
                [(not (equal? (dir-name myfiledir) firstofpath))
                 (string-append "FileDir not found: " firstofpath)]
                [else 'dir])]))]
    (lofiledir-type (dir-contents mydir) path)))  ;; main function

(check-expect (filedir-type fs2 empty) 'dir)
(check-expect (filedir-type (make-dir "HH" empty) empty) 'dir)

;; *****************************************************
;; (fs-pathable? mydir) judges whether mydir is pathable or not
;; fs-pathable?: FileSystem -> Bool
;; Examples:
(check-expect (fs-pathable? fs1) false)
(check-expect (fs-pathable? fs2) true)

(define (fs-pathable? mydir)
  (local
    ;; (fs-pathable?lofiledir mylofiledir passed)judges whether there are duplicated members or not
    ;;     with accumulator passed
    ;; mylofiledirfn: (listof FileDir) (listof Str) -> Any
    [(define (fs-pathable?lofiledir mylofiledir passed)
       (cond [(empty? mylofiledir) true]
             [else (local [(define myfiledir (first mylofiledir))]
                     (cond [(file? myfiledir)
                            (cond [(member? (file-name myfiledir) passed) false]
                                  [else (fs-pathable?lofiledir 
                                         (rest mylofiledir) (cons (file-name myfiledir) passed))])]
                           [(dir? myfiledir)
                            (cond [(member? (dir-name myfiledir) passed) false]
                                  [else (and (fs-pathable? myfiledir)
                                             (fs-pathable?lofiledir 
                                              (rest mylofiledir) (cons (dir-name myfiledir) passed)))])]))]))]
    (fs-pathable?lofiledir (dir-contents mydir) empty)))

;; Tests:
(check-expect (fs-pathable? dir0) true)
(check-expect (fs-pathable? fs3) false)