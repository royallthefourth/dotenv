#lang info
(define collection "dotenv")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/dotenv.scrbl" ())))
(define pkg-desc "A library that allows for reading .env files instead of environment variables")
(define version "1.1")
(define pkg-authors '("Royall Spence <royall@royall.us>"))
