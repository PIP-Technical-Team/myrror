# Overview of how the package works:
# 1. no keys given - no differences ----
mo1 <- create_myrror_object(survey_data, survey_data)

## 1.1 workhorse function (myrror()) ----
myrror(survey_data, survey_data)

## 1.2 compare_type() ----
compare_type(survey_data, survey_data)
compare_type(myrror_object = mo1) # equivalent
compare_type(myrror_object = mo1, output = "simple") # just the types.


## 1.3 compare_values() ----
compare_values(survey_data, survey_data)
compare_values(myrror_object = mo1) # equivalent
compare_values(myrror_object = mo1, output = "simple") # just the values.

## extract_diff_values() ----
extract_diff_values(survey_data, survey_data) # default = simple
extract_diff_values(myrror_object = mo1) # equivalent
extract_diff_values(myrror_object = mo1, output = "full") # just the differences.


## extract_diff_table() ----
extract_diff_table(survey_data, survey_data) # default = simple
extract_diff_table(myrror_object = mo1) # equivalent
extract_diff_table(myrror_object = mo1, output = "full") # just the differences.




# 2. no keys given (but mistake) - differences (additional rows) ----

myrror(survey_data, survey_data_4)

myrror(survey_data, survey_data_4, by=c('country', 'year'))

# no keys given - differences (different values) ----
mo2 <- create_myrror_object(survey_data, survey_data_2)
extract_diff_values(myrror_object = mo2) # ok


# keys given - no differences ----
mo1k <- create_myrror_object(survey_data, survey_data, by=c('country', 'year'))
extract_diff_values(myrror_object = mo1k) # ok

# keys given - differences (additional rows)
mo4k <- create_myrror_object(survey_data, survey_data_4, by=c('country', 'year'))
extract_diff_values(myrror_object = mo4k) # ok

# keys given - differences (different values)
mo2k <- create_myrror_object(survey_data, survey_data_2, by=c('country', 'year'))
extract_diff_values(myrror_object = mo2k) # issue
