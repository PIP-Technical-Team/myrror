#' myrror main function
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param tolerance tolerance list. Can be: NULL, 'no_cap', 'no_symbols', 'no_whitespace'
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#'
#' @return draft: selection of by variables
#' @export
#' @import collapse
#' @import data.table
#' @import stats
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


  # 0. Store original datasets ----
  original_dfx <- dfx
  original_dfy <- dfy

  # 1. Check dfx and dfy arguments ----
  # - df1 and df2 needs to be data.frames structures and not empty.
  # - if NULL, say that that there is a NULL, and stop.
  # - if list, check it could be transformed into a data.frame, and then transform.

  dfx <- check_df(dfx)
  dfy <- check_df(dfy)

  # 2. Apply tolerance to columns and by -----
  # - Check if tolerance vector is non-null.
  # - Apply specific adjustments (draft, to be updated) -> column names might change.
  # - Record changes (can use tolerance vector).
  # !!! POSTPONED for NOW.

  # if (!is.null(tolerance)) {
  #   names(dfx) <- apply_tolerance(names(dfx), tolerance = tolerance)
  #   names(dfy) <- apply_tolerance(names(dfy), tolerance = tolerance)
  #
  #   if (!is.null(by)) {
  #     by <- apply_tolerance(by, tolerance = tolerance)
  #   }
  #
  #   if (!is.null(by.x)) {
  #     by.x <- apply_tolerance(by.x, tolerance = tolerance)
  #   }
  #
  #   if (!is.null(by.y)) {
  #     by.y <- apply_tolerance(by.y, tolerance = tolerance)
  #   }
  # }


  # 3. Check by, by.x, by.y arguments: ----
  # - by, by.x, by.y needs to be of 'character' type.
  # - either by specified, or by.y AND by.x specified, or NULL.
  # - if NULL, it will become a row.names comparison (by = "rn")

  set_by <- check_set_by(by, by.x, by.y)

  # Now the by keys are stored here:
  #set_by$by
  #set_by$by.x
  #set_by$by.y


  # 4. Prepare Dataset for Alignment ----
  # - make into data.table.
  # - make into valid column names.
  # - check that by variable are in the colnames of the given dataset.
  # - factor to character (keep track of this), default = TRUE.

  prepared_dfx <- prepare_df(dfx,
                             by = by.x,
                             factor_to_char = factor_to_char)

  prepared_dfy <- prepare_df(dfy,
                             by = by.y,
                             factor_to_char = factor_to_char)

  # - Check that by.x is not in the non-key columns of dfy and vice versa
  if (by.x %in% setdiff(names(prepared_dfy), by.y)) {
    stop("by.x is part of the non-index columns of dfy.")
  }
  if (by.y %in% setdiff(names(prepared_dfx), by.x)) {
    stop("by.y is part of the non-index columns of dfx.")
  }

  # MERGED DATA REPORT ----
  # 5. Merge ----
  # - use collapse to merge and keep matching and non-matching observations.



  ## Give row index to x and y:
  prepared_dfx[, 'row_index' := .I]
  prepared_dfy[, 'row_index' := .I]

  ## Merge using Join
  merged_data <- collapse::join(prepared_dfx,
                                prepared_dfy,
                                on=setNames(by.x, by.y),
                                how='full',
                                sort = TRUE, # already sorted here !!
                                multiple = TRUE,
                                suffix = c(".x",".y"),
                                keep.col.order = FALSE,
                                verbose = 0,
                                column = list("join", c("x", "y", "x_y")),
                                attr = TRUE)

  ## Store
  merged_data_report <- list()
  merged_data_report$merged_data <- merged_data


  # 6. Get matched and non-matched ----
  ## Subset using join column
  matched_data <- merged_data |> fsubset(join == 'x_y')
  unmatched_data <- merged_data |> fsubset(join != 'x_y')

  ## Store
  merged_data_report$matched_data <- matched_data
  merged_data_report$unmatched_data <- unmatched_data

  # COMPARISON REPORT ----
  # 7. New Observations ----
  ## 1. Rows in x but not in y.
  ## 2. Rows in y but not in x.

  x_not_in_y <- unmatched_data |> fsubset(join == 'x')
  y_not_in_x <- unmatched_data |> fsubset(join == 'y')

  #x_not_in_y_count <- x_not_in_y |> fnrow() Can add directly to summary?
  #y_not_in_x_count <- y_not_in_x |> fnrow()

  ## Store
  comparison_report <- list()
  comparison_report$y_not_in_x <- y_not_in_x
  comparison_report$x_not_in_y <- x_not_in_y

  # 8. New Variables ----
  # 1. Variables in x but not in y.
  # 2. Variables in y but not in x.

  ## Remove suffixes
  clean_columns_x <- gsub("\\.x$", "", names(prepared_dfx))
  clean_columns_y <- gsub("\\.y$", "", names(prepared_dfy))


  ## Get the set difference
  variables_only_in_x <- setdiff(clean_columns_x, clean_columns_y)
  variables_only_in_y <- setdiff(clean_columns_y, clean_columns_x)

  #variables_only_in_x_count <- variables_only_in_x |> length() Can add directly to summary
  #variables_only_in_y_count <- variables_only_in_y |> length()

  ## Store
  comparison_report$variables_only_in_x <- variables_only_in_x
  comparison_report$variables_only_in_y <- variables_only_in_y

  # 9. Sorting: ----
  # Was data sorted in x, if so, by which variable?
  # Was data sorted in y, is so, by which variable?
  # Was data sorted by the same variable?

  sorted_vars_x <- detect_sorting(original_dfx)
  sorted_vars_y <- detect_sorting(original_dfy)

  common_vars <- intersect(sorted_vars_x, sorted_vars_y)
  is_common_sorted = !length(common_vars) == 0

  ## Store
  comparison_report$sorted_vars_x <- sorted_vars_x
  comparison_report$sorted_vars_y <- sorted_vars_y

  # 10. Variable comparison: ----
  ## 4.1 Is it the same type?
  ## 4.2 N of new observations in given variable: in x but not in y (deleted), in y but not in x (added).
  ## 4.3 Different value: NA to value, value != value, value to NA.

  variable_comparison <- process_fselect_col_pairs(merged_data)

  comparison_report$variable_comparison <- variable_comparison

  # Prepare output structure for 'myrror_object'
  output <- list(
    dfx = original_dfx,
    dfy = original_dfy,
    tolerance = tolerance,
    processed_dfx = dfx,
    processed_dfy = dfy,
    prepared_dfy = prepared_dfy,
    prepared_dfx = prepared_dfx,
    by.x = by.x,
    by.y = by.y,
    merged_data_report = merged_data_report,
    comparison_report = comparison_report
  )

  # Set-up structure of 'myrror_object'
  structure(output, class = "myrror_object")
}


#' @rdname myrror
#' @export
print.myrror_object <- function(x)
{
  cat("Compare Object\n\n")
  cat("Function Call: \n")
  print(x$comparison_report)
  cat("\n")
  invisible(x)
}

