# A country-year level dataset for 2 countries, 4 years, and 4 variables:

# Create a dataset
survey_data <- data.frame(
  country = rep(c("A", "B"), each = 8),
  year = rep(2010:2017, 2),
  variable1 = rnorm(16),
  variable2 = rnorm(16),
  variable3 = rnorm(16),
  variable4 = rnorm(16)
)


# Variation of survey_data that has different values in variable2:
survey_data_2 <- survey_data
survey_data_2$variable2 <- rnorm(16)

# Variation of survey_data that has different type of variable for variable1:
survey_data_3 <- survey_data
survey_data_3$variable1 <- as.character(survey_data_3$variable1)


# Variation of survey_data that has missing rows:
survey_data_4 <- survey_data[-c(1, 2, 3, 4), ]

# Variation of survey_data that has missing columns:
survey_data_5 <- survey_data[, -c(3, 5)]

# Variation of survey_data that has additional rows:
survey_data_6 <- rbind(survey_data, survey_data)


survey_data <- as.data.table(survey_data)
survey_data_2 <- as.data.table(survey_data_2)
survey_data_3 <- as.data.table(survey_data_3)
survey_data_4 <- as.data.table(survey_data_4)
survey_data_5 <- as.data.table(survey_data_5)
survey_data_6 <- as.data.table(survey_data_6)


usethis::use_data(survey_data, survey_data_2, survey_data_3, survey_data_4,
                  survey_data_5, survey_data_6, overwrite = TRUE)

