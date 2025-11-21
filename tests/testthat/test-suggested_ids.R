# Tests for suggested_ids.R

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

  # Single ID
  expect_true(is.character(suggested[[1]]))

  # Combo ID
  expect_true(is.character(suggested[[2]]))
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

test_that("suggested_ids handles a dataframe where all values are the same", {
  df_constant <- data.frame(a = c(1, 1, 1),
                            b = c(1, 1, 1))

  expect_equal(suggested_ids(df_constant), NULL)
})

test_that("suggested_ids gracefully handles errors from joyn::possible_ids", {
  # Create a data frame that will trigger an internal error in joyn
  df_problematic <- data.frame(a = I(list(1, 2, 3)), b = I(list(4, 5, 6)))

  expect_equal(suggested_ids(df_problematic), NULL)
})
