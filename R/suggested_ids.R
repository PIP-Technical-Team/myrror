#' Identify Suggested Keys or IDs for Data Frame
#'
#' This function attempts to find potential unique identifier columns or combinations
#' for a given data frame. It first tries to identify single-column keys, then
#' two-column key combinations that uniquely identify each row in the data frame.
#'
#' @param df A data frame for which to identify potential unique identifiers
#'
#' @return A list containing up to two elements:
#'   \item{1}{The first single-column key identified (if any)}
#'   \item{2}{The first two-column key combination identified (if any)}
#'   Returns NULL if no valid keys were found.
#'
#' @details Uses the joyn::possible_ids function to identify columns or column 
#'   combinations that can uniquely identify rows in the data frame.
#'
#' @keywords internal
#'
suggested_ids <- function(df) {

  # GC Note: temporary solution which uses min_combination_size = 1
  # + max_combination_size = 1 and min/max_combination_size = 2
  # to get the first option and the first combo.

  # Try to find possible keys with single-column combinations
    possible_ids_df_one <- tryCatch(
      joyn::possible_ids(df, verbose = FALSE, min_combination_size = 1, max_combination_size = 1),
      error = function(e) NULL
    )

  # Try to find possible keys with two-column combinations
    possible_ids_df_combo <- tryCatch(
      joyn::possible_ids(df, verbose = FALSE, min_combination_size = 2, max_combination_size = 2),
      error = function(e) NULL
    )

  # Ensure both results are not NULL but check if they are empty lists
    if (is.null(possible_ids_df_one) || length(possible_ids_df_one) == 0) {
      possible_ids_df_one <- NULL
    }

    if (is.null(possible_ids_df_combo) || length(possible_ids_df_combo) == 0) {
      possible_ids_df_combo <- NULL
    }

    # If both are NULL, return NULL
    if (is.null(possible_ids_df_one) && is.null(possible_ids_df_combo)) {
      return(NULL)
    }

    # Select suggestions
    suggested_ids_df <- list()

    if (!is.null(possible_ids_df_one)) {
      suggested_ids_df <- append(suggested_ids_df, list(possible_ids_df_one[[1]][1]))
    }

    if (!is.null(possible_ids_df_combo)) {
      suggested_ids_df <- append(suggested_ids_df, list(possible_ids_df_combo[[1]]))
    }

    # Ensure the function returns NULL if no valid keys were found
    if (length(suggested_ids_df) == 0) {
      return(NULL)
    }

    return(suggested_ids_df)
  }
