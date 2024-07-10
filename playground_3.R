
# logic using only
myrror_object <- create_myrror_object(iris, iris_var4)


compare_type(myrror_object = myrror_object, verbose = FALSE, output = "myrror_object")



compare_object <- compare_values(myrror_object = myrror_object, verbose = FALSE, output = "simple")

rowbind(compare_object, idcol = "variable") |>
  fsubset(count > 0) |>
  fselect(-count)|>
  tidyr::unnest(cols = c(indexes)) |>
  fmutate(indexes = as.character(indexes)) |>
  dplyr::left_join(myrror_object$merged_data_report$matched_data, by = c("indexes" = "rn"))

