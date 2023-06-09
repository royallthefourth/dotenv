#lang scribble/manual
@require[@for-label[dotenv
                    racket]]

@title{dotenv}
@author[@author+email["Royall Spence" "royall@royall.us"]]

@defmodule[dotenv]

A library that allows applications to read .env files instead of environment variables

@section{Usage Examples}
To load from @var[.env] to override your program's environment variables,
use @racket[dotenv-load!]
@racketblock[
 (require dotenv)
 (dotenv-load!)]

To load multiple files, pass one or more @racket[path-string?] arguments
@racketblock[
 (require dotenv)
 (dotenv-load! "database.env" "api.env")]

The legacy calling convention of passing a list of filenames still works
@deprecated[#:what "calling convention" "rest arguments"]
@racketblock[
 (require dotenv)
 (dotenv-load! '("database.env" "api.env"))]

To return a new @racket[environment-variables?] set instead of updating
@racket[current-environment-variables], use @racket[dotenv-read]
@racketblock[
 (require dotenv)
 (define other-env (dotenv-read "database.env" "api.env"))]

The legacy calling convention for @racket[dotenv-read] also still works
@deprecated[#:what "calling convention" "rest arguments"]
@racketblock[
 (require dotenv)
 (define other-env (dotenv-read '("database.env" "api.env")))]

@section{API}

@defproc[(dotenv-load! [filename path-string?] ...) (listof boolean?)]{
 Update @racket[current-environment-variables] using the values parsed
 from all the files given as arguments. Updates are done in order, so later
 definitions override earlier ones. If no arguments are passed, the file @var[.env]
 from the current-directory will be loaded.

 Return value represents success or failure of setting each var;
 every element should be @racket[#t]. Raises exception on failure.
 @history[#:changed "1.2" "Can now use path-string? rest arguments."]
 @history[#:changed "1.2" "Calling with a list argument is deprecated."]}

@defproc[(dotenv-read [filename path-string?] ...) environment-variables?]{
 Otherwise identical to @racket[dotenv-load!], except that instead of returning
 a @racket[(listof boolean?)], a newly created @racket[environment-variables?]
 set is returned. @racket[current-environment-variables] is not modified by
 calling this procedure.

 Raises exception on failure.
 @history[#:added "1.1"]
 @history[#:changed "1.2" "Can now use path-string? rest arguments."]
 @history[#:changed "1.2" "Calling with a list argument is deprecated."]
 @history[#:changed "1.2" "Now behaves like dotenv-load! and attempts to read .env when no arguments are given."]}
