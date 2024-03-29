dotenv
======
[![Build Status](https://travis-ci.org/royallthefourth/dotenv.svg?branch=master)](https://travis-ci.org/royallthefourth/dotenv)

This library allows Racket applications to override their environment variables with a `.env` file.

## Usage
To load `.env`, require the package and invoke it:
```racket
(require dotenv)
(dotenv-load!)
```

To use the lightweight library-only version without documentation or test dependencies, use `dotenv-lib` instead.

To use multiple files, use `path-string?` rest arguments:
```racket
(require dotenv)
(dotenv-load! "database.env" "api.env")
```

More details in [the official documentation](http://docs.racket-lang.org/dotenv/index.html).
