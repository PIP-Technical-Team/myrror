# Readline wrapper. Internal function.

This function is a wrapper around the base R readline function. It is
used to provide a consistent interface for the readline function.

## Usage

``` r
my_readline(...)
```

## Arguments

- ...:

  Arguments passed to
  [`base::readline()`](https://rdrr.io/r/base/readline.html),
  particularly `prompt`.

## Value

Character string containing the user's input.
