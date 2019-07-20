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

(module+ test
  
  (require rackunit)

  (define envstream (sequence->stream (in-lines (open-input-file ".env"))))
  (define test-user '("DATABASE_USER" . "test-user"))
  (define test-pass '("DATABASE_PASSWORD" . "test-password"))
  (define more-user '("MORE_USER" . "more-test-user"))
  (define more-pass '("MORE_PASSWORD" . "more-test-password"))
  (define most-user '("MOST_USER" . "most-test-user"))
  (define most-pass '("MOST_PASSWORD" . "most-test-password"))
  (check-equal? (process-line "TEST_KEY=test-value") '("TEST_KEY" . "test-value"))
  (check-equal? (car (process-file envstream '())) test-pass)
  (check-equal? (car (load-file ".env" '())) test-pass)

  (parameterize ([current-environment-variables (make-environment-variables)])
    (test-case
      "Test that dotenv-load! changes environment"
      (check-false (getenv (car test-user))
        "Environment not clear before main check")
      (dotenv-load!)
      (check-equal? (getenv (car test-user)) (cdr test-user)
        "Environment did not change after call to dotenv-load!"))

    (test-case
      "Test that dotenv-load! changes environment with explicit filename"
      (check-false (getenv (car more-user))
        "Environment not clear before main check")
      (dotenv-load! "more.env")
      (check-equal? (getenv (car more-user)) (cdr more-user)
        "Environment did not change after call to dotenv-load!"))

    (test-case
      "Test that dotenv-load! changes environment with list of filenames"
      (check-false (getenv (car most-user))
        "Environment not clear before main check")
      (dotenv-load! '("most.env"))
      (check-equal? (getenv (car most-user)) (cdr most-user)
        "Environment did not change after call to dotenv-load!")))

  (test-case
    "Test that dotenv-read does not change environment"
    (check-false (getenv (car test-user))
      "Environment not clear before main check")
    (define test-env (dotenv-read))
    (check-false (getenv (car test-user))
      "Environment should not be affected by call to dotenv-read")
    (check-equal?
      (environment-variables-ref
        test-env
        (string->bytes/utf-8 (car test-user)))
      (string->bytes/utf-8 (cdr test-user))))

  (test-case
    "Test that dotenv-read does not change environment with explicit filename"
    (check-false (getenv (car more-user))
      "Environment not clear before main check")
    (define test-env2 (dotenv-read "more.env"))
    (check-false (getenv (cdr more-user))
      "Environment should not be affected by call to dotenv-read")
    (check-equal?
      (environment-variables-ref
        test-env2
        (string->bytes/utf-8 (car more-user)))
      (string->bytes/utf-8 (cdr more-user))))

  (test-case
    "Test that dotenv-read does not change environment with list of filenames"
    (check-false (getenv (car most-user))
      "Environment not clear before main check")
    (define test-env3 (dotenv-read '("most.env")))
    (check-false (getenv (cdr most-user))
      "Environment should not be affected by call to dotenv-read")
    (check-equal?
      (environment-variables-ref
        test-env3
        (string->bytes/utf-8 (car most-user)))
      (string->bytes/utf-8 (cdr most-user)))))
