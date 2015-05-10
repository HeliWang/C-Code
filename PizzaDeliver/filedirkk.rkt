;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname filedirkk) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
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
;; (filedir-type mydir path) indicates 'file if mydir is a File, or 'dir of mydir is a Dir, 
;;    or error info when get error
;; filedir-type: FileSystem (listof Str) -> (anyof Sym Str)
;; Examples:

(define (filedir-type mydir path)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  (cond [(empty? path) 'dir]
        [else (first path)
              (filedir-type(mydir (rest path)))]
        
;; mylofiledirfn: (listof FileDir) -> Any
(define (mylofiledirfn mylofiledir path)
  (cond [(empty? mylofiledir) (string-append "FileDir not found: " (first path))]
        [else (.....(myfiledirfn (first myfiledir))
                    ......(mylofiledirfn (rest mylofiledir))...)]))

;; myfiledirfn: FileDir -> Any
(define (myfiledirfn myfiledir path)                                                                                                                                                                                                               
  (cond [(file? myfiledir) (myfilefn myfiledir)]
        [(dir? myfiledir) (filedir-type myfiledir)]))

(define (myfilefn myfile path) type mydir path)
  (...(dir-name mydir)...
      (mylofiledirfn (dir-contents mydir))...)) 




