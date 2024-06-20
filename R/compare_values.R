# compare_values ---------------------------------------------------------------
compare_values <- function(myrror_object,
                            pairs) {
  pairs_list <- lapply(seq_len(nrow(pairs$pairs)), function(i) {
    c(pairs$pairs$col_x[i], pairs$pairs$col_y[i])
  })

  value_to_na <- get_value_to_na(myrror_object$merged_data_report, pairs_list)
  na_to_value <- get_na_to_value(myrror_object$merged_data_report, pairs_list)
  change_in_value <- get_change_in_value(myrror_object$merged_data_report, pairs_list)

  all_changes <- mapply(function(x, y, z) {
    rbind(x, y, z)
  }, value_to_na, na_to_value, change_in_value, SIMPLIFY = FALSE)

  return(all_changes)
}



# compare_values utils ---------------------------------------------------------
## 1. Get value to NA
get_value_to_na <- function(matched_data,
                              pairs) {

  result <- purrr::map(pairs, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    myrror_object$merged_data_report$matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(!is.na(get(col_x)) & is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "value_to_na")
  })

  return(result)

}

## 2. Get NA to value
get_na_to_value <- function(matched_data,
                              pairs) {

  result <- purrr::map(pairs, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    myrror_object$merged_data_report$matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(is.na(get(col_x)) & !is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "na_to_value")
  })

  return(result)

}

## 3. Get change in value
get_change_in_value <- function(matched_data,
                                  pairs) {

  result <- purrr::map(pairs, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    myrror_object$merged_data_report$matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(get(col_x) != get(col_y)) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "change_in_value")
  })

  return(result)

}










