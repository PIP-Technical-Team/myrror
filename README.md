
<!-- README.md is generated from README.Rmd. Please edit that file -->

# myrror

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/myrror?color=orange)](https://cran.r-project.org/package=myrror)
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
devtools::install_github("PIP-Technical-Team/myrror")
```

## Usage

The main function is `myrror()`, which goes through each single step of
the comparison:

``` r
library(myrror)
myrror(survey_data, survey_data_all, by = c('country' = "COUNTRY", "year" = "YEAR"),
       interactive = FALSE)
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: survey_data with 16 rows and 6 columns.
#> dfy: survey_data_all with 12 rows and 5 columns.
#> keys dfx: country and year.
#> keys dfy: COUNTRY and YEAR.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 3
#> ! Non-shared columns in survey_data: 1 ("variable3")
#> ! Non-shared columns in survey_data_all: 0 ()
#> 
#> ✔ Total shared rows: 12
#> ! Non-shared rows in survey_data: 4.
#> ! Non-shared rows in survey_data_all: 0.
#> 
#> ℹ Note: run `extract_diff_rows()` to extract the missing/new rows.
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
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: character-numeric comparison is allowed.
#> 
#> ── Overview: ──
#> 
#> # A tibble: 1 × 4
#>   variable  change_in_value na_to_value value_to_na
#>   <fct>               <int>       <int>       <int>
#> 1 variable2              12           0           0
#> 
#> ── Value comparison: ──
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "variable2"
#>               diff indexes country  year variable2.x variable2.y
#>             <char>  <char>  <char> <int>       <num>       <num>
#> 1: change_in_value       5       A  2014  -1.0678237   0.9222675
#> 2: change_in_value       6       A  2015  -0.2179749   2.0500847
#> 3: change_in_value       7       A  2016  -1.0260044  -0.4910312
#> 4: change_in_value       8       A  2017  -0.7288912  -2.3091689
#> 5: change_in_value       9       B  2010  -0.6250393   1.0057385
#> ...
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
started](https://PIP-Technical-team.github.io/myrror/articles/myrror.html)
vignette.
