# Functions used within myrror()


# 1. Normalize (column) names based on tolerance settings ----
#' Apply Tolerance to Column Names
#'
#' @param names character vector
#' @param tolerance character vector, options: 'no_cap', 'no_underscore', 'no_whitespace'
#'
#' @return a list of processed column names
#' @export
#'
#' @examples
#' processed_names <- apply_tolerance(names(iris), tolerance = 'no_cap')
apply_tolerance <- function(names, tolerance) {
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

# 2.Prepare dataset for alignment  ----
prepare_alignment <- function(df,
                              by,
                              factor_to_char = TRUE) {
  # Convert DataFrame to Data Table if it's not already
  data.table::setDT(df)

  # Validate and adjust column names to valid R identifiers
  valid_col_names <- make.names(names(df), unique = TRUE)
  if (!identical(names(df), valid_col_names)) {
    data.table::setnames(df, old = names(df), new = valid_col_names)
  }

  # Ensure the keys are available in the column names
  if (!all(by %in% names(df))) {
    stop("Specified keys are not all present in the column names.")
  }



  # Convert factors to characters
  if (isTRUE(factor_to_char)){
  factor_cols <- names(df)[sapply(df, is.factor)]
  df[, (factor_cols) := lapply(.SD, as.character), .SDcols = factor_cols]
  }
  return(df)
}
