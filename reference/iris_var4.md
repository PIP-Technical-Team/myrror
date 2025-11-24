# Iris Dataset Variation 4

This dataset variation includes:

- Uppercase transformation of `Species` factor levels.

- Duplicated rows (first 10 rows repeated).

- An altered scale for `Petal.Width` (values multiplied by 10).

## Usage

``` r
iris_var4
```

## Format

A `data.frame` with 160 rows and 5 variables:

- Sepal.Length:

  Numeric, length in cm.

- Sepal.Width:

  Numeric, width in cm.

- Petal.Length:

  Numeric, length in cm.

- Petal.Width:

  Numeric, width in cm, values scaled by a factor of 10.

- Species:

  Factor with levels modified to uppercase: "SETOSA", "VERSICOLOR",
  "VIRGINICA".

## Source

Modified `iris` dataset.

## Details

Designed to test handling of categorical variable level modifications,
duplicate rows, and numeric scale adjustments.
