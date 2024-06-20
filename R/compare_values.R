# compare_values ---------------------------------------------------------------
compare_values <- function(myrror_object,
                            pairs) {



}

compare_values(myrror_object,
              pairs = pairs)


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







