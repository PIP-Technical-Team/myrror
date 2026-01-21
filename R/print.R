#' Print method for Myrror object.
#'
#' @param x an object of class 'myrror_object'
#' @param ... additional arguments
#'
#' @return Invisibly returns the myrror object `x`. Called for side effects (printing comparison report to console).
#'
#' @examples
#' # Create example datasets
#' dfx <- data.frame(id = 1:5,
#'                   name = c("A", "B", "C", "D", "E"),
#'                   value = c(10, 20, 30, 40, 50))
#'
#' dfy <- data.frame(id = 1:6,
#'                   name = c("A", "B", "C", "D", "E", "F"),
#'                   value = c(10, 20, 35, 40, 50, 60))
#'
#' # Create a myrror object
#' library(myrror)
#' m <- myrror(dfx, dfy, by.x = "id", by.y = "id")
#'
#' # Print the myrror object (happens automatically)
#' m
#'
#' # Create object with different print settings
#' \donttest{
#' # With interactive mode disabled
#' m2 <- myrror(dfx, dfy, by.x = "id", by.y = "id", interactive = FALSE)
#' print(m2)
#' }
#'
#' @export
print.myrror <- function(x, ...) {
  # 1. General ----
  shared_cols_n <- nrow(x$pairs$pairs)
  shared_rows_n <- nrow(x$merged_data_report$matched_data)
  nonshared_dfy_cols <- setdiff(x$pairs$nonshared_cols_dfy, x$set_by.y)
  nonshared_dfx_cols <- setdiff(x$pairs$nonshared_cols_dfx, x$set_by.x)
  nonshared_dfx_cols_n <- length(nonshared_dfx_cols)
  nonshared_dfy_cols_n <- length(nonshared_dfy_cols)
  nonshared_dfy_cols <- setdiff(x$pairs$nonshared_cols_dfy, x$set_by.y)
  nonshared_dfx_cols <- setdiff(x$pairs$nonshared_cols_dfx, x$set_by.x)
  nonshared_dfx_cols_n <- length(nonshared_dfx_cols)
  nonshared_dfy_cols_n <- length(nonshared_dfy_cols)
  name_dfx <- x$name_dfx
  name_dfy <- x$name_dfy

  cli::cli_h2("General Information:")
  cli::cli_text(
    "{.strong dfx}: {.field {name_dfx}} with {x$datasets_report$dfx_char$nrow} rows and {x$datasets_report$dfx_char$ncol} columns."
  )
  cli::cli_text(
    "{.strong dfy}: {.field {name_dfy}} with {x$datasets_report$dfy_char$nrow} rows and {x$datasets_report$dfy_char$ncol} columns."
  )
  # Check if by.x is equal to by.y
  if (all(x$set_by.x == x$set_by.y)) {
    cli::cli_text("{.strong keys}: {x$set_by.x}.")
  } else {
    cli::cli_text("{.strong keys dfx}: {x$set_by.x}.")
    cli::cli_text("{.strong keys dfy}: {x$set_by.y}.")
  }

  cli::cli_h2("Note: comparison is done for shared columns and rows.")
  cli::cli_alert_success("Total shared columns (no keys): {shared_cols_n}")
  cli::cli_alert_warning(
    "Non-shared columns in {name_dfx}: {nonshared_dfx_cols_n} ({.val {nonshared_dfx_cols}})"
  )
  cli::cli_alert_warning(
    "Non-shared columns in {name_dfy}: {nonshared_dfy_cols_n} ({.val {nonshared_dfy_cols}})"
  )
  cli::cli_text("\n")
  cli::cli_alert_success("Total shared rows: {shared_rows_n}")
  cli::cli_alert_warning(
    "Non-shared rows in {name_dfx}: {max(x$datasets_report$dfx_char$nrow - shared_rows_n, 0)}."
  )
  cli::cli_alert_warning(
    "Non-shared rows in {name_dfy}: {max(x$datasets_report$dfy_char$nrow - shared_rows_n, 0)}."
  )

  if (
    x$datasets_report$dfx_char$nrow - shared_rows_n > 0 ||
      x$datasets_report$dfy_char$nrow - shared_rows_n > 0
  ) {
    cli::cli_text("\n")
    cli::cli_alert_info(
      "Note: run {.fn extract_diff_rows} to extract the missing/new rows."
    )
  } else {
    cli::cli_text("\n")
    cli::cli_alert_success("There are no missing or new rows.")
  }

  # 1. Compare Type ----
  if (x$print$compare_type) {
    # Prompt the User to go ahead if x$interactive == TRUE:
    if (x$interactive) {
      response <- my_readline(
        prompt = "Press ENTER to continue or type 'q' to stop: "
      )
      if (tolower(response) == "q") {
        cli::cli_alert_success("End of Myrror Report")
        return(invisible(x))
      }
    }

    cli::cli_h1("1. Shared Columns Class Comparison")
    cli::cli_text("\n")

    ## Display only if there are differences:
    if (prod(x$compare_type$same_class) == 1) {
      cli::cli_alert_success("All shared columns have the same class.")
      cli::cli_text("\n")
    } else {
      n_diff_type_columns <- length(x$compare_type$same_class) -
        sum(x$compare_type$same_class)
      cli::cli_alert_warning(
        "{n_diff_type_columns} shared column(s) have different class(es):"
      )
      cli::cli_text("\n")
      print(
        x$compare_type |>
          fsubset(same_class == FALSE) |>
          fselect(variable, class_x, class_y)
      )
      cli::cli_text("\n")
    }
  }

  # 3. Compare Values ----
  if (x$print$compare_values) {
    # Prompt the User to go ahead if x$interactive == TRUE:
    if (x$interactive) {
      response <- my_readline(
        prompt = "Press ENTER to continue or type 'q' to stop: "
      )
      if (tolower(response) == "q") {
        cli::cli_alert_success("End of Myrror Report")
        return(invisible(x))
      }
    }

    cli::cli_h1("2. Shared Columns Values Comparison")
    cli::cli_text("\n")
    n_diff_values_columns <- length(x$compare_values$variable)

    if (n_diff_values_columns == 0) {
      cli::cli_alert_success("All shared columns have the same values.")
      cli::cli_text("\n")
    } else {
      cli::cli_alert_warning(
        "{n_diff_values_columns} shared column(s) have different value(s):"
      )
      cli::cli_alert_info("Note: character-numeric comparison is allowed.")
      cli::cli_text("\n")
      cli::cli_h2("Overview:")
      print(x$compare_values)
      cli::cli_text("\n")
    }
  }

  # 4. Extract different values (only diff_list) ----
  if (x$print$extract_diff_values) {
    # Prompt the User to go ahead if x$interactive == TRUE:
    if (x$interactive) {
      response <- my_readline(
        prompt = "Press ENTER to continue or type 'q' to stop: "
      )
      if (tolower(response) == "q") {
        cli::cli_alert_success("End of Myrror Report")
        return(invisible(x))
      }
    }

    n_diff_values_columns <- length(x$extract_diff_values$diff_list)

    if (n_diff_values_columns == 0) {
      cli::cli_alert_success("All shared columns have the same values.")
      cli::cli_text("\n")
    } else {
      cli::cli_text("\n")
      cli::cli_h2("Value comparison:")
      cli::cli_alert_warning(
        "{n_diff_values_columns} shared column(s) have different value(s):"
      )
      cli::cli_alert_info("Note: Only first 5 rows shown for each variable.")

      for (variable in names(x$extract_diff_values$diff_list)) {
        cli::cli_h3("{.val {variable}}")
        nrows <- ifelse(
          nrow(x$extract_diff_values$diff_list[[variable]]) > 5,
          5,
          nrow(x$extract_diff_values$diff_list[[variable]])
        )
        print(x$extract_diff_values$diff_list[[variable]][1:nrows])
        cli::cli_text("...")
        cli::cli_text("\n")

        # Prompt the User to go ahead if x$interactive == TRUE:
        if (x$interactive) {
          response <- my_readline(
            prompt = "Press ENTER to continue or type 'q' to stop: "
          )
          if (tolower(response) == "q") {
            cli::cli_alert_success("End of Myrror Report")
            return(invisible(x))
          }
        }

        cli::cli_alert_info(
          "Note: run {.fn extract_diff_values} or {.fn extract_diff_table} to access the results in list or table format."
        )
        cli::cli_text("\n")
      }
    }

    # 6. Exit ----
    cli::cli_alert_success("End of Myrror Report.")
    return(invisible(x))
  }
}
