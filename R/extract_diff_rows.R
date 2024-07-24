# Objective: similar to extract_diff_values() but instead of returning the
# differences in values, it returns the rows missing from dfy or new in dfy.

#' Extract Different Rows - User-facing
#' Function to extract missing or new rows from comparing two dataframes.
#'
#'
#' @param dfx data.frame object.
#' @param dfy data.frame object.
#' @param by character, key to be used for dfx and dfy.
#' @param by.x character, key to be used for dfx.
#' @param by.y character, key to be used for dfy.
#' @param myrror_object myrror object.
#' @param output character, one of "simple", "full", "silent".
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
                              by = NULL,
                              by.x = NULL,
                              by.y = NULL,
                              myrror_object = NULL,
                              output = c("simple", "full", "silent")){
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
  myrror_object$extract_diff_rows <- myrror_object$merged_data_report$unmatched_data

  # Check if results are empty and adjust accordingly
  if(length(myrror_object$extract_diff_rows) == 0) {
    if(output == "simple") {
      return(NULL)  # Return NULL for "simple" if no differences are found
    } else {
      myrror_object$extract_diff_rows <- list(message = "No differences in rows.")
    }
  }

  # 4. Output ----

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
