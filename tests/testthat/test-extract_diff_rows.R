
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

# Additional tests

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

test_that("extract_diff_rows does not modify input data frames", {
  dfx <- data.frame(a = 1:3, b = 4:6)
  dfy <- data.frame(a = c(1,2,4), b = c(4,6,7))

  dfx_copy <- dfx
  dfy_copy <- dfy

  extract_diff_rows(dfx, dfy, by = "a", output = "simple")

  expect_identical(dfx, dfx_copy)
  expect_identical(dfy, dfy_copy)
})

test_that("extract_diff_rows correctly assigns dfx/dfy source", {
  dfx <- data.frame(a=1:2, val=c(10,20))
  dfy <- data.frame(a=c(1,3), val=c(10,30))

  res <- extract_diff_rows(dfx, dfy, by="a", output="simple")

  expect_true(all(res$df %in% c("dfx", "dfy")))
  expect_true("df" %in% names(res))
})

test_that("extract_diff_rows returns correct unmatched rows", {
  dfx <- data.frame(id=1:3, val=c("a","b","c"))
  dfy <- data.frame(id=c(1,3,4), val=c("a","c","d"))

  res <- extract_diff_rows(dfx, dfy, by="id", output="simple")

  expect_equal(nrow(res), 2)

  # One missing from dfy, one new in dfy
  expect_true(any(res$id == 2 & res$df == "dfx"))
  expect_true(any(res$id == 4 & res$df == "dfy"))
})

test_that("extract_diff_rows works when column order differs", {
  dfx <- data.frame(a=1:2, b=c(5,6))
  dfy <- data.frame(b=c(5,6), a=1:2)

  res <- extract_diff_rows(dfx, dfy, by="a", output="simple")
  expect_null(res)
})

test_that("extract_diff_rows identifies extra rows in dfy when using row numbers BUT no keys supplied", {
  dfx <- data.frame(x = 1:3)
  dfy <- data.frame(x = 1:4) # row 4 is new

  expect_error(
    extract_diff_rows(dfx, dfy, output = "simple"),
    "Different row numbers and no keys supplied"
  )
})

test_that("extract_diff_rows errors when row counts differ and no keys are supplied", {
  dfx <- data.frame(
    x = 1:5,
    y = rep("a", 5)
  )

  dfy <- data.frame(
    x = c(1:3, 10, 11, 12),  # different number of rows
    y = rep("a", 6)
  )

  expect_error(
    extract_diff_rows(dfx, dfy, output = "simple"),
    "Different row numbers and no keys supplied"
  )
})




