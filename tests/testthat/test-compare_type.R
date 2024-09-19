# Compare Type Tests
# Set-up ---------------------------------------------------------------
withr::local_options(list(myrror.interactive = FALSE,
                          myrror.verbose = FALSE))

mo5 <- create_myrror_object(iris, iris_var5)
compare_type_object_5 <- compare_type(myrror_object = mo5)

mo1 <- create_myrror_object(iris, iris_var1)
compare_type_object_1 <- compare_type(myrror_object = mo1)


# Arguments ----------------------------------------------------------------
## 1. compare_type and compare_type_int() work as expected: ----------------
test_that("compare_type() correctly identifies type", {

  expect_equal(compare_type_object_1$compare_type$same_class,
               c(TRUE, TRUE, TRUE, TRUE, TRUE))
  expect_equal(compare_type_object_5$compare_type$same_class,
               c(FALSE, TRUE, TRUE, TRUE, TRUE))
})



## 2. compare_type() creates myrror object if not supplied -----------------
test_that("compare_type() creates myrror object if not supplied", {

  compare_type_object_1_2 <- compare_type(iris, iris_var1)
  expect_equal(compare_type_object_1_2$name_dfx, compare_type_object_1$name_dfx)
  expect_equal(compare_type_object_1_2$name_dfy, compare_type_object_1$name_dfy)
  expect_equal(compare_type_object_1_2$compare_type,
               compare_type_object_1$compare_type)

})

## 3. compare_type() both df must be provided ------------------------------
test_that("compare_type() both df must be provided", {

  expect_error(compare_type(iris, NULL))
  expect_error(compare_type(NULL, iris_var1))

})

# Output ---------------------------------------------------------------
## 4. Correct output when specified ----------------------------------------
test_that("compare_type() correct output when specified", {

  compare_type_object_1_3 <- compare_type(iris, iris_var1, output = "simple")
  expect_equal(compare_type_object_1_3, compare_type_object_1$compare_type)

  compare_type_object_1_4 <- compare_type(iris, iris_var1, output = "silent")
  compare_type_object_1_2 <- compare_type(iris, iris_var1)
  expect_equal(compare_type_object_1_4, compare_type_object_1_2)
  expect

})

