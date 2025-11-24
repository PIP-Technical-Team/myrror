# Iris Dataset Variation 3

This dataset variation includes:

- Column name changes (e.g., `Sepal.Length` to `SL`).

- Conversion of numeric to character type for the `Sepal.Length` (now
  `SL`) column.

- An NA value introduced into the `SL` column.

## Usage

``` r
iris_var3
```

## Format

A `data.frame` with 150 rows and 5 variables:

- SL:

  Character, originally numeric, with one NA value.

- SW:

  Numeric, Sepal width in cm.

- PL:

  Numeric, Petal length in cm.

- PW:

  Numeric, Petal width in cm.

- Species:

  Factor with levels: "setosa","versicolor","virginica".

## Source

Modified `iris` dataset.

## Details

This variation tests the package's ability to correctly identify and
handle column renaming, type conversion, and missing values.
