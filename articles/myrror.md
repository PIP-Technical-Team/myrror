# myrror

``` r
library(myrror)
```

## Overview

[myrror](https://pip-technical-team.github.io/myrror/) is a package that
helps you compare two data frames.

It has three types of functions:

1.  **Complete comparison**:
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md),
    the “workhorse” function which will go through a complete comparison
    of two datastes.

2.  **Partial comparison**:

    - [`compare_type()`](https://PIP-Technical-Team.github.io/myrror/reference/compare_type.md):
      Compares the types of the columns in the two data frames.

    - [`compare_values()`](https://PIP-Technical-Team.github.io/myrror/reference/compare_values.md):
      Compares the values of the columns in the two data frames.

3.  **Extract differences**: two functions which allow you to access the
    rows that differ in values between the two data frames.

    - [`extract_diff_values()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_values.md):
      Returns the differences in a list format, one table per variable.

    - [`extract_diff_table()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_table.md):
      Returns the differences in a table format, all variables.

For all of this functions, the results will be displayed interactively
in the console. ALternatively, the user has the option to return the
results as an object to use in further analysis.

## Workflow Example 1

One use case of the package is to check whether two versions of the same
dataset have any discrepancies. If so, the objective of `myrror` is to
help the user to quickly identify which variables, values or
observations are different.

In this example, we will compare one simulated dataset `survey_data`
with a second version, `survey_data_2`. Each row is uniquely identified
by two variables, `country` and `year`:

``` r
survey_data
#>     country  year   variable1  variable2   variable3   variable4
#>      <char> <int>       <num>      <num>       <num>       <num>
#>  1:       A  2010 -0.56047565  0.4978505  0.89512566  0.77996512
#>  2:       A  2011 -0.23017749 -1.9666172  0.87813349 -0.08336907
#>  3:       A  2012  1.55870831  0.7013559  0.82158108  0.25331851
#>  4:       A  2013  0.07050839 -0.4727914  0.68864025 -0.02854676
#>  5:       A  2014  0.12928774 -1.0678237  0.55391765 -0.04287046
#>  6:       A  2015  1.71506499 -0.2179749 -0.06191171  1.36860228
#>  7:       A  2016  0.46091621 -1.0260044 -0.30596266 -0.22577099
#>  8:       A  2017 -1.26506123 -0.7288912 -0.38047100  1.51647060
#>  9:       B  2010 -0.68685285 -0.6250393 -0.69470698 -1.54875280
#> 10:       B  2011 -0.44566197 -1.6866933 -0.20791728  0.58461375
#> 11:       B  2012  1.22408180  0.8377870 -1.26539635  0.12385424
#> 12:       B  2013  0.35981383  0.1533731  2.16895597  0.21594157
#> 13:       B  2014  0.40077145 -1.1381369  1.20796200  0.37963948
#> 14:       B  2015  0.11068272  1.2538149 -1.12310858 -0.50232345
#> 15:       B  2016 -0.55584113  0.4264642 -0.40288484 -0.33320738
#> 16:       B  2017  1.78691314 -0.2950715 -0.46665535 -1.01857538
```

The second dataset is just a variation of the first one:

``` r
survey_data_2
#>     country  year   variable1   variable2   variable3   variable4
#>      <char> <int>       <num>       <num>       <num>       <num>
#>  1:       A  2010 -0.56047565 -1.07179123  0.89512566  0.77996512
#>  2:       A  2011 -0.23017749  0.30352864  0.87813349 -0.08336907
#>  3:       A  2012  1.55870831  0.44820978  0.82158108  0.25331851
#>  4:       A  2013  0.07050839  0.05300423  0.68864025 -0.02854676
#>  5:       A  2014  0.12928774  0.92226747  0.55391765 -0.04287046
#>  6:       A  2015  1.71506499  2.05008469 -0.06191171  1.36860228
#>  7:       A  2016  0.46091621 -0.49103117 -0.30596266 -0.22577099
#>  8:       A  2017 -1.26506123 -2.30916888 -0.38047100  1.51647060
#>  9:       B  2010 -0.68685285  1.00573852 -0.69470698 -1.54875280
#> 10:       B  2011 -0.44566197 -0.70920076 -0.20791728  0.58461375
#> 11:       B  2012  1.22408180 -0.68800862 -1.26539635  0.12385424
#> 12:       B  2013  0.35981383  1.02557137  2.16895597  0.21594157
#> 13:       B  2014  0.40077145 -0.28477301  1.20796200  0.37963948
#> 14:       B  2015  0.11068272 -1.22071771 -1.12310858 -0.50232345
#> 15:       B  2016 -0.55584113  0.18130348 -0.40288484 -0.33320738
#> 16:       B  2017  1.78691314 -0.13889136 -0.46665535 -1.01857538
```

And it clearly has different values in `variable2`:

``` r
all.equal(survey_data, survey_data_2)
#> [1] "Column 'variable2': Mean relative difference: 1.506422"
```

[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
helps the user diagnosing this difference. To get a complete report of
the differences between `survey_data` and `survey_data_2` the user can
run:

``` r
myrror(survey_data, survey_data_2, 
       by = c("country", "year")) 
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
#> ── 2. Shared Columns Values Comparison ─────────────────────────────────────────
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: character-numeric comparison is allowed.
#> 
#> ── Overview: ──
#> 
#>    variable change_in_value na_to_value value_to_na
#> 1 variable2              16           0           0
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

By setting the `by` argument, the user can specify the unique keys that
identify each row. This is useful when the user wants to compare two
datasets that have the same structure but different order or number of
rows.

Once the user identifies the differences, they can use the
[`extract_diff_values()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_values.md)
function to extract the rows that differ in values between the two data
frames:

``` r
extract_diff_values()
#> Last myrror object used for comparison.
#> $variable2
#>                diff indexes country  year variable2.x variable2.y
#>              <char>  <char>  <char> <int>       <num>       <num>
#>  1: change_in_value       1       A  2010   0.4978505 -1.07179123
#>  2: change_in_value       2       A  2011  -1.9666172  0.30352864
#>  3: change_in_value       3       A  2012   0.7013559  0.44820978
#>  4: change_in_value       4       A  2013  -0.4727914  0.05300423
#>  5: change_in_value       5       A  2014  -1.0678237  0.92226747
#>  6: change_in_value       6       A  2015  -0.2179749  2.05008469
#>  7: change_in_value       7       A  2016  -1.0260044 -0.49103117
#>  8: change_in_value       8       A  2017  -0.7288912 -2.30916888
#>  9: change_in_value       9       B  2010  -0.6250393  1.00573852
#> 10: change_in_value      10       B  2011  -1.6866933 -0.70920076
#> 11: change_in_value      11       B  2012   0.8377870 -0.68800862
#> 12: change_in_value      12       B  2013   0.1533731  1.02557137
#> 13: change_in_value      13       B  2014  -1.1381369 -0.28477301
#> 14: change_in_value      14       B  2015   1.2538149 -1.22071771
#> 15: change_in_value      15       B  2016   0.4264642  0.18130348
#> 16: change_in_value      16       B  2017  -0.2950715 -0.13889136
```

The function
[`extract_diff_values()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_values.md)
operates on the comparison object created by
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
and stored in the environment. If the user wants to extract the
differences from a different comparison, one can simply re-run
[`extract_diff_values()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_values.md)
with the appropriate arguments, for example:

``` r
extract_diff_values(survey_data, survey_data_2, 
                    by = c("country", "year"))
#> $variable2
#>                diff indexes country  year variable2.x variable2.y
#>              <char>  <char>  <char> <int>       <num>       <num>
#>  1: change_in_value       1       A  2010   0.4978505 -1.07179123
#>  2: change_in_value       2       A  2011  -1.9666172  0.30352864
#>  3: change_in_value       3       A  2012   0.7013559  0.44820978
#>  4: change_in_value       4       A  2013  -0.4727914  0.05300423
#>  5: change_in_value       5       A  2014  -1.0678237  0.92226747
#>  6: change_in_value       6       A  2015  -0.2179749  2.05008469
#>  7: change_in_value       7       A  2016  -1.0260044 -0.49103117
#>  8: change_in_value       8       A  2017  -0.7288912 -2.30916888
#>  9: change_in_value       9       B  2010  -0.6250393  1.00573852
#> 10: change_in_value      10       B  2011  -1.6866933 -0.70920076
#> 11: change_in_value      11       B  2012   0.8377870 -0.68800862
#> 12: change_in_value      12       B  2013   0.1533731  1.02557137
#> 13: change_in_value      13       B  2014  -1.1381369 -0.28477301
#> 14: change_in_value      14       B  2015   1.2538149 -1.22071771
#> 15: change_in_value      15       B  2016   0.4264642  0.18130348
#> 16: change_in_value      16       B  2017  -0.2950715 -0.13889136
```

## Workflow Example 2

Again, we want to compare two datasets: `survey_data` and
`survey_data_4`:

``` r
all.equal(survey_data, survey_data_4)
#> [1] "Different number of rows"
```

These two datasets have a different number of rows.
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
can help by identifying the different number of rows, while also
providing a complete report of the differences between the two datasets.

The user can then extract the rows missing from one of the two datasets:

``` r
extract_diff_rows(survey_data, survey_data_4, 
                  by=c("country", "year"))
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
