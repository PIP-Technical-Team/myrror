# Tests for suggested_ids.R

library(testthat)

test_that("suggested_ids returns NULL if no unique ids exist", {
  df_no_ids <- data.frame(a = c(1, 1, 2), b = c(1, 1, 2))
  expect_equal(suggested_ids(df_no_ids), NULL)
})

test_that("suggested_ids returns a combination of keys when no single unique identifier exists", {
  df_combo_ids <- data.frame(a = c(1, 1, 2),
                             b = c(1, 2, 2))
  expect_equal(suggested_ids(df_combo_ids), list(c("a", "b")))
})

test_that("suggested_ids returns the first single and first combo ID", {
  df_multiple_options <- data.frame(
    a = c(1, 2, 3),
    b = c(1, 2, 3),
    c = c(1, 2, 2)
  )
  suggested <- suggested_ids(df_multiple_options)
  expect_length(suggested, 2)
  expect_type(suggested, "list")
  expect_true(is.character(suggested[[1]]))  # single ID
  expect_true(is.character(suggested[[2]]))  # combo ID
  expect_length(suggested[[2]], 2)
})

test_that("suggested_ids handles empty dataframes correctly", {
  df_empty <- data.frame()
  expect_equal(suggested_ids(df_empty), NULL)
})

test_that("suggested_ids handles a single-column dataframe", {
  df_single_col <- data.frame(a = c(1, 2, 3, 4))
  expect_equal(suggested_ids(df_single_col), list("a"))
})

test_that("suggested_ids handles a single-column dataframe with repeated values", {
  df_single_repeat <- data.frame(a = c(1, 1, 2, 2))
  expect_equal(suggested_ids(df_single_repeat), NULL)
})

test_that("suggested_ids handles a dataframe where all values are the same", {
  df_constant <- data.frame(a = c(1, 1, 1),
                            b = c(1, 1, 1))
  expect_equal(suggested_ids(df_constant), NULL)
})

test_that("suggested_ids picks only the first combination when multiple combos exist", {
  df_multi_combo <- data.frame(
    a = c(1,2,3),
    b = c(1,2,3),
    c = c(3,2,1)
  )
  suggested <- suggested_ids(df_multi_combo)
  expect_length(suggested, 2)
  expect_equal(suggested[[2]], c("a","b"))
})

test_that("suggested_ids gracefully handles errors from joyn::possible_ids", {
  df_bad <- data.frame(a = I(list(1, 2)), b = I(list(3, 4)))
  expect_equal(suggested_ids(df_bad), NULL)
})

test_that("suggested_ids handles empty list returned from joyn::possible_ids", {
  df_empty_joyn <- data.frame(a = c(1, 1, 1), b = c(1, 1, 1))
  expect_equal(suggested_ids(df_empty_joyn), NULL)
})

test_that("suggested_ids handles no possible IDs", {
  df_none <- data.frame(a = c(1,1,1), b = c(1,1,1), c = c(1,1,1))
  expect_equal(suggested_ids(df_none), NULL)
})

test_that("suggested_ids returns NULL if suggested_ids_df empty", {
  df_empty_list <- data.frame(a = c(1,1), b = c(1,1))
  expect_equal(suggested_ids(df_empty_list), NULL)
})

test_that("suggested_ids handles NA values gracefully", {
  df_na <- data.frame(a = c(1,2,NA), b = c(1,2,3))
  expect_type(suggested_ids(df_na), "list")
})

