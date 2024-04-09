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


