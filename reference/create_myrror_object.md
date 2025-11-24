# Creates a myrror object for comparing two data frames

This function constructs a myrror object by comparing two data frames.
It handles the preparation, validation, and joining of datasets,
identifies matching and non-matching observations, and performs column
pairing for comparison. The function supports various join types (1:1,
1:m, m:1) and provides detailed reports on the comparison results.

## Usage

``` r
create_myrror_object(
  dfx,
  dfy,
  by = NULL,
  by.x = NULL,
  by.y = NULL,
  factor_to_char = TRUE,
  verbose = getOption("myrror.verbose"),
  interactive = getOption("myrror.interactive")
)
```

## Arguments

- dfx:

  a non-empty data.frame.

- dfy:

  a non-empty data.frame.

- by:

  character, key to be used for dfx and dfy.

- by.x:

  character, key to be used for dfx.

- by.y:

  character, key to be used for dfy.

- factor_to_char:

  TRUE or FALSE, default to TRUE.

- verbose:

  logical: If `TRUE` additional information will be displayed.

- interactive:

  logical: If `TRUE`, print S3 method for myrror objects displays by
  chunks. If `FALSE`, everything will be printed at once.

## Value

An object of class "myrror" containing comparison results, dataset
information, and various reports on matching/non-matching observations.
