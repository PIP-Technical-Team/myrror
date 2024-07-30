# myrror
<!-- badges: start -->
  [![R-CMD-check](https://github.com/giorgiacek/myrror/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/giorgiacek/myrror/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->



A R package to compare data frames in R.

The main function is `myrror()`.

``` r
library(myrror)
myrror(iris, iris_var1)

```

## Installation

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("giocek/myrror")
```

## Auxiliary functions:

-   `compare_type()`: compares the type of shared columns.

-   `compare_values()`: compares the values of shared columns.

-   `extract_diff_values()`: extract the values that are different between two data frames, returns a list of data frames with the differences, one for each variable.

-   `extract_diff_table()`: extract the values that are different between two data frames, returns a data.table with all differences.
