# Myrror Constructor
#' myrror_object constructor (internal)
#'
#' @inheritParams myrror
#' @param verbose logical: If `TRUE` additional information will be displayed.
#'
#' @return object of class myrror_object.
#'
#' @keywords internal
create_myrror_object <- function(dfx,
                                 dfy,
                                 by = NULL,
                                 by.x = NULL,
                                 by.y = NULL,
                                 factor_to_char = TRUE,
                                 verbose = getOption("myrror.verbose"),
                                 interactive = getOption("myrror.interactive")) {

  # 0. Store original datasets and orginal dataset characteristics ----
  original_call <- match.call()


  dfx_name <- get_df_name(df = dfx, original_call$dfx)
  dfy_name <- get_df_name(df = dfy, original_call$dfy)


  # If these are data.tables, it is necessary to create a hard copy.Otherwise,
  # the same object will be bound to two different names.
  original_dfx <- copy(dfx)
  original_dfy <- copy(dfy)

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

  # 5. No keys check ----
  ## If no keys supplied
  if ("rn" %in% set_by$set_by.x) {

    # Find possible keys for both datasets
    possible_ids_dfx <- temp_possible_ids(dfx)
    possible_ids_dfy <- temp_possible_ids(dfy)

    # Check if the row numbers match
    if (dfx_char$nrow == dfy_char$nrow) {

      # Check if possible keys are found in both datasets
      if (length(possible_ids_dfx) > 0 & length(possible_ids_dfy) > 0) {
        cli::cli_alert_info("No keys supplied, but possible keys found in both datasets.")
        cli::cli_alert_info("Possible keys found in {.field {dfx_name}}: {.val {possible_ids_dfx}}")
        cli::cli_alert_info("Possible keys found in {.field {dfy_name}}: {.val {possible_ids_dfy}}")
        cli::cli_alert_info("Consider using these keys for the comparison. The comparison will go ahead using row numbers.")

        # If no possible keys are found in either dataset
      } else if (length(possible_ids_dfx) == 0 & length(possible_ids_dfy) == 0){
        cli::cli_alert_info("No keys supplied, and no possible keys found. The comparison will go ahead using row numbers.")
      }

      # If the row numbers do not match, abort the process
    } else {
      cli::cli_abort("Different row numbers and no keys supplied. The comparison will be aborted.")
    }
  }

  # 6. Prepare Datasets for Join ----
  # - make into data.table.
  # - make into valid column names.
  # - check that by variable are in the colnames of the given dataset.
  # - check whether the user supplied keys: if not and if the two datasets have different row numbers ->
  # - check whether the by variables uniquely identify the dataset:
  # -- If identified -> proceed as default.
  # -- If not identified -> inform the user + ask if wants to proceed.
  # --- If not, abort.
  # --- If yes, proceed as default.
  # - factor to character (keep track of this), default = TRUE.
  prepared_dfx <- prepare_df(dfx,
                             by = set_by$by.x,
                             factor_to_char = factor_to_char,
                             interactive = interactive,
                             verbose = verbose)

  prepared_dfy <- prepare_df(dfy,
                             by = set_by$by.y,
                             factor_to_char = factor_to_char,
                             interactive = interactive,
                             verbose = verbose)
  # 7. Pre-merge checks ----

  ## 7.1 Check that set_by$by.x is not in the non-key columns of dfy and vice-versa ----
  # Note: this step needs to be done here because the column names might
  # change in the prepare_df() function.
  if (any(set_by$by.x %in% setdiff(names(prepared_dfy), set_by$by.y))) {
    cli::cli_abort("by.x is part of the non-index columns of dfy.")
  }
  if (any(set_by$by.y %in% setdiff(names(prepared_dfx), set_by$by.x))) {
    cli::cli_abort("by.y is part of the non-index columns of dfx.")
  }

  ## 7.2 Create dynamic 'by' argument for joyn (giving a name) ----
  on_join_arg <- set_by$by.y
  names(on_join_arg) <- set_by$by.x

  by_joyn_arg <- set_by$by.x
  names(by_joyn_arg) <- set_by$by.y


  by_joyn_arg <- sapply(names(by_joyn_arg), function(n) paste(by_joyn_arg[n], n,
                                                              sep = " = "))
  by_joyn_arg <- paste(unname(by_joyn_arg))


  ## 7.3 Check join type ----
  ## TO DO: Next version we will add options for 1:m and m:1 joins.
  match_type <- check_join_type(prepared_dfx,
                                prepared_dfy,
                                by.x = set_by$by.x,
                                by.y = set_by$by.y)


  is_id_dfx <- joyn::is_id(prepared_dfx, by = set_by$by.x, return_report = TRUE, verbose = FALSE)
  is_id_dfy <- joyn::is_id(prepared_dfy, by = set_by$by.y, return_report = TRUE, verbose = FALSE)



  is_id_report <- collapse::join(is_id_dfx, is_id_dfy,
                                 on = on_join_arg,
                                 how = "full",
                                 suffix = c(".dfx", ".dfy"),
                                 verbose = FALSE)

  # Proceed without interruption if the match type is 1:1
  if (match_type == "1:1") {
    # No special action needed for 1:1 joins

  } else if (match_type %in% c("1:m", "m:1")) {
    # Conditional warnings based on verbose setting
    if (verbose == TRUE) {
      message_type <- ifelse(match_type == "1:m", "1:m", "m:1")
      cli::cli_alert_warning("When comparing the data, the join is {.strong {message_type}} between {.field {dfx_name}} and {.field {dfy_name}}.")
      cli::cli_h2("Identification Report:")
      cli::cli_text("Only first 5 keys shown:")
      cli::cli_text("\n")
      print(is_id_report[1:5])
      cli::cli_text("...")
      cli::cli_text("\n")
    }

    # Interactive choice to continue only if interactive is TRUE
    if (interactive == TRUE) {
      proceed <- my_menu(
        choices = c("Yes, continue.", "No, abort."),
        title = "The join type is not 1:1. Do you want to proceed?"
      )
      if (proceed == 2) {
        cli::cli_abort("Operation aborted by the user.")
      }
    }

  } else {
    # Abort if the join type is m:m, consider verbosity
    if (verbose == TRUE) {
      cli::cli_abort("When comparing the datasets, the join is {.strong m:m} between {.field {dfx_name}} and {.field {dfy_name}}. The comparison will stop here.")
    } else {
      stop("Join type m:m, operation aborted.")
    }
  }


  #cli::cli_alert_info("You could use `check_join_type()` to check identified and non-identified observations.")

  # 6. Merge ----
  ## Use joyn to merge and keep matching and non-matching observations.

  merged_data <- joyn::joyn(prepared_dfx,
                            prepared_dfy,
                            by = by_joyn_arg,
                            match_type = match_type,
                            keep = "full",
                            keep_common_vars = TRUE,
                            update_values = FALSE,
                            update_NAs = FALSE,
                            verbose = FALSE)

  ## Adjust rn and row_index:
  if ("rn.x" %in% colnames(merged_data)) {
    merged_data <- merged_data |>
      fmutate(rn = rn.x) |>
      fselect(-rn.x, -rn.y)
  }


  if ("row_index.x" %in% colnames(merged_data)) {
    merged_data <- merged_data |>
      fmutate(row_index = row_index.x) |>
      fselect(-row_index.x, -row_index.y)
  }



  ## Store
  merged_data_report <- list()

  # 8. Get matched and non-matched ----
  matched_data <- merged_data |> fsubset(.joyn == 'x & y')
  unmatched_data <- merged_data |> fsubset(.joyn != 'x & y')


  ## Store
  merged_data_report$keys <- key(merged_data)
  merged_data_report$matched_data <- matched_data
  merged_data_report$unmatched_data <- unmatched_data
  merged_data_report$colnames_dfx <- colnames(prepared_dfx)
  merged_data_report$colnames_dfy <- colnames(prepared_dfy)

  # 9. Pair columns ----
  pairs <- pair_columns(merged_data_report)


  # 10. Set-up output structure ----
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
    match_type = match_type,
    merged_data_report = merged_data_report,
    pairs = pairs,
    print = list(
      compare_type = FALSE,
      compare_values = FALSE,
      extract_diff_values = FALSE
    ),
    interactive = getOption("myrror.interactive")
  )

  # 11. Return myrror object (invisible) ----
  return(invisible(structure(output,
                             class = "myrror")))

}
