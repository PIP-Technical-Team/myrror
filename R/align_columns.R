align_columns <- function(dfx,
                          dfy,
                          by,
                          by.x,
                          by.y,
                          control = list(tol.vars = NULL)) {

    # Align keys

    by.x <- keys$x
    by.y <- keys$y

    for (i in seq_along(by.x)) {
      if (by.y[i] %in% names(df2)) {
        # Record the column name changes for df2
        colname_changes_df2$old <- c(colname_changes_df2$old, by.y[i])
        colname_changes_df2$new <- c(colname_changes_df2$new, by.x[i])
        setnames(df2, old = by.y[i], new = by.x[i])
      }
    }

    # Implement tolerance adjustments based on 'control$tol.vars'
    if (!is.null(control$tol.vars) && length(control$tol.vars) > 0) {
      tol.vars <- control$tol.vars

      if(tol.vars$ignore_case) {
        names(df1) <- tolower(gsub(" ", "", names(df1)))
        names(df2) <- tolower(gsub(" ", "", names(df2)))
      }
      if(tol.vars$ignore_underscore) {
        names(df1) <- gsub("_", "", names(df1))
        names(df2) <- gsub("_", "", names(df2))
      }

      # Placeholder for additional complex adjustments
    }

    # Return adjusted datasets
    return(list(df1 = df1, df2 = df2))
  }
