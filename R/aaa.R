# Global Variables ----
utils::globalVariables(c("variable", "column_x", "column_y", "class_x", "class_y",
                         "same_class", ".joyn", "count", "rn", "rn.x", "rn.y",
                         "row_index.x", "row_index.y", "row_index", "indexes", "equal"))

# Package specific environment ----
.myrror_env <- new.env(parent = emptyenv())
