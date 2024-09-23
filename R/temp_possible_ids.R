#' Temporary possible_ids() function
#'
#' @param df data.frame
#' @param max_combination_size integer
#' @param verbose logical
#'
#' @return vector of possible ids
#' @keywords internal
temp_possible_ids <- function(df,
                         max_combination_size = 5,
                         verbose = FALSE) {

  # 1. Make into data.table
  df <- as.data.table(df)

  # 2. Store variable names
  vars <- names(df)

  # 3. Calculate unique counts and sort by count (ascending)
  unique_counts <- vapply(df[, ..vars], function(x) length(unique(x)), numeric(1))
  n_rows <- nrow(df)

  vars <- vars[order(unique_counts)]
  unique_counts <- unique_counts[order(unique_counts)]

  # 4. Option 1: Check combinations of low-unique-value columns
  for (comb_size in 2:max_combination_size) {

    combos <- utils::combn(vars, comb_size, simplify = FALSE)

    for (combo in combos) {
      # Test if the combination uniquely identifies rows
      if (nrow(unique(df[, ..combo])) == n_rows) {
        if (verbose) message(paste("Found unique combination:", paste(combo, collapse = ", ")))
        return(combo)  # Return the combination as the identifier
      }
    }
  }

  # 5. Option 2: Fallback - If no combinations found, try single variables with high uniqueness
  for (var in vars) {
    if (length(unique(df[[var]])) == n_rows) {
      if (verbose) message(paste("Single unique identifier found:", var))
      return(var)  # Return the variable as the identifier
    }
  }

  # If no identifier found, return NULL
  if (verbose) message("No unique identifier found.")
  return(NULL)
}
