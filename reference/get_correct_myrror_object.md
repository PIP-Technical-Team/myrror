# Get correct myrror object. Internal function.

It checks all the arguments parsed to parent function. If
`myrror_object` if found, then it will be used. If not, it checks if
both databases are NULL. If they are it looks for the the last myrror
object. If nothing available, then error. Finally, it checks for the
availability of both datasets. If they are available, then create
`myrror_object`

## Usage

``` r
get_correct_myrror_object(
  myrror_object,
  dfx,
  dfy,
  by,
  by.x,
  by.y,
  verbose,
  interactive,
  ...
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

- verbose:

  logical: If `TRUE` additional information will be displayed.

- interactive:

  logical: If `TRUE`, print S3 method for myrror objects displays by
  chunks. If `FALSE`, everything will be printed at once.

- ...:

  other arguments parsed to parent function.

## Value

myrror object
