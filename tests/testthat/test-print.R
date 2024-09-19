# General ----
## !! Here we probably need to add additional checks to be honest
test_that("Print general information", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data, survey_data_2, interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "General Information")

})

# Different keys ----
test_that("Print general information with different keys", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data_2, survey_data_2_cap, by=c("country" = "COUNTRY",
                                                                 "year" = "YEAR"),
                          interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "keys dfx:")

})

# Missing rows ----
test_that("Print general information with missing rows", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data_2, survey_data_4, by=c("country", "year"),
                          interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "to extract the missing/new")

})

# Compare type ----
test_that("Print general information with different types", {

  myrror_output <- myrror(survey_data, survey_data_3, by=c("country", "year"),
                          interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "have different")

})

test_that("Print general information with different types, goes ahead", {

  myrror_output <- myrror(survey_data, survey_data_3, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)

  with_mocked_bindings(
    my_readline = function(...) "",{
      expect_message(print(myrror_output), "have different")
    }
  )

})


test_that("Print general information with different types, aborts", {

  myrror_output <- myrror(survey_data, survey_data_3, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)

  with_mocked_bindings(
    my_readline = function(...) "q",{
      expect_message(print(myrror_output), "End of Myrror Report")
    }
  )

})

# Compare values ----
test_that("Print general information with different values", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "All shared columns have the same class")
  expect_message(print(myrror_output), "have different value")

})

test_that("Print general information with different values, goes ahead", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)

  with_mocked_bindings(
    my_readline = function(...) "",{
      expect_message(print(myrror_output), "have different value")
    }
  )

})


test_that("Print general information with different types, aborts", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)


  readline_sequence <- c("", "q")

  readline_mock <- function(...) {
    # Take the first value from the sequence and remove it from the list
    current_input <- readline_sequence[1]
    readline_sequence <<- readline_sequence[-1]
    return(current_input)
  }

  with_mocked_bindings(
    my_readline = readline_mock,{
      expect_message(print(myrror_output), "End of Myrror Report")
    }
  )

})

# Extract different values ----
test_that("Print general information with extracted values", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = FALSE, verbose = FALSE)

  expect_message(print(myrror_output), "All shared columns have the same class")
  expect_message(print(myrror_output), "Note: Only first 5 rows shown for each variable.")

})

test_that("Print general information with different values, goes ahead", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)

  with_mocked_bindings(
    my_readline = function(...) "",{
      expect_message(print(myrror_output), "have different value")
      expect_message(print(myrror_output), "Note: Only first 5 rows shown for each variable.")
    }
  )

})


test_that("Print general information with different types, aborts", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)


  readline_sequence <- c("", "", "q")

  readline_mock <- function(...) {
    # Take the first value from the sequence and remove it from the list
    current_input <- readline_sequence[1]
    readline_sequence <<- readline_sequence[-1]
    return(current_input)
  }

  with_mocked_bindings(
    my_readline = readline_mock,{
      expect_message(print(myrror_output), "End of Myrror Report")
    }
  )

})

test_that("Print general information with different types, aborts next variable", {

  myrror_output <- myrror(survey_data, survey_data_2, by=c("country", "year"),
                          interactive = TRUE, verbose = FALSE)


  readline_sequence <- c("", "", "", "q")

  readline_mock <- function(...) {
    # Take the first value from the sequence and remove it from the list
    current_input <- readline_sequence[1]
    readline_sequence <<- readline_sequence[-1]
    return(current_input)
  }

  with_mocked_bindings(
    my_readline = readline_mock,{
      expect_message(print(myrror_output), "End of Myrror Report")
    }
  )

})
