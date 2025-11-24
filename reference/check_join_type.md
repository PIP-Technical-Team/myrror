# Check join type. Internal function.

This function checks the join type between two data frames. Internal
function. It returns the type of match between the two data frames
("1:1", "1:m", "m:1", "m:m"), and the identified and non-identified
rows.

## Usage

``` r
check_join_type(dfx, dfy, by.x, by.y, return_match = FALSE)
```

## Arguments

- dfx:

  data.frame

- dfy:

  data.frame

- by.x:

  character vector, keys for by.y.

- by.y:

  character vector, keys for by.x.

- return_match:

  logical, default is FALSE.

## Value

character/list depending on return_match FALSE/TRUE.
