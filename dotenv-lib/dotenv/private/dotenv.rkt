#lang racket/base

(require racket/contract racket/list racket/stream racket/string)

(provide
 (contract-out
  [dotenv-read (->* () ()
                 #:rest (or/c (listof path-string?) (listof (listof path-string?)))
                 environment-variables?)]
  [dotenv-load! (->* () ()
                  #:rest (or/c (listof path-string?) (listof (listof path-string?)))
                  (listof boolean?))]))

(define (ignorable-line? line)
  (or 
   (eq? (string-length line) 0)
   (eq? (first (string->list line)) #\#)))

(define (process-line text)
  (let ([creds (string-split text "=")])
    (cons (car creds) (cadr creds))))

(define (process-file filestream vars)
  (if
   (stream-empty? filestream)
   vars
   (process-file
    (stream-rest filestream)
    (let ([line (stream-first filestream)])
      (if (ignorable-line? line)
          vars
          (cons (process-line line) vars))))))

(define (load-file filename vars)
  (let ([file 
         (sequence->stream (in-lines (open-input-file filename)))])
    (append vars (process-file file '()))))

(define (load-files files vars)
  (if (empty? files)
      vars
      (load-files (cdr files) (load-file (car files) vars))))

(define (dotenv-read . filenames)
  (parameterize ([current-environment-variables (make-environment-variables)])
    (apply dotenv-load! filenames)
    (current-environment-variables)))

(define (dotenv-load! . filenames)
  (define files (cond ((empty? filenames) '(".env"))
                      ((list? (car filenames)) (car filenames))
                      (else filenames)))
  (map
   (λ (pair)
     (putenv (car pair) (cdr pair)))
   (load-files files '())))
