# Clear last myrror object. Internal Function.

This function unbinds the last myrror object from the package-specific
environment, effectively removing it.

## Usage

``` r
clear_last_myrror_object()
```

## Value

Invisible `NULL`, indicating the object was successfully cleared.

## Examples

``` r
# myrror(iris, iris_var1, interactive = FALSE) # Run myrror to create myrror object.
# clear_last_myrror_object()  # Clear the environment
# rlang::env_has(.myrror_env, "last_myrror_object") # should return an error
```
