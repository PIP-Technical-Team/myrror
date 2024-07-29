# myrror

A R package to compare data frames in R.

The main function is `myrror()`.

Auxiliary functions:

-   `compare_type()`: compares the type of shared columns.

-   `compare_values()`: compares the values of shared columns.

-   `extract_diff_values()`: extract the values that are different between two data frames, returns a list of data frames with the differences, one for each variable.

-   `extract_diff_table()`: extract the values that are different between two data frames, returns a data.table with all differences.
