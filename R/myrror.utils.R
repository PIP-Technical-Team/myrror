# Functions used within myrror()

# 1. Arguments Checks Utils ----
## 1.1 dfx dfy ----
#' Check if the df arguments are valid,
#' makes them into a data.frame if they are a list. Internal function.
#'
#' @param df data frame
#'
#' @keywords internal
check_df <- function(df) {

  # retrieve names
  df_name <- attr(df, "df_name")

  # Check if dfx or dfy are data frames,
  # if not, try to convert them if they are lists.
  if (!is.data.frame(df)) {
    if (is.list(df)) {
      tryCatch({
        df <- as.data.frame(df)
      }, error = function(e) {
        cli::cli_abort(c(x = "{.field {df_name}} is a list, but cannot be converted to a data frame.",
                         i = "Please supply a data frame or a convertible list."),
                       call = NULL)
      })
    } else {
      cli::cli_abort(c(x = "You supplied a NULL or non-allowed object.",
                       i = "Please supply a data frame or a convertible list."),
                     call = NULL)
    }
  }

  # Check if dfx is empty
  if ((!is.null(df) && nrow(df) == 0)) {
    cli::cli_abort(c(x = "You supplied an empty data frame.",
                     i = "Please supply a non-empty data frame or a convertible list"),
                   call = NULL)
  }

  return(df)

  }


## 1.2 by.y by.x ----
#' Check if the by arguments are valid,
#' makes them into a data.frame if they are a list. Internal function.
#'
#' @param by character vector
#' @param by.x character vector
#' @param by.y character vector
#'
#' @examples
#'
#' #check_set_by(NULL, NULL, NULL) # rn set
#' #check_set_by("id", NULL, NULL) # by set
#' #check_set_by(NULL, "id", "id") # by.x and by.y set
#'
#' @keywords internal
check_set_by <- function(by = NULL,
                         by.x = NULL,
                         by.y = NULL){

  # Validate inputs are non-empty character vectors if provided
  if (!is.null(by) && (!is.character(by) || length(by) == 0)) {
    cli::cli_abort(c(x = "The 'by' argument is empty",
                     i = "The 'by' argument must be a non-empty character vector."),
                   call = NULL)
  }
  if (!is.null(by.x) && (!is.character(by.x) || length(by.x) == 0)) {
    cli::cli_abort(c(x = "The 'by.x' argument is empty",
                     i = "The 'by.x' argument must be a non-empty character vector."),
                   call = NULL)
  }
  if (!is.null(by.y) && (!is.character(by.y) || length(by.y) == 0)) {
    cli::cli_abort(c(x = "The 'by.y' argument is empty",
                     i = "The 'by.y' argument must be a non-empty character vector."),
                   call = NULL)
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
      cli::cli_abort(c(x = "Argument by.x is NULL.",
                       i = "If using by.y, by.x also needs to be specified."),
                     call = NULL)
    }
    if (!is.null(by.x) && is.null(by.y)) {
      cli::cli_abort(c(x = "Argument by.y is NULL.",
                       i = "If using by.x, by.y also needs to be specified."),
                     call = NULL)
    }
    # Set defaults if both are NULL
    by.x <- by.y <- "rn"
  }

  # Return the possibly modified by variables
  return(list(by = by,
              by.x = by.x,
              by.y = by.y))
}



# 3.Prepare dataset for joyn  ----
#' Prepares dataset for joyn::joyn(). Internal function.
#'
#' @param df data.frame or data.table
#' @param by character vector
#' @param factor_to_char logical
#' @param interactive logical
#' @param verbose logical
#'
#' @examples
#' # dataset <- data.frame(a = 1:10, b = letters[1:10])
#' # prepare_df(dataset, by = "a")
#'
#' @keywords internal
prepare_df <- function(df,
                       by = NULL,
                       factor_to_char = TRUE,
                       interactive = getOption("myrror.interactive"),
                       verbose = getOption("myrror.verbose")) {

  ## 1. Check that "rn" is not in the colnames
  if ("rn" %in% colnames(df)) {
    cli::cli_abort(c(x ="'rn' present in colnames but it cannot be a column name."),
                   call = NULL)
  }

  ## 2. Check for duplicate column names in both datasets
  if (length(unique(names(df))) != length(names(df))) {
    cli::cli_abort(c(x = "Duplicate column names found in dataframe."),
                   call = NULL)
    # Note: cli additions needed.
  }

  ## 3. Check that keys supplied are not the total number of columns
  if (length(by) == ncol(df)) {
    cli::cli_abort(c(x = "The by keys cannot be the only columns to compare."),
                   call = NULL)
  }

  ## 4. Convert DataFrame to Data Table if it's not already.
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



  ## 4. Ensure the by keys are available in the column names
  if (!all(by %in% names(dt))) {
    cli::cli_abort(c(x ="Specified by keys are not all present in the column names."),
                   call = NULL)
  }


  ## 5. Check that the keys provided identify the dataset correctly
  ### 5.1 Get name
  df_name <- attr(df, "df_name")


  ## 5.2 Check uniqueness of rows when  by == 'rn'
  if ('rn' %in% by){
    all_columns_no_rn <- setdiff(names(dt), c("rn", "row_index"))


    copies <- joyn::is_id(dt,
                          by = all_columns_no_rn,
                          verbose = FALSE,
                          return_report = TRUE)|>
      fsubset(copies > 1 & percent != "100%")


    if (nrow(copies) >= 1) {
      if (verbose) {
        cli::cli_alert_warning("There are duplicates in the dataset ({.field {df_name}}).")
      }

      if (interactive) {
        proceed <- my_menu(c("Yes, continue.", "No, abort."),
                               title = "Do you want to proceed?")
        if (proceed == 2) {
          cli::cli_abort("Operation aborted by the user.", call = NULL)
        }
      } else {
        if (verbose) {
          cli::cli_alert_warning("Proceeding with the operation despite non-unique rows.")
        }
      }
    }
  }

  ### 5.3 Check uniqueness of rows by key (by = key) (does not turn on when by = 'rn')
  if (isFALSE(joyn::is_id(dt, by, verbose = FALSE))) {
    if (verbose) {
      cli::cli_alert_warning("The by keys provided ({.val {by}}) do not uniquely identify the dataset ({.field {df_name}}).")
    }

    if (interactive) {
      proceed <- my_menu(c("Yes, continue.", "No, abort."),
                             title = "The by keys do not uniquely identify the dataset. Do you want to proceed?")
      if (proceed == 2) {
        cli::cli_abort("Operation aborted by the user.",
                       call = NULL)
      }
    } else {
      if (verbose) {
        cli::cli_alert_warning("Proceeding with the operation despite non-unique identification.")
      }
    }
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


# 4. Variable comparison utils ----
## 4.2 Process col pairs ----
#' Pairs columns and prepares them for comparison.
#'
#' @param merged_data_report joined prepared_dfx and prepared_dfy.
#' @param suffix_x suffix for dfx (default .x)
#' @param suffix_y suffix for dfy (default .y)
#'
#' @return paired_columns
#'
#' @examples
#' # mo <- create_myrror_object(iris, iris_var1)
#' # pair_columns(mo$merged_data_report)
#'
#' @keywords internal
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

# 5. Get keys or default ----
#' Get keys or default. A simple function wrapper which returns 'rn' (row names)
#' if the data.table has no keys.
#'
#' @param keys character vector
#' @param default character
#'
#' @return character
#'
#' @keywords internal
get_keys_or_default <- function(keys, default = "rn") {
  if (is.null(keys)) {
    default
  } else {
    keys
  }
}

# 6. Compare with tolerance ----
#' Are these two values equal with tolerance applied? This function is used to
#' apply tolerance to the comparison of two numeric values.
#'
#' @param x numeric
#' @param y numeric
#' @param tolerance numeric
#'
#' @return logical
#'
#' @keywords internal
equal_with_tolerance <- function(x, y, tolerance = 1e-7) {

  # check if x and y are numeric:
  if (is.numeric(x) & is.numeric(y)) {
    abs_diff <- abs(x - y)
    return(abs_diff <= tolerance)
  }

  # Else compare two non-numeric without tolerance:
  return(x == y)

}





# 7. Get correct myrror object ----
#' Get correct myrror object. Internal function.
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
#'
#' @keywords internal
get_correct_myrror_object <- function(myrror_object,
                                      dfx,
                                      dfy,
                                      by,
                                      by.x,
                                      by.y,
                                      verbose,
                                      interactive,
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
          cli::cli_inform('Last myrror object used for comparison.')
        }
      } else {
        cli::cli_abort(abort_msg,
                       call = NULL)
      }
    } else if (!is.null(dfx) && !is.null(dfy)) {
      myrror_object <- create_myrror_object(dfx = dfx,
                                            dfy = dfy,
                                            by = by,
                                            by.x = by.x,
                                            by.y = by.y,
                                            verbose = verbose,
                                            interactive = interactive)

    } else {
      cli::cli_abort(abort_msg,
                     call = NULL)
    }
  }
  myrror_object
}

# 8. Clear last myrror object ----
#' Clear last myrror object. Internal Function.
#'
#' @description This function unbinds the last myrror object from the package-specific
#' environment, effectively removing it.
#'
#' @return Invisible `NULL`, indicating the object was successfully cleared.
#' @export
#'
#' @examples
#' # myrror(iris, iris_var1, interactive = FALSE) # Run myrror to create myrror object.
#' # clear_last_myrror_object()  # Clear the environment
#' # rlang::env_has(.myrror_env, "last_myrror_object") # should return an error
#'
#' @keywords internal
clear_last_myrror_object <- function() {
  if (rlang::env_has(.myrror_env, "last_myrror_object")) {
    rlang::env_unbind(.myrror_env, "last_myrror_object")
  }
  invisible(NULL)
}





# 9. Check join type ----
#' Check join type. Internal function.
#'
#' @description This function checks the join type between two data frames. Internal function.
#' It returns the type of match between the two data frames ("1:1", "1:m", "m:1", "m:m"),
#' and the identified and non-identified rows.
#'
#' @param dfx data.frame
#' @param dfy data.frame
#' @param by.x character vector, keys for by.y.
#' @param by.y character vector, keys for by.x.
#' @param return_match logical, default is FALSE.
#'
#' @return character/list depending on return_match FALSE/TRUE.
#'
#' @keywords internal
check_join_type <- function(dfx,
                            dfy,
                            by.x,
                            by.y,
                            return_match = FALSE) {

  # Step 1: Count the number of occurrences of each key combination in both datasets
  count_dfx <-
    dfx |>
    collapse::fgroup_by(by.x) |>
    fcount()

  count_dfy <-
    dfy |>
    collapse::fgroup_by(by.y) |>
    fcount()

  on_arg <- by.y

  names(on_arg) <- by.x


  # Step 2: Join counts
  join_counts <- collapse::join(count_dfx, count_dfy, on = on_arg, how = 'full',
                                suffix = c(".dfx", ".dfy"),
                                verbose = FALSE)


  identified <- join_counts |>
    collapse::fsubset(N.dfx == 1 & N.dfy == 1)

  non_identified <- join_counts |>
    collapse::fsubset(N.dfx != 1 | N.dfy != 1)

  # Step 3: Determine the type of relationship
  match_type <- if (all(join_counts$N.dfx == 1 & join_counts$N.dfy == 1, na.rm = TRUE)) {
    "1:1"
  } else if (any(join_counts$N.dfx > 1 & join_counts$N.dfy > 1, na.rm = TRUE)) {
    "m:m"
  } else if (any(join_counts$N.dfx > 1 & join_counts$N.dfy == 1, na.rm = TRUE)) {
    "m:1"
  } else if (any(join_counts$N.dfx == 1 & join_counts$N.dfy > 1, na.rm = TRUE)) {
    "1:m"
  }

  # Step 4: Return results based on return_match argument
  if (return_match) {
    return(list(match_type = match_type,
                identified = identified,
                non_identified = non_identified))
  } else {
    return(match_type)
  }
}

# 9. Get df name -----
#' Get the name of a data frame. Internal function.
#'
#' @description This function gets the name of a data frame. Internal function.
#' If the data frame has a name attribute, it returns that. Otherwise, it returns
#' the deparse of the original call.
#'
#' @param df data.frame
#' @param original_call original call (df)
#'
#' @return character
#'
#' @keywords internal
get_df_name <- function(df, original_call) {

  name_attr <- attr(df, "df_name")

  if (is.null(name_attr)) {
    return(deparse(original_call))
  } else {
    return(name_attr)
  }
}

# 10. Menu wrapper ----
#' Menu wrapper. Internal function.
#' @description This function is a wrapper around the base R menu function.
#' It is used to provide a consistent interface for the menu function.
#' @param ... arguments passed to the menu function.
#' @return menu
#' @keywords internal
my_menu <- function(...) {
  utils::menu(...)
}

# 11. readline wrapper ----
#' Readline wrapper. Internal function.
#' @description This function is a wrapper around the base R readline function.
#' It is used to provide a consistent interface for the readline function.
#' @param ... arguments passed to the readline function.
#' @return readline
#' @keywords internal
my_readline <- function(...) {
  readline(...)
}


# 12. Digest hatch and skip if same ----
compare_digested <- function(dfx,dfy){



  digest_dfx <- digest::digest(dfx)
  digest_dfy <- digest::digest(dfy)

  if (digest_dfx == digest_dfy) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
