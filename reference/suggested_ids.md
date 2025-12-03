# Identify Suggested Keys or IDs for Data Frame

This function attempts to find potential unique identifier columns or
combinations for a given data frame. It first tries to identify
single-column keys, then two-column key combinations that uniquely
identify each row in the data frame.

## Usage

``` r
suggested_ids(df)
```

## Arguments

- df:

  A data frame for which to identify potential unique identifiers

## Value

A list containing up to two elements:

- 1:

  The first single-column key identified (if any)

- 2:

  The first two-column key combination identified (if any)

Returns NULL if no valid keys were found.
