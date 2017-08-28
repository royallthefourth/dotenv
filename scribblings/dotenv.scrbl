#lang scribble/manual
@require[@for-label[dotenv
                    racket/base]]

@title{dotenv}
@author[@author+email["Royall Spence" "royall@royall.us"]]

@defmodule[dotenv]

A library that allows for reading .env files instead of environment variables

@section{Usage}
To load from .env to override your program's environment variables, just use
@racketblock[
 (require dotenv)
 (dotenv-load!)]

To load multiple files, use dotenv-load-files!
@racketblock[
 (require dotenv)
 (dotenv-load-files! '("raccoon.env possum.env"))]
