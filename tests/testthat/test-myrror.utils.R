# Tests for myrror.utils
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



