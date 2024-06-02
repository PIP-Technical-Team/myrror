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
    collapse::setColnames(df, valid_col_names)
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

# 3. Sorting utils ----
is.sorted <- function(x, ...) {
  !is.unsorted(x, ...) | !is.unsorted(rev(x), ...)
}

detect_sorting <- function(data){
  sorted <- lapply(data, is.sorted)
  names(which(unlist(sorted) == TRUE))
}

# 4. Variable comparison utils ----
process_fselect_col_pairs <- function(df, suffix_x = ".x", suffix_y = ".y") {
  cols_x <- names(df)[grepl(suffix_x, names(df))]
  cols_y <- names(df)[grepl(suffix_y, names(df))]

  base_names_x <- sub(suffix_x, "", cols_x)
  base_names_y <- sub(suffix_y, "", cols_y)

  common_base_names <- intersect(base_names_x, base_names_y)

  paired_columns <- Map(function(x, y) c(x, y),
                        paste0(common_base_names, suffix_x),
                        paste0(common_base_names, suffix_y))

  comparisons <- lapply(paired_columns, function(cols) {
    col_x = fselect(df, cols[1])
    col_y = fselect(df, cols[2])
    idx_x = fselect(df, "row_index.x")
    idx_y = fselect(df, "row_index.y")

    compare_column_values(col_x[[1]], col_y[[1]], idx_x[[1]], idx_y[[1]])
  })

  names(comparisons) <- common_base_names

  return(comparisons)
}

compare_column_values <- function(col_x, col_y,
                                  idx_x, idx_y) {

  result <- list()

  # 4.1 Is it the same type?
  result$same_class <- class(col_x) == class(col_y)

  # 4.2. N of new observations in given variable: in x but not in y (deleted), in y but not in x (added).
  result$deleted_from_x = length(setdiff(col_x, col_y))
  result$added_to_y = length(setdiff(col_y, col_x))

  # 4.3 Different value: NA to value, value != value, value to NA.
  na_to_value_indices = which(is.na(col_x) & !is.na(col_y))
  value_to_na_indices = which(!is.na(col_x) & is.na(col_y))
  value_changes_indices = which(!is.na(col_x) & !is.na(col_y) & col_x != col_y)

  result$na_to_value = length(na_to_value_indices)
  result$value_to_na = length(value_to_na_indices)
  result$value_changes = length(value_changes_indices)
  result$na_to_value_row_indexes = idx_x[na_to_value_indices]
  result$value_to_na_row_indexes = idx_x[value_to_na_indices]
  result$value_changes_row_indexes_x = idx_x[value_changes_indices]
  result$value_changes_row_indexes_y = idx_y[value_changes_indices]

  return(result)
}
