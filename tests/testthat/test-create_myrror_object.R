# Tests for create_myrror_object()


# 0. Utils ----
# Helper function to create sample data frames
create_sample_df <- function(n = 10) {
  data.frame(
    a = 1:n,
    b = letters[1:n],
    stringsAsFactors = FALSE
  )
}


# 1. Input Validation ----

## 1.1 Valid Input ----
test_that("create_myrror_object handles valid inputs", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  result <- create_myrror_object(dfx, dfy, by = "a")

  expect_true("myrror" %in% class(result))
  expect_equal(result$name_dfx, "dfx")
  expect_equal(result$name_dfy, "dfy")
  expect_equal(length(result$datasets_report$dfx_char), 2)
  expect_equal(length(result$datasets_report$dfy_char), 2)
})

## 1.2 NULL or Invalid Input ----
test_that("create_myrror_object handles NULL inputs", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  expect_error(create_myrror_object(NULL, dfy), "NULL")
  expect_error(create_myrror_object(dfx, NULL), "NULL")
})


## 1.3 Lists (to data frames) ----
test_that("create_myrror_object converts lists to data frames", {
  dfx_list <- list(a = 1:10, b = letters[1:10])
  dfy_list <- list(a = 1:10, b = letters[1:10])
  result <- create_myrror_object(dfx_list, dfy_list, by = "a", factor_to_char = TRUE)

  expect_true("myrror" %in% class(result))
})

## 1.4 Empty data frames ----
test_that("create_myrror_object handles empty data frames", {
  empty_dfx <- data.frame()
  empty_dfy <- data.frame()

  expect_error(create_myrror_object(empty_dfx, empty_dfy), "empty data frame")
})



# 2. By Key handling ----
## 2.1 by, by.x and by.y provided ----
test_that("Handling of 'by' arguments correctly", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  result <- create_myrror_object(dfx, dfy, by.x = "a", by.y = "a")
  result2 <- create_myrror_object(dfx, dfy, by = "a")
  expect_equal(result$set_by.x, "a")
  expect_equal(result$set_by.y, "a")
  expect_equal(result2$set_by.x, "a")
  expect_equal(result2$set_by.y, "a")
})

## 2.2 By not provided ----
test_that("Fallback to row names when 'by' is NULL", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  result <- create_myrror_object(dfx, dfy, factor_to_char = TRUE)
  expect_equal(result$set_by.x, "rn")
  expect_equal(result$set_by.y, "rn")
})

## 2.3 By in non-index columns ----
test_that("by.x is flagged when part of non-index columns of dfy", {
  dfx <- data.frame(by_x = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = 6:10, by_x = 11:15)  # by_x also exists as a non-key column in dfy

  # Ensure that by_x is intended as a key in dfx but mistakenly also a regular column in dfy
  expect_error(create_myrror_object(dfx, dfy, by.x = "by_x", by.y = "a"),
               "by.x is part of the non-index columns of dfy")
})

test_that("by.y is flagged when part of non-index columns of dfx", {
  dfx <- data.frame(a = 1:5, b = 6:10, by_y = 11:15)  # by_y also exists as a non-key column in dfx
  dfy <- data.frame(by_y = 1:5, b = 6:10)

  # Ensure that by_y is intended as a key in dfy but mistakenly also a regular column in dfx
  expect_error(create_myrror_object(dfx, dfy, by.x = "a", by.y = "by_y"),
               "by.y is part of the non-index columns of dfx")
})


# 3. Data Preparation ----
test_that("create_myrror_object handles merging and pairs correctly", {
  dfx <- data.frame(a = 1:10, b = 1:10)
  dfy <- data.frame(a = 1:10, b = 1:10)

  result <- create_myrror_object(dfx, dfy, by = "a")

  expect_true(nrow(result$merged_data_report$matched_data) > 0)
  expect_true(all(result$pairs$col_x == c("a.x", "b.x")))
})

test_that("Data is correctly merged", {
  dfx <- data.frame(a = 1:5, b = 6:10)
  dfy <- data.frame(a = 1:5, b = 6:10)

  result <- create_myrror_object(dfx, dfy, by = "a")
  expect_equal(nrow(result$merged_data_report$matched_data), 5)
})


# 4. Creation of output ----
test_that("Correct output structure", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  result <- create_myrror_object(dfx, dfy, by = "a")
  expect_true("myrror" %in% class(result))
  expect_equal(length(result$datasets_report), 2)
  expect_true(!is.null(result$merged_data_report))
  expect_true(!is.null(result$pairs))
})

# 5. Error conditions ----
test_that("Error handling in input conditions", {
  expect_error(create_myrror_object(data.frame(), data.frame()), "empty data frame")
})


# 6. Join type checks ----
test_that("1:1 join proceeds without user interaction", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "1:1",
    {
      expect_silent(create_myrror_object(dfx, dfy, by = 'a', interactive = FALSE))
    }
  )
})

test_that("1:m join type does not inform user with interactive = FALSE and verbose = FALSE", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "1:m",
    {
      expect_no_message(create_myrror_object(dfx, dfy, by = 'a', interactive = FALSE, verbose = FALSE))
    }
  )
})

test_that("1:m join type does not inform user with interactive = TRUE and verbose = FALSE", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()


  with_mocked_bindings(
    check_join_type = function(...) "1:m",
    my_menu = function(...) 1,
    {
      expect_no_message(create_myrror_object(dfx, dfy, by = 'a', interactive = TRUE, verbose = FALSE))
    }
  )
})

test_that("m:1 join type informs user with interactive = TRUE and verbose = TRUE", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()


  with_mocked_bindings(
    check_join_type = function(...) "m:1",
    my_menu = function(...) 1,
    {
      expect_message(create_myrror_object(dfx, dfy, interactive = TRUE, verbose = TRUE))
    }
  )
})



test_that("m:1 join type informs user with interactive = FALSE", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "m:1",
    {
      expect_message(create_myrror_object(dfx, dfy, interactive = FALSE, verbose = TRUE))
    }
  )
})



test_that("m:m join type results in an abort without user interaction", {

  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "m:m",
    {
      expect_error(create_myrror_object(dfx, dfy, interactive = FALSE, verbose = FALSE), "m:m")
    }
  )
})

test_that("m:m join type results in an abort without user interaction but verbose", {

  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "m:m",
    {
      expect_error(create_myrror_object(dfx, dfy, interactive = FALSE, verbose = TRUE), "m:m")
    }
  )
})

test_that("1:m join type results in an abort with user interaction == 2", {

  dfx <- create_sample_df()
  dfy <- create_sample_df()

  with_mocked_bindings(
    check_join_type = function(...) "1:m",
    my_menu = function(...) 2,
    {
      expect_error(create_myrror_object(dfx, dfy, interactive = TRUE, verbose = FALSE), "aborted")
    }
  )
})









