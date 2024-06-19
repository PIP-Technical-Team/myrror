# Functions used within myrror()

# 1. Arguments Checks Utils ----
## 1.1 dfx dfy ----
#' Check if the df arguments are valid,
#' makes them into a data.frame if they are a list.
#' @param df data frame
#' @export
#' @examples
#' check_df(iris)
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
#' @export
#' @examples
#'
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
  return(list(by = by,
              by.x = by.x,
              by.y = by.y))
}



# 2. Normalize (column) names based on tolerance settings ----
#' Apply Tolerance to Column Names
#'
#' @param names character vector
#' @param tolerance character vector, options: 'no_cap', 'no_underscore', 'no_whitespace'
#'
#' @return a list of processed column names
#' @export
#' @importFrom data.table copy
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
#' Prepares dataset for join, internal function.
#' @param df data.frame or data.table
#' @param by character vector
#' @param factor_to_char logical
#'
#' @import collapse
#' @export
#' @examples
#' dataset <- data.frame(a = 1:10, b = letters[1:10])
#' prepare_df(dataset, by = "a")
#'
prepare_df <- function(df,
                       by = NULL,
                       factor_to_char = TRUE) {

  ## 1. Check that "rn" is not in the colnames
  if ("rn" %in% colnames(df)) {
    stop("'rn' present in colnames but it cannot be a column name.")
  }

  ## 2. Check for duplicate column names in both datasets
  if (length(unique(names(df))) != length(names(df))) {
    stop("Duplicate column names found in dataframe.")
    # Note: cli additions needed.
  }

  ## 3. Convert DataFrame to Data Table if it's not already.
  # We keep rownames ("rn") regardless.
  if (data.table::is.data.table(df)) {

    dt <- data.table::copy(df)
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

  ## 4. Ensure the by keys are available in the column names
  if (!all(by %in% names(dt))) {
    stop("Specified by keys are not all present in the column names.")
  }

  df_name <- deparse(substitute(df))

  ## 5. Check that the keys provided identify the dataset correctly
  if (isFALSE(joyn::is_id(dt, by, verbose = FALSE))) {
    cli::cli_abort("The by keys provided ({.val {by}}) do not uniquely identify the dataset ({.val {df_name}})")
  }

  ## 6. Convert factors to characters
  if (isTRUE(factor_to_char)){
    dt <- dt |>
      collapse::fmutate(acr(is.factor, as.character))
  }

  return(dt)
}

# 4. Sorting utils ----
## 4.1 Is it sorted? ----
#' Check if a vector is sorted
#' @param x vector
#' @param ... additional arguments of is.sorted()
#' @return logical
#' @export
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
#' @return list
#' @export
#' @examples
#' detect_sorting(iris)
#'
detect_sorting <- function(data) {
  sorted <- lapply(data, is.sorted)
  sort_variable <- names(which(unlist(sorted) == TRUE))

  if (length(sort_variable) == 0) {
    return("not sorted")
  } else {
    return(sort_variable)
  }
}

## 4.3 Detect sorting in a data frame ----
#' Detect sorting in a data frame
#' @param df data.frame
#' @param by character vector
#' @param decreasing logical
#' @return list
#' @export
#' @examples
#' is_dataframe_sorted_by(iris, by = "Sepal.Length")
#'
is_dataframe_sorted_by <- function(df,
                                   by = NULL,
                                   decreasing = FALSE) {

  if (identical(by, "rn")) {

    other_sort <- detect_sorting(df)
    return(list("not sorted by key", other_sort))

  } else {


    # Generate the order indices using do.call to pass each by to order()
    order_indices <- do.call(order, lapply(by, function(col) df[[col]]))

    # Check if the order indices match the original row indices
    is_sorted_by <- identical(order_indices, seq_len(nrow(df)))


    if (all(by != "rn") & is_sorted_by) {

      return(list("sorted by key", by))

    } else {

      other_sort <- detect_sorting(df)
      return(list("not sorted by key", other_sort))
    }

  }


}




# 4. Variable comparison utils ----
## 4.2 Process col pairs ----
#' Title
#'
#' @param merged_data joined prepared_dfx and prepared_dfy
#' @param suffix_x
#' @param suffix_y
#'
#' @return paired_columns
#'
#'
#' @examples
pair_columns <- function(merged_data_report,
                         suffix_x = ".x",
                         suffix_y = ".y") {

  # Clean up the column names from the suffix
  # Get suffixes
  cols_x <- names(merged_data_report$matched_data)[grepl(suffix_x, names(merged_data_report$matched_data), fixed = TRUE)]
  cols_y <- names(merged_data_report$matched_data)[grepl(suffix_y, names(merged_data_report$matched_data), fixed = TRUE)]

  # Get names without suffix
  base_names_x <- gsub(suffix_x, "", cols_x, fixed = TRUE)
  base_names_y <- gsub(suffix_y, "", cols_y, fixed = TRUE)


  # Get common base names
  common_base_names <- setdiff(intersect(base_names_x, base_names_y), "row_index")

  # Pair them up
  pairs <- data.table(
    col_x = paste0(common_base_names, suffix_x),
    col_y = paste0(common_base_names, suffix_y)
  )

  # Identify unmatched columns

  nonshared_cols_dfx <- setdiff(c(merged_data_report$colnames_dfx), c("row_index", "rn", base_names_x))
  nonshared_cols_dfy <- setdiff(c(merged_data_report$colnames_dfy), c("row_index", "rn", base_names_y))


  # Return both pairs and unmatched columns in a list or separately as needed
  list(pairs = pairs,
       nonshared_cols_dfx = nonshared_cols_dfx,
       nonshared_cols_dfy = nonshared_cols_dfy)

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
