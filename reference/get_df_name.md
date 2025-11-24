# Get the name of a data frame. Internal function.

This function gets the name of a data frame. Internal function. If the
data frame has a name attribute, it returns that. Otherwise, it returns
the deparse of the original call.

## Usage

``` r
get_df_name(df, original_call)
```

## Arguments

- df:

  data.frame

- original_call:

  original call (df)

## Value

character
