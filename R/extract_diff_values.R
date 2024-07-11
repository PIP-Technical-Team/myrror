
# Objective: extract_diff_values() : depends on indexes identified in compare_values(),
# The function will go through each dataset associated with each variable stored
# in the output of compare_values() and select the the indexes when count > 0.
# Then it will return a list with a subset-dataset for each variable, with the
# observations identified by the selected indexes. These observations will be
# identified by the type of diff: value_to_na, na_to_value, change_in_value.
# The function will return:
# 1. A list with a 'subset-dataset for each variable', with the observations that
# are different in value (only that variable from dfx and dfy and the id).
# 2. Another pivoted "complete" data.table (all variables with id) with all observations
# for which variables are different: the user can then select the variables they want to keep.




#' Extract Different Values - User-facing
#' Function to extract rows with different values between two dataframes.
#'
#'
#' @param dfx
#' @param dfy
#' @param myrror_object
#' @param verbose
#' @param output
#'
#' @return list, if verbose == TRUE, it will print the object.
#' @export
#'
#' @examples
#'
#' extract_diff_values(iris, iris_var1)
extract_diff_values <- function(dfx = NULL,
                                dfy = NULL,
                                myrror_object = NULL,
                                verbose = TRUE, # so that it actually prints the object.
                                output = c("myrror_object", "simple")) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx, dfy = dfy)

    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }

  # 3. Run extract_values_int() ----
  myrror_object$extract_diff_values <- extract_diff_values_int(myrror_object)

  # 4. Output ----
  # If verbose true -> print myrror_object using print method with extract_diff_values == TRUE:
  if (verbose) {
    myrror_object$print$extract_diff_values <- TRUE # rest is FALSE by default
    print(myrror_object)
  }

  # And return an invisible copy of the object
  if (output == "myrror_object") {

    return(invisible(myrror_object))

  } else if (output == "simple") {

    return(invisible(myrror_object$extract_diff_values))

  }
}





#' Extract Different Values - Internal
#'
#' @param myrror_object
#'
#' @return list with two elements:
#' 1. diff_list
#' 2. diff_table
#'
#'
#' @examples
#' extract_diff_value_int(myrror_object = myrror_object)
#'
extract_diff_values_int <- function(myrror_object = NULL) {

  # 1. Get indexes and data ----
  compare_values_object <- compare_values_int(myrror_object = myrror_object)
  matched_data <- myrror_object$merged_data_report$matched_data


  # 2. List option -----
  diff_list <- purrr::imap(compare_values_object, function(df, variable) {
    column_x <- paste0(variable, ".x")
    column_y <- paste0(variable, ".y")

    df %>%
      dplyr::filter(count > 0) |>
      dplyr::select(-count) |>
      tidyr::unnest(cols = c(indexes)) %>%
      dplyr::mutate(indexes = as.character(indexes)) |>
      dplyr::left_join(matched_data |>
                         dplyr::select(rn, all_of(column_x),
                                       all_of(column_y)),
                       by = c("indexes" = "rn"))

  })

  non_empty_diff_list <- purrr::keep(diff_list, ~ nrow(.x) > 0)

  # 3. Table option ----
  diff_table <- rowbind(compare_values_object, idcol = "variable") |>
    fsubset(count > 0) |>
    fselect(-count)|>
    tidyr::unnest(cols = c(indexes)) |> # is there a better version of unnest?
    fmutate(indexes = as.character(indexes)) |>
    dplyr::left_join(matched_data, by = c("indexes" = "rn"))


  # 4. Store and Return ----
  result <- list(
    diff_list = diff_list,
    diff_table = diff_table
  )

  return(result)

}







