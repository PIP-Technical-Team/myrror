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


#' Iris Dataset Variation 5
#'
#' This dataset variation includes:
#' - Column with different type: `Sepal.Length` (character).
#' - Column with different values: `Sepal.Length` (1 modified value).
#'
#' @format A `data.frame` with 160 rows and 5 variables:
#' \describe{
#'   \item{Sepal.Length}{Charactert, length in cm.}
#'   \item{Sepal.Width}{Numeric, width in cm.}
#'   \item{Petal.Length}{Numeric, length in cm.}
#'   \item{Petal.Width}{Numeric, Petal width in cm.}
#'   \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#' }
#'
#' @source Modified `iris` dataset.
"iris_var5"

#' Iris Dataset Variation 6
#' @format A `data.frame` with 146 rows and 5 variables:
#' \describe{
#' \item{Sepal.Length}{Numeric, Sepal length in cm.}
#' \item{Sepal.Width}{Numeric, Sepal width in cm.}
#' \item{Petal.Length}{Numeric, Petal length in cm.}
#' \item{Petal.Width}{Numeric, Petal width in cm.}
#' \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#' }
#'
#' @source Modified `iris` dataset.
"iris_var6"

#' Iris Dataset Variation 7
#' @format A `data.frame` with 146 rows and 5 variables:
#' \describe{
#' \item{Sepal.Length}{Numeric, Sepal length in cm.}
#' \item{Sepal.Width}{Numeric, Sepal width in cm.}
#' \item{Petal.Length}{Numeric, Petal length in cm.}
#' \item{Petal.Width}{Numeric, Petal width in cm.}
#' \item{Species}{Factor with levels: "setosa","versicolor","virginica".}
#' }
#'
#' @source Modified `iris` dataset.
"iris_var7"

#' Survey Data
#' A country-year level dataset with 15 rows and 6 variables. 2 countries,
#' 4 years, and 4 additional variables.
#' @format A `data.table` with 16 rows and 4 variables:
#' \describe{
#'  \item{country}{Factor with levels: "A", "B".}
#'  \item{year}{Numeric, with values: 2010, 2011, 2012, 2013.}
#'  \item{variable1}{Numeric.}
#'  \item{variable2}{Numeric.}
#'  \item{variable3}{Numeric.}
#'  \item{variable4}{Numeric.}
#'  }
#'  @source Simulated data.
"survey_data"

#' Survey Data Variation 2
#' @format A `data.table` with 15 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010, 2011, 2012, 2013.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric. Modified variable values.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_2"

#' Survey Data Variation 2 with Cap Keys
#' @format A `data.table` with 15 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010, 2011, 2012, 2013.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric. Modified variable values.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_2_cap"

#' Survey Data Variation 3
#' @format A `data.table` with 15 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Character. Modified variable class.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_3"

#' Survey Data Variation 4
#' @format A `data.table` with 12 rows (4 missing) and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_4"

#' Survey Data Variation 5
#' @format A `data.table` with 15 rows and 4 variables (2 missing):
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_5"

#' Survey Data Variation 6
#' @format A `data.table` with 15+15 (duplicated) rows and 4 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Simulated data.
"survey_data_6"

#' Survey Data 1:m Variation 1
#' @format A `data.table` with 36 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Variation of `survey_data` with non-unique ids and a 1:m relationship between ids and values.
"survey_data_1m"


#' Survey Data 1:m Variation 2
#' @format A `data.table` with 36 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Variation of `survey_data` with non-unique ids and a 1:m relationship between ids and values.
"survey_data_1m_2"

#' Survey Data m:1
#' @format A `data.table` with 15 rows and 6 variables:
#' \describe{
#' \item{country}{Factor with levels: "A", "B".}
#' \item{year}{Numeric, with values: 2010-2017.}
#' \item{variable1}{Numeric.}
#' \item{variable2}{Numeric.}
#' \item{variable3}{Numeric.}
#' \item{variable4}{Numeric.}
#' }
#' @source Variation of `survey_data` with non-unique ids and a m:1 relationship between ids and values.
"survey_data_m1"








