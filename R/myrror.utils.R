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
    cli::cli_abort("Input data frame(s) cannot be NULL.")
  }

  # Check if dfx or dfy are data frames,
  # if not, try to convert them if they are lists.
  if (!is.data.frame(df)) {
    if (is.list(df)) {
      tryCatch({
        df <- as.data.frame(df)
      }, error = function(e) {
        cli::cli_abort("df is a list but cannot be converted to a data frame.")
      })
    } else {
      cli::cli_abort("df must be a data frame or a convertible list.")
    }
  }

  # Check if dfx is empty
  if ((!is.null(df) && nrow(df) == 0)) {
    cli::cli_abort("Input data frame(s) cannot be empty.")
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
    cli::cli_abort("The 'by' argument must be a non-empty character vector.")
  }
  if (!is.null(by.x) && (!is.character(by.x) || length(by.x) == 0)) {
    cli::cli_abort("The 'by.x' argument must be a non-empty character vector.")
  }
  if (!is.null(by.y) && (!is.character(by.y) || length(by.y) == 0)) {
    cli::cli_abort("The 'by.y' argument must be a non-empty character vector.")
  }


  # Handle named vector for 'by'
  if (!is.null(by) && !is.null(names(by)) && any(nchar(names(by)) > 0)) {
    # Split the named 'by' into 'by.x' and 'by.y'
    by.x <- names(by)
    by.y <- as.character(by)
  } else if (!is.null(by)) {
    by.x <- by.y <- by
  }

 if (is.null(by.x) || is.null(by.y)) {
    if (is.null(by.x) && !is.null(by.y)) {
      cli::cli_abort("Argument by.x is NULL. If using by.y, by.x also needs to be specified.")
    }
    if (!is.null(by.x) && is.null(by.y)) {
      cli::cli_abort("Argument by.y is NULL. If using by.x, by.y also needs to be specified.")
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
# apply_tolerance <- function(names,
#                             tolerance) {
#   # Ensure tolerance is treated as a list for uniform processing
#   if (!is.null(tolerance)) {
#     if (is.character(tolerance)) {
#       tolerance <- as.list(tolerance)
#     }
#     cli::cli_alert_info('Applying tolerance parameters to dataset.')
#   }
#
#   # Apply tolerance settings to column names
#   for (tol in tolerance) {
#     if (tol == "no_underscore") {
#       names <- gsub("_", "", names, fixed = TRUE)
#     }
#     if (tol == "no_cap") {
#       names <- tolower(names)
#     }
#     if (tol == "no_whitespace") {
#       names <- gsub("\\s+", "", names, fixed = TRUE)
#     }
#   }
#
#   return(names)
#
# }


# 3.Prepare dataset for join  ----
#' Prepares dataset for join, internal function.
#' @param df data.frame or data.table
#' @param by character vector
#' @param factor_to_char logical
#'
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
    cli::cli_abort("'rn' present in colnames but it cannot be a column name.")
  }

  ## 2. Check for duplicate column names in both datasets
  if (length(unique(names(df))) != length(names(df))) {
    cli::cli_abort("Duplicate column names found in dataframe.")
    # Note: cli additions needed.
  }

  ## 3. Convert DataFrame to Data Table if it's not already.
  # We keep rownames ("rn") regardless.
  if (data.table::is.data.table(df)) {

    dt <- data.table::copy(df)
    dt <- df |>
          fmutate(rn = row.names(df),
                  row_index = 1:nrow(df))
  }

  else {
    dt <- copy(df)
    data.table::setDT(dt, keep.rownames = TRUE)
    dt <- dt |>
      fmutate(row_index = 1:nrow(dt))
    }

  ## N. Validate colnames (make.names) and replace if needed.
  # If we work in data.table we don't need to check names.
  # valid_col_names <- make.names(names(dt), unique = TRUE)
  #
  # if (!identical(names(dt), valid_col_names)) {
  #   setColnames(dt, valid_col_names)
  # }

  ## 4. Ensure the by keys are available in the column names
  if (!all(by %in% names(dt))) {
    cli::cli_abort("Specified by keys are not all present in the column names.")
  }

  df_name <- deparse(substitute(df))

  ## 5. Check that the keys provided identify the dataset correctly
  if (isFALSE(joyn::is_id(dt, by, verbose = FALSE))) {
    cli::cli_abort("The by keys provided ({.val {by}}) do not uniquely identify the dataset ({.val {df_name}})")
  }

  ## 6. Convert factors to characters
  if (isTRUE(factor_to_char)){

    # I wanted to implement it like so, but check() would not recognize across() as a  function
    #dt <- dt |>
      #fmutate(across(is.factor, as.character))

    # Get names of factor columns
    factor_cols <- names(dt)[sapply(dt, is.factor)]

    # Convert all factor columns to character
    dt[, (factor_cols) := lapply(.SD, as.character), .SDcols = factor_cols]

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
#' @param merged_data_report joined prepared_dfx and prepared_dfy
#' @param suffix_x suffix for dfx (default .x)
#' @param suffix_y suffix for dfy (default .y)
#'
#' @return paired_columns
#'
#'
#' @examples
#' # mo <- create_myrror_object(iris, iris_var1)
#' # pair_columns(mo$merged_data_report)
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
  common_base_names <- setdiff(intersect(base_names_x, base_names_y), c("row_index", "rn"))

  # Pair them up
  pairs <- data.table(
    col_x = paste0(common_base_names, suffix_x),
    col_y = paste0(common_base_names, suffix_y)
  )

  # Identify unmatched columns
  # Get set_by/keys
  get_keys_or_default <- function(keys, default = "rn") {
    if (is.null(keys)) {
      default
    } else {
      keys
    }
  }

  # Usage
  keys <- get_keys_or_default(merged_data_report$keys)

  nonshared_cols_dfx <- setdiff(c(merged_data_report$colnames_dfx),
                                c("row_index", "rn", base_names_x, keys))
  nonshared_cols_dfy <- setdiff(c(merged_data_report$colnames_dfy),
                                c("row_index", "rn", base_names_y, keys))


  # Return both pairs and unmatched columns in a list or separately as needed
  list(pairs = pairs,
       nonshared_cols_dfx = nonshared_cols_dfx,
       nonshared_cols_dfy = nonshared_cols_dfy)

}

# 5. Compare with tolerance ----
#' Are these two values equal with tolerance applied?
#'
#' @param x numeric
#' @param y numeric
#' @param tolerance numeric
#' @return logical
#'
equal_with_tolerance <- function(x, y, tolerance = 1e-7) {

  # check if x and y are numeric:
  if (is.numeric(x) & is.numeric(y)) {
    abs_diff <- abs(x - y)
    return(abs_diff <= tolerance)
  }

  # Else compare two non-numeric without tolerance:
  return(x == y)

}






#' Get correct myrror object
#'
#' @description It checks all the arguments parsed to parent function. If
#' `myrror_object` if found, then it will be used. If not, it checks if both
#' databases are NULL. If they are it looks for the the last myrror object. If
#' nothing available, then error. Finally, it checks for the availability of
#' both datasets. If they are available, then create `myrror_object`
#'
#' @inheritParams create_myrror_object
#' @param ... other arguments parsed to parent function.
#'
#' @return myrror object
#' @keywords internal
get_correct_myrror_object <- function(myrror_object,
                                      dfx,
                                      dfy,
                                      by,
                                      by.x,
                                      by.y,
                                      verbose,
                                      ...) {


  abort_msg <- "You need to provide a {.arg myrror_object}, or two datasets
                         ({.arg {c('dfx', 'dfy')}}). Alternatively, you need to execute
                         {.pkg myrror} properly at least once to make use of the last
                         {.field myrror} object saved in the myrror environment"

  if (is.null(myrror_object)) {
    if (is.null(dfx) && is.null(dfy)) {
      if (rlang::env_has(.myrror_env, "last_myrror_object")) {
        myrror_object <- rlang::env_get(.myrror_env, "last_myrror_object")
        if (verbose) {
          cli::cli_inform('Last myrror object used for comparison')
        }
      } else {
        cli::cli_abort(abort_msg)
      }
    } else if (!is.null(dfx) && !is.null(dfy)) {
      myrror_object <- create_myrror_object(dfx = dfx,
                                            dfy = dfy,
                                            by = by,
                                            by.x = by.x,
                                            by.y = by.y)
      ## Re-assign names from within this call:
      myrror_object$name_dfx <- deparse(substitute(dfx, env = parent.frame()))
      myrror_object$name_dfy <- deparse(substitute(dfy, env = parent.frame()))
    } else {
      cli::cli_abort(abort_msg)
    }
  }
  myrror_object
}
