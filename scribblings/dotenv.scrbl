#lang scribble/manual
@require[@for-label[dotenv
                    racket]]

@title{dotenv}
@author[@author+email["Royall Spence" "royall@royall.us"]]

@defmodule[dotenv]

A library that allows for reading .env files instead of environment variables

@section{Usage Examples}
To load from .env to override your program's environment variables, just use
@racketblock[
 (require dotenv)
 (dotenv-load!)]

To load multiple files, pass a list of filenames
@racketblock[
 (require dotenv)
 (dotenv-load! '("raccoon.env"  "possum.env"))]

To return an environment variable set without overwriting the current
environment variables, use @racket[dotenv-read]
@racketblock[
 (require dotenv)
 (define other-env (dotenv-read '("raccoon.env"  "possum.env")))]

@section{API}

@defproc[(dotenv-load! [filenames (listof string?)]) (listof boolean?)]{
 Loads the .env file from the current directory and replaces the current
 environment variables with the file's contents.
 Optionally accepts a list of filenames.
 Return value represents success or failure of setting each var;
 every element should be @racket[#t].}

@defproc[(dotenv-read
          (filenames (listof string?)))
         environment-variables?]{
 Loads a list of files from the current directory and replaces the current
 environment variables with the contents of the files.
 Return value is a new @racket[environment-variables?]. Raises exception on failure.
 @history[#:added "1.1"]}
