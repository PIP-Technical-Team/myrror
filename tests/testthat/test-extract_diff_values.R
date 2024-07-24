# 1. compare_values() takes two dataframes or a myrror object ----
test_that("extract_diff_values() takes two dataframes or a myrror_object", {

  # Empty or single dataframe
  expect_error(extract_diff_values())
  expect_error(extract_diff_values(iris))

  # Two dataframes or a myrror_object
  mo <- create_myrror_object(iris, iris_var1)
  expect_no_error(extract_diff_values(iris, iris_var1))
  expect_no_error(extract_diff_values(myrror_object = mo))

  df_compare <- extract_diff_values(iris, iris_var1)
  mo_compare <- extract_diff_values(myrror_object = mo)
  expect_equal(df_compare$merged_data_report, mo_compare$merged_data_report)
})

# 2. extract_diff_values() returns NULL if simple and no differences ----

test_that("extract_diff_values() returns NULL if simple and no differences", {

  # No differences
  expect_equal(extract_diff_values(iris, iris_var3, output = "simple"), NULL)
  expect_equal(extract_diff_values(iris, iris, output = "simple"), NULL)

})

# 3. compare_values() returns a NULL compare_values item if no differences ----

test_that("extract_diff_values() returns a NULL compare_values item if no differences", {

  # No differences
  mo <- create_myrror_object(iris, iris)
  target <- as.list("No differences found between the variables.")
  names(target) <- "message"
  expect_equal(extract_diff_values(myrror_object = mo, output = "full")$extract_diff_values, target)

})

# 4. extract_diff_values() returns a simple compare_values item if differences ----

test_that("extract_diff_values() returns a simple compare_values item if differences", {

  mo <- create_myrror_object(iris, iris_var1)

  expect_equal(extract_diff_values(myrror_object = mo, output = "simple"),
               extract_diff_values(myrror_object = mo, output = "full")$extract_diff_values$diff_list)

})

# 5. extract_diff_values() returns an invisible myrror_object if silent ----

test_that("extract_diff_values() returns an invisible myrror_object if silent", {

  mo <- create_myrror_object(iris, iris_var1)

  expect_invisible(extract_diff_values(myrror_object = mo, output = "silent"))

})
