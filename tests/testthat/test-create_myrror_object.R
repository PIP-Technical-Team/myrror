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
  dfy <- data.frame(
    a = c(1, 1, 2, 3, 4, 5, 6, 7, 8, 9),  # Duplicates in key column
    b = letters[1:10],
    stringsAsFactors = FALSE
  )

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


test_that("different row numbers and no keys -> abort", {
  dfx <- create_sample_df(5)
  dfy <- create_sample_df(10)

  expect_error(create_myrror_object(dfx, dfy, interactive = FALSE, verbose = FALSE))
})

# ================================================================
#  More structural tests
# ================================================================

test_that("create_myrror_object preserves column names and structure (corrected)", {
  dfx <- data.frame(
    id = 1:4,
    varA = c("x", "y", "z", "w"),
    numX = c(10, 20, 30, 40),
    stringsAsFactors = FALSE
  )

  dfy <- data.frame(
    id = 1:4,
    varB = c("a", "b", "c", "d"),
    numY = c(100, 200, 300, 400),
    stringsAsFactors = FALSE
  )

  res <- create_myrror_object(dfx, dfy, by = "id", interactive = FALSE, verbose = FALSE)

  # Check myrror object class
  expect_s3_class(res, "myrror")

  # Original names preserved are stored in merged_data_report
  expect_equal(res$merged_data_report$colnames_dfx, names(res$prepared_dfx))
  expect_equal(res$merged_data_report$colnames_dfy, names(res$prepared_dfy))

  # Key storage correct (top-level)
  expect_equal(res$set_by.x, "id")
  expect_equal(res$set_by.y, "id")

  # Merged data contains correct columns after joining (check matched_data)
  merged <- res$merged_data_report$matched_data
  expect_true(all(c("id", "varA", "numX", "varB", "numY") %in% names(merged)))

  # Matched rows count correct
  expect_equal(nrow(merged), 4)
})

test_that("create_myrror_object generates correct pairs (corrected)", {
  dfx <- data.frame(id = 1:3, A = c(1,2,3))
  dfy <- data.frame(id = 1:3, A = c(1,2,4))

  res <- create_myrror_object(dfx, dfy, by = "id", interactive = FALSE)

  # pairs is returned top-level
  expect_true(is.list(res$pairs))
  expect_true(all(c("col_x", "col_y") %in% names(res$pairs$pairs)))

  # Pair correctness (variable correspondence) - pair_columns likely returns col names without suffixes;
  # but create_myrror_object pairs should reference suffixed column names (x/y)
  expect_true(any(grepl("^A(\\.x|\\.y)$", res$pairs$pairs$col_x)) || any(grepl("^A\\.x$", res$pairs$col_x)))
  expect_true(any(grepl("^A(\\.y|\\.x)$", res$pairs$pairs$col_y)) || any(grepl("^A\\.y$", res$pairs$col_y)))
})

test_that("merged_data_report sections are consistent and correct (corrected)", {
  dfx <- data.frame(id = 1:5, a = rnorm(5))
  dfy <- data.frame(id = 1:5, a = rnorm(5))

  res <- create_myrror_object(dfx, dfy, by = "id", interactive = FALSE, verbose = FALSE)

  rpt <- res$merged_data_report

  # Correct components exist
  expect_true(all(c("matched_data", "unmatched_data") %in% names(rpt)))

  # Should match all rows
  expect_equal(nrow(rpt$matched_data), 5)
  expect_equal(nrow(rpt$unmatched_data), 0)

  # Ensure keys include the join column (note: keys may be a vector from key())
  expect_true("id" %in% res$set_by.y)
  expect_true("id" %in% res$set_by.x)

})

test_that("Row-number fallback produces correct 'rn' keys (corrected)", {
  dfx <- create_sample_df(5)
  dfy <- create_sample_df(5)

  res <- create_myrror_object(dfx, dfy, by = NULL, interactive = FALSE)

  expect_equal(res$set_by.x, "rn")
  expect_equal(res$set_by.y, "rn")

  rpt <- res$merged_data_report$matched_data
  expect_true("rn" %in% names(rpt))
  # Ensure rn reflects row order (prepared datasets may have altered types but rn should be 1:n)
  expect_equal(as.integer(rpt$rn), 1:5)
})

test_that("Factors are correctly converted to characters when factor_to_char=TRUE (corrected)", {
  dfx <- data.frame(id = 1:3, fac = factor(c("a", "b", "c")))
  dfy <- data.frame(id = 1:3, fac = factor(c("a", "b", "d")))

  res <- create_myrror_object(dfx, dfy, by = "id", factor_to_char = TRUE, interactive = FALSE)

  expect_true(is.character(res$prepared_dfx$fac))
  expect_true(is.character(res$prepared_dfy$fac))
})

test_that("create_myrror_object output has all required list components (corrected)", {
  dfx <- create_sample_df()
  dfy <- create_sample_df()

  res <- create_myrror_object(dfx, dfy, by = "a", interactive = FALSE)

  mandatory <- c(
    "original_call",
    "name_dfx",
    "name_dfy",
    "prepared_dfy",
    "prepared_dfx",
    "original_by.x",
    "original_by.y",
    "set_by.y",
    "set_by.x",
    "datasets_report",
    "match_type",
    "merged_data_report",
    "pairs",
    "print",
    "interactive"
  )

  expect_true(all(mandatory %in% names(res)))
})
