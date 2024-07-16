print.myrror <- function(x, ...) {


  # 1. General ----
  shared_cols_n <- nrow(x$pairs$pairs)
  nonshared_dfx_cols_n <- x$datasets_report$dfx_char$ncol - shared_cols_n
  nonshared_dfy_cols_n <- x$datasets_report$dfy_char$ncol - shared_cols_n
  name_dfx <- x$name_dfx
  name_dfy <- x$name_dfy

  cli::cli_h1("Myrror Report")

  cli::cli_h2("Note: comparison is done for shared columns.")
  cli::cli_alert_success("Total shared columns: {shared_cols_n}")
  cli::cli_alert_warning("Non-shared columns in {name_dfx}: {nonshared_dfx_cols_n} ({x$pairs$nonshared_cols_dfx})")
  cli::cli_alert_warning("Non-shared columns in {name_dfy}: {nonshared_dfy_cols_n} ({x$pairs$nonshared_cols_dfy})")

  # Prompt the User to go ahead:
  response <- readline(prompt = "Press ENTER to continue or type 'q' to stop: ")
  if (tolower(response) == "q") {
    cli::cli_alert_success("End of Myrror Report")
    return(invisible(x))
  }


  # 1. Compare Type ----
  if (x$print$compare_type) {

    cli::cli_h1("1. Shared Columns Class Comparison")
    print(x$compare_type)

  }

  # Prompt the User to go ahead:
  response <- readline(prompt = "Press ENTER to continue or type 'q' to stop: ")
  if (tolower(response) == "q") {
    cli::cli_alert_success("End of Myrror Report")
    return(invisible(x))
  }

  # 3. Compare Values ----
  if (x$print$compare_values) {

    cli::cli_h1("2. Shared Columns Values Comparison")
    print(x$compare_values)

  }


  # 4. Extract different values (only type 1)




  cli::cli_alert_success("End of Myrror Report.")
  return(invisible(x))
}
