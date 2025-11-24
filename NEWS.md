# myrror 0.1.0

Initial release of `myrror`, a package for comparing data frames.

## Main Features
* `myrror()` - Compare two data frames and identify differences.
* Interactive console output for easy inspection of differences.
* Handles various key relationships between data frames (e.g., primary/foreign keys).

## Auxiliary Functions
* `compare_type()` - Compare the types of shared columns between data frames.
* `compare_values()` - Compare the values of shared columns.
* `extract_diff_values()` - Extract differing values, returning a list of data frames.
* `extract_diff_table()` - Extract differing values, returning a single consolidated data frame.
