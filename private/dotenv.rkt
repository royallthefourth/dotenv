#lang racket/base

(require racket/contract racket/list racket/stream racket/string)

(provide
 process-line
 process-file
 load-file
 (contract-out
  [dotenv-read (-> (listof string?) environment-variables?)]
  [dotenv-load-files! (-> (listof string?) (listof boolean?))]
  [dotenv-load! (-> (listof boolean?))]))

(define (process-line text)
  (let ([creds (string-split text "=")])
    (cons (car creds) (cadr creds))))

(define (process-file filestream vars)
  (if
    (stream-empty? filestream)
    vars
    (process-file
     (stream-rest filestream)
     (cons (process-line (stream-first filestream)) vars))))

(define (load-file filename vars)
  (let ([file (sequence->stream (in-lines (open-input-file filename)))])
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

(define (dotenv-load-files! files)
  (map
   (λ (pair)
     (putenv (car pair) (cdr pair)))
   (load-files files '())))

(define (dotenv-load!)
 (dotenv-load-files! '(".env")))
