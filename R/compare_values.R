# compare_values ---------------------------------------------------------------
#' Compare values of matched datasets
#'
#' @param dfx
#' @param dfy
#' @param myrror_object
#' @param output
#'
#' @return
#' @export
#'
#' @examples
#'
#' comparison <- compare_values(iris, iris_var1)
#'
compare_values <- function(dfx = NULL,
                           dfy = NULL,
                           myrror_object = NULL,
                           output = c("full", "simple", "silent")) {

  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx, dfy = dfy)

    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }


  # 3. Run compare_values_int() ----
  myrror_object$compare_values <- compare_values_int(myrror_object)



  # 2. Output ----

  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$compare_values <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$compare_values <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$compare_values)
         }
  )


}

# compare_values internal -----------------------------------------------------
compare_values_int <- function(myrror_object = NULL) {

  # 1. Pair columns ----
  merged_data_report <- myrror_object$merged_data_report
  pairs <- myrror_object$pairs

  # 3. Pairs list ----
  # GC Note: probably not the cleanest solution, need to change this.
  pairs_list <- lapply(seq_len(nrow(pairs$pairs)), function(i) {
    c(pairs$pairs$col_x[i], pairs$pairs$col_y[i])
  })

  # 4. Get changes ----
  value_to_na <- get_value_to_na(myrror_object$merged_data_report$matched_data, pairs_list)
  names(value_to_na) <- gsub(".x", "", pairs$pairs$col_x)

  na_to_value <- get_na_to_value(myrror_object$merged_data_report$matched_data, pairs_list)
  names(na_to_value) <- gsub(".x", "", pairs$pairs$col_x)

  change_in_value <- get_change_in_value(myrror_object$merged_data_report$matched_data, pairs_list)
  names(na_to_value) <- gsub(".x", "", pairs$pairs$col_x)

  # 5. Combine all changes ----
  all_changes <- mapply(function(x, y, z) {
    rbind(x, y, z)
  }, value_to_na, na_to_value, change_in_value, SIMPLIFY = FALSE)

  # 6. Return ----
  return(all_changes)

}



# compare_values utils ---------------------------------------------------------
## 1. Get value to NA
get_value_to_na <- function(matched_data,
                              pairs_list) {

  result <- purrr::map(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(!is.na(get(col_x)) & is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "value_to_na")|>
      colorder(diff, count, indexes)

  })


  return(result)

}

## 2. Get NA to value
get_na_to_value <- function(matched_data,
                              pairs_list) {

  result <- purrr::map(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(is.na(get(col_x)) & !is.na(get(col_y))) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "na_to_value")|>
      colorder(diff, count, indexes)
  })

}

## 3. Get change in value
get_change_in_value <- function(matched_data,
                                  pairs_list) {

  result <- purrr::map(pairs_list, function(pair) {

    col_x <- pair[[1]]
    col_y <- pair[[2]]

    matched_data |>
      fselect(c(col_x, col_y, "row_index.x", "row_index.y")) |>
      fsubset(get(col_x) != get(col_y)) |>
      fsummarise(indexes = list(row_index.x),
                 count = fnobs(row_index.x)) |>
      fmutate(diff = "change_in_value")|>
      colorder(diff, count, indexes)
  })

  return(result)

}













