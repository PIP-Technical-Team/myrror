# EXTRACT DIFF VALUES ----
# 1. extract_diff_values() takes two dataframes or a myrror object ----
test_that("extract_diff_values() takes two dataframes or a myrror_object", {

  # Two dataframes or a myrror_object
  mo <- create_myrror_object(iris, iris_var2)
  expect_no_error(extract_diff_values(iris, iris_var2))
  expect_no_error(extract_diff_values(myrror_object = mo))

  df_compare <- extract_diff_values(iris, iris_var2)
  mo_compare <- extract_diff_values(myrror_object = mo)
  expect_equal(df_compare$Sepal.Length, mo_compare$Sepal.Length)
})

# 2. extract_diff_values() returns NULL if simple and no differences ----

test_that("extract_diff_values() returns NULL if simple and no differences", {

  # No differences
  expect_equal(extract_diff_values(iris, iris_var3, output = "simple"), NULL)
  expect_equal(extract_diff_values(iris, iris, output = "simple"), NULL)

})


# 4. extract_diff_values() returns a simple extract_diff_values() item if differences ----

test_that("extract_diff_values() returns a simple compare_values item if differences", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_equal(extract_diff_values(myrror_object = mo, output = "simple"),
               extract_diff_values(myrror_object = mo, output = "full")$extract_diff_values$diff_list)

})

# 5. extract_diff_values() returns an invisible myrror_object if silent ----

test_that("extract_diff_values() returns an invisible myrror_object if silent", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_invisible(extract_diff_values(myrror_object = mo, output = "silent"))

})

# 6. extract_diff_values() retrieves myrror_object from environment ----
test_that("extract_diff_values() retrieves myrror_object from environment", {

  mo <- myrror(iris, iris_var2)
  myrror(iris, iris_var2)

  expect_equal(extract_diff_values(myrror_object = mo),
               extract_diff_values())

})

# 7. extract_diff_values() returns an error if no mo or dfs supplied ----
test_that("extract_diff_values() returns an error if no mo or dfs supplied", {
  # Remove all objects within the .myrror_env environment
  rm(list = ls(envir = .myrror_env), envir = .myrror_env)

  # No mo or dfs
  expect_error(extract_diff_values())

})

# EXTRACT DIFF TABLE ----
# 1. extract_diff_table() runs correctly ----
test_that("extract_diff_table() takes two dataframes or a myrror_object", {

  # Two dataframes or a myrror_object
  mo <- create_myrror_object(iris, iris_var2)
  expect_no_error(extract_diff_table(iris, iris_var2, interactive = FALSE))
  expect_no_error(extract_diff_table(myrror_object = mo, interactive = FALSE))

  df_compare <- extract_diff_table(iris, iris_var2)
  mo_compare <- extract_diff_table(myrror_object = mo)
  expect_equal(df_compare, mo_compare)
})

# 2. extract_diff_table() returns an error if no mo or dfs supplied ----
test_that("extract_diff_table() returns an error if no mo or dfs supplied", {

  # Remove all objects within the .myrror_env environment
  rm(list = ls(envir = .myrror_env), envir = .myrror_env)

  # No mo or dfs
  expect_error(extract_diff_table())

})

# 3. extract_diff_table() retrieves myrror_object from environment ----
test_that("extract_diff_table() retrieves myrror_object from environment", {

  mo <- myrror(iris, iris_var2)
  myrror(iris, iris_var2)

  expect_equal(extract_diff_table(myrror_object = mo),
               extract_diff_table())

})

# 3. extract_diff_values() returns NULL if simple and no differences ----

test_that("extract_diff_table() returns NULL if simple and no differences", {

  # No differences
  expect_equal(extract_diff_table(iris, iris_var3, output = "simple"), NULL)
  expect_equal(extract_diff_table(iris, iris, output = "simple"), NULL)

})

# 4. extract_diff_values() returns a simple extract_diff_values() item if differences ----

test_that("extract_diff_values() returns a simple compare_values item if differences", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_equal(extract_diff_table(myrror_object = mo, output = "simple"),
               extract_diff_table(myrror_object = mo, output = "full")$extract_diff_values$diff_table)

})

# 5. extract_diff_values() returns an invisible myrror_object if silent ----
# How do I actually check for this?
test_that("extract_diff_values() returns an invisible myrror_object if silent", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_invisible(extract_diff_table(myrror_object = mo, output = "silent"))

})

# Additional tests
test_that("extract_diff_values errors if dfx or dfy is NULL and no myrror_object", {
  extract_diff_values(dfx = NULL,
                      dfy = iris) |>
    expect_error()

  extract_diff_values(dfx = iris,
                      dfy = NULL) |>
    expect_error()
})

test_that("extract_diff_values detects a single row change", {
  df1 <- iris
  df2 <- iris
  df2$Sepal.Length[1] <- df2$Sepal.Length[1] + 1

  res <- extract_diff_values(df1, df2, output = "simple")

  expect_equal(length(res$Sepal.Length$indexes),
               1)

  expect_equal(res$Sepal.Length$diff[1],
               "change_in_value")
})

test_that("extract_diff_values detects NA changes correctly", {
  df1 <- iris
  df2 <- iris
  df2$Sepal.Width[2] <- NA
  df2$Petal.Width[3] <- NA

  res <- extract_diff_values(df1, df2, output = "simple")

  expect_true(any(
    res$Sepal.Width$diff == "value_to_na"))

  expect_true(any(
    res$Petal.Width$diff == "value_to_na"))
})

test_that("extract_diff_values respects tolerance", {
  df1 <- iris
  df2 <- iris
  df2$Sepal.Length[1] <- df2$Sepal.Length[1] + 1e-8  # smaller than default tolerance

  res <- extract_diff_values(df1, df2, output = "simple")
  expect_null(res)  # should ignore very small differences
})

test_that("extract_diff_values outputs have correct structure", {
  df1 <- iris
  df2 <- iris
  df2$Sepal.Length[1] <- df2$Sepal.Length[1] + 1

  mo <- create_myrror_object(df1, df2)
  res <- extract_diff_values(myrror_object = mo, output = "full")

  # Check that diff_list and diff_table exist
  expect_true(all(c("diff_list", "diff_table") %in% names(res$extract_diff_values)))

  # diff_list should include only variables that differ
  expect_true("Sepal.Length" %in% names(res$extract_diff_values$diff_list))

  # diff_table should contain columns for keys + diff info + differing variable
  expected_cols <- c("diff", "variable", "indexes", "Sepal.Length.x", "Sepal.Length.y")
  expect_true(all(expected_cols %in% names(res$extract_diff_values$diff_table)))
})


