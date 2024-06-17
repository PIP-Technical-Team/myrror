# Workhorse function
#' myrror main function
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#'
#' @return draft: selection of by variables
#' @export
#' @import collapse
#'
#' @examples
#' comparison <- myrror(iris, iris_var1)
myrror <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   #tolerance = NULL, POSTPONED
                   factor_to_char = TRUE) {

 # 1. Create myrror object
  myrror_object <- create_myrror_object(dfx = dfx,
                                        dfy = dfy,
                                        by = by,
                                        by.x = by.x,
                                        by.y = by.y,
                                        factor_to_char = factor_to_char)

  # 2. Compare datasets
  # Example: comparison <- compare_datasets(myrror_object)

  # 3. Return comparison
  # return(comparison)

  return(myrror_object)


}

# Old print ----
# @rdname myrror
# @param x an object of class 'myrror_object'
# @param ... additional arguments
# @export
# print.myrror_object <- function(x, ...)
# {
#   cli::cli_h1("Myrror Object")
#   cli::cli_h2("Datasets Characteristics")
#   print(knitr::kable(data.frame(row.names = c("dfx", "dfy"),
#                    dataset = c(x$name_dfx, x$name_dfy),
#                    nrow = c(x$datasets_report$dfx_char$nrow, x$datasets_report$dfy_char$nrow),
#                    ncol = c(x$datasets_report$dfx_char$ncol, x$datasets_report$dfy_char$ncol),
#                    set_by = c(paste0(x$set_by.x, collapse = ", "), paste0(x$set_by.x, collapse = ", ")),
#                    # sorting = c(paste(x$datasets_report$sorting_dfx[[1]], collapse = ", "),
#                    #             paste(x$datasets_report$sorting_dfy[[1]], collapse = ", "))
#                    )),
#         format = "simple", row.names = FALSE, align = 'l')
#   cat("\n")
#   cli::cli_h2("Variables Comparison")
#   print(knitr::kable(data.frame(row.names = c("Variables only in dfx", "Variables only in dfy"),
#                    count = c(length(x$comparison_report$variables_only_in_x), length(x$comparison_report$variables_only_in_y)),
#                    variables = c(paste(x$comparison_report$variables_only_in_x, collapse = ", "),
#                                  paste(x$comparison_report$variables_only_in_y, collapse = ", ")))),
#               format = "simple", row.names = FALSE, align = 'l')
#   cat("\n")
#   cli::cli_h2("Observations Comparison")
#   print(knitr::kable(data.frame(row.names = c("Rows in dfx but not in dfy", "Rows in dfy but not in dfx"),
#                    count = c(x$comparison_report$x_not_in_y |> fnrow(),
#                              x$comparison_report$y_not_in_x |> fnrow()))),
#         format = "simple", align = 'l')
#   cat("\n")
#   cli::cli_alert_info("{.strong Note}: 'rn' means datasets were compared by row name.")
#
#   invisible(x)
# }

# Old structure part 2 ----
# # COMPARISON REPORT
# # 7. New Observations
# ## 1. Rows in x but not in y.
# ## 2. Rows in y but not in x.
#
# x_not_in_y <- unmatched_data |> fsubset(join == 'x')
# y_not_in_x <- unmatched_data |> fsubset(join == 'y')
#
# #x_not_in_y_count <- x_not_in_y |> fnrow() Can add directly to summary?
# #y_not_in_x_count <- y_not_in_x |> fnrow()
#
# ## Store
# comparison_report <- list()
# comparison_report$y_not_in_x <- y_not_in_x
# comparison_report$x_not_in_y <- x_not_in_y
#
# # 8. New Variables
# # 1. Variables in x but not in y.
# # 2. Variables in y but not in x.
#
# ## Remove suffixes
# clean_columns_x <- gsub("\\.x$", "", names(prepared_dfx))
# clean_columns_y <- gsub("\\.y$", "", names(prepared_dfy))
#
#
# ## Get the set difference
# variables_only_in_x <- setdiff(clean_columns_x, clean_columns_y)
# variables_only_in_y <- setdiff(clean_columns_y, clean_columns_x)
#
# #variables_only_in_x_count <- variables_only_in_x |> length() Can add directly to summary
# #variables_only_in_y_count <- variables_only_in_y |> length()
#
# ## Store
# comparison_report$variables_only_in_x <- variables_only_in_x
# comparison_report$variables_only_in_y <- variables_only_in_y
#
#
# # 10. Variable comparison:
# ## 4.1 Is it the same type?
# ## 4.2 N of new observations in given variable: in x but not in y (deleted), in y but not in x (added).
# ## 4.3 Different value: NA to value, value != value, value to NA.
#
# variable_comparison <- process_fselect_col_pairs(merged_data)
#
# comparison_report$variable_comparison <- variable_comparison
#
# # Prepare output structure for 'myrror_object'
# output <- list(
#   original_call = original_call,
#   name_dfx = dfx_name,
#   name_dfy = dfy_name,
#   dfx = original_dfx,
#   dfy = original_dfy,
#   #tolerance = tolerance,
#   processed_dfx = dfx,
#   processed_dfy = dfy,
#   prepared_dfy = prepared_dfy,
#   prepared_dfx = prepared_dfx,
#   original_by.x = by.x,
#   original_by.y = by.y,
#   set_by.y = set_by$by.y,
#   set_by.x = set_by$by.x,
#   datasets_report = datasets_report,
#   merged_data_report = merged_data_report,
#   comparison_report = comparison_report
# )
#
# # Set-up structure of 'myrror_object'
# structure(output, class = "myrror")
