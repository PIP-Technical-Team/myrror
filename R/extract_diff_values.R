
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

# extract_diff_table() will return the pivoted "complete" data.table (all variables with id).



#' Extract Different Values - User-facing - List format
#' Function to extract rows with different values between two dataframes.
#'
#'
#' @inheritParams myrror
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full", "simple", "silent".
#' @param verbose logical: If `TRUE` additional information will be displayed.
#' @param tolerance numeric, default to 1e-7.
#'
#' @return list object with two items: diff_list and diff_table
#' @export
#'
#' @examples
#'
#' # 1. Standard report, after running myrror() or compare_values():
#' myrror(survey_data, survey_data_2, by=c('country', 'year'))
#' extract_diff_values()
#'
#' # 2. Standard report, with new data:
#' extract_diff_values(survey_data, survey_data_2, by=c('country', 'year'))
#'
#' # 3. Toggle tolerance:
#' extract_diff_values(survey_data, survey_data_2, by=c('country', 'year'),
#'                     tolerance = 1e-5)
#'
extract_diff_values <- function(dfx = NULL,
                                dfy = NULL,
                                myrror_object = NULL,
                                by = NULL,
                                by.x = NULL,
                                by.y = NULL,
                                output = c("simple", "full", "silent"),
                                tolerance = 1e-7,
                                verbose = TRUE) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)


  # 4. Run extract_values_int() ----
  myrror_object$extract_diff_values <- extract_diff_int(myrror_object,
                                                        tolerance = tolerance)

  # Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_values) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } #else {
    #myrror_object$extract_diff_values <- list(message = "No differences found between the variables.")
    #} # need to think about whether I want to keep this option instead of printing out the mo.
  }

  # 5. Output ----

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








#' Extract Different Values - User-facing - Table format
#' Function to extract rows with different values between two dataframes.
#'
#' @inheritParams myrror
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full", "simple", "silent".
#' @param verbose logical: If `TRUE` additional information will be displayed.
#' @param tolerance numeric, default to 1e-7.
#'
#' @return data.table object with all observations for which at least 1 value is different.
#' @export
#'
#' @examples
#'
#' # 1. Standard report, after running myrror() or compare_values():
#' myrror(survey_data, survey_data_2, by=c('country', 'year'))
#' extract_diff_table()
#'
#' # 2. Standard report, with new data:
#' extract_diff_table(survey_data, survey_data_2, by=c('country', 'year'))
#'
#' # 3. Toggle tolerance:
#' extract_diff_table(survey_data, survey_data_2, by=c('country', 'year'),
#'                     tolerance = 1e-5)
#'
extract_diff_table <- function(dfx = NULL,
                               dfy = NULL,
                               myrror_object = NULL,
                               by = NULL,
                               by.x = NULL,
                               by.y = NULL,
                               output = c("simple", "full", "silent"),
                               tolerance = 1e-7,
                               verbose = TRUE) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)


  # 4. Run extract_values_int() ----
  myrror_object$extract_diff_values <- extract_diff_int(myrror_object,
                                                        tolerance = tolerance)

  # 5. Save to package environment ----
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # 6. Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_values) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } #else {
      #myrror_object$extract_diff_values <- list(message = "No differences found between the variables.")
    #} # need to think about whether I want to keep this option instead of printing out the mo.
  }

  # 7. Output ----

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
#' @param tolerance numeric, default to 1e-7
#'
#' @return list with two elements:
#' 1. diff_list
#' 2. diff_table
#'
#'
#'
extract_diff_int <- function(myrror_object = NULL,
                             tolerance = 1e-07) {

  # 1. Get indexes and data ----
  compare_values_object <- compare_values_int(myrror_object = myrror_object,
                                              tolerance = tolerance)

  matched_data <- myrror_object$merged_data_report$matched_data

  keys <- myrror_object$set_by.x

  # Check if results are empty and adjust accordingly
  if(length(compare_values_object) == 0) {

    # Exit early with NULL
    return(NULL)

  } else {


  # 2. List option -----
    ## With lapply(), need to extract variable_names to assign to the list:

    variable_names <- names(compare_values_object)

    diff_list <- lapply(variable_names, function(variable) {

      df <- compare_values_object[[variable]]

      column_x <- paste0(variable, ".x")
      column_y <- paste0(variable, ".y")


      result <- df |>
        fsubset(count > 0) |>
        fselect(-count) |>
        _[, .(indexes = unlist(indexes)), by = .(diff)] |>
        fmutate(indexes = as.character(indexes))|>
        collapse::join(matched_data |>
                         fselect(c("rn", keys, column_x, column_y)),
                       on = c("indexes" = "rn"),
                       how = "left",
                       verbose = 0) |>
        fselect(c("diff", "indexes", keys, column_x, column_y)) |>
        roworderv(c(keys))

    })

    names(diff_list) <- variable_names

    non_empty_diff_list <- diff_list[sapply(diff_list,
                                  function(x) !is.null(x) && nrow(x) > 0)]

  # 3. Table option ----
  diff_table <- rowbind(compare_values_object, idcol = "variable") |>
     fsubset(count > 0) |>
     fselect(-count) |>
       _[, .(indexes = unlist(indexes)), by = .(diff, variable)] |>
    fmutate(indexes = as.character(indexes)) |>
    collapse::join(matched_data,
                   on = c("indexes" = "rn"),
                   how = "left",
                   verbose = 0) |>
      fselect(-row_index, -.joyn)


    ## order columns
    priority_cols <- setdiff(c("diff", "variable", "indexes", keys), "rn")
    remaining_cols <- setdiff(names(diff_table), priority_cols)
    sorted_remaining_cols <- sort(remaining_cols)
    new_order <- c(priority_cols, sorted_remaining_cols)
    setcolorder(diff_table, new_order)


  # 4. Store and Return ----
  result <- list(
    diff_list = non_empty_diff_list,
    diff_table = diff_table
  )

  return(result)
  }

}







