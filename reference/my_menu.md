# Menu wrapper. Internal function.

This function is a wrapper around the base R menu function. It is used
to provide a consistent interface for the menu function.

## Usage

``` r
my_menu(...)
```

## Arguments

- ...:

  Arguments passed to
  [`utils::menu()`](https://rdrr.io/r/utils/menu.html), including
  `choices` and `title`.

## Value

Integer indicating the selected menu item.
