

# Test when no differences are found
test_that("extract_diff_rows returns NULL for 'simple' output when no differences are found", {
  result <- extract_diff_rows(survey_data, survey_data, output = "simple")
  expect_equal(result, NULL)
})

# Test when differences are found
test_that("extract_diff_rows returns data when differences are found", {
  result <- extract_diff_rows(survey_data, survey_data_4, by=c('country', 'year'), output = "simple")
  expect_true(length(result) > 0)
})


# Test the silent output
test_that("extract_diff_rows returns invisible myrror object for 'silent' output", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = c(6, 7, 8, 10, 10))
  result <- capture.output(
    val <- extract_diff_rows(dfx, dfy, by = 'a', output = "silent")
  )
  expect_type(val, "list")
  expect_equal(length(result), 0)
})


# Test verbose messages
test_that("verbose mode informs about used myrror_object", {
  mo <- myrror(survey_data, survey_data_4, by=c('country', 'year'))
  expect_message(extract_diff_rows(verbose = TRUE),
                 "Last myrror object used for comparison.")
})

# Additional tests for full coverage 9/4/24 ----

# Assuming `myrror` sets up a myrror_object properly
test_that("extract_diff_rows handles different outputs", {
  myrror_object <- myrror(survey_data, survey_data_2, by = c("country", "year"))

  # Test full output
  result_full <- extract_diff_rows(myrror_object = myrror_object, output = "full")
  expect_true("print" %in% names(result_full))

  # Test silent output
  result_silent <- extract_diff_rows(myrror_object = myrror_object, output = "silent")
  expect_silent(result_silent)

  # Test simple output
  result_simple <- extract_diff_rows(myrror_object = myrror_object, output = "simple")
  expect_equal(result_simple, NULL)  # Adjust according to what `simple` should return
})


# This test covers the input validation
test_that("extract_diff_rows validates output argument correctly", {
  expect_error(extract_diff_rows(myrror_object = myrror_object, output = "invalid"))
})
