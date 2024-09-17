# Alignment procedure based on daff.js library
# Note: When keys are not provided, daff.js uses an adaptation of the
# Patience Diff algorithm, which is a hybrid between the
# Longest Common Subsequence (LCS) algorithm and simpler approaches
# like Hunt–Szymanski and Myers' Diff.

dfx <- iris
dfy <- iris_var6

# align_rows ----
align_rows <- function(dfx, dfy) {


}

# test ----
align_rows(dfx, dfy)


# utils ----
## row_distance -----
row_dist <- function(row1, row2) {
  # Start distance
  dist <- 0

  # Check length of columns
  num_col <- length(row1)

  # Loop through columns
  for (i in 1:num_col) {
    value1 <- row1[[i]]
    value2 <- row2[[i]]


  }
}
