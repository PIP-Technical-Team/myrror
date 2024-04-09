#' Iris Dataset Variation 1
#'
#' This dataset variation includes:
#' - Additional rows by duplicating the first 5 rows.
#' - A new column `Petal.Area` calculated from `Petal.Length` and `Petal.Width`.
#' - Introduction of NA values in `Sepal.Length`.
#'
#' It tests the handling of extended datasets, new calculated fields, and missing values.
#'
#' @format A `data.frame` with 155 rows and 6 variables:
#' \describe{
#'   \item{Sepal.Length}{Numeric, Sepal length in cm, with some NA values.}
#'   \item{Sepal.Width}{Numeric, Sepal width in cm.}
#'   \item{Petal.Length}{Numeric, Petal length in cm.}
#'   \item{Petal.Width}{Numeric, Petal width in cm.}
#'   \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#'   \item{Petal.Area}{Numeric, calculated as `Petal.Length * Petal.Width`.}
#' }
#' @source Modified `iris` dataset.
"iris_var1"




#' Iris Dataset Variation 2
#'
#' This dataset variation includes:
#' - NaN values in the `Sepal.Width` column.
#' - Random adjustments to `Sepal.Length` to create a range of different values.
#' - A shuffled order of rows to test comparison without reliance on row order.
#'
#' It is designed to test the handling of `NaN` values, comparison of numeric differences, and insensitivity to row order.
#'
#' @format A data frame with 150 rows and 5 variables, row order shuffled:
#' \describe{
#'   \item{Sepal.Length}{Numeric, Sepal length in cm, modified by adding random values.}
#'   \item{Sepal.Width}{Numeric, Sepal width in cm, with some NaN values.}
#'   \item{Petal.Length}{Numeric, Petal length in cm.}
#'   \item{Petal.Width}{Numeric, Petal width in cm.}
#'   \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#' }
#' @source Modified `iris` dataset.
"iris_var2"




#' Iris Dataset Variation 3
#'
#' This dataset variation includes:
#' - Column name changes (e.g., `Sepal.Length` to `SL`).
#' - Conversion of numeric to character type for the `Sepal.Length` (now `SL`) column.
#' - An NA value introduced into the `SL` column.
#'
#' This variation tests the package's ability to correctly identify and handle column renaming, type conversion, and missing values.
#'
#' @format A `data.frame` with 150 rows and 5 variables:
#' \describe{
#'   \item{SL}{Character, originally numeric, with one NA value.}
#'   \item{SW}{Numeric, Sepal width in cm.}
#'   \item{PL}{Numeric, Petal length in cm.}
#'   \item{PW}{Numeric, Petal width in cm.}
#'   \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#' }
#' @source Modified `iris` dataset.
"iris_var3"




#' Iris Dataset Variation 4
#'
#' This dataset variation includes:
#' - Uppercase transformation of `Species` factor levels.
#' - Duplicated rows (first 10 rows repeated).
#' - An altered scale for `Petal.Width` (values multiplied by 10).
#'
#' Designed to test handling of categorical variable level modifications, duplicate rows, and numeric scale adjustments.
#'
#' @format A `data.frame` with 160 rows and 5 variables:
#' \describe{
#'   \item{Sepal.Length}{Numeric, length in cm.}
#'   \item{Sepal.Width}{Numeric, width in cm.}
#'   \item{Petal.Length}{Numeric, length in cm.}
#'   \item{Petal.Width}{Numeric, width in cm, values scaled by a factor of 10.}
#'   \item{Species}{Factor with levels modified to uppercase: "SETOSA", "VERSICOLOR", "VIRGINICA".}
#' }
#'
#' @source Modified `iris` dataset.
"iris_var4"





