.onLoad <- function(libname, pkgname) {
  op <- options()
  op.myrror <- list(
    myrror.verbose         = TRUE
  )
  toset <- !(names(op.myrror) %in% names(op))

  #store them in .myrrorenv
  rlang::env_bind(.myrror_env, op.myrror = op.myrror)

  if(any(toset)) {
    options(op.myrror[toset])
  }

  #get_myrror_options()

  invisible()
}
