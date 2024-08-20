# Objective: similar to extract_diff_values() but instead of returning the
# differences in values, it returns the rows missing from dfy or new in dfy.

#' Extract Different Rows - User-facing
#' Function to extract missing or new rows from comparing two dataframes.
#'
#'
#' @inheritParams myrror
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full", "simple", "silent"
#' @param tolerance numeric, default to 1e-7.
#'
#' @return data.table object with the rows that are missing or new.
#' @export
#'
#' @examples
#'
#' extract_diff_rows(iris, iris_var1)
#' extract_diff_rows(survey_data, survey_data_2, by=c('country', 'year'))
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

  # 4. Run extract_values_int() ----
  myrror_object$extract_diff_rows <- myrror_object$merged_data_report$unmatched_data

  # Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_rows) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } else {
      myrror_object$extract_diff_rows <- list(message = "No differences in rows.")
    }
  }

  # 5. Output ----

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
