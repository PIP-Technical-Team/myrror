#' Prepare Dataset
#' - setDT
#' - make valid col names
#' - factor to character
#' - keys in colnames
#'
#' @param df data.frame or data.table object
#' @param keys identifier
#'
#' @return a list
#' @import data.table
#' @export
#'
#' @examples
#' prepared_dataset <- prepare_dataset(iris_var1)
prepare_dataset <- function(df, keys = NULL) {


  # Step 1:Ensure df is a data.table
  setDT(df)

  # Step 2: Make Column Names Valid
  valid_col_names <- make.names(names(df), unique = TRUE)

  if (!all(valid_col_names == names(df))) {
    cli::cli_alert_info("Adjusting column names to valid R identifiers.")
    setnames(df, old = names(df), new = valid_col_names)  # No change needed, setnames is a data.table function
  }

  # Step 3: Check for Key Columns
  if (!is.null(keys) && !all(keys %in% names(df))) {
    missing_keys <- keys[!keys %in% names(df)]
    cli::cli_alert_danger(glue::glue("Missing key variables: {paste(missing_keys, collapse = ', ')}"))
    stop("key variable(s) not in dataset.")
  }

  # Step 4: Convert factors to characters
  factor_cols <- names(df)[sapply(df, is.factor)]
  df[, (factor_cols) := lapply(.SD, as.character), .SDcols = factor_cols]


  # Step 6: Return Prepared Dataset and Metadata
  return(list(
    prepared_dt = df,
    metadata = list(
      original_col_names = names(df),
      valid_col_names = valid_col_names,
      keys = keys
    )
  ))

}



