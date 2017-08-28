#lang racket/base

(require racket/list racket/stream racket/string)

(provide
 process-line
 process-file
 load-file
 dotenv-load-files!
 dotenv-load!)

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

(define (dotenv-load-files! files)
  (map
   (λ (pair)
     (putenv (car pair) (cdr pair)))
   (load-files files '())))

(define (dotenv-load!)
 (dotenv-load-files! '(".env")))
