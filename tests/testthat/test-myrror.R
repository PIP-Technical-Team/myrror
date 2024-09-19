

# CREATE MYRROR OBJECT TESTS ---------------------------------------------------
# 1. Test that the function stops for NULL inputs
test_that("function stops for NULL inputs", {
  expect_error(create_myrror_object(NULL, iris), "cannot be NULL")
  expect_error(create_myrror_object(iris, NULL), "cannot be NULL")
})

# 2. Test that the function stops for empty data frames
test_that("function stops for empty data frames", {
  empty_df <- data.frame()
  expect_error(create_myrror_object(empty_df, iris), "cannot be empty")
  expect_error(create_myrror_object(iris, empty_df), "cannot be empty")
})

# 3. Test handling of non-data.frame inputs that are lists
test_that("function converts list inputs to data frames", {
  list_input <- list(a = 1:10, b = letters[1:10])
  result <- create_myrror_object(list_input, list_input)
  expect_true(is.data.frame(result$prepared_dfx))
  expect_true(is.data.frame(result$prepared_dfy))
})

# 4. Test by, by.x, by.y validation
test_that("function stops for invalid by, by.x, by.y inputs", {
  expect_error(create_myrror_object(iris, iris, by = 123), "must be a non-empty character vector")
  expect_error(create_myrror_object(iris, iris, by.x = 123), "must be a non-empty character vector")
  expect_error(create_myrror_object(iris, iris, by.y = 123), "must be a non-empty character vector")
})

# 5. series of by tests
df1 <- data.frame(a = 1:10, b = letters[1:10])
df2 <- data.frame(a = 1:10, c = LETTERS[1:10])
rownames(df1) <- paste0("row", 1:10)
rownames(df2) <- paste0("row", 1:10)



# 6 Sample problematic list
problematic_list <- list(
  a = 1:5,
  b = letters[1:4]  # Different length than 'a'
)

# Define the test
test_that("Test with a list that cannot be converted to a data frame", {
  expect_error(
    create_myrror_object(problematic_list, df2),  # df2 is a normal data frame for comparison
    "cannot be converted to a data frame"
  )
})

# MYRROR TESTS ----------------------------------------------------------------
# 1. Test input validation ----
test_that("function errors correctly with NULL inputs", {

  expect_error(myrror(NULL, NULL))
})

# Test feature flags
test_that("compare type is skipped when disabled", {
  dfx <- dfy <- data.frame(a = 1:10, b = 1:10)
  result <- myrror(dfx, dfy, compare_type = FALSE)
  expect_null(result$compare_type)
})

# Test tolerance
test_that("tolerance is respected", {
  dfx <- dfy <- data.frame(a = c(1, 1.0000001), b = c(1,3))
  result <- myrror(dfx, dfy, tolerance = 0)
  expect_true(all(result$compare_values$a$diff != "change_in_value"))
  result <- myrror(dfx, dfy, tolerance = 1e-6)
  expect_true(all(result$compare_values$a$diff == "change_in_value"))
})

# Environment tests
test_that("object is saved to environment", {
  dfx <- dfy <- data.frame(a = 1:10, b=1:10)
  myrror(dfx, dfy)
  expect_true(exists("last_myrror_object", envir = .myrror_env))
})

# Output verification
test_that("returned object has correct properties", {
  dfx <- dfy <- data.frame(a = 1:10, b=1:10)
  result <- myrror(dfx, dfy, interactive = TRUE)
  expect_true(result$interactive)
  expect_type(result, "list")
})



