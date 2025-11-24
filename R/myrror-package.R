#' myrror: Compare Data Frames
#'
#' `myrror` provides tools for comparing data frames, identifying differences,
#' and extracting summary tables or lists of differences.
#'
#' @docType package
#' @name myrror
#' @keywords internal
#' @references https://pip-technical-team.github.io/myrror/
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @rawNamespace import(collapse, except = fdroplevels)
#' @rawNamespace import(data.table, except = fdroplevels)
## usethis namespace: end
.datatable.aware = TRUE


# Global Variables ----
if (getRversion() >= "2.15.1") {
  utils::globalVariables(
    names = c(
      "variable",
      "column_x",
      "column_y",
      "class_x",
      "class_y",
      "same_class",
      ".joyn",
      "count",
      "rn",
      "rn.x",
      "rn.y",
      "row_index.x",
      "row_index.y",
      "row_index",
      "indexes",
      "equal",
      "N.dfx",
      "N.dfy",
      ".",
      "df",
      "..vars",
      "..combo",
      "percent",
      "..byvar",
      "n"# not sure why feeling this might be an issue
    ),
    package = utils::packageName()
  )


}


NULL
