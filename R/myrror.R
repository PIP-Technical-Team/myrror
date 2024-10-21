# Workhorse function
#' myrror main function
#'
#' @param dfx a non-empty data.frame.
#' @param dfy a non-empty data.frame.
#' @param by character, key to be used for dfx and dfy.
#' @param by.x character, key to be used for dfx.
#' @param by.y character, key to be used for dfy.
#' @param compare_type TRUE or FALSE, default to TRUE.
#' @param compare_values TRUE or FALSE, default to TRUE.
#' @param extract_diff_values TRUE or FALSE, default to TRUE.
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#' @param interactive logical: If `TRUE`, print S3 method for myrror objects
#' displays by chunks. If `FALSE`, everything will be printed at once.
#' @param verbose logical: If `TRUE`, print messages.
#' @param tolerance numeric, default to 1e-7.
#'
#'
#' @return Object of class myrror_object. A comparison report between the two datasets.
#' @export
#'
#' @examples
#'
#'
#' # 1. Specifying by, by.x or by.y:
#' myrror(survey_data, survey_data_2, by=c('country', 'year'))
#'
#' ## These are equivalent:
#' myrror(survey_data, survey_data_2_cap, by.x=c('country', 'year'), by.y = c('COUNTRY', 'YEAR'))
#' myrror(survey_data, survey_data_2_cap, by=c('country' = 'COUNTRY', 'year' = 'YEAR'))
#'
#' # 2. Turn off interactivity:
#' myrror(survey_data, survey_data_2, by=c('country', 'year'), interactive = FALSE)
#'
#' # 3. Turn off factor_to_char (it will treat factors as factors):
#' myrror(survey_data, survey_data_2, by=c('country', 'year'), factor_to_char = FALSE)
#'
#' # 4. Turn off compare_type:
#' myrror(survey_data, survey_data_2, by=c('country', 'year'), compare_type = FALSE)
#' ## Same can be done for compare_values and extract_diff_values.
#'
#' # 5. Set tolerance:
#' myrror(survey_data, survey_data_2, by=c('country', 'year'), tolerance = 1e-5)
#'

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
                   verbose = getOption("myrror.verbose"),
                   tolerance = getOption("myrror.tolerance")
                   ) {


  # 0. Digest and exit if identical ----

  digested_identical <- compare_digested(dfx, dfy)
  if (digested_identical & !is.null(dfx) & !is.null(dfy)) {
    cli::cli_alert_success("The two datasets are identical.")
    return(invisible(NULL))
  }

  # 1. NULL check ----
  ## Store name for print
  name_dfx <- deparse(substitute(dfx))
  name_dfy <- deparse(substitute(dfy))

  ## Note: needs to be done at this stage or you cannot set the name.
  # Check if dfx or dfy are NULL
  if (is.null(dfx)) {
    cli::cli_abort(c(x = "{.field {name_dfx}} is NULL.",
                     i = "Input data frame(s) cannot be NULL."),
                   call = NULL)
  }

  if (is.null(dfy)) {
    cli::cli_abort(c(x = "{.field {name_dfy}} is NULL.",
                   i = "Input data frame(s) cannot be NULL."),
                   call = NULL)
  }


  # 2. Name storage ----

  ## Store for operations within myrror()
  attr(dfx, "df_name") <- name_dfx
  attr(dfy, "df_name") <- name_dfy


  # 3. Create myrror object ----
  myrror_object <- create_myrror_object(dfx = dfx,
                                        dfy = dfy,
                                        by = by,
                                        by.x = by.x,
                                        by.y = by.y,
                                        factor_to_char = factor_to_char,
                                        interactive = interactive,
                                        verbose = verbose)
  ## Store within myrror_object
  myrror_object$name_dfx <- name_dfx
  myrror_object$name_dfy <- name_dfy

  # 4. Compare Type ----
  if (compare_type) {
    myrror_object <- compare_type(myrror_object = myrror_object,
                                  output = "silent")
  }

  # 5. Compare Values ----
  if (compare_values) {
    myrror_object <- compare_values(myrror_object = myrror_object,
                                    output = "silent",
                                    tolerance = tolerance)
  }

  # 6. Extract different values ----
  if (extract_diff_values) {
    myrror_object <- extract_diff_values(myrror_object = myrror_object,
                                         output = "silent",
                                         tolerance = tolerance)
  }

  # 7. Save whether interactive or not ----
  myrror_object$interactive <- interactive

  # 8. Save to package environment ----
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # 9. Return myrror_object ----
  return(myrror_object)

}
