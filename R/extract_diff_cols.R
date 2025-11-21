extract_diff_cols <- function(dfx = NULL,
                              dfy = NULL,
                              myrror_object = NULL,
                              by = NULL,
                              by.x = NULL,
                              by.y = NULL,
                              output = c("simple", "full", "silent"),
                              verbose = getOption("myrror.verbose"),
                              interactive = getOption("myrror.interactive")) {

  # 0. Digest and exit if identical ----
  if (!is.null(dfx) && !is.null(dfy)) {
    digested_identical <- compare_digested(dfx, dfy)
    if (digested_identical) {
      cli::cli_alert_success("The two datasets are identical.")
      return(invisible(NULL))
    }
  }

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list ----
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)

  # Determine key columns to ignore
  keys <- if (!is.null(by)) by else character(0)
  if (!is.null(by.x)) keys <- by.x
  if (!is.null(by.y)) keys <- by.y

  # 4. Extract columns excluding keys ----
  cols_x <- setdiff(names(myrror_object$dfx), keys)
  cols_y <- setdiff(names(myrror_object$dfy), keys)

  only_x <- setdiff(cols_x, cols_y)
  only_y <- setdiff(cols_y, cols_x)

  # Build diff data.table
  diff_cols <- data.table::rbindlist(list(
    if (length(only_x) > 0) data.table::data.table(
      column = only_x,
      df = "dfx",
      type = sapply(myrror_object$dfx[, only_x, drop = FALSE], class)
    ) else NULL,
    if (length(only_y) > 0) data.table::data.table(
      column = only_y,
      df = "dfy",
      type = sapply(myrror_object$dfy[, only_y, drop = FALSE], class)
    ) else NULL
  ))

  # Store in myrror object ----
  myrror_object$extract_diff_cols <- diff_cols
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # Check if results are empty ----
  if (nrow(diff_cols) == 0 && output == "simple") return(NULL)

  # 5. Output ----
  switch(output,
         full = {
           myrror_object$print$extract_diff_cols <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$extract_diff_cols <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(diff_cols)
         }
  )
}
