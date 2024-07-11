# Extract diff logic
myrror_object <- create_myrror_object(iris, iris_var4)


compare_type(myrror_object = myrror_object, verbose = FALSE, output = "myrror_object")



compare_object <- compare_values(myrror_object = myrror_object, verbose = FALSE, output = "simple")

# 1. Subset of datasets
compare_object$Species |>
  fsubset(count > 0) |>
  fselect(-count) |>
  tidyr::unnest(cols = c(indexes)) |>
  fmutate(indexes = as.character(indexes)) |>
  dplyr::left_join(myrror_object$merged_data_report$matched_data |>
                     fselect(rn, Species.x, Species.y), by = c("indexes" = "rn"))

processed_list <- purrr::imap(compare_object, function(df, name) {
  column_x <- paste0(name, ".x")
  column_y <- paste0(name, ".y")

  df %>%
    dplyr::filter(count > 0) %>%
    dplyr::select(-count) %>%
    tidyr::unnest(cols = c(indexes)) %>%
    dplyr::mutate(indexes = as.character(indexes)) %>%
    dplyr::left_join(myrror_object$merged_data_report$matched_data %>%
                dplyr::select(rn, all_of(column_x), all_of(column_y)), by = c("indexes" = "rn"))
})



# 2. Data table
rowbind(compare_object, idcol = "variable") |>
  fsubset(count > 0) |>
  fselect(-count)|>
  tidyr::unnest(cols = c(indexes)) |> # is there a better version of unnest?
  fmutate(indexes = as.character(indexes)) |>
  dplyr::left_join(myrror_object$merged_data_report$matched_data, by = c("indexes" = "rn")) |>
  #dplyr::select(variable, diff, indexes, dplyr::starts_with("Sepal.Width"))



