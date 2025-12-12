# Print method for Myrror object.

Print method for Myrror object.

## Usage

``` r
# S3 method for class 'myrror'
print(x, ...)
```

## Arguments

- x:

  an object of class 'myrror_object'

- ...:

  additional arguments

## Value

Invisibly returns the myrror object `x`. Called for side effects
(printing comparison report to console).

## Examples

``` r
# Create example datasets
dfx <- data.frame(id = 1:5,
                  name = c("A", "B", "C", "D", "E"),
                  value = c(10, 20, 30, 40, 50))

dfy <- data.frame(id = 1:6,
                  name = c("A", "B", "C", "D", "E", "F"),
                  value = c(10, 20, 35, 40, 50, 60))

# Create a myrror object
library(myrror)
m <- myrror(dfx, dfy, by.x = "id", by.y = "id")

# Print the myrror object (happens automatically)
m
#> 
#> ── Myrror Report ───────────────────────────────────────────────────────────────
#> 
#> ── General Information: ──
#> 
#> dfx: dfx with 5 rows and 3 columns.
#> dfy: dfy with 6 rows and 3 columns.
#> keys: id.
#> 
#> ── Note: comparison is done for shared columns and rows. ──
#> 
#> ✔ Total shared columns (no keys): 2
#> ! Non-shared columns in dfx: 0 ()
#> ! Non-shared columns in dfy: 0 ()
#> 
#> ✔ Total shared rows: 5
#> ! Non-shared rows in dfx: 0.
#> ! Non-shared rows in dfy: 1.
#> 
#> ℹ Note: run `extract_diff_rows()` to extract the missing/new rows.
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
#>   variable change_in_value na_to_value value_to_na
#>   <fct>              <int>       <int>       <int>
#> 1 value                  1           0           0
#> 
#> 
#> 
#> ── Value comparison: ──
#> 
#> ! 1 shared column(s) have different value(s):
#> ℹ Note: Only first 5 rows shown for each variable.
#> 
#> ── "value" 
#>               diff indexes    id value.x value.y
#>             <char>  <char> <int>   <num>   <num>
#> 1: change_in_value       3     3      30      35
#> ...
#> 
#> ℹ Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
#> 
#> ✔ End of Myrror Report.

# Create object with different print settings
if (FALSE) { # \dontrun{
# With interactive mode disabled
m2 <- myrror(dfx, dfy, by.x = "id", by.y = "id", interactive = FALSE)
print(m2)

# Print without value comparison
m3 <- myrror(dfx, dfy, by.x = "id", by.y = "id",
             print = list(compare_values = FALSE))
print(m3)
} # }
```
