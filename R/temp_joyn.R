# Temporary imports from Joyn
# Add global variables to avoid NSE notes in R CMD check
if (getRversion() >= '2.15.1')
  utils::globalVariables(
    c('N', '.', 'copies')
  )

#' Check if dt is uniquely identified by `by` variable
#'
#' report if dt is uniquely identified by `by` var or, if report = TRUE, the duplicates in `by` variable
#'
#' @param dt either right of left table
#' @param verbose logical: if TRUE messages will be displayed
#' @param by variable to merge by
#' @param return_report logical: if TRUE, returns data with summary of duplicates.
#' If FALSE, returns logical value depending on whether `dt` is uniquely identified
#' by `by`
#'
#' @return logical or data.frame, depending on the value of argument `return_report`
#' @export
#'
#' @examples
#' library(data.table)
#'
#' # example with data frame not uniquely identified by `by` var
#'
#' y <- data.table(id = c("c","b", "c", "a"),
#'                  y  = c(11L, 15L, 18L, 20L))
#' is_id(y, by = "id")
#' is_id(y, by = "id", return_report = TRUE)
#'
#' # example with data frame uniquely identified by `by` var
#'
#' y1 <- data.table(id = c("1","3", "2", "9"),
#'                  y  = c(11L, 15L, 18L, 20L))
#' is_id(y1, by = "id")
temp_is_id <- function(dt,
                  by,
                  verbose  = getOption("joyn.verbose", default = FALSE),
                  return_report  = FALSE) {

  # Ensure dt is a data.table
  if (!is.data.table(dt)) {
    dt <- as.data.table(dt)
  }

  # Check for duplicates
  is_id <- !(anyDuplicated(dt, by = by) > 0)


  if (verbose) {
    if (is_id) {
      cli::cli_alert_success("No duplicates found by {.code {by}}")
    } else {
      cli::cli_alert_warning("Duplicates found by: {.code {by}}")
    }
  }

  if (return_report) {

    d <- temp_freq_table(x = dt,
                    byvar = by,
                    freq_var_name = "copies")

    if (verbose) {

      cli::cli_h3("Duplicates in terms of {.code {by}}")

      d |>
        fsubset(copies > 1) |>
        print()

      cli::cli_rule(right = "End of {.field is_id()} report")

    }
    return(invisible(d))
  } else {
    return(is_id)
  }
}



#' Tabulate simple frequencies
#'
#' tabulate one variable frequencies
#'
#' @param x  data frame
#' @param byvar character: name of variable to tabulate. Use Standard evaluation.
#' @param digits numeric: number of decimal places to display. Default is 1.
#' @param na.rm logical: report NA values in frequencies. Default is FALSE.
#'
#' @return data.table with frequencies.
#' @export
#'
#' @examples
#' library(data.table)
#' x4 = data.table(id1 = c(1, 1, 2, 3, 3),
#'                 id2 = c(1, 1, 2, 3, 4),
#'                 t   = c(1L, 2L, 1L, 2L, NA_integer_),
#'                 x   = c(16, 12, NA, NA, 15))
#' freq_table(x4, "id1")
temp_freq_table <- function(x,
                       byvar,
                       digits = 1,
                       na.rm  = FALSE,
                       freq_var_name = "n") {

  x_name <- as.character(substitute(x))

  if (!is.data.frame(x)) {
    cli::cli_abort("Argument {.arg x} ({.field {x_name}}) must be a data frame")
  }

  dt <- as.data.table(x)

  fq <- qtab(dt[, ..byvar], dnn = byvar, na.exclude = na.rm)


  ft <- fq |>
    as.data.table() |>
    setnames("N", "n") |>
    fsubset(n > 0)

  # Calculate total N
  N <- sum(ft$n)

  # Percent column
  ft[, percent := paste0(round(n / N * 100, digits), "%")]

  # Total row
  total_row <- as.list(rep("total", length(byvar)))
  names(total_row) <- byvar
  total_row <- c(total_row, list(n = N, percent = "100%"))
  total_row <- as.data.table(total_row)

  # Rbind
  ft <- rbind(ft, total_row, fill = TRUE) |>
    setnames("n", freq_var_name)

  return(ft)
}
