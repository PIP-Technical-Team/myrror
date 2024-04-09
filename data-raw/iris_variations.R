## Code to prepare variations of the base R dataset iris.
# library(data.table)


# List of variations:
# 1. New Rows, New Column, and NA introduced.
# 2. NaN introduced, Old Variable with Different Value, Row Order Shuffled.
# 3. Same Variable with Different Name and One Value Missing, Mixed Type Column.
# 4. Categorical Variable Levels Modified, Duplicate Rows, and Subset of Columns with Altered Scale.

# Load the iris dataset
data("iris")

# Variation 1: New Rows, New Column, and NA introduced
iris_var1 <- rbind(iris, iris[1:5, ])  # Add new rows
iris_var1$Petal.Area <- with(iris_var1, Petal.Length * Petal.Width)  # New calculated column
iris_var1$Sepal.Length[sample(1:nrow(iris_var1), 5)] <- NA  # Introduce NAs

# Variation 2: NaN introduced, Old Variable with Different Value, Row Order Shuffled
iris_var2 <- iris
iris_var2$Sepal.Width[sample(1:nrow(iris_var2), 5)] <- NaN  # Introduce NaNs
iris_var2$Sepal.Length <- iris_var2$Sepal.Length + runif(nrow(iris_var2))  # Different values
set.seed(42)  # Ensure reproducibility
iris_var2 <- iris_var2[sample(1:nrow(iris_var2)), ]  # Shuffle rows

# Variation 3: Same Variable with Different Name and One Value Missing, Mixed Type Column
iris_var3 <- setNames(iris, c("SL", "SW", "PL", "PW", "Species"))  # Rename columns
iris_var3$SL <- as.character(iris_var3$SL)  # Convert numeric to character
iris_var3$SL[1] <- NA  # Introduce a missing value
iris_var3$SW <- ifelse(iris_var3$SW > 3.5, as.character(iris_var3$SW), "Wide")  # Mixed types

# Variation 4: Categorical Variable Levels Modified, Duplicate Rows, and Subset of Columns with Altered Scale
iris_var4 <- iris
levels(iris_var4$Species) <- toupper(levels(iris_var4$Species))  # Modify factor levels
iris_var4 <- rbind(iris_var4, iris_var4[1:10, ])  # Duplicate rows
iris_var4$Petal.Width <- iris_var4$Petal.Width * 10  # Altered scale

# Ensuring the variations are data.tables if needed
iris_var1 <- as.data.table(iris_var1)
iris_var2 <- as.data.table(iris_var2)
iris_var3 <- as.data.table(iris_var3)
iris_var4 <- as.data.table(iris_var4)


usethis::use_data(iris_var1, overwrite = TRUE)
usethis::use_data(iris_var2, overwrite = TRUE)
usethis::use_data(iris_var3, overwrite = TRUE)
usethis::use_data(iris_var4, overwrite = TRUE)

