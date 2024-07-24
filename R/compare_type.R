
#' Compare type of variables
#'
#' @param dfx data.frame object
#' @param dfy data.frame object
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param myrror_object myrror object
#' @param output character, one of "full", "simple", "silent"
#'
#' @return list object
#' @export
#'
#' @examples
#' comparison <- compare_type(iris, iris_var1)
#'
compare_type <- function(dfx = NULL,
                         dfy = NULL,
                         by = NULL,
                         by.x = NULL,
                         by.y = NULL,
                         myrror_object = NULL,
                         output = c("full", "simple", "silent")) {
  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Create object if not supplied ----
  if (is.null(myrror_object)) {
    if (is.null(dfx) || is.null(dfy)) {
      stop("Both 'dfx' and 'dfy' must be provided if 'myrror_object' is not supplied.")
    }

    myrror_object <- create_myrror_object(dfx = dfx,
                                          dfy = dfy,
                                          by = by,
                                          by.x = by.x,
                                          by.y = by.y)
    ## Re-assign names from within this call:
    myrror_object$name_dfx <- deparse(substitute(dfx))
    myrror_object$name_dfy <- deparse(substitute(dfy))

  }

  # 3. Run compare_type_int() and update myrror_object ----
  myrror_object$compare_type <- compare_type_int(myrror_object)



  # 2. Output ----

  ## Handle the output type
  switch(output,
         full = {
           myrror_object$print$compare_type <- TRUE
           return(myrror_object)
         },
         silent = {
           myrror_object$print$compare_type <- TRUE
           return(invisible(myrror_object))
         },
         simple = {
           return(myrror_object$compare_type)
         }
  )

}




#' Compare type of variables, internal function.
#'
#' @param myrror_object myrror object
#'
#' @return data.table object
#'
compare_type_int <- function(myrror_object = NULL){

  # 1. Pair columns ----
  merged_data_report <- myrror_object$merged_data_report
  pairs <- myrror_object$pairs


  # 2. Compare types ----
  compare_type <- lapply(seq_len(nrow(pairs$pairs)), function(i) {
    row <- pairs$pairs[i, ]
    list(
      column_x = row$col_x,
      column_y = row$col_y,
      class_x = class(merged_data_report$matched_data[[row$col_x]]),
      class_y = class(merged_data_report$matched_data[[row$col_y]]),
      same_class = class(merged_data_report$matched_data[[row$col_x]]) == class(merged_data_report$matched_data[[row$col_y]])
    )
  })

  compare_type <- rbindlist(compare_type)

  compare_type <- compare_type |>
    collapse::fmutate(variable = gsub(".x", "", column_x))|>
    collapse::fselect(variable, class_x, class_y, same_class)

  # 3. Resturn results ----
  return(compare_type)

}
