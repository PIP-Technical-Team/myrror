compare_type_int <- function(x, y) {
  if (is.integer(x) && is.integer(y)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


compare_type <- function(x       = NULL,
                         y       = NULL,
                         mo      = NULL,
                         verbose = TRUE,
                         output  = c("myrror_object", "simple")) {
  if (!is.null(mo)) {
    mo <- create_myrror_object(x,y)
  }
  mo <- compare_type_int(mo) # mo$compare_type

  if (verbose) {
    mo$compare_type
    mo$print$compare_type <- TRUE
    print(mo)
  }
  if (output == "myrror_object") {
    return(invisible(mo))
  } else if (output == "simple") {
    return(invisible(mo$compare_type)) # think of classes...
  }

}


myrror <- function(x,y) {
  if (!is.null(mo)) {
    mo <- create_myrror_object(x,y)
  }
  if (compare_type = TRUE) {
    mo <- compare_type_int(mo)
  }
  if (compare_values = TRUE) {
    mo <- compare_values_int(mo)
  }

}



print.myrror <- function(x) {
  if (x$print$compare_type) {
    cat("Type comparison: ", x$compare_type, "\n")
  }
  if (x$print$compare_values) {
    cat("Value comparison: ", x$compare_values, "\n")
  }
}


print.myrror <- function(x) {
  if (x$print$compare_type) {
    cat("Type comparison: ", x$compare_type, "\n")
  }
  if (x$print$compare_values) {
    cat("Value comparison: ", x$compare_values, "\n")
  }
}
