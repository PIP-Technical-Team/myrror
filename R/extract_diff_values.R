
# Objective: extract_diff_values() : depends on indexes identified in compare_values(),
# The function will go through each dataset associated with each variable stored
# in the output of compare_values() and select the the indexes when count > 0.
# Then it will return a list with a subset-dataset for each variable, with the
# observations identified by the selected indexes. These observations will be
# identified by the type of diff: value_to_na, na_to_value, change_in_value.
# The function will return:
# 1. A list with a 'subset-dataset for each variable', with the observations that
# are different in value (only that variable from dfx and dfy and the id).
# 2. Another pivoted "complete" data.table (all variables with id) with all observations
# for which variables are different: the user can then select the variables they want to keep.

extract_diff_value_int <- function(myrror_object = NULL) {

  # 1. Get indexes and data ----
  compare_values_object <- compare_values_int(myrror_object = myrror_object)
  matched_data <- myrror_object$merged_data_report$matched_data


  # 2. List option -----
  diff_list <- purrr::imap(compare_values_object, function(df, variable) {
    column_x <- paste0(variable, ".x")
    column_y <- paste0(variable, ".y")

    df %>%
      dplyr::filter(count > 0) |>
      dplyr::select(-count) |>
      tidyr::unnest(cols = c(indexes)) %>%
      dplyr::mutate(indexes = as.character(indexes)) |>
      dplyr::left_join(matched_data |>
                         dplyr::select(rn, all_of(column_x),
                                       all_of(column_y)),
                       by = c("indexes" = "rn"))

  })

  non_empty_diff_list <- purrr::keep(processed_list, ~ nrow(.x) > 0)

  # 3. Table option ----
  diff_table <- rowbind(compare_values_object, idcol = "variable") |>
    fsubset(count > 0) |>
    fselect(-count)|>
    tidyr::unnest(cols = c(indexes)) |> # is there a better version of unnest?
    fmutate(indexes = as.character(indexes)) |>
    dplyr::left_join(matched_data, by = c("indexes" = "rn"))


  # 4. Store and Return ----
  result <- list(
    diff_list = diff_list,
    diff_table = diff_table
  )

  return(result)

}





