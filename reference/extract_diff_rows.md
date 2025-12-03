# Extract Different Rows Function to extract missing or new rows from comparing two data frames.

Extract Different Rows Function to extract missing or new rows from
comparing two data frames.

## Usage

``` r
extract_diff_rows(
  dfx = NULL,
  dfy = NULL,
  myrror_object = NULL,
  by = NULL,
  by.x = NULL,
  by.y = NULL,
  output = c("simple", "full", "silent"),
  tolerance = 0.0000001,
  verbose = getOption("myrror.verbose"),
  interactive = getOption("myrror.interactive")
)
```

## Arguments

- dfx:

  a non-empty data.frame.

- dfy:

  a non-empty data.frame.

- myrror_object:

  myrror object from
  [create_myrror_object](https://PIP-Technical-Team.github.io/myrror/reference/create_myrror_object.md)

- by:

  character, key to be used for dfx and dfy.

- by.x:

  character, key to be used for dfx.

- by.y:

  character, key to be used for dfy.

- output:

  character: one of "full", "simple", "silent".

- tolerance:

  numeric, default to 1e-7.

- verbose:

  logical: If `TRUE` additional information will be displayed.

- interactive:

  logical: If `TRUE`, print S3 method for myrror objects displays by
  chunks. If `FALSE`, everything will be printed at once.

## Value

Depending on `output` parameter:

- `"full"`: myrror object with `extract_diff_rows` slot containing a
  data.table of non-matching rows

- `"simple"`: data.table with columns: df (indicating 'dfx' or 'dfy'),
  keys, and all other columns. Contains rows that exist in only one
  dataset

- `"silent"`: invisibly returns myrror object (same as "full")

Returns `NULL` if no row differences are found and `output = "simple"`.

## Examples

``` r
# 1. Standard report, after running myrror() or compare_values():
myrror(survey_data, survey_data_2, by=c('country', 'year'))
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_2 with 16 rows and 6 columns.
#> keys: country and year.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_2: 0 ()
#> 
#> ✔ Total shared rows: 16
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_2: 0.
#> 
#> ✔ There are no missing or new rows.
#> 
#> ── 1. Shared Columns Class Comparison ──────────────────────────────────────────
#> 
#> ✔ All shared columns have the same class.
#> 
#> 
#> ── 2. Shared Columns Values Comparison ─────────────────────────────────────────
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: character-numeric comparison is allowed.
#> 
#> 
#> ── Overview: ──
#> 
#> # A tibble: 1 × 4
#>   variable  change_in_value na_to_value value_to_na
#>   <fct>               <int>       <int>       <int>
#> 1 variable2              16           0           0
#> 
#> 
#> 
#> ── Value comparison: ──
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "variable2" 
#>               diff indexes country  year variable2.x variable2.y
#>             <char>  <char>  <char> <int>       <num>       <num>
#> 1: change_in_value       1       A  2010   0.4978505 -1.07179123
#> 2: change_in_value       2       A  2011  -1.9666172  0.30352864
#> 3: change_in_value       3       A  2012   0.7013559  0.44820978
#> 4: change_in_value       4       A  2013  -0.4727914  0.05300423
#> 5: change_in_value       5       A  2014  -1.0678237  0.92226747
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.
extract_diff_rows()
#> Last myrror object used for comparison.
#> NULL

# 2. Standard report, with new data:
extract_diff_rows(survey_data, survey_data_2, by=c('country', 'year'))
#> NULL


# 3. Toggle tolerance:
extract_diff_rows(survey_data, survey_data_2, by=c('country', 'year'),
                    tolerance = 1e-5)
#> NULL
```
