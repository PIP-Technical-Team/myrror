# myrror: Compare Data Frames

`myrror` provides tools for comparing data frames, identifying
differences, and extracting summary tables or lists of differences.

## Usage

``` r
myrror(
  dfx,
  dfy,
  by = NULL,
  by.x = NULL,
  by.y = NULL,
  compare_type = TRUE,
  compare_values = TRUE,
  extract_diff_values = TRUE,
  factor_to_char = TRUE,
  interactive = getOption("myrror.interactive"),
  verbose = getOption("myrror.verbose"),
  tolerance = getOption("myrror.tolerance")
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

- compare_type:

  TRUE or FALSE, default to TRUE.

- compare_values:

  TRUE or FALSE, default to TRUE.

- extract_diff_values:

  TRUE or FALSE, default to TRUE.

- factor_to_char:

  TRUE or FALSE, default to TRUE.

- interactive:

  logical: If `TRUE`, print S3 method for myrror objects displays by
  chunks. If `FALSE`, everything will be printed at once.

- verbose:

  logical: If `TRUE`, print messages.

- tolerance:

  numeric, default to 1e-7.

## Value

Object of class "myrror" containing:

- `name_dfx`, `name_dfy`: Names of input data frames

- `prepared_dfx`, `prepared_dfy`: Prepared versions of input data frames

- `set_by.x`, `set_by.y`: Keys used for comparison

- `datasets_report`: Characteristics of input datasets (rows, columns)

- `match_type`: Type of join relationship ("1:1", "1:m", "m:1")

- `merged_data_report`: Information about matched and unmatched data

- `pairs`: Column pairing information

- `compare_type`: Results from type comparison (if enabled)

- `compare_values`: Results from value comparison (if enabled)

- `extract_diff_values`: Extracted differences (if enabled)

- `interactive`: Whether interactive mode is enabled

Returns `NULL` invisibly if the two datasets are identical.

## References

https://pip-technical-team.github.io/myrror/

## See also

Useful links:

- <https://pip-technical-team.github.io/myrror/>

- <https://github.com/PIP-Technical-Team/myrror>

- Report bugs at <https://github.com/PIP-Technical-Team/myrror/issues>

## Author

**Maintainer**: R.Andres Castaneda <acastanedaa@worldbank.org>

Authors:

- Giorgia Cecchinato <gcecchinato@worldbank.org>

- Rossana Tatulli <rtatulli@worldbank.org>

Other contributors:

- Global Poverty and Inequality Data Team World Bank \[copyright
  holder\]

## Examples

``` r

# 1. Specifying by, by.x or by.y:
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

## These are equivalent:
myrror(survey_data, survey_data_2_cap, by.x=c('country', 'year'), by.y = c('COUNTRY', 'YEAR'))
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_2_cap with 16 rows and 6 columns.
#> keys dfx: country and year.
#> keys dfy: COUNTRY and YEAR.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_2_cap: 0 ()
#> 
#> ✔ Total shared rows: 16
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_2_cap: 0.
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
myrror(survey_data, survey_data_2_cap, by=c('country' = 'COUNTRY', 'year' = 'YEAR'))
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_2_cap with 16 rows and 6 columns.
#> keys dfx: country and year.
#> keys dfy: COUNTRY and YEAR.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_2_cap: 0 ()
#> 
#> ✔ Total shared rows: 16
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_2_cap: 0.
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

# 2. Turn off interactivity:
myrror(survey_data, survey_data_2, by=c('country', 'year'), interactive = FALSE)
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

# 3. Turn off factor_to_char (it will treat factors as factors):
myrror(survey_data, survey_data_2, by=c('country', 'year'), factor_to_char = FALSE)
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

# 4. Turn off compare_type:
myrror(survey_data, survey_data_2, by=c('country', 'year'), compare_type = FALSE)
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
## Same can be done for compare_values and extract_diff_values.

# 5. Set tolerance:
myrror(survey_data, survey_data_2, by=c('country', 'year'), tolerance = 1e-5)
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
```
