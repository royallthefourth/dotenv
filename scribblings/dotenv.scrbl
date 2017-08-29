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

To load multiple files, use dotenv-load-files!
@racketblock[
 (require dotenv)
 (dotenv-load-files! '("raccoon.env"  "possum.env"))]

@section{API}

@defproc[(dotenv-load!) (listof boolean?)]{
 Loads the .env file from the current directory and replaces the current
 environment variables with the file's contents.
 Return value represents success or failure of setting each var,
 which is currently useless.}

@defproc[(dotenv-load-files! (filenames (listof string?))) (listof boolean?)]{
 Loads a list of files from the current directory and replaces the current
 environment variables with the contents of the files.
 Return value represents success or failure of setting each var,
 which is currently useless.}
