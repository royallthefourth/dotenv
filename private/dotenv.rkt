#lang racket/base

(require racket/contract racket/list racket/stream racket/string)

(provide
 (contract-out
  [dotenv-read (-> (listof string?) environment-variables?)]
  [dotenv-load! (case-> (-> (listof string?) (listof boolean?))
                        (-> (listof boolean?)))]))

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

(define (dotenv-read files)
  (define new-env (make-environment-variables))
  (map
   (λ (pair)
     (environment-variables-set! new-env
                                 (string->bytes/locale (car pair))
                                 (string->bytes/locale (cdr pair))))
   (load-files files '()))
  new-env)

(define (dotenv-load! [filenames '(".env")])
  (map
   (λ (pair)
     (putenv (car pair) (cdr pair)))
   (load-files filenames '())))

(module+ test
  
  (require rackunit)

  (define envstream (sequence->stream (in-lines (open-input-file ".env"))))
  (define test-user '("DATABASE_USER" . "test-user"))
  (define test-pass '("DATABASE_PASSWORD" . "test-password"))
  (check-equal? (process-line "TEST_KEY=test-value") '("TEST_KEY" . "test-value"))
  (check-equal? (car (process-file envstream '())) test-pass)
  (check-equal? (car (load-file ".env" '())) test-pass)
  (dotenv-load!)
  (check-equal? (getenv "DATABASE_USER") (cdr test-user))
  (check-equal?
   (environment-variables-ref
    (dotenv-read '(".env"))
    (string->bytes/utf-8 "DATABASE_USER"))
   (string->bytes/utf-8 "test-user")))
