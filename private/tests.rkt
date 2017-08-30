#lang racket/base
(module+ test
  
  (require "dotenv.rkt" racket/stream rackunit)

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
