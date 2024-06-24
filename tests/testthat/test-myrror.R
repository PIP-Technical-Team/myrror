
# First batch of tests for create_myrror_object

# 1 Test that the function stops for NULL inputs
test_that("function stops for NULL inputs", {
  expect_error(create_myrror_object(NULL, iris), "cannot be NULL")
  expect_error(create_myrror_object(iris, NULL), "cannot be NULL")
})

# 2 Test that the function stops for empty data frames
test_that("function stops for empty data frames", {
  empty_df <- data.frame()
  expect_error(create_myrror_object(empty_df, iris), "cannot be empty")
  expect_error(create_myrror_object(iris, empty_df), "cannot be empty")
})

# 3 Test handling of non-data.frame inputs that are lists
test_that("function converts list inputs to data frames", {
  list_input <- list(a = 1:10, b = letters[1:10])
  result <- create_myrror_object(list_input, list_input)
  expect_true(is.data.frame(result$prepared_dfx))
  expect_true(is.data.frame(result$prepared_dfy))
})

# 4 Test by, by.x, by.y validation
test_that("function stops for invalid by, by.x, by.y inputs", {
  expect_error(create_myrror_object(iris, iris, by = 123), "must be a non-empty character vector")
  expect_error(create_myrror_object(iris, iris, by.x = 123), "must be a non-empty character vector")
  expect_error(create_myrror_object(iris, iris, by.y = 123), "must be a non-empty character vector")
})

# 5 series of by tests
df1 <- data.frame(a = 1:10, b = letters[1:10])
df2 <- data.frame(a = 1:10, c = LETTERS[1:10])
rownames(df1) <- paste0("row", 1:10)
rownames(df2) <- paste0("row", 1:10)

# Test 5.1: 'by' is provided
#test_that("Test with 'by' provided", {
#  expect_equal(myrror(df1, df2, by = "a")$by.x, 'a')
#})

# Test 5.2: 'by.x' and 'by.y' are provided
#test_that("Test with 'by' provided", {
#  expect_equal(myrror(df1, df2, by.x = "a", by.y = 'a')$by.x, 'a')
#})


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



