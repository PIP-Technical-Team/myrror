# Snapshot tests: General Complete Output, no interaction ----
## These need to be changed into something that actually tests the output...
test_that("Print general information correctly", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data, survey_data_2, interactive = FALSE)

  expect_snapshot(myrror_output)

})

test_that("Print general information correctly with different keys", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data_2, survey_data_2_cap, by=c("country" = "COUNTRY",
                                                                 "year" = "YEAR"), interactive = FALSE)

  expect_snapshot(myrror_output)

})

test_that("Print general information correctly with class differences", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data, survey_data_3, by=c("country", "year"), interactive = FALSE)

  expect_snapshot(myrror_output)

})

test_that("Print general information correctly with rows differences", {
  # Create a mock myrror_object
  myrror_output <- myrror(survey_data, survey_data_4, by=c("country", "year"), interactive = FALSE)

  expect_snapshot(myrror_output)

})

# Snapshot tests: General Complete Output, with interaction ----
## Cannot do this, I won't reach full coverage.
# test_that("Print general information correctly with interaction", {
#   # Create a mock myrror_object
#   myrror_output <- myrror(survey_data, survey_data_2, interactive = TRUE)
#
#     expect_message(myrror_output, "General Information")
#
#
# })
