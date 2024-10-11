#' Suggested keys/ids
#'
#' @param df data.frame
#'
#' @return list with suggested keys/ids (first option and first combo)
#'
suggested_ids <- function(df) {


    # 1. Find possible keys for both datasets
    possible_ids_df <- joyn::possible_ids(df, get_all = TRUE, verbose = FALSE)

    # 2. Select suggestions
    if (length(possible_ids_df) > 0) {
      combos <- Filter(function(x) length(x) > 1, possible_ids_df)
      suggested_ids_df <- list(possible_ids_df[[1]][1], combos[[1]])
    } else {
      suggested_ids_df <- list(NULL)
    }

    return(suggested_ids_df)

}


