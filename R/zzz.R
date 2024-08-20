.onLoad <- function(libname, pkgname) {

  # Retrieve all current global options
  op <- options()

  # Define default myrror package options
  op.myrror <- list(
    myrror.verbose         = TRUE,
    myrror.interactive     = interactive(),
    myrror.tolerance       = 1e-7
  )

  # Identify which myrror options are not already set in global options
  toset <- !(names(op.myrror) %in% names(op))

  # Store them in .myrrorenv
  rlang::env_bind(.myrror_env, op.myrror = op.myrror)

  # Set global options that have not been set yet
  if(any(toset)) {
    options(op.myrror[toset])
  }

  #get_myrror_options()

  invisible()
}
