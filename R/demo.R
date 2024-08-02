library(devtools)
load_all()

# Workhorse function: ----
## Different value in a column (variable2): ----
myrror_object <- myrror(survey_data, survey_data_2, by=c("country", "year"))
compare_values(myrror_object = myrror_object)


## Different type of variable for variable 1: ----
myrror(survey_data, survey_data_3, by=c("country", "year"))


## Different number of rows (missing rows: ----
myrror(survey_data, survey_data_4, by=c("country", "year"))


## Different number of columns (missing columns): ----
myrror(survey_data, survey_data_5, by=c("country", "year"))


## Missing rows and change in value: ----
survey_data_4_var <- survey_data_4 |> collapse::fmutate(variable3 = variable3/2)
myrror(survey_data, survey_data_4_var, by=c("country", "year"))

# With PIP Data ----
pip_data <- pipfaker::fk_micro |> fungroup()
pip_data_var1 <- pip_data |> collapse::fmutate(weight = weight*100)

myrror(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                     "survey_year", "hhid", "pid"))

pip_data_var2 <- pip_data |> collapse::fsubset(gender != "female")
myrror(pip_data, pip_data_var2, by=c("country_code", "surveyid_year",
                                     "survey_year", "hhid", "pid"))


# Workflow example ----

myrror(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                     "survey_year", "hhid", "pid"))

extract_diff_values(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                                  "survey_year", "hhid", "pid"))

weight_diff <- extract_diff_values(pip_data,
                                   pip_data_var1, by=c("country_code", "surveyid_year",
                                                                 "survey_year", "hhid", "pid"))$weight

weight_diff |>
  group_by(country_code, surveyid_year, survey_year) #etc


# Auxiliary functions ----
compare_values(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                             "survey_year", "hhid", "pid"))

compare_values(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                             "survey_year", "hhid", "pid"),
               output = "simple")

compare_type(pip_data, pip_data_var1, by=c("country_code", "surveyid_year",
                                           "survey_year", "hhid", "pid"))

compare_type(survey_data, survey_data_4, by=c("country", "year"),
             output = "simple")



# Next:
# 1. Add the keys to the output (instead of the indexes).
# 2. Tolerance for the difference in the values.
# 3. Tests for efficiency with large datasets.
# 4. Variations in the extract_* functions.


