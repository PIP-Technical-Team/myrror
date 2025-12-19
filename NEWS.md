# myrror 0.1.2

CRAN resubmission with vignette build fix:

* Fixed vignette build failure caused by undefined variables in `print.myrror()` (#CRAN-6)
* Added missing variable assignments (`name_dfx <- x$name_dfx`, `name_dfy <- x$name_dfy`) to ensure variables are in scope when used in `cli::cli_text()` calls
* Removed duplicate line assignments in `print.myrror()` function

# myrror 0.1.1

CRAN resubmission with requested fixes:

* Added missing `\value` documentation to `print.myrror()` (#CRAN-1)
* Exported `create_myrror_object()` function; `pair_columns()` remains internal (not exported) (#CRAN-2)
* Replaced `\dontrun{}` with `\donttest{}` in examples and regenerated documentation with `devtools::document()` (#CRAN-3)
* Uncommented all examples and made them executable (#CRAN-4)
* Fixed examples that referenced unexported functions (#CRAN-5)
* **Second resubmission fix:** Properly regenerated `.Rd` files after source edits using roxygen2

# myrror 0.1.0

Initial release of `myrror`, a package for comparing data frames in R.

## Main Features

* `myrror()` - Comprehensive comparison of two data frames with interactive reporting
* Support for multiple join types (1:1, 1:m, m:1) with user warnings and control
* Configurable tolerance for numeric comparisons
* Automatic identification of potential key variables
* Interactive console output with option for non-interactive mode
* Package-specific environment for storing comparison objects

## Comparison Functions

* `compare_type()` - Compare the types of shared columns between data frames
* `compare_values()` - Compare the values of shared columns with tolerance support

## Extraction Functions

* `extract_diff_values()` - Extract differing values, returning a list of data frames (one per variable)
* `extract_diff_table()` - Extract differing values, returning a single consolidated data frame
* `extract_diff_rows()` - Extract rows that exist in only one of the two data frames

## Documentation

* Comprehensive vignettes demonstrating package workflows
* Detailed function documentation with runnable examples
* pkgdown website available at <https://pip-technical-team.github.io/myrror/>

## Internal Improvements

* Robust error handling and input validation
* Efficient data.table-based operations for performance
* S3 print methods for user-friendly myrror object display
* Helper functions for column pairing and join type detection
