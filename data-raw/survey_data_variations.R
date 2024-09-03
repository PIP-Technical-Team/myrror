# survey_data ----
# A country-year level dataset for 2 countries, 4 years, and 4 variables:

set.seed(123)
survey_data <- data.frame(
  country = rep(c("A", "B"), each = 8),
  year = rep(2010:2017, 2),
  variable1 = rnorm(16),
  variable2 = rnorm(16),
  variable3 = rnorm(16),
  variable4 = rnorm(16)
)


# survey_data_2 ----
# Variation of survey_data that has different values in variable2:
survey_data_2 <- survey_data
survey_data_2$variable2 <- rnorm(16)

survey_data_2_cap <- survey_data_2 |>
  frename(COUNTRY = country, YEAR = year)

# survey_data_3 ----
# Variation of survey_data that has different type of variable for variable1:
survey_data_3 <- survey_data
survey_data_3$variable1 <- as.character(survey_data_3$variable1)

# survey_data_4 ----
# Variation of survey_data that has missing rows:
survey_data_4 <- survey_data[-c(1, 2, 3, 4), ]

# survey_data_5 ----
# Variation of survey_data that has missing columns:
survey_data_5 <- survey_data[, -c(3, 5)]

# survey_data_6 ----
# Variation of survey_data that has additional rows duplicates):
survey_data_6 <- rbind(survey_data, survey_data)

# survey_data_1m ----
# Variation of survey_data with 1:m relationship
rep_factor <- sample(1:3, nrow(survey_data), replace = TRUE)
survey_data_1m <- survey_data[rep(seq_len(nrow(survey_data)), times = rep_factor), ]
## change order
survey_data_1m <- survey_data_1m[sample(nrow(survey_data_1m)), ]

## add noise
survey_data_1m$variable1 <- survey_data_1m$variable1 + rnorm(nrow(survey_data_1m), sd = 0.1)
survey_data_1m$variable2 <- survey_data_1m$variable2 + rnorm(nrow(survey_data_1m), sd = 0.1)
survey_data_1m$variable3 <- survey_data_1m$variable3 + rnorm(nrow(survey_data_1m), sd = 0.1)
#survey_data_1m$variable4 <- survey_data_1m$variable4 + rnorm(nrow(survey_data_1m), sd = 0.1)

# survey_data_1m_2 ----
set.seed(432)
rep_factor <- sample(1:3, nrow(survey_data), replace = TRUE)
survey_data_1m_2 <- survey_data[rep(seq_len(nrow(survey_data)), times = rep_factor), ]
## change order
survey_data_1m_2 <- survey_data_1m_2[sample(nrow(survey_data_1m_2)), ]

## add noise
survey_data_1m_2$variable1 <- survey_data_1m_2$variable1 + rnorm(nrow(survey_data_1m_2), sd = 0.1)
#survey_data_1m_2$variable2 <- survey_data_1m_2$variable2 + rnorm(nrow(survey_data_1m_2), sd = 0.1)
#survey_data_1m_2$variable3 <- survey_data_1m_2$variable3 + rnorm(nrow(survey_data_1m_2), sd = 0.1)
#survey_data_1m_2$variable4 <- survey_data_1m_2$variable4 + rnorm(nrow(survey_data_1m_2), sd = 0.1)

# survey_data_m1 (actually not an issue) ----
# Variation of survey_data with m:1 relationship
n_unique <- 8
unique_indices <- sample(1:nrow(survey_data), n_unique)

uniqUe_rows <- survey_data[unique_indices, ]
survey_data_m1 <- survey_data

mapping <- sample(1:n_unique, nrow(survey_data), replace = TRUE)
survey_data_m1$variable1 <- uniqUe_rows$variable1[mapping]
survey_data_m1$variable2 <- uniqUe_rows$variable2[mapping]
survey_data_m1$variable3 <- uniqUe_rows$variable3[mapping]
survey_data_m1$variable4 <- uniqUe_rows$variable4[mapping]




# Make into data.table ----
survey_data <- as.data.table(survey_data)
survey_data_2 <- as.data.table(survey_data_2)
survey_data_2_cap <- as.data.table(survey_data_2_cap)
survey_data_3 <- as.data.table(survey_data_3)
survey_data_4 <- as.data.table(survey_data_4)
survey_data_5 <- as.data.table(survey_data_5)
survey_data_6 <- as.data.table(survey_data_6)
survey_data_1m <- as.data.table(survey_data_1m)
survey_data_1m_2 <- as.data.table(survey_data_1m_2)
survey_data_m1 <- as.data.table(survey_data_m1)


# Usethis
usethis::use_data(survey_data, survey_data_2, survey_data_2_cap, survey_data_3,
                  survey_data_4, survey_data_5, survey_data_6, survey_data_1m,
                  survey_data_1m_2, survey_data_m1, overwrite = TRUE)

