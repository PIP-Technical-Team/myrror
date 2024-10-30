# Walkthrough

# 1. Libraries ----
library(myrror)
library(waldo)


# 2. Data ---
## 2.1 Simple differences ----
survey_data

### This is a variation of the survey_data dataset with different values in variable2
survey_data_2

### There are already packages that do a very good job at comparing data frames:
all.equal(survey_data, survey_data_2)
waldo::compare(survey_data, survey_data_2)

### myrror() offers a more structured approach:
myrror(survey_data, survey_data_2, by = c("country", "year"))

### and additional tools to operate on the actual differences:
extract_diff_values()

### Here are other examples:

### Different types
myrror(survey_data, survey_data_3, by = c("country", "year")) # different classes

### Different number of rows
all.equal(survey_data, survey_data_4)
waldo::compare(survey_data, survey_data_4)
myrror(survey_data, survey_data_4, by = c("country", "year"))
extract_diff_rows()


# 2.2 More complex ----
## Where myrror() shines is when the discrepancies are more complex and need to be understood in detail:
all.equal(survey_data, survey_data_all) # this report is concise and correct
waldo::compare(survey_data, survey_data_all) # this report reports all the discrepancies but is not as structured:
myrror(survey_data, survey_data_all, by = c("country" = "COUNTRY", "year" = "YEAR"))
extract_diff_rows()
extract_diff_values()

survey_data[1:4,]

## Also note that all checks of myrror() can be done separately by running:
compare_type(survey_data, survey_data_all, by = c("country" = "COUNTRY", "year" = "YEAR"))
compare_values(survey_data, survey_data_all, by = c("country" = "COUNTRY", "year" = "YEAR"))
## and extract_diff_rows()/values() too.

# 3. Additional Notes and Features ----
## 3.2 Non-identified datasets ----
survey_data_1m ## sometimes there are duplicates, or more than one row for each key:

## myrror() will throw warnings whenever it detects that the datasets are not uniquely identified:
myrror(survey_data, survey_data_1m, by = c("country", "year"))
all.equal(survey_data, survey_data_1m)
waldo::compare(survey_data, survey_data_1m)
## in my (humble) opinion, and improvement compared to all.equal() and waldo::compare().

## 3.1 Tolerance and simple output ----
## The tolerance argument is useful when comparing floating point numbers:
survey_data_copy <- survey_data
survey_data_copy$variable1[1] <- survey_data_copy$variable1[1] + 1e-5
compare_values(survey_data, survey_data_copy, by = c("country", "year"), tolerance = 1e-5)
compare_values(survey_data, survey_data_copy, by = c("country", "year"), tolerance = 1e-5, output = "simple")
compare_values(survey_data, survey_data_copy, by = c("country", "year"), tolerance = 1e-6, output = "simple")

## 3.3 by keys and row alignment ----
## Because myrror() does not work with row alignment (yet!!), it is always
## recommended to use by keys.
myrror(survey_data, survey_data_1m)

## Row-alignment will come next! (maybe)


