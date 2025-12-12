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

## Examples

``` r
# convert rownames of mtcars to a column
mtcars2 <- mtcars
mtcars2$car_name <- rownames(mtcars2)
rownames(mtcars2) <- NULL
# modify mtcars2 slightly by remove one row and changing one value
mtcars3 <- mtcars2[-1, ]
mtcars3$mpg[1] <- mtcars3$mpg[1] + 1

mo <- create_myrror_object(mtcars2, mtcars3, by = "car_name")
mo
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: mtcars2 with 32 rows and 12 columns.
#> dfy: mtcars3 with 31 rows and 12 columns.
#> keys: car_name.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 11
#> ! Non-shared columns in mtcars2: 0 ()
#> ! Non-shared columns in mtcars3: 0 ()
#> 
#> ✔ Total shared rows: 31
#> ! Non-shared rows in mtcars2: 1.
#> ! Non-shared rows in mtcars3: 0.
#> 
#> ℹ Note: run `extract_diff_rows()` to extract the missing/new rows.
```
