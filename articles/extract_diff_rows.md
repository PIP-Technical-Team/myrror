# Extract Different Rows

This article looks a series of workflow for the function
[`extract_diff_rows()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_rows.md).

## Introduction

At its core, the function does the following:

1.  Sets up the two data frames (`dfx` and `dfy`) for comparison:
    - Pairs rows based on the keys provided (given by the user using the
      `by` , `by.x`, `by.y` arguments, or by row number).
    - Pairs columns based on the column names.
2.  Runs the comparison between shared rows and shared columns only.
3.  Returns the rows/observations that are missing from either `dfx` or
    `dfy`, with all variables from both datasets.

### ⚠️ No keys provided

Right now, [myrror](https://pip-technical-team.github.io/myrror/) does
not align rows based on row content. This means that if the user does
not provide keys, the function will compare the two datasets based on
row number only. This can lead to incorrect results
(`extract_diff_row()` will not return the correct rows) if:

- the datasets have different row orders.

- a detaset have duplicate rows.

- a dataset has new/missing rows.

Therefore, we suggest the user to **always provide keys** when running
the function.

## Example 1: missing rows in dfy.

In
[`extract_diff_rows()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_rows.md),
the default options for `output` is `simple`. This returns a data.table
with the rows that are missing or new. In this example, we will compare
the `survey_data` dataset with a modified version, `survey_data_4`:

``` r
output <- extract_diff_rows(survey_data, survey_data_4, by = c('country', 'year'), output = "simple")
print(output)
#>        df country  year variable1.x variable2.x variable3.x variable4.x
#>    <char>  <char> <int>       <num>       <num>       <num>       <num>
#> 1:    dfx       A  2010 -0.56047565   0.4978505   0.8951257  0.77996512
#> 2:    dfx       A  2011 -0.23017749  -1.9666172   0.8781335 -0.08336907
#> 3:    dfx       A  2012  1.55870831   0.7013559   0.8215811  0.25331851
#> 4:    dfx       A  2013  0.07050839  -0.4727914   0.6886403 -0.02854676
#>    variable1.y variable2.y variable3.y variable4.y     rn
#>          <num>       <num>       <num>       <num> <char>
#> 1:          NA          NA          NA          NA      1
#> 2:          NA          NA          NA          NA      2
#> 3:          NA          NA          NA          NA      3
#> 4:          NA          NA          NA          NA      4
```

The column `df` tells the user whether the row is part of `dfx` or
`dfy`. In this case, the rows are part of the `dfx` dataset, but are
missing from `dfy` (`survey_data`). So the column `df` shows the value
`dfx`.

If the user runs the function with `output = "full"`, the console will
print a user-friendly summary of the comparison, similar to the output
of
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md).
However, given that the output of
[`extract_diff_rows()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_rows.md)
is not part of the `myrror` object, the user will need to run
[`extract_diff_rows()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_rows.md)
separately to see the extracted rows.

``` r
# First run the function in full mode:
extract_diff_rows(survey_data, survey_data_4, by = c('country', 'year'), output = "full")
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: dfx with 16 rows and 6 columns.
#> dfy: dfy with 12 rows and 6 columns.
#> keys: country and year.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in dfx: 0 ()
#> ! Non-shared columns in dfy: 0 ()
#> 
#> ✔ Total shared rows: 12
#> ! Non-shared rows in dfx: 4.
#> ! Non-shared rows in dfy: 0.
#> 
#> ℹ Note: run `extract_diff_rows()` to extract the missing/new rows.
```

Following the suggestion in the note, the user can extract the results.
The advantage of extracting the results is that the user can further
explore or manipulate the data using additional packages or functions.
For example, here we extract the results and display them using
[`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html):

``` r
# Then extract the results and analyse them:
extract_diff_rows() |> 
    datatable(
  filter = 'top',
  rownames = FALSE,
  style = 'auto',
  options = list(
    searching = FALSE,
    paging = TRUE,
    scrollX = TRUE,
    autoWidth = TRUE,
    pageLength = 5
  )
)
#> Last myrror object used for comparison.
```

## Example 2: missing rows in dfx.

Similarly, if `dfx` is missing some rows, they will be extracted like
so:

``` r
output <- extract_diff_rows(survey_data_4, survey_data, by = c('country', 'year'), interactive = FALSE, output = "simple")
output |> 
    datatable(
  filter = 'top',
  rownames = FALSE,
  style = 'auto',
  options = list(
    searching = FALSE,
    paging = TRUE,
    scrollX = TRUE,
    autoWidth = TRUE,
    pageLength = 5
  )
)
```
