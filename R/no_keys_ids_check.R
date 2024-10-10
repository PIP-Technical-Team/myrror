

no_keys_ids_check <- function(df,
                              set_by) {

  if ("rn" %in% set_by$by.x) {

    # 1. Find possible keys for both datasets
    possible_ids_df <- joyn::possible_ids(df, get_all = TRUE, verbose = FALSE)

    # 2. Select suggestions
    if (length(possible_ids_df) > 0) {
      combos <- Filter(function(x) length(x) > 1, possible_ids_df)
    }


    suggested_ids_df <- list(possible_ids_df[[1]][1], combos[[1]])

    return(suggested_ids_df)
  } else {
    return(NULL)
  }

}


