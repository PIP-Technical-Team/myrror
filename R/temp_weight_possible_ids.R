temp_weight_possible_ids <- function(df,
                              max_combination_size = 5,
                              verbose = FALSE,
                              print_first = 4) {

  # 1. Convert to data.table + get df info
  df <- as.data.table(df)
  vars <- names(df)
  n_rows <- nrow(df)

  # 2. Get variable info
  var_info <- data.table(
    var = vars,
    unique_count = sapply(df, function(x) length(unique(x))),
    var_type = sapply(df, function(x) {
      if (is.factor(x) || is.character(x)) "categorical" else "continuous"
    })
  )

  # 3. Generate all variable combinations
  all_combos <- list()
  for (k in 1:max_combination_size) {
    combos_k <- utils::combn(vars, k, simplify = FALSE)
    all_combos <- c(all_combos, combos_k)
  }

  # 4. Score each combination
  combo_scores <- lapply(all_combos, function(combo) {
    vars_in_combo <- var_info[var %in% combo]

    # 1. Cardinality Score (less unique values = higher score)
    C_s <- 1 / sum(vars_in_combo$unique_count)

    # 2. Type Score (categorical - higher score)
    T_s <- sum(vars_in_combo$var_type == "categorical")

    # 3. Size Score (more combo vars = higher score)
    S_s <- if (length(combo) > 1) 1 / length(combo) else 0  # Penalize single vars

    # 4. Adjust score with subjective weights (can change)
    w_c <- 0.5; w_t <- 0.3; w_s <- 0.2;
    Total_s <- w_c * C_s + w_t * T_s + w_s * S_s

    list(combo = combo, score = Total_s)
  })

  # Sort combinations by weighted score
  combo_scores <- combo_scores[order(sapply(combo_scores, function(x) -x$score))]

  # Check for uniqueness and collect combinations
  unique_ids_list <- list()
  for (cs in combo_scores) {
    combo <- cs$combo
    n_unique_rows <- nrow(unique(df[, ..combo]))
    if (n_unique_rows == n_rows) {
      if (verbose) {
        message(paste("Found unique combination:", paste(combo, collapse = ", "), "with score:", cs$score))
      }
      unique_ids_list <- c(unique_ids_list, list(combo))
    }
  }

  if (length(unique_ids_list) == 0) {
    if (verbose) {
      message("No unique identifier found.")
    }
    return(NULL)
  }

  # return first N combinations selected by user only
  if (print_first > 0) {
    return(unique_ids_list[1:min(print_first, length(unique_ids_list))])
  }

}
