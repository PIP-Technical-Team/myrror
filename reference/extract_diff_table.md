# Extract Different Values in Table Format Function to extract rows with different values between two data frames.

Extract Different Values in Table Format Function to extract rows with
different values between two data frames.

## Usage

``` r
extract_diff_table(
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

- `"full"`: myrror object with `extract_diff_values` slot containing a
  list with `diff_list` and `diff_table`

- `"simple"`: data.table with all observations where at least one value
  differs. Contains columns: diff, variable, indexes, keys, and all
  compared variables with .x/.y suffixes

- `"silent"`: invisibly returns myrror object (same as "full")

Returns `NULL` if no differences are found and `output = "simple"`.

## Examples

``` r
# 1. Standard report, after running myrror() or compare_values():
myrror(survey_data, survey_data_2, by=c('country', 'year'))
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
extract_diff_table()
#> Last myrror object used for comparison.
#>                diff  variable indexes country  year variable1.x variable1.y
#>              <char>    <fctr>  <char>  <char> <int>       <num>       <num>
#>  1: change_in_value variable2       1       A  2010 -0.56047565 -0.56047565
#>  2: change_in_value variable2       2       A  2011 -0.23017749 -0.23017749
#>  3: change_in_value variable2       3       A  2012  1.55870831  1.55870831
#>  4: change_in_value variable2       4       A  2013  0.07050839  0.07050839
#>  5: change_in_value variable2       5       A  2014  0.12928774  0.12928774
#>  6: change_in_value variable2       6       A  2015  1.71506499  1.71506499
#>  7: change_in_value variable2       7       A  2016  0.46091621  0.46091621
#>  8: change_in_value variable2       8       A  2017 -1.26506123 -1.26506123
#>  9: change_in_value variable2       9       B  2010 -0.68685285 -0.68685285
#> 10: change_in_value variable2      10       B  2011 -0.44566197 -0.44566197
#> 11: change_in_value variable2      11       B  2012  1.22408180  1.22408180
#> 12: change_in_value variable2      12       B  2013  0.35981383  0.35981383
#> 13: change_in_value variable2      13       B  2014  0.40077145  0.40077145
#> 14: change_in_value variable2      14       B  2015  0.11068272  0.11068272
#> 15: change_in_value variable2      15       B  2016 -0.55584113 -0.55584113
#> 16: change_in_value variable2      16       B  2017  1.78691314  1.78691314
#>     variable2.x variable2.y variable3.x variable3.y variable4.x variable4.y
#>           <num>       <num>       <num>       <num>       <num>       <num>
#>  1:   0.4978505 -1.07179123  0.89512566  0.89512566  0.77996512  0.77996512
#>  2:  -1.9666172  0.30352864  0.87813349  0.87813349 -0.08336907 -0.08336907
#>  3:   0.7013559  0.44820978  0.82158108  0.82158108  0.25331851  0.25331851
#>  4:  -0.4727914  0.05300423  0.68864025  0.68864025 -0.02854676 -0.02854676
#>  5:  -1.0678237  0.92226747  0.55391765  0.55391765 -0.04287046 -0.04287046
#>  6:  -0.2179749  2.05008469 -0.06191171 -0.06191171  1.36860228  1.36860228
#>  7:  -1.0260044 -0.49103117 -0.30596266 -0.30596266 -0.22577099 -0.22577099
#>  8:  -0.7288912 -2.30916888 -0.38047100 -0.38047100  1.51647060  1.51647060
#>  9:  -0.6250393  1.00573852 -0.69470698 -0.69470698 -1.54875280 -1.54875280
#> 10:  -1.6866933 -0.70920076 -0.20791728 -0.20791728  0.58461375  0.58461375
#> 11:   0.8377870 -0.68800862 -1.26539635 -1.26539635  0.12385424  0.12385424
#> 12:   0.1533731  1.02557137  2.16895597  2.16895597  0.21594157  0.21594157
#> 13:  -1.1381369 -0.28477301  1.20796200  1.20796200  0.37963948  0.37963948
#> 14:   1.2538149 -1.22071771 -1.12310858 -1.12310858 -0.50232345 -0.50232345
#> 15:   0.4264642  0.18130348 -0.40288484 -0.40288484 -0.33320738 -0.33320738
#> 16:  -0.2950715 -0.13889136 -0.46665535 -0.46665535 -1.01857538 -1.01857538

# 2. Standard report, with new data:
extract_diff_table(survey_data, survey_data_2, by=c('country', 'year'))
#>                diff  variable indexes country  year variable1.x variable1.y
#>              <char>    <fctr>  <char>  <char> <int>       <num>       <num>
#>  1: change_in_value variable2       1       A  2010 -0.56047565 -0.56047565
#>  2: change_in_value variable2       2       A  2011 -0.23017749 -0.23017749
#>  3: change_in_value variable2       3       A  2012  1.55870831  1.55870831
#>  4: change_in_value variable2       4       A  2013  0.07050839  0.07050839
#>  5: change_in_value variable2       5       A  2014  0.12928774  0.12928774
#>  6: change_in_value variable2       6       A  2015  1.71506499  1.71506499
#>  7: change_in_value variable2       7       A  2016  0.46091621  0.46091621
#>  8: change_in_value variable2       8       A  2017 -1.26506123 -1.26506123
#>  9: change_in_value variable2       9       B  2010 -0.68685285 -0.68685285
#> 10: change_in_value variable2      10       B  2011 -0.44566197 -0.44566197
#> 11: change_in_value variable2      11       B  2012  1.22408180  1.22408180
#> 12: change_in_value variable2      12       B  2013  0.35981383  0.35981383
#> 13: change_in_value variable2      13       B  2014  0.40077145  0.40077145
#> 14: change_in_value variable2      14       B  2015  0.11068272  0.11068272
#> 15: change_in_value variable2      15       B  2016 -0.55584113 -0.55584113
#> 16: change_in_value variable2      16       B  2017  1.78691314  1.78691314
#>     variable2.x variable2.y variable3.x variable3.y variable4.x variable4.y
#>           <num>       <num>       <num>       <num>       <num>       <num>
#>  1:   0.4978505 -1.07179123  0.89512566  0.89512566  0.77996512  0.77996512
#>  2:  -1.9666172  0.30352864  0.87813349  0.87813349 -0.08336907 -0.08336907
#>  3:   0.7013559  0.44820978  0.82158108  0.82158108  0.25331851  0.25331851
#>  4:  -0.4727914  0.05300423  0.68864025  0.68864025 -0.02854676 -0.02854676
#>  5:  -1.0678237  0.92226747  0.55391765  0.55391765 -0.04287046 -0.04287046
#>  6:  -0.2179749  2.05008469 -0.06191171 -0.06191171  1.36860228  1.36860228
#>  7:  -1.0260044 -0.49103117 -0.30596266 -0.30596266 -0.22577099 -0.22577099
#>  8:  -0.7288912 -2.30916888 -0.38047100 -0.38047100  1.51647060  1.51647060
#>  9:  -0.6250393  1.00573852 -0.69470698 -0.69470698 -1.54875280 -1.54875280
#> 10:  -1.6866933 -0.70920076 -0.20791728 -0.20791728  0.58461375  0.58461375
#> 11:   0.8377870 -0.68800862 -1.26539635 -1.26539635  0.12385424  0.12385424
#> 12:   0.1533731  1.02557137  2.16895597  2.16895597  0.21594157  0.21594157
#> 13:  -1.1381369 -0.28477301  1.20796200  1.20796200  0.37963948  0.37963948
#> 14:   1.2538149 -1.22071771 -1.12310858 -1.12310858 -0.50232345 -0.50232345
#> 15:   0.4264642  0.18130348 -0.40288484 -0.40288484 -0.33320738 -0.33320738
#> 16:  -0.2950715 -0.13889136 -0.46665535 -0.46665535 -1.01857538 -1.01857538

# 3. Toggle tolerance:
extract_diff_table(survey_data, survey_data_2, by=c('country', 'year'),
                    tolerance = 1e-5)
#>                diff  variable indexes country  year variable1.x variable1.y
#>              <char>    <fctr>  <char>  <char> <int>       <num>       <num>
#>  1: change_in_value variable2       1       A  2010 -0.56047565 -0.56047565
#>  2: change_in_value variable2       2       A  2011 -0.23017749 -0.23017749
#>  3: change_in_value variable2       3       A  2012  1.55870831  1.55870831
#>  4: change_in_value variable2       4       A  2013  0.07050839  0.07050839
#>  5: change_in_value variable2       5       A  2014  0.12928774  0.12928774
#>  6: change_in_value variable2       6       A  2015  1.71506499  1.71506499
#>  7: change_in_value variable2       7       A  2016  0.46091621  0.46091621
#>  8: change_in_value variable2       8       A  2017 -1.26506123 -1.26506123
#>  9: change_in_value variable2       9       B  2010 -0.68685285 -0.68685285
#> 10: change_in_value variable2      10       B  2011 -0.44566197 -0.44566197
#> 11: change_in_value variable2      11       B  2012  1.22408180  1.22408180
#> 12: change_in_value variable2      12       B  2013  0.35981383  0.35981383
#> 13: change_in_value variable2      13       B  2014  0.40077145  0.40077145
#> 14: change_in_value variable2      14       B  2015  0.11068272  0.11068272
#> 15: change_in_value variable2      15       B  2016 -0.55584113 -0.55584113
#> 16: change_in_value variable2      16       B  2017  1.78691314  1.78691314
#>     variable2.x variable2.y variable3.x variable3.y variable4.x variable4.y
#>           <num>       <num>       <num>       <num>       <num>       <num>
#>  1:   0.4978505 -1.07179123  0.89512566  0.89512566  0.77996512  0.77996512
#>  2:  -1.9666172  0.30352864  0.87813349  0.87813349 -0.08336907 -0.08336907
#>  3:   0.7013559  0.44820978  0.82158108  0.82158108  0.25331851  0.25331851
#>  4:  -0.4727914  0.05300423  0.68864025  0.68864025 -0.02854676 -0.02854676
#>  5:  -1.0678237  0.92226747  0.55391765  0.55391765 -0.04287046 -0.04287046
#>  6:  -0.2179749  2.05008469 -0.06191171 -0.06191171  1.36860228  1.36860228
#>  7:  -1.0260044 -0.49103117 -0.30596266 -0.30596266 -0.22577099 -0.22577099
#>  8:  -0.7288912 -2.30916888 -0.38047100 -0.38047100  1.51647060  1.51647060
#>  9:  -0.6250393  1.00573852 -0.69470698 -0.69470698 -1.54875280 -1.54875280
#> 10:  -1.6866933 -0.70920076 -0.20791728 -0.20791728  0.58461375  0.58461375
#> 11:   0.8377870 -0.68800862 -1.26539635 -1.26539635  0.12385424  0.12385424
#> 12:   0.1533731  1.02557137  2.16895597  2.16895597  0.21594157  0.21594157
#> 13:  -1.1381369 -0.28477301  1.20796200  1.20796200  0.37963948  0.37963948
#> 14:   1.2538149 -1.22071771 -1.12310858 -1.12310858 -0.50232345 -0.50232345
#> 15:   0.4264642  0.18130348 -0.40288484 -0.40288484 -0.33320738 -0.33320738
#> 16:  -0.2950715 -0.13889136 -0.46665535 -0.46665535 -1.01857538 -1.01857538
```
