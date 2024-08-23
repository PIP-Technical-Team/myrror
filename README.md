
<!-- README.md is generated from README.Rmd. Please edit that file -->

# myrror

<!-- badges: start -->

[![CRAN
checks](https://badges.cranchecks.info/summary/myrror.svg)](https://cran.r-project.org/web/checks/check_results_myrror.html)[![](https://www.r-pkg.org/badges/version/myrror?color=orange)](https://cran.r-project.org/package=myrror)
[![](https://img.shields.io/badge/devel%20version-0.0.0.9001-blue.svg)](https://github.com/giorgiacek/myrror)
[![](https://codecov.io/gh/giorgiacek/myrror/branch/main/graph/badge.svg)](https://app.codecov.io/gh/giorgiacek/myrror)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

A R package to compare data frames in R. The assumption is that the user
wants the two data frames to be the same. `myrror()` highlights the
differences between values. When there is no difference, the comparison
is “successful”.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("giorgiacek/myrror")
```

## Usage

The main function is `myrror()`, which goes through each single step of
the comparison:

``` r
library(myrror)
myrror(iris, iris_var1)
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: iris with 150 rows and 5 columns.
#> dfy: iris_var1 with 155 rows and 6 columns.
#> Keys: rn.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 5
#> ! Non-shared columns in iris: 0 ()
#> ! Non-shared columns in iris_var1: 1 (Petal.Area)
#> 
#> ✔ Total shared rows: 150
#> ! Non-shared rows in iris: 0.
#> ! Non-shared rows in iris_var1: 5.
#> 
#> ℹ Note: run `extract_diff_rows()` to extract the missing/new rows.
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
#> # A tibble: 1 × 4
#>   variable     change_in_value na_to_value value_to_na
#>   <fct>                  <int>       <int>       <int>
#> 1 Sepal.Length               0           0           5
#> 
#> ── Value comparison: ──
#> 
#> ! 1 shared column(s) have different value(s):
#> 
#> ── Sepal.Length
#>           diff indexes     rn Sepal.Length.x Sepal.Length.y
#>         <char>  <char> <char>          <num>          <num>
#> 1: value_to_na     104    104            6.3             NA
#> 2: value_to_na     125    125            6.7             NA
#> 3: value_to_na      67     67            5.6             NA
#> 4: value_to_na      80     80            5.7             NA
#> 5: value_to_na      96     96            5.7             NA
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.
```

## Auxiliary functions

The auxiliary functions go through a specific step of the comparison,
and can be used independently:

- `compare_type()`: compares the type of shared columns.

- `compare_values()`: compares the values of shared columns.

- `extract_diff_values()`: extract the values that are different between
  two data frames, returns a list of data frames with the differences,
  one for each variable.

- `extract_diff_table()`: extract the values that are different between
  two data frames, returns a data.table with all differences.

See more in the [Get
started](https://giocek.github.io/myrror/articles/myrror.html) vignette.
