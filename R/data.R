#' Iris Dataset Variation 1
#'
#' This variation of the Iris dataset includes additional rows, a new column named `Petal.Area`
#' calculated as the product of `Petal.Length` and `Petal.Width`, and introduces `NA` values into the
#' `Sepal.Length` column. It tests the handling of extended datasets, new calculated fields, and missing values.
#'
#' @format A data frame with 155 rows and 6 variables:
#' \describe{
#'   \item{SL}{Numeric Sepal length in cm, with some NA values.}
#'   \item{SW}{Numeric Sepal width in cm.}
#'   \item{PL}{Numeric Petal length in cm.}
#'   \item{PW}{Numeric Petal width in cm.}
#'   \item{Species}{Factor w/ 3 levels "setosa","versicolor","virginica"}
#'   \item{Petal.Area}{Numeric calculated as Petal.Length * Petal.Width.}
#' }
#' @source Modified iris dataset.
"iris_var1"




#' Iris Dataset Variation 2
#'
#' This variation introduces `NaN` values into the `Sepal.Width` column, adds random values to
#' `Sepal.Length` to create different numeric values, and shuffles the row order. It is designed to test
#' the handling of `NaN` values, comparison of numeric differences, and insensitivity to row order.
#'
#' @format A data frame with 150 rows and 5 variables, row order shuffled:
#' \describe{
#'   \item{Sepal.Length}{Numeric Sepal length in cm, modified by adding random values.}
#'   \item{Sepal.Width}{Numeric Sepal width in cm, with some NaN values.}
#'   \item{Petal.Length}{Numeric Petal length in cm.}
#'   \item{Petal.Width}{Numeric Petal width in cm.}
#'   \item{Species}{Factor w/ 3 levels "setosa","versicolor","virginica"}
#' }
#' @source Modified iris dataset with randomized alterations.
"iris_var2"




#' Iris Dataset Variation 3
#'
#' This dataset variation tests column name changes, type conversion from numeric to character,
#' and the introduction of a missing value. The `Sepal.Length` column is renamed to `SL` and converted to
#' character type, with one NA value introduced. It assesses the package's ability to handle column renaming,
#' type mismatches, and missing data.
#'
#' @format A data frame with 150 rows and 5 variables:
#' \describe{
#'   \item{SL}{Character Sepal length in cm, originally numeric, with one NA value.}
#'   \item{SW}{Mixed types. Numeric Sepal width > 3.5, otherwise "Wide".}
#'   \item{PL}{Numeric Petal length in cm.}
#'   \item{PW}{Numeric Petal width in cm.}
#'   \item{Species}{Factor w/ 3 levels "setosa","versicolor","virginica"}
#' }
#' @source Modified iris dataset with column renaming and type conversion.
"iris_var3"




#' Iris Dataset Variation 4
#'
#' Incorporates modified factor levels, duplicated rows, and an altered scale for `Petal.Width`.
#' Factor levels for `Species` are converted to uppercase, rows 1-10 are duplicated, and `Petal.Width`
#' values are multiplied by 10. This variation tests handling of factor level changes, duplicate rows,
#' and numeric scale adjustments.
#'
#' @format A data frame with 160 rows and 5 variables:
#' \describe{
#'   \item{Sepal.Length}{Numeric Sepal length in cm.}
#'   \item{Sepal.Width}{Numeric Sepal width in cm.}
#'   \item{Petal.Length}{Numeric Petal length in cm.}
#'   \item{Petal.Width}{Numeric Petal width in cm, values scaled by a factor of 10.}
#'   \item{Species}{Factor w/ 3 levels "SETOSA","VERSICOLOR","VIRGINICA"}
#' }
#' @source Modified iris dataset with factor level modifications and data duplication.
"iris_var4"





