# Myrror Process Flow

``` r
library(myrror)
```

## With keys supplied

If keys (`by` or `by.x` and `by.y`) are supplied by the user,
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
will first check whether the keys uniquely identify the dataset:

### Identified

If the keys are supplied and they uniquely identify the dataset,
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
will proceed by joining the two datasets by the keys:

1.  **1:1** If the relationship between the two datasets is 1:1,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will proceed by comparing the values of each matched row.

``` r
myrror(survey_data, survey_data_3, by = c("country", "year"), interactive = FALSE)
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_3 with 16 rows and 6 columns.
#> keys: country and year.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_3: 0 ()
#> 
#> ✔ Total shared rows: 16
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_3: 0.
#> 
#> ✔ There are no missing or new rows.
#> 
#> ── 1. Shared Columns Class Comparison ──────────────────────────────────────────
#> 
#> ! 1 shared column(s) have different class(es):
#> 
#>     variable class_x   class_y
#>       <char>  <char>    <char>
#> 1: variable1 numeric character
#> 
#> ── 2. Shared Columns Values Comparison ─────────────────────────────────────────
#> 
#> ✔ All shared columns have the same values.
#> 
#> ✔ All shared columns have the same values.
#> 
#> ✔ End of Myrror Report.
```

2.  **m:1, 1:m** If the relationship between the two datasets is not 1:1
    (i.e. there are multiple rows in one dataset that match a single row
    in the other dataset),
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will ask the user whether they want to proceed. If the user chooses
    to proceed,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will join the two datasets by the keys and then compare the values
    of each matched row.

``` r
myrror(survey_data, survey_data_1m, by = c("country", "year"), interactive = FALSE)
#> ! The by keys provided ("country" and "year") do not uniquely identify the dataset (survey_data_1m).
#> ! Proceeding with the operation despite non-unique identification.
#> ! When comparing the data, the join is 1:m between survey_data and survey_data_1m.
#> 
#> ── Identification Report: ──
#> 
#> Only first 5 keys shown:
#> 
#>    country   year copies.dfx percent.dfx copies.dfy percent.dfy
#>     <char> <char>      <int>      <char>      <int>      <char>
#> 1:       A   2010          1        6.2%          3        8.3%
#> 2:       B   2010          1        6.2%          1        2.8%
#> 3:       A   2011          1        6.2%          2        5.6%
#> 4:       B   2011          1        6.2%          2        5.6%
#> 5:       A   2012          1        6.2%          2        5.6%
#> ...
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_1m with 36 rows and 6 columns.
#> keys: country and year.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 4
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_1m: 0 ()
#> 
#> ✔ Total shared rows: 36
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_1m: 0.
#> 
#> ✔ There are no missing or new rows.
#> 
#> ── 1. Shared Columns Class Comparison ──────────────────────────────────────────
#> 
#> ✔ All shared columns have the same class.
#> 
#> ── 2. Shared Columns Values Comparison ─────────────────────────────────────────
#> 
#> ! 3 shared column(s) have different value(s):
#> ℹ Note: character-numeric comparison is allowed.
#> 
#> ── Overview: ──
#> 
#>    variable change_in_value na_to_value value_to_na
#> 1 variable1              36           0           0
#> 2 variable2              36           0           0
#> 3 variable3              36           0           0
#> 
#> ── Value comparison: ──
#> 
#> ! 3 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "variable1"
#>               diff indexes country  year variable1.x variable1.y
#>             <char>  <char>  <char> <int>       <num>       <num>
#> 1: change_in_value       1       A  2010  -0.5604756  -0.4750861
#> 2: change_in_value       1       A  2010  -0.5604756  -0.4750861
#> 3: change_in_value       1       A  2010  -0.5604756  -0.4750861
#> 4: change_in_value       2       A  2011  -0.2301775  -0.1511585
#> 5: change_in_value       2       A  2011  -0.2301775  -0.1511585
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable2"
#>               diff indexes country  year variable2.x variable2.y
#>             <char>  <char>  <char> <int>       <num>       <num>
#> 1: change_in_value       1       A  2010   0.4978505   0.4889819
#> 2: change_in_value       1       A  2010   0.4978505   0.4889819
#> 3: change_in_value       1       A  2010   0.4978505   0.4889819
#> 4: change_in_value       2       A  2011  -1.9666172  -2.1479705
#> 5: change_in_value       2       A  2011  -1.9666172  -2.1479705
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable3"
#>               diff indexes country  year variable3.x variable3.y
#>             <char>  <char>  <char> <int>       <num>       <num>
#> 1: change_in_value       1       A  2010   0.8951257   0.9687451
#> 2: change_in_value       1       A  2010   0.8951257   0.9687451
#> 3: change_in_value       1       A  2010   0.8951257   0.9687451
#> 4: change_in_value       2       A  2011   0.8781335   1.1156799
#> 5: change_in_value       2       A  2011   0.8781335   1.1156799
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.
```

3.  **m:m** If the relationship between the two datasets is m:m,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will abort the comparison by default.

``` r
myrror(survey_data_1m_2, survey_data_1m, by = c("country", "year"), interactive = FALSE)
#> ! The by keys provided ("country" and "year") do not uniquely identify the dataset (survey_data_1m_2).
#> ! Proceeding with the operation despite non-unique identification.
#> ! The by keys provided ("country" and "year") do not uniquely identify the dataset (survey_data_1m).
#> ! Proceeding with the operation despite non-unique identification.
#> Error:
#> ✖ When comparing the datasets, the join is m:m between survey_data_1m_2
#>   and survey_data_1m.
#> ℹ The comparison will stop here.
```

### Non-Identified

If the keys are supplied but they do not uniquely identify the dataset,
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
will inform the user and ask whether they want to proceed:

1.  **proceed** If the user chooses to proceed,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will join the two datasets by the keys and then compare the values
    of each matched row.
    - **m:1, 1:m** As above, if the relationship between the two
      datasets is not 1:1,
      [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
      will ask the user whether they want to proceed. If the user
      chooses to proceed,
      [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
      will join the two datasets by the keys and then compare the values
      of each matched row.
    - **m:m** If the relationship between the two datasets is m:m,
      [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
      will abort the comparison.
2.  **not proceed** If the user chooses not to proceed,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will abort the comparison.

## Without keys supplied

Currently, [myrror](https://pip-technical-team.github.io/myrror/) does
not align rows based on row content
(e.g. [waldo](https://waldo.r-lib.org)). This means that if the user
does not provide keys, the function will compare the two datasets based
on row number only. As you might expect, this can lead to incorrect
result, especially if there are discrepancies in the number of rows.
This is why there are a series of warning which will make the user
consider whether or not it is sensible to proceed.

### Different Number of Rows

By default, if no keys are supplied, and there is a different number of
rows, the comparison will be aborted:

``` r
myrror(survey_data, survey_data_4, interactive = FALSE)
#> Error:
#> ✖ Different row numbers and no keys supplied.
#> ℹ The comparison will be aborted.
```

### Same Number of Rows

If no keys are supplied, there is the same number of rows, and the
dataset is identified (there are no duplicates):

#### Identified

1.  **Possible Keys Found** First,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will try to suggest two possible keys or combinations of keys. Then
    it will proceed combining the two dataset by row numbers.
2.  **No Keys Found** If no keys are found,
    [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
    will proceed combining the two dataset by row numbers.

``` r
myrror(survey_data, survey_data_2, interactive = FALSE)
#> ℹ No keys supplied, but possible keys found in both datasets.
#> ℹ Possible keys found in survey_data: variable1 and c("country", "year")
#> ℹ Possible keys found in survey_data_2: variable1 and c("country", "year")
#> ℹ Consider using these keys for the comparison. The comparison will go ahead using row numbers.
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_2 with 16 rows and 6 columns.
#> keys: rn.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 6
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
#> # A data frame: 1 × 4
#>   variable  change_in_value na_to_value value_to_na
#>   <fct>               <int>       <int>       <int>
#> 1 variable2              16           0           0
#> 
#> ── Value comparison: ──
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "variable2"
#>               diff indexes     rn variable2.x variable2.y
#>             <char>  <char> <char>       <num>       <num>
#> 1: change_in_value       1      1   0.4978505  -1.0717912
#> 2: change_in_value      10     10  -1.6866933  -0.7092008
#> 3: change_in_value      11     11   0.8377870  -0.6880086
#> 4: change_in_value      12     12   0.1533731   1.0255714
#> 5: change_in_value      13     13  -1.1381369  -0.2847730
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.
```

### Non-Identified

If no keys are supplied, there is the same number of rows, and the
dataset is not identified (there are duplicates),
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
will inform the user and ask whether they want to proceed, if the user
chooses to proceed,
[`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md)
will join the two datasets by row number.

``` r
row_to_duplicate <- sample(nrow(survey_data), 1)
survey_data_copy <- rbind(survey_data, survey_data[row_to_duplicate, ])
row_to_remove <- sample(setdiff(1:nrow(survey_data_copy), row_to_duplicate), 1)
survey_data_copy <- survey_data_copy[-row_to_remove, ]

myrror(survey_data, survey_data_copy, interactive = FALSE)
#> ! There are duplicates in the dataset (survey_data_copy).
#> ! Proceeding with the operation despite non-unique rows.
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_copy with 16 rows and 6 columns.
#> keys: rn.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 6
#> ! Non-shared columns in survey_data: 0 ()
#> ! Non-shared columns in survey_data_copy: 0 ()
#> 
#> ✔ Total shared rows: 16
#> ! Non-shared rows in survey_data: 0.
#> ! Non-shared rows in survey_data_copy: 0.
#> 
#> ✔ There are no missing or new rows.
#> 
#> ── 1. Shared Columns Class Comparison ──────────────────────────────────────────
#> 
#> ✔ All shared columns have the same class.
#> 
#> ── 2. Shared Columns Values Comparison ─────────────────────────────────────────
#> 
#> ! 6 shared column(s) have different value(s):
#> ℹ Note: character-numeric comparison is allowed.
#> 
#> ── Overview: ──
#> 
#> # A data frame: 6 × 4
#>   variable  change_in_value na_to_value value_to_na
#>   <fct>               <int>       <int>       <int>
#> 1 country                 1           0           0
#> 2 year                   10           0           0
#> 3 variable1              10           0           0
#> 4 variable2              10           0           0
#> 5 variable3              10           0           0
#> 6 variable4              10           0           0
#> 
#> ── Value comparison: ──
#> 
#> ! 6 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "country"
#>               diff indexes     rn country.x country.y
#>             <char>  <char> <char>    <char>    <char>
#> 1: change_in_value       8      8         A         B
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "year"
#>               diff indexes     rn year.x year.y
#>             <char>  <char> <char>  <int>  <int>
#> 1: change_in_value      10     10   2011   2012
#> 2: change_in_value      11     11   2012   2013
#> 3: change_in_value      12     12   2013   2014
#> 4: change_in_value      13     13   2014   2015
#> 5: change_in_value      14     14   2015   2016
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable1"
#>               diff indexes     rn variable1.x variable1.y
#>             <char>  <char> <char>       <num>       <num>
#> 1: change_in_value      10     10  -0.4456620   1.2240818
#> 2: change_in_value      11     11   1.2240818   0.3598138
#> 3: change_in_value      12     12   0.3598138   0.4007715
#> 4: change_in_value      13     13   0.4007715   0.1106827
#> 5: change_in_value      14     14   0.1106827  -0.5558411
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable2"
#>               diff indexes     rn variable2.x variable2.y
#>             <char>  <char> <char>       <num>       <num>
#> 1: change_in_value      10     10  -1.6866933   0.8377870
#> 2: change_in_value      11     11   0.8377870   0.1533731
#> 3: change_in_value      12     12   0.1533731  -1.1381369
#> 4: change_in_value      13     13  -1.1381369   1.2538149
#> 5: change_in_value      14     14   1.2538149   0.4264642
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable3"
#>               diff indexes     rn variable3.x variable3.y
#>             <char>  <char> <char>       <num>       <num>
#> 1: change_in_value      10     10  -0.2079173  -1.2653964
#> 2: change_in_value      11     11  -1.2653964   2.1689560
#> 3: change_in_value      12     12   2.1689560   1.2079620
#> 4: change_in_value      13     13   1.2079620  -1.1231086
#> 5: change_in_value      14     14  -1.1231086  -0.4028848
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ── "variable4"
#>               diff indexes     rn variable4.x variable4.y
#>             <char>  <char> <char>       <num>       <num>
#> 1: change_in_value      10     10   0.5846137   0.1238542
#> 2: change_in_value      11     11   0.1238542   0.2159416
#> 3: change_in_value      12     12   0.2159416   0.3796395
#> 4: change_in_value      13     13   0.3796395  -0.5023235
#> 5: change_in_value      14     14  -0.5023235  -0.3332074
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.
```
