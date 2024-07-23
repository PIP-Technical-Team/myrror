
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
#' @param dfx data.frame object
#' @param dfy data.frame object
#' @param myrror_object myrror object
#' @param output character, one of "full", "simple", "silent"
#'
#' @return list object with two items: diff_list and diff_table
#' @export
#'
#' @examples
#'
#' extract_diff_values(iris, iris_var1)
#'
extract_diff_values <- function(dfx = NULL,
                                dfy = NULL,
                                by = NULL,
                                by.x = NULL,
                                by.y = NULL,
                                myrror_object = NULL,
                                output = c("simple", "full", "silent")) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx,
                                          dfy = dfy,
                                          by = by,
                                          by.x = by.x,
                                          by.y = by.y)

    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }

  # 3. Run extract_values_int() ----
  myrror_object$extract_diff_values <- extract_diff_int(myrror_object)

  # Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_values) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } else {
      myrror_object$extract_diff_values <- list(message = "No differences found between the variables.")
    }
  }

  # 4. Output ----

  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$extract_diff_values <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$extract_diff_values <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$extract_diff_values$diff_list)
         }
  )
}

extract_diff_table <- function(dfx = NULL,
                               dfy = NULL,
                               by = NULL,
                               by.x = NULL,
                               by.y = NULL,
                               myrror_object = NULL,
                               output = c("simple", "full", "silent")) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx,
                                          dfy = dfy,
                                          by = by,
                                          by.x = by.x,
                                          by.y = by.y)

    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }

  # 3. Run extract_values_int() ----
  myrror_object$extract_diff_values <- extract_diff_int(myrror_object)

  # Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_values) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } else {
      myrror_object$extract_diff_values <- list(message = "No differences found between the variables.")
    }
  }

  # 4. Output ----

  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$extract_diff_values <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$extract_diff_values <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$extract_diff_values$diff_table)
         }
  )
}





#' Extract Different Values - Internal
#'
#' @param myrror_object myrror object
#'
#' @return list with two elements:
#' 1. diff_list
#' 2. diff_table
#'
#'
#'
extract_diff_int <- function(myrror_object = NULL) {

  # 1. Get indexes and data ----
  compare_values_object <- compare_values_int(myrror_object = myrror_object)
  matched_data <- myrror_object$merged_data_report$matched_data

  # Check if results are empty and adjust accordingly
  if(length(compare_values_object) == 0) {

    # Exit early with NULL
    return(NULL)

  } else {


  # 2. List option -----
  diff_list <- purrr::imap(compare_values_object, function(df, variable) {


    column_x <- paste0(variable, ".x")
    column_y <- paste0(variable, ".y")

    df |>
      collapse::fsubset(count > 0) |>
      collapse::fselect(-count) |>
      tidyr::unnest(cols = c("indexes")) |>
      fmutate(indexes = as.character(indexes)) |>
      collapse::join(matched_data |>
                       collapse::fselect(c("rn", column_x, column_y)),
                     on = c("indexes" = "rn"),
                     how = "left",
                     verbose = 0)

  })

  non_empty_diff_list <- purrr::keep(diff_list, ~ nrow(.x) > 0)

  # 3. Table option ----
  diff_table <- rowbind(compare_values_object, idcol = "variable") |>
    fsubset(count > 0) |>
    fselect(-count)|>
    tidyr::unnest(cols = c(indexes)) |> # is there a better version of unnest?
    fmutate(indexes = as.character(indexes)) |>
    collapse::join(matched_data,
                   on = c("indexes" = "rn"),
                   how = "left",
                   verbose = 0)


  # 4. Store and Return ----
  result <- list(
    diff_list = non_empty_diff_list,
    diff_table = diff_table
  )

  return(result)
  }

}







