# Iris Dataset Variation 2

This dataset variation includes:

- NaN values in the `Sepal.Width` column.

- Random adjustments to `Sepal.Length` to create a range of different
  values.

- A shuffled order of rows to test comparison without reliance on row
  order.

## Usage

``` r
iris_var2
```

## Format

A data frame with 150 rows and 5 variables, row order shuffled:

- Sepal.Length:

  Numeric, Sepal length in cm, modified by adding random values.

- Sepal.Width:

  Numeric, Sepal width in cm, with some NaN values.

- Petal.Length:

  Numeric, Petal length in cm.

- Petal.Width:

  Numeric, Petal width in cm.

- Species:

  Factor with levels: "setosa","versicolor","virginica".

## Source

Modified `iris` dataset.

## Details

It is designed to test the handling of `NaN` values, comparison of
numeric differences, and insensitivity to row order.
