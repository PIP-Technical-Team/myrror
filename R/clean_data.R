library(data.table)
library(cli)

clean_data <- function(df, keys = NULL) {

  # Check if NA, if so, return error
  if (is.null(df)) {

  }

  print
  # Convert dataframe to data.table, if not already a data.frame
  if (!is.data.table(df)) {
    df <- as.data.table(df)
  }
}
