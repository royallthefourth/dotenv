#lang racket/base

(require "dotenv.rkt" racket/stream rackunit)
(provide dotenv-test-suite)

(define (dotenv-test-suite)
  (define envstream (sequence->stream (in-lines (open-input-file ".env"))))
  (define test-user '("DATABASE_USER" . "test-user"))
  (define test-pass '("DATABASE_PASSWORD" . "test-password"))
  (check-equal? (process-line "TEST_KEY=test-value") '("TEST_KEY" . "tes-value"))
  (check-equal? (car (process-file envstream '())) test-pass)
  (check-equal? (car (load-file ".env" '())) test-pass)
  (dotenv-load!)
  (check-equal? (getenv "DATABASE_USER") (cdr test-user)))
