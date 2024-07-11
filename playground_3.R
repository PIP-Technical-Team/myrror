# Extract diff logic
myrror_object <- create_myrror_object(iris, iris_var2)
compare_object <- compare_values(myrror_object = myrror_object, verbose = FALSE, output = "simple")

# 1. Subset of datasets ----
## Logic ----
compare_object$Species |>
  fsubset(count > 0) |>
  fselect(-count) |>
  tidyr::unnest(cols = c(indexes)) |>
  fmutate(indexes = as.character(indexes)) |>
  dplyr::left_join(myrror_object$merged_data_report$matched_data |>
                     fselect(rn, Species.x, Species.y), by = c("indexes" = "rn"))


processed_list <- purrr::imap(compare_object, function(df, variable) {
  column_x <- paste0(variable, ".x")
  column_y <- paste0(variable, ".y")

  df %>%
    dplyr::filter(count > 0) %>%
    dplyr::select(-count) %>%
    tidyr::unnest(cols = c(indexes)) %>%
    dplyr::mutate(indexes = as.character(indexes)) %>%
    dplyr::left_join(myrror_object$merged_data_report$matched_data %>%
                dplyr::select(rn, all_of(column_x), all_of(column_y)),
                by = c("indexes" = "rn"))

})

## Clean-up ----
non_empty_processed_list <- purrr::keep(processed_list, ~ nrow(.x) > 0)

# Return
non_empty_processed_list

# 2. Complete data table ----
rowbind(compare_object, idcol = "variable") |>
  fsubset(count > 0) |>
  fselect(-count)|>
  tidyr::unnest(cols = c(indexes)) |> # is there a better version of unnest?
  fmutate(indexes = as.character(indexes)) |>
  dplyr::left_join(myrror_object$merged_data_report$matched_data, by = c("indexes" = "rn")) |>
  #dplyr::select(variable, diff, indexes, dplyr::starts_with("Sepal.Width"))



extract_diff_values(myrror_object = myrror_object, output = "simple")
