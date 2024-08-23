# compare_values ---------------------------------------------------------------
#' Compare values of matched datasets
#'
#' @inheritParams myrror
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full" (returns a myrror_object), "simple" (returns a dataframe), "silent" (invisible object returned).
#' @param verbose logical: If `TRUE` additional information will be displayed.
#' @param tolerance numeric, default to 1e-7.
#'
#' @return myrror_object with compare_values slot updated. Or a list of data.tables when `output = 'simple'` is selected.
#' @export
#'
#' @examples
#'
#' # 1. Standard report, myrror_object output:
#' compare_values(survey_data, survey_data_2, by=c('country', 'year'))
#'
#' # 2. Simple output, list of data.tables output:
#' compare_values(survey_data, survey_data_2, by=c('country', 'year'),
#'                output = 'simple')
#'
#' # 3. Toggle tolerance:
#' compare_values(survey_data, survey_data_2, by=c('country', 'year'),
#'                tolerance = 1e-5)
#'
#' # 4. Toggle interactvity:
#' compare_values(survey_data, survey_data_2, by=c('country', 'year'),
#'                interactive = FALSE)
#'
#' # 5. Different keys (see also ?myrror):
#' compare_values(survey_data, survey_data_2_cap,
#'                by.x = c('country', 'year'), by.y = c('COUNTRY', 'YEAR'))
#'
compare_values <- function(dfx = NULL,
                           dfy = NULL,
                           myrror_object = NULL,
                           by = NULL,
                           by.x = NULL,
                           by.y = NULL,
                           output = c("full", "simple", "silent"),
                           interactive = getOption("myrror.interactive"),
                           verbose = getOption("myrror.verbose"),
                           tolerance = getOption("myrror.tolerance")) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)


  # 4. Run compare_values_int() ----

  compare_values_list <- compare_values_int(myrror_object,
                                            tolerance = tolerance)

  ## Check if results are empty and adjust:
  ### If empty then NULL or myrror_object NULL.
  if(length(compare_values_list) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } else {
      myrror_object$compare_values <- NULL
    }

  } else {

  ### else if not empty, then create a tibble with the results.
  compare_values_df <- lapply(compare_values_list, \(x) fselect(x, diff, count)) |>
    rowbind(idcol = "variable") |>
    fmutate(diff = as.factor(diff))|>
    pivot(ids = 1, how = "wider", names = "diff")|>
    qTBL()

  myrror_object$compare_values <- compare_values_df

  }

  # 5. Save whether interactive or not ----
  myrror_object$interactive <- interactive

  # 6. Save to package environment ----
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # 7. Output ----
  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$compare_values <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$compare_values <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$compare_values)
         }
  )


}

# compare_values internal -----------------------------------------------------
compare_values_int <- function(myrror_object = NULL,
                               tolerance = NULL) {

  # 1. Pair columns ----
  merged_data_report <- myrror_object$merged_data_report
  pairs <- myrror_object$pairs

  # 3. Pairs list ----
  # GC Note: probably not the cleanest solution, need to change this.
  pairs_list <- lapply(seq_len(nrow(pairs$pairs)), function(i) {
    c(pairs$pairs$col_x[i], pairs$pairs$col_y[i])
  })

  # 4. Get changes ----
  value_to_na <- get_value_to_na(myrror_object$merged_data_report$matched_data, pairs_list)
  names(value_to_na) <- gsub(".x", "", pairs$pairs$col_x)

  na_to_value <- get_na_to_value(myrror_object$merged_data_report$matched_data, pairs_list)
  names(na_to_value) <- gsub(".x", "", pairs$pairs$col_x)

  change_in_value <- get_change_in_value(myrror_object$merged_data_report$matched_data,
                                         pairs_list,
                                         tolerance = tolerance)
  names(na_to_value) <- gsub(".x", "", pairs$pairs$col_x)

  # 5. Combine all changes ----
  all_changes <- mapply(function(x, y, z) {
    rbind(x, y, z)
  }, value_to_na, na_to_value, change_in_value, SIMPLIFY = FALSE)


  # Filter results to exclude variables where all counts are zero
  all_changes <- Filter(function(x) any(x$count > 0), all_changes)


  # 6. Return ----
  return(all_changes)

}



# compare_values utils ---------------------------------------------------------
## 1. Get value to NA
get_value_to_na <- function(matched_data,
                              pairs_list) {

  result <- lapply(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]


    matched_data |>
      fselect(c(col_x, col_y, "row_index")) |>
      fsubset(!is.na(get(col_x)) & is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index),
                 count = fnobs(row_index)) |>
      fmutate(diff = "value_to_na")|>
      colorder(diff, count, indexes)

  })


  return(result)

}

## 2. Get NA to value
get_na_to_value <- function(matched_data,
                              pairs_list) {

  result <- lapply(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]


    matched_data |>
      fselect(c(col_x, col_y, "row_index")) |>
      fsubset(is.na(get(col_x)) & !is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index),
                 count = fnobs(row_index)) |>
      fmutate(diff = "na_to_value")|>
      colorder(diff, count, indexes)
  })

}

## 3. Get change in value
get_change_in_value <- function(matched_data,
                                  pairs_list,
                                  tolerance) {

  result <- lapply(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    matched_data |>
      fmutate(equal = equal_with_tolerance(get(col_x), get(col_y), tolerance)) |>
      fsubset(equal == FALSE) |>
      fselect(c("row_index", col_x, col_y)) |>
      fsummarise(indexes = list(row_index),
                 count = fnobs(row_index)) |>
      fmutate(diff = "change_in_value")|>
      colorder(diff, count, indexes)

  })

  return(result)

}













