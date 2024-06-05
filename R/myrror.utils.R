# Functions used within myrror()

# 1. Arguments Checks Utils ----
## 1.1 dfx dfy ----
#' Check if the df arguments are valid,
#' makes them into a data.frame if they are a list.
#' @param dfx data frame
#'
#' @examples
#' check_dfs(iris, iris_var_v1)
#'
check_df <- function(df) {
  # Check if dfx or dfy are NULL
  if (is.null(df)) {
    stop("Input data frame(s) cannot be NULL.")
  }

  # Check if dfx or dfy are data frames,
  # if not, try to convert them if they are lists.
  if (!is.data.frame(df)) {
    if (is.list(df)) {
      tryCatch({
        df <- as.data.frame(df)
      }, error = function(e) {
        stop("df is a list but cannot be converted to a data frame.")
      })
    } else {
      stop("df must be a data frame or a convertible list.")
    }
  }

  # Check if dfx is empty
  if ((!is.null(df) && nrow(df) == 0)) {
    stop("Input data frame(s) cannot be empty.")
  }

  return(df)

}

## 1.2 by.y by.x ----
#' Check if the df arguments are valid,
#' makes them into a data.frame if they are a list.
#' @param by character vector
#' @param by.x character vector
#' @param by.y character vector
#'
#' @examples
#' check_set_by(NULL, NULL, "id") # error
#' check_set_by(NULL, NULL, NULL) # rn set
#' check_set_by("id", NULL, NULL) # by set
#' check_set_by(NULL, "id", "id") # by.x and by.y set
#'
check_set_by <- function(by = NULL,
                         by.x = NULL,
                         by.y = NULL){

  # Validate inputs are non-empty character vectors if provided
  if (!is.null(by) && (!is.character(by) || length(by) == 0)) {
    stop("The 'by' argument must be a non-empty character vector.")
  }
  if (!is.null(by.x) && (!is.character(by.x) || length(by.x) == 0)) {
    stop("The 'by.x' argument must be a non-empty character vector.")
  }
  if (!is.null(by.y) && (!is.character(by.y) || length(by.y) == 0)) {
    stop("The 'by.y' argument must be a non-empty character vector.")
  }


  # Check and set by.x and by.y based on the presence of by
  if (!is.null(by)) {

    by.x <- by.y <- by

  } else if (is.null(by.x) || is.null(by.y)) {
    if (is.null(by.x) && !is.null(by.y)) {
      stop("Argument by.x is NULL. If using by.y, by.x also needs to be specified.")
    }
    if (!is.null(by.x) && is.null(by.y)) {
      stop("Argument by.y is NULL. If using by.x, by.y also needs to be specified.")
    }
    # Set defaults if both are NULL
    by.x <- by.y <- "rn"
  }

  # Return the possibly modified by variables
  return(list(by = by, by.x = by.x, by.y = by.y))
}



# 2. Normalize (column) names based on tolerance settings ----
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
apply_tolerance <- function(names,
                            tolerance) {
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


# 3.Prepare dataset for join  ----
#' Prepares dataset for join
#' @param df data.frame or data.table
#' @param by character vector
#' @param factor_to_char logical
#'
#' @examples
#' prepare_df(iris_var1, by = NULL) # adds "rn" variable
#'
prepare_df <- function(df,
                       by,
                       factor_to_char = TRUE) {

  ## 1. Check that "rn" is not in the colnames
  if ("rn" %in% colnames(df)) {
    stop("'rn' present in colnames but it cannot be a column name.")
  }

  ## 2. Convert DataFrame to Data Table if it's not already.
  # We keep rownames ("rn") regardless.
  if (data.table::is.data.table(df)) {

    dt <- copy(df)
    dt <- df |>
          collapse::fmutate(rn = row.names(df),
                  row_index = 1:nrow(df))
  }

  else {
    dt <- copy(df)
    data.table::setDT(dt, keep.rownames = TRUE)
    dt <- dt |>
      collapse::fmutate(row_index = 1:nrow(dt))
    }

  ## N. Validate colnames (make.names) and replace if needed.
  # If we work in data.table we don't need to check names.
  # valid_col_names <- make.names(names(dt), unique = TRUE)
  #
  # if (!identical(names(dt), valid_col_names)) {
  #   collapse::setColnames(dt, valid_col_names)
  # }

  ## 3. Ensure the by keys are available in the column names
  if (!all(by %in% names(dt))) {
    stop("Specified by keys are not all present in the column names.")
  }

  ## 4. Check for duplicate column names in both datasets
  if (length(unique(names(dt))) != length(names(dt))) {
    stop("Duplicate column names found in dataframe.")
    # Note: cli additions needed.
  }

  ## 5. Convert factors to characters
  if (isTRUE(factor_to_char)){
    dt <- dt |>
      collapse::fmutate(across(is.factor, as.character))
  }

  return(dt)
}

# 4. Sorting utils ----
## 4.1 Is it sorted? ----
#' Check if a vector is sorted
#' @param x vector
#' @param ... additional arguments of is.sorted()
#' @return logical
#'
#' @examples
#' is.sorted(iris$Sepal.Length)
#'
is.sorted <- function(x, ...) {
  # Note: I used the ellipsis to pass the options of is.unsorted(.).
  !is.unsorted(x, ...) | !is.unsorted(rev(x), ...)
}

## 4.2 Detect sorting ----
#' Detect sorting in a data frame
#' @param data data.frame
#' @return character vector
#'
#' @examples
#' detect_sorting(iris)
#'
detect_sorting <- function(data) {
  sorted <- lapply(data, is.sorted)
  names(which(unlist(sorted) == TRUE))
}

# 4. Variable comparison utils ----
## 4.2 Process col pairs ----
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
    col_x <- fselect(df, cols[1])
    col_y <- fselect(df, cols[2])
    idx_x <- fselect(df, "row_index.x")
    idx_y <- fselect(df, "row_index.y")

    compare_column_values(col_x[[1]], col_y[[1]], idx_x[[1]], idx_y[[1]])
  })

  names(comparisons) <- common_base_names

  return(comparisons)
}


## 4.3 Compare col values ----
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
