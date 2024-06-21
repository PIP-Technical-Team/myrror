
#' Compare type of variables
#'
#' @param myrror_object
#' @param dfx
#' @param dfy
#' @param output
#'
#' @return list object
#' @export
#'
#' @examples
compare_type <- function(dfx = NULL,
                         dfy = NULL,
                         myrror_object = NULL,
                         output = c("compare", "myrror")) {
  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx, dfy = dfy)
    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }

  # 3. Pair columns ----
  merged_data_report <- myrror_object$merged_data_report

  pairs <- pair_columns(merged_data_report)

  # 4. Compare types ----
  results <- lapply(seq_len(nrow(pairs$pairs)), function(i) {
    row <- pairs$pairs[i, ]
    list(
      column_x = row$col_x,
      column_y = row$col_y,
      class_x = class(merged_data_report$matched_data[[row$col_x]]),
      class_y = class(merged_data_report$matched_data[[row$col_y]]),
      same_class = class(merged_data_report$matched_data[[row$col_x]]) == class(merged_data_report$matched_data[[row$col_y]])
    )
  })

  results_dt <- rbindlist(results)

  results_dt <- results_dt |>
    fmutate(variable = gsub(".x", "", column_x))|>
    fselect(variable, class_x, class_y, same_class)

  # 2. Output ----
  if (output == "compare") {

    # maybe this we need to move to the core of the function (before the if statement)
    # also we need to figure out how this is printed out only when object printed?
    shared_cols_n <- nrow(pairs$pairs)
    nonshared_dfx_cols_n <- myrror_object$datasets_report$dfx_char$ncol - shared_cols_n
    nonshared_dfy_cols_n <- myrror_object$datasets_report$dfy_char$ncol - shared_cols_n
    name_dfx <- myrror_object$name_dfx
    name_dfy <- myrror_object$name_dfy


    cli::cli_h2("Note: comparison is done for shared columns.")
    cli::cli_alert_success("Total shared columns: {shared_cols_n}")
    cli::cli_alert_warning("Non-shared columns in {name_dfx}: {nonshared_dfx_cols_n}")
    cli::cli_alert_warning("Non-shared columns in {name_dfy}: {nonshared_dfy_cols_n}")
    cli::cli_h1("Shared Columns Class Comparison")

    print(results_dt)

    cli::cli_h1("Non-Shared Columns")
    cli::cli_text("Columns only in {name_dfx}: {pairs$nonshared_cols_dfx}")
    cli::cli_text("Columns only in {name_dfy}: {pairs$nonshared_cols_dfy}")


  } else {
    return(results_dt)
  }

}
