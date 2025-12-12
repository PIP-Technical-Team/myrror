# Prepares dataset for joyn::joyn(). Internal function.

Prepares dataset for joyn::joyn(). Internal function.

## Usage

``` r
prepare_df(
  df,
  by = NULL,
  factor_to_char = TRUE,
  interactive = getOption("myrror.interactive"),
  verbose = getOption("myrror.verbose")
)
```

## Arguments

- df:

  data.frame or data.table

- by:

  character vector

- factor_to_char:

  logical

- interactive:

  logical

- verbose:

  logical

## Value

data.table
