
#' Compare type of variables
#'
#' @param myrror_object myrror object from [create_myrror_object]
#' @param output character: one of "full", "simple", "silent"
#' @inheritParams myrror
#'
#' @return list object
#' @export
#'
#' @examples
#' comparison <- compare_type(iris, iris_var1)
#'
compare_type <- function(dfx = NULL,
                         dfy = NULL,
                         myrror_object = NULL,
                         by = NULL,
                         by.x = NULL,
                         by.y = NULL,
                         output = c("full", "simple", "silent"),
                         interactive = getOption("myrror.interactive"),
                         verbose = getOption("myrror.verbose")
                         ){
  # 1. Arguments check ----
  output <- match.arg(output)

  # 2. Capture all arguments as a list
  args <- as.list(environment())

  # 3. Create object if not supplied ----
  myrror_object <- do.call(get_correct_myrror_object, args)

  # 4. Run compare_type_int() and update myrror_object ----
  myrror_object$compare_type <- compare_type_int(myrror_object)

  # 5. Save whether interactive or not ----
  myrror_object$interactive <- interactive

  # 6. Save to package environment ----
  rlang::env_bind(.myrror_env, last_myrror_object = myrror_object)

  # 7. Output ----
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
    fmutate(variable = gsub(".x", "", column_x))|>
    fselect(variable, class_x, class_y, same_class)

  # 3. Resturn results ----
  return(compare_type)

}
