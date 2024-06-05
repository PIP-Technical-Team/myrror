# Tests for myrror.utils.R
# check_df() ----
# Test 1: Input is NULL
test_that("check_df stops with NULL input", {
  expect_error(check_df(NULL),
                 "Input data frame(s) cannot be NULL.",
               fixed = TRUE)
})

# Test 2: Input is not a data frame or a list
test_that("check_df stops with non-data frame non-list input", {
  expect_error(check_df(5), "df must be a data frame or a convertible list.")
  expect_error(check_df("not a dataframe"), "df must be a data frame or a convertible list.")
})

# Test 3: Input is a list that can be converted to a data frame
test_that("check_df converts list to data frame", {
  test_list <- list(a = 1, b = 2)
  result <- check_df(test_list)
  expect_true(is.data.frame(result))
  expect_equal(result$a, 1)
  expect_equal(result$b, 2)
})

# Test 4: Input is a list that cannot be converted to a data frame
test_that("check_df stops with non-convertible list", {
  test_list <- list(a = 1:4,
                    b = "two",
                    c = list(1:3))
  expect_error(check_df(test_list),
               "df is a list but cannot be converted to a data frame.")
})

# Test 5: Input is an empty data frame
test_that("check_df stops with empty data frame", {
  empty_df <- data.frame()
  expect_error(check_df(empty_df), "Input data frame(s) cannot be empty.",
               fixed = TRUE)
})

# Test 6: Input is a valid data frame
test_that("check_df returns the data frame if valid", {
  valid_df <- data.frame(a = 1:3,
                         b = 4:6)
  result <- check_df(valid_df)
  expect_equal(result, valid_df)
})




# check_set_by() ----
# Test 1: Valid input with all parameters provided
test_that("Valid input with all parameters provided works", {
  result <- check_set_by(by = "id", by.x = "id1", by.y = "id2")
  expect_equal(result$by, "id")
  expect_equal(result$by.x, "id")
  expect_equal(result$by.y, "id")
})

# Test 2: Valid input with 'by' only
test_that("Valid input with 'by' only sets by.x and by.y", {
  result <- check_set_by(by = "id")
  expect_equal(result$by.x, "id")
  expect_equal(result$by.y, "id")
})

# Test 3: Invalid input types
test_that("Function stops with non-character or empty inputs", {
  expect_error(check_set_by(by = 123), "non-empty character vector")
  expect_error(check_set_by(by.x = FALSE), "non-empty character vector")
})

# Test 4: Only one of by.x or by.y is provided
test_that("Function stops if only one of by.x or by.y is provided", {
  expect_error(check_set_by(by.x = "id"), "by.y also needs to be specified")
  expect_error(check_set_by(by.y = "id"), "by.x also needs to be specified")
})

# Test 5: Default setting when both by.x and by.y are NULL
test_that("Defaults to 'rn' when both by.x and by.y are NULL", {
  result <- check_set_by()
  expect_equal(result$by.x, "rn")
  expect_equal(result$by.y, "rn")
})

# prepare_df() ----
# Test 1: Conversion of DataFrame to Data Table
test_that("DataFrame is converted to Data Table", {
  df <- data.frame(a = 1:3, b = as.factor(c("one", "two", "three")))
  result <- prepare_df(df, by = "a")
  expect_true(is.data.table(result))
  expect_true("rn" %in% colnames(result))
})

# Test 2: Error when 'rn' is an existing column name
test_that("'rn' present in colnames triggers an error", {
  df <- data.frame(rn = 1:3, b = 2:4)
  expect_error(prepare_df(df, by = "rn"), "'rn' present in colnames")
})

# Test 3: Verify handling of 'by' keys
test_that("Error if 'by' keys not present in column names", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_error(prepare_df(df, by = "c"), "Specified by keys are not all present")
})

# Test 4: Detection of duplicate column names
test_that("Function detects duplicate column names", {
  df <- data.frame(a = 1:3, a = 4:6, check.names = FALSE)
  expect_error(prepare_df(df, by = "a"), "Duplicate column names found")
})

# Test 5: Conversion of factors to characters
test_that("Factors are converted to characters", {
  df <- data.frame(a = 1:3, b = as.factor(c("one", "two", "three")))
  result <- prepare_df(df, by = "a", factor_to_char = TRUE)
  expect_true(is.character(result$b))
})


# is.sorted() ----
# Test 1: Sorted vector
test_that("Function detects sorted vector", {
  expect_true(is.sorted(1:10))
})

# Test 2: Unsorted vector
test_that("Function detects unsorted vector", {
  expect_false(is.sorted(c(1, 3, 2, 4)))
})

# Test 5: Sorted vector with ties
test_that("Function detects sorted vector with ties", {
  expect_true(is.sorted(c(1, 1, 2, 3, 3)))
})

# detect_sorting() ----
# Test 1: Sorted data frame
test_that("Function detects sorted data frame", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_equal(detect_sorting(df), c('a', 'b'))
})

# Test 2: Unsorted data frame
test_that("Function detects unsorted data frame", {
  df <- data.frame(a = c(1, 3, 2), b = c(4, 3, 7))
  expect_equal(detect_sorting(df), c("not sorted"))
})


# is_dataframe_sorted_by() ----
# Test 1: Data frame sorted by the specified column
test_that("Function detects data frame sorted by specified column", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_equal(is_dataframe_sorted_by(df, "a"), list("sorted by key", "a"))
})

# Test 2: Data frame not sorted by the specified column
test_that("Function detects data frame not sorted by specified column", {
  df <- data.frame(a = c(1, 3, 2), b = c(4, 3, 7))
  expect_equal(is_dataframe_sorted_by(df, "a"), list("not sorted by key", "not sorted"))
})

# Test 3: Data frame sorted by "rn" (default) and by "a" and "b
test_that("Function detects data frame sorted by 'rn'", {
  df <- data.frame(a = 1:3, b = 4:6, rn = 1:3)
  expect_equal(is_dataframe_sorted_by(df, "rn"), list("not sorted by key", c("a", "b", "rn")))
})

# Test 4: Data frame not sorted by the specified column but by another column
test_that("Function detects data frame sorted by another column", {
  df <- data.frame(a = c(1, 3, 2), b = c(4, 3, 7), other_column = 1:3)
  expect_equal(is_dataframe_sorted_by(df, "a"), list("not sorted by key", "other_column"))
})










