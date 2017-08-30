dotenv
======
This library allows Racket applications to override their environment variables with a `.env` file.

## Usage
To load `.env`, just require the package and invoke it:
```racket
(require dotenv)
(dotenv-load!)
```

To use multiple files, use `dotenv-load-files!` with a list:
```racket
(require dotenv)
(dotenv-load-files! '("raccoon.env" "possum.env"))
```

More details in [the official documentation](http://docs.racket-lang.org/dotenv/index.html).
