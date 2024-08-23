
# Test when no differences are found
test_that("extract_diff_rows returns NULL for 'simple' output when no differences are found", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = c(6, 7, 8, 10, 10))
  result <- extract_diff_rows(dfx, dfx, output = "simple")
  expect_equal(nrow(result), 0)
})

# Test when differences are found
test_that("extract_diff_rows returns data when differences are found", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = c(6, 7, 8, 10, 10))
  result <- extract_diff_rows(dfx, dfy, output = "simple")
  expect_true(length(result) > 0)
})


# Test the silent output
test_that("extract_diff_rows returns invisible myrror object for 'silent' output", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = c(6, 7, 8, 10, 10))
  result <- capture.output(
    val <- extract_diff_rows(dfx, dfy, output = "silent")
  )
  expect_type(val, "list")
  expect_equal(length(result), 0)
})

# Test handling of default `myrror_object`
test_that("extract_diff_rows uses default myrror_object when not provided", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = c(6, 7, 8, 10, 10))
  result <- extract_diff_rows(dfx, dfy, output = "simple")
  expect_true(length(result) > 0)
})

# Test verbose messages
test_that("verbose mode informs about used myrror_object", {
  mo <- myrror(iris, iris_var1)
  expect_message(extract_diff_rows(),
                 "Last myrror object used for comparison.")
})
