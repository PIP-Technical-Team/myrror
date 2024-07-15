
myrror_object <- create_myrror_object(iris, iris_var1)

myrror_object <- compare_type(myrror_object = myrror_object, output = "myrror_object")

myrror_object <- compare_values(myrror_object = myrror_object, output = "myrror_object")

myrror_object <- extract_diff_values(myrror_object = myrror_object, output = "myrror_object")


myrror(iris, iris_var1)
