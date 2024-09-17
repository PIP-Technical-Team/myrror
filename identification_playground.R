# Keys given ----
## dfx and dfy are identified ----
### match is 1:1 (okay - default) ----
myrror(survey_data, survey_data_2, by=c("country", "year"))

### match is not 1:1 (okay - default) ----
survey_data_expanded <- survey_data |>
  fmutate(year = year + 10) |>
  rbind(survey_data)
myrror(survey_data, survey_data_expanded, by=c("country", "year"))

## dfx and dfy are not identified ----
### match is 1:m/m:1, then proceed but warn ---
myrror(survey_data, survey_data_1m, by=c("country", "year"))
# Note: no row alignment, so wrong results.
### match is m:m, then abort ----
myrror(survey_data_1m, survey_data_1m, by=c("country", "year"))

# Keys not given ----
# Then datasets are merged by row number 'rn'
# What can we report to the user without row alignment?

## dfx and dfy do not have duplicates/missing/new rows ----
# then comparison can proceed as before and there will be no issues.
myrror(survey_data, survey_data_2)

## dfx and dfy have duplicates/missing/new rows ----
# we can notify the user of duplicates (similar to notifying about not identified by the keys)
# we cannot notify the user about missing/new rows without row alignment.
# we can only compare row number.
myrror(iris, iris_var7, interactive = FALSE)
extract_diff_rows()
