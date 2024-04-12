# Functions used within myrror()


# 1. Normalize column names based on tolerance settings ----
#' Apply Tolerance to Column Names
#'
#' @param names character vector, column names to be processed
#' @param tolerance character vector, options: 'no_cap', 'no_underscore', 'no_whitespace'
#'
#' @return a list of processed column names
#' @export
#'
#' @examples
#' processed_names <- apply_tolerance_colnames(names(iris), tolerance = 'no_cap')
apply_tolerance_colnames <- function(names, tolerance) {
  # Ensure tolerance is treated as a list for uniform processing
  if (!is.null(tolerance)) {
    if (is.character(tolerance)) {
      tolerance <- as.list(tolerance)
    }
    cli::cli_alert_info('Applying tolerance parameters to dataset.')
  }

  # Apply tolerance settings to column names
  for (tol in tolerance) {
    if (tol == "no_underscore") {
      names <- gsub("_", "", names, fixed = TRUE)
    }
    if (tol == "no_cap") {
      names <- tolower(names)
    }
    if (tol == "no_whitespace") {
      names <- gsub("\\s+", "", names, fixed = TRUE)
    }
  }

  return(names)

}

# 2.
