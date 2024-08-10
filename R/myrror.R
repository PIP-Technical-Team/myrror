# Workhorse function
#' myrror main function
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param compare_type TRUE or FALSE, default to TRUE.
#' @param compare_values TRUE or FALSE, default to TRUE.
#' @param extract_diff_values TRUE or FALSE, default to TRUE.
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#' @param interactive logical: If `TRUE`, print S3 method for myrror objects
#' displays by chunks. If `FALSE`, everything will be printed at once
#' @param tolerance numeric, default to 1e-7.
#' @param verbose logical: If `TRUE` additional information will be displayed
#'
#'
#' @return draft: selection of by variables
#' @export
#'
#' @examples
#' comparison <- myrror(iris, iris_var1)
myrror <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   compare_type = TRUE,
                   compare_values = TRUE,
                   extract_diff_values = TRUE,
                   factor_to_char = TRUE,
                   interactive = getOption("myrror.interactive"),
                   tolerance = getOption("myrror.tolerance"),
                   verbose = getOption("myrror.verbose")
                   ) {

 # 1. Create myrror object ----
  myrror_object <- create_myrror_object(dfx = dfx,
                                        dfy = dfy,
                                        by = by,
                                        by.x = by.x,
                                        by.y = by.y,
                                        factor_to_char = factor_to_char)

  myrror_object$name_dfx <- deparse(substitute(dfx)) # Re-assign names from the call.
  myrror_object$name_dfy <- deparse(substitute(dfy))

  # 2. Compare Type ----
  if (compare_type) {
    myrror_object <- compare_type(myrror_object = myrror_object,
                                  output = "silent")
  }

  # 3. Compare Values ----
  if (compare_values) {
    myrror_object <- compare_values(myrror_object = myrror_object,
                                    output = "silent",
                                    tolerance = tolerance)
  }

  # 4. Extract different values ----
  if (extract_diff_values) {
    myrror_object <- extract_diff_values(myrror_object = myrror_object,
                                         output = "silent",
                                         tolerance = tolerance)
  }

  # 5. Save whether interactive or not ----
  myrror_object$interactive <- interactive

  # 6. Save to package environment ----
  assign("last_myrror_object", myrror_object, envir = .myrror_env)

  # 6. Return myrror_object ----
  return(myrror_object)

}
