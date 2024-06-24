extract_diff_values <- function(dfx = NULL,
                         dfy = NULL,
                         myrror_object = NULL,
                         output = c("compare", "myrror")) {

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

      })

      # 3. Extract differences ----
      # It takes the indexes from compare_values() and extracts those values
      # from the original (prepared) dataframes

}

myrror_object <- create_myrror_object(iris, iris_var1)
compare_values_output <- compare_values(iris, iris_var1, output = "myrror")
value_to_na_indexes <- compare_values_output$Sepal.Length$indexes[[1]]

myrror_object$merged_data_report$matched_data |>
  fsubset(row_index.x %in% value_to_na_indexes)




