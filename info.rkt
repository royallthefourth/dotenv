#lang info
(define collection "dotenv")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/dotenv.scrbl" ())))
(define pkg-desc "A library that allows for reading .env files instead of environment variables")
(define version "0.1")
(define pkg-authors '(royall))
