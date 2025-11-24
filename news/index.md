# Changelog

## myrror 0.1.0

Initial release of `myrror`, a package for comparing data frames.

### Main Features

- [`myrror()`](https://PIP-Technical-Team.github.io/myrror/reference/myrror.md) -
  Compare two data frames and identify differences.
- Interactive console output for easy inspection of differences.
- Handles various key relationships between data frames (e.g.,
  primary/foreign keys).

### Auxiliary Functions

- [`compare_type()`](https://PIP-Technical-Team.github.io/myrror/reference/compare_type.md) -
  Compare the types of shared columns between data frames.
- [`compare_values()`](https://PIP-Technical-Team.github.io/myrror/reference/compare_values.md) -
  Compare the values of shared columns.
- [`extract_diff_values()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_values.md) -
  Extract differing values, returning a list of data frames.
- [`extract_diff_table()`](https://PIP-Technical-Team.github.io/myrror/reference/extract_diff_table.md) -
  Extract differing values, returning a single consolidated data frame.
