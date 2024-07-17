#' Print method for Myrror object.
#'
#' @param x
#' @param ...
#'
#' @export
#'
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
  cli::cli_text("\n")

  # Prompt the User to go ahead:
  response <- readline(prompt = "Press ENTER to continue or type 'q' to stop: ")
  if (tolower(response) == "q") {
    cli::cli_alert_success("End of Myrror Report")
    return(invisible(x))
  }


  # 1. Compare Type ----
  if (x$print$compare_type) {

    cli::cli_h1("1. Shared Columns Class Comparison")
    cli::cli_text("\n")

    ## Display only if there are differences:
    if (prod(x$compare_type$same_class) == 1) {

      cli::cli_alert_success("All shared columns have the same class.")
      cli::cli_text("\n")

    } else {
      n_diff_type_columns <- length(x$compare_type$same_class) - sum(x$compare_type$same_class)
      cli::cli_alert_warning("{n_diff_type_columns} shared column(s) have different classe(s):")
      cli::cli_text("\n")
      print(x$compare_type |> fsubset(same_class == FALSE) |> fselect(variable, class_x, class_y))
      cli::cli_text("\n")

  }

  }

  ## Prompt the User to go ahead:
  response <- readline(prompt = "Press ENTER to continue or type 'q' to stop: ")
  if (tolower(response) == "q") {
    cli::cli_alert_success("End of Myrror Report")
    return(invisible(x))
  }

  # 3. Compare Values ----
  if (x$print$compare_values) {

    cli::cli_h1("2. Shared Columns Values Comparison")
    cli::cli_text("\n")
    n_diff_values_columns <- length(x$compare_values$variable)

    if (n_diff_values_columns == 0) {
      cli::cli_alert_success("All shared columns have the same values.")
      cli::cli_text("\n")
    } else {
      cli::cli_alert_warning("{n_diff_values_columns} shared column(s) have different value(s):")
      cli::cli_alert_info("Note: character-numeric comparison is allowed.")
      cli::cli_text("\n")
      cli::cli_h2("Overview:")
      print(x$compare_values)
      cli::cli_text("\n")
    }


  }

  ## Prompt the User to go ahead:
  response <- readline(prompt = "Press ENTER to continue or type 'q' to stop: ")
  if (tolower(response) == "q") {
    cli::cli_alert_success("End of Myrror Report")
    return(invisible(x))
  }

  # 4. Extract different values (only diff_list) ----
  if (x$print$extract_diff_values) {

    n_diff_values_columns <- length(x$extract_diff_values$diff_list)

    if (n_diff_values_columns == 0) {
      cli::cli_alert_success("All shared columns have the same values.")
      cli::cli_text("\n")
    } else {
      cli::cli_text("\n")
      cli::cli_h2("Value comparison:")
      cli::cli_alert_warning("{n_diff_values_columns} shared column(s) have different value(s):")

      for (variable in names(x$extract_diff_values$diff_list)) {
        cli::cli_h3(variable)
        print(x$extract_diff_values$diff_list[[variable]])
        cli::cli_text("\n")

        # Prompt the user to continue or quit
        response <- readline(prompt = "Press ENTER to continue to next variable or type 'q' to stop: ")
        if (tolower(response) == "q") {
          cli::cli_alert_success("End of Myrror Report")
          return(invisible())  # Exit the function and return invisibly
        }
      }


      cli::cli_alert_info("Note: run extract_diff_values() to access the results in list or table format.")
      cli::cli_text("\n")
    }

  }



  # 5. Exit ----
  cli::cli_alert_success("End of Myrror Report.")
  return(invisible(x))
}
