# Iris Dataset Variation 1

This dataset variation includes:

- Additional rows by duplicating the first 5 rows.

- A new column `Petal.Area` calculated from `Petal.Length` and
  `Petal.Width`.

- Introduction of NA values in `Sepal.Length`.

## Usage

``` r
iris_var1
```

## Format

A `data.frame` with 155 rows and 6 variables:

- Sepal.Length:

  Numeric, Sepal length in cm, with some NA values.

- Sepal.Width:

  Numeric, Sepal width in cm.

- Petal.Length:

  Numeric, Petal length in cm.

- Petal.Width:

  Numeric, Petal width in cm.

- Species:

  Factor with levels: "setosa","versicolor","virginica".

- Petal.Area:

  Numeric, calculated as `Petal.Length * Petal.Width`.

## Source

Modified `iris` dataset.

## Details

It tests the handling of extended datasets, new calculated fields, and
missing values.
