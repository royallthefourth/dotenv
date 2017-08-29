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

@defproc[(dotenv-load!) null]{
 Loads the .env file from the current directory and replaces the current
 environment variables with the file's contents.}

@defproc[(dotenv-load-files! (filenames (listof string?))) null]{
 Loads a list of files from the current directory and replaces the current
 environment variables with the contents of the files.}
