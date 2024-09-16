# Objective: similar to extract_diff_values() but instead of returning the
# differences in values, it returns the rows missing from dfy or new in dfy.

#' Extract Different Rows - User-facing
#' Function to extract missing or new rows from comparing two dataframes.
#'
#'
#' @inheritParams myrror
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full", "simple", "silent".
#' @param verbose logical: If `TRUE` additional information will be displayed.
#' @param tolerance numeric, default to 1e-7.
#'
#' @return data.table object with the rows that are missing or new.
#' @export
#'
#' @examples
#'
#' # 1. Standard report, after running myrror() or compare_values():
#' myrror(survey_data, survey_data_2, by=c('country', 'year'))
#' extract_diff_rows()
#'
#' # 2. Standard report, with new data:
#' extract_diff_rows(survey_data, survey_data_2, by=c('country', 'year'))
#'
#'
#' # 3. Toggle tolerance:
#' extract_diff_rows(survey_data, survey_data_2, by=c('country', 'year'),
#'                     tolerance = 1e-5)
#'
extract_diff_rows <- function(dfx = NULL,
                              dfy = NULL,
                              myrror_object = NULL,
                              by = NULL,
                              by.x = NULL,
                              by.y = NULL,
                              output = c("simple", "full", "silent"),
                              tolerance = 1e-7,
                              verbose = TRUE){
  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)

  # 4. Extract different rows using unmatched_data ----


  diff_rows <- myrror_object$merged_data_report$unmatched_data |>
    fmutate(.joyn = ifelse(.joyn == "x", "dfx", "dfy")) |>
    frename(df = .joyn)|>
    fselect(-row_index)|>
    colorder(df)

  myrror_object$extract_diff_rows <- diff_rows

  # 5. Save to package environment ----
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # Check if results are empty and adjust accordingly
  if(nrow(myrror_object$extract_diff_rows) == 0) {
    if(output == "simple") {
      return(NULL)}  # Return NULL for "simple" if no differences are found
    # } else {
    #   myrror_object$extract_diff_rows <- list(message = "No differences in rows.")
    # }
  }

  # 6. Output ----

  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$extract_diff_rows <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$extract_diff_rows <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$extract_diff_rows)
         }
  )

}
