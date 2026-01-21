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
#' @keywords internal
suggested_ids <- function(df) {
  # Handle empty data frames early
  if (ncol(df) == 0 || nrow(df) == 0) {
    return(NULL)
  }

  # --- Special handling for single-column data frames ---
  if (ncol(df) == 1) {
    col <- names(df)[1]
    if (length(unique(df[[col]])) == nrow(df)) {
      return(list(col))
    } else {
      return(NULL)
    }
  }

  # --- Use joyn for 1-column and 2-column combinations ---

  # Try to find possible 1-column IDs
  possible_ids_df_one <- tryCatch(
    joyn::possible_ids(
      df,
      verbose = FALSE,
      min_combination_size = 1,
      max_combination_size = 1
    ),
    error = function(e) NULL
  )

  # Try to find possible 2-column combinations
  possible_ids_df_combo <- tryCatch(
    joyn::possible_ids(
      df,
      verbose = FALSE,
      min_combination_size = 2,
      max_combination_size = 2
    ),
    error = function(e) NULL
  )

  # Normalize empty or NULL results
  if (is.null(possible_ids_df_one) || length(possible_ids_df_one) == 0) {
    possible_ids_df_one <- NULL
  }

  if (is.null(possible_ids_df_combo) || length(possible_ids_df_combo) == 0) {
    possible_ids_df_combo <- NULL
  }

  # If neither found anything, return NULL
  if (is.null(possible_ids_df_one) && is.null(possible_ids_df_combo)) {
    return(NULL)
  }

  # Build suggestions list
  suggested_ids_df <- list()

  if (!is.null(possible_ids_df_one)) {
    suggested_ids_df <- append(
      suggested_ids_df,
      list(possible_ids_df_one[[1]][1])
    )
  }

  if (!is.null(possible_ids_df_combo)) {
    suggested_ids_df <- append(
      suggested_ids_df,
      list(possible_ids_df_combo[[1]])
    )
  }

  # Return NULL if nothing valid ended up in the list
  if (length(suggested_ids_df) == 0) {
    return(NULL)
  }

  return(suggested_ids_df)
}
