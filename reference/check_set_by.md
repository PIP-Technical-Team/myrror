# Check if the by arguments are valid, makes them into a data.frame if they are a list. Internal function.

Check if the by arguments are valid, makes them into a data.frame if
they are a list. Internal function.

## Usage

``` r
check_set_by(by = NULL, by.x = NULL, by.y = NULL)
```

## Arguments

- by:

  character vector

- by.x:

  character vector

- by.y:

  character vector

## Examples

``` r
#check_set_by(NULL, NULL, NULL) # rn set
#check_set_by("id", NULL, NULL) # by set
#check_set_by(NULL, "id", "id") # by.x and by.y set
```
