# Myrror Constructor
#' myrror_object constructor
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#'
#' @return object of class myrror_object
#'
#' @import collapse
#'
create_myrror_object <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   factor_to_char = TRUE) {


   # 0. Store original datasets and orginal dataset characteristics ----
  original_call <- match.call()
  dfx_name <- deparse(substitute(dfx))
  dfy_name <- deparse(substitute(dfy))
  original_dfx <- dfx
  original_dfy <- dfy

  # 1. Check dfx and dfy arguments ----
  # - df1 and df2 needs to be data.frames structures and not empty.
  # - if NULL, say that that there is a NULL, and stop.
  # - if list, check it could be transformed into a data.frame, and then transform.

  dfx <- check_df(dfx)
  dfy <- check_df(dfy)

  # 3. Check by, by.x, by.y arguments: ----
  # - by, by.x, by.y needs to be of 'character' type.
  # - either by specified, or by.y AND by.x specified, or NULL.
  # - if NULL, it will become a row.names comparison (by = "rn")


  set_by <- check_set_by(by, by.x, by.y)

  # Now the by keys are stored here:
  #set_by$by
  #set_by$by.x
  #set_by$by.y

  # 4. Datasets characteristics ----
  dfx_char <- list(
    nrow = nrow(original_dfx),
    ncol = ncol(original_dfx)
  )

  dfy_char <- list(
    nrow = nrow(original_dfy),
    ncol = ncol(original_dfy)
  )

  ## Store
  datasets_report <- list()
  datasets_report$dfx_char <- dfx_char
  datasets_report$dfy_char <- dfy_char

  # 5. Prepare Datasets for Join ----
  # - make into data.table.
  # - make into valid column names.
  # - check that by variable are in the colnames of the given dataset.
  # - check whether the by variables uniquely identify the dataset.
  # - factor to character (keep track of this), default = TRUE.

  prepared_dfx <- prepare_df(dfx,
                             by = set_by$by.x,
                             factor_to_char = factor_to_char)

  prepared_dfy <- prepare_df(dfy,
                             by = set_by$by.y,
                             factor_to_char = factor_to_char)

  # - Check that set_by$by.x is not in the non-key columns of dfy and vice-versa.
  # Note: this step needs to be done here because the column names might
  # change in the prepare_df() function.
  if (any(set_by$by.x %in% setdiff(names(prepared_dfy), set_by$by.y))) {
    stop("by.x is part of the non-index columns of dfy.")
  }
  if (any(set_by$by.y %in% setdiff(names(prepared_dfx), set_by$by.x))) {
    stop("by.y is part of the non-index columns of dfx.")
  }

  # 5. Merge ----
  # - identify
  # - use joyn to merge and keep matching and non-matching observations.

  ## Merge using Joyn

  ### Create dynamic 'by' argument for joyn
  by_joyn_arg <- stats::setNames(set_by$by.x, set_by$by.y)
  by_joyn_arg <- sapply(names(by_joyn_arg), function(n) paste(by_joyn_arg[n], n,
                                                              sep = " = "))
  by_joyn_arg <- paste(unname(by_joyn_arg))

  ### Merge
  merged_data <- joyn::joyn(prepared_dfx,
                      prepared_dfy,
                      by = c(by_joyn_arg),
                      match_type = c("1:1"),
                      keep = "full",
                      keep_common_vars = TRUE,
                      update_values = FALSE,
                      update_NAs = FALSE,
                      verbose = FALSE)




  ## Adjust rn and row_index:
  if ("rn.x" %in% colnames(merged_data)) {
    merged_data <- merged_data |>
      collapse::fmutate(rn = rn.x) |>
      collapse::fselect(-rn.x, -rn.y)
  }


  if ("row_index.x" %in% colnames(merged_data)) {
    merged_data <- merged_data |>
      collapse::fmutate(row_index = row_index.x) |>
      collapse::fselect(-row_index.x, -row_index.y)
  }



  ## Store
  merged_data_report <- list()

  # 6. Get matched and non-matched ----
  matched_data <- merged_data |> fsubset(.joyn == 'x & y')
  unmatched_data <- merged_data |> fsubset(.joyn != 'x & y')

  ## Store
  merged_data_report$keys <- key(merged_data)
  merged_data_report$matched_data <- matched_data
  merged_data_report$unmatched_data <- unmatched_data
  merged_data_report$colnames_dfx <- colnames(prepared_dfx)
  merged_data_report$colnames_dfy <- colnames(prepared_dfy)

  # 7. Pair columns ----
  pairs <- pair_columns(merged_data_report)


  # 8. Set-up output structure ----
  ## GC Note: this is a draft, we might reduce the number of items stored.
  output <- list(
    original_call = original_call,
    name_dfx = dfx_name,
    name_dfy = dfy_name,
    prepared_dfy = prepared_dfy,
    prepared_dfx = prepared_dfx,
    original_by.x = by.x,
    original_by.y = by.y,
    set_by.y = set_by$by.y,
    set_by.x = set_by$by.x,
    datasets_report = datasets_report,
    merged_data_report = merged_data_report,
    pairs = pairs,
    print = list(
      compare_type = FALSE,
      compare_values = FALSE,
      extract_diff_values = FALSE
    )
  )

  # 8. Return myrror object (invisible) ----
  return(invisible(structure(output,
            class = "myrror")))

}
