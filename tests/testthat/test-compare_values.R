# Set-up -----------------------------------------------------------------------
withr::local_options(list(myrror.interactive = FALSE,
                          myrror.verbose = FALSE))

# 1. compare_values() takes two data frames or a myrror object ----
test_that("compare_values() takes two dataframes or a myrror_object", {

  # Clear Environment
  clear_last_myrror_object()

  # Empty or single dataframe returns error
  expect_error(compare_values())
  expect_error(compare_values(iris))

  # Two dataframes or a myrror_object is accepted
  mo <- create_myrror_object(iris, iris_var2)
  expect_no_error(compare_values(iris, iris_var2))
  expect_no_error(compare_values(myrror_object = mo))

  df_compare <- compare_values(iris, iris_var2)
  mo_compare <- compare_values(myrror_object = mo)
  expect_equal(df_compare$compare_values, mo_compare$compare_values)
})


# 2. compare_values() returns NULL if "simple" and no differences ----

test_that("compare_values() returns NULL if simple and no differences", {

  # No differences
  expect_equal(compare_values(iris, iris_var3, output = "simple"), NULL)
  expect_equal(compare_values(iris, iris, output = "simple"), NULL)

})

# 3. compare_values() returns a NULL compare_values item if no differences ----

test_that("compare_values() returns a NULL compare_values item if no differences", {

  # No differences
  mo <- create_myrror_object(iris, iris)
  expect_equal(compare_values(myrror_object = mo)$compare_values, NULL)

})

# 4. compare_values() returns a simple compare_values item if differences ----

test_that("compare_values() returns a simple compare_values item if differences", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_equal(compare_values(myrror_object = mo, output = "simple"),
               compare_values(myrror_object = mo)$compare_values)

})

# 5. compare_values() returns correct object with multiple keys ----

test_that("compare_values() returns the correct myrror_object with multiple keys", {


  mod <- compare_values(survey_data_2_cap, survey_data, by=c("COUNTRY" = "country",
                                                             "YEAR" = "year"),
                        output = "simple")

  non_mod <- compare_values(survey_data_2, survey_data, by=c("country", "year"),
                            output = "simple")

  expect_equal(mod, non_mod)

})

# 6. compare_values() returns correct output with invisible() ----
test_that("compare_values() returns correct output with silent", {

  mo <- create_myrror_object(iris, iris_var2)

  expect_equal(mo_silent <- compare_values(myrror_object = mo, output = "silent")$compare_values,
               mo_normal <- compare_values(myrror_object = mo)$compare_values)

})




