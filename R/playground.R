
# Example of specific task function
compare_type <- function(dfx = NULL,
                         dfy = NULL,
                         constructor = NULL,
                         output     = getOption("myrror.user.return")) {

  # check that dfx and dfy are not null or that constructor is not null
  if (is.null(dfx) | is.null(dfy)) {
    stop("dfx and dfy must be provided")
  }

  if (is.null(constructor)) {
    constructor <- myrror_constructor(dfx, dfy)
  }

  # Type comnparison
  # Here you do the heavy lifting of the comparison


  # Return
  if (output = "user") {
    return(x)
  } else {
    return(y)
  }


}


# workhorse function
myrror <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   #tolerance = NULL, POSTPONED
                   factor_to_char = TRUE,
                   compare_type = TRUE,
                   compare_obs = TRUE
) {


  # 0. Store original datasets and orginal dataset characteristics ----
  original_call <- match.call()
  dfx_name <- deparse(substitute(dfx))
  dfy_name <- deparse(substitute(dfy))
  original_dfx <- dfx
  original_dfy <- dfy

  constructor <- myrror_constructor(dfx, dfy, by, by.x, by.y)

  if (compare_type) {
    ct <- compare_type(constructor = constructor,
                       output = "myrror")
  } else {
    ct <- list()
  }


}

# actual constructor function
# whatever is necessary for any comparison

myrror_constructor <- function() {
  dfx <- check_df(dfx)
  dfy <- check_df(dfy)

  set_by <- check_set_by(by, by.x, by.y)


  dfx_char <- list(
    nrow = nrow(original_dfx),
    ncol = ncol(original_dfx)
  )

  dfy_char <- list(
    nrow = nrow(original_dfy),
    ncol = ncol(original_dfy)
  )



  sorting_dfx <- is_dataframe_sorted_by(original_dfx, set_by$by.x)
  sorting_dfy <- is_dataframe_sorted_by(original_dfy, set_by$by.y)


  common_vars <- intersect(sorting_dfx[[2]], sorting_dfy[[2]])
  is_common_sorted = !length(common_vars) == 0

  ## Store
  datasets_report <- list()
  datasets_report$dfx_char <- dfx_char
  datasets_report$dfy_char <- dfy_char
  datasets_report$sorting_dfx <- sorting_dfx
  datasets_report$sorting_dfy <- sorting_dfy
  datasets_report$is_common_sorted <- is_common_sorted


  # 5. Prepare Dataset for Join ----
  # - make into data.table.
  # - make into valid column names.
  # - check that by variable are in the colnames of the given dataset.
  # - factor to character (keep track of this), default = TRUE.

  prepared_dfx <- prepare_df(dfx,
                             by = set_by$by.x,
                             factor_to_char = factor_to_char)

  prepared_dfy <- prepare_df(dfy,
                             by = set_by$by.y,
                             factor_to_char = factor_to_char)

  # - Check that set_by$by.x is not in the non-key columns of dfy and vice-versa.
  # Note: this step needs to be done here because the column names might
  # change in the prepare_df() function.
  if (any(set_by$by.x %in% setdiff(names(prepared_dfy), set_by$by.y))) {
    stop("by.x is part of the non-index columns of dfy.")
  }
  if (any(set_by$by.y %in% setdiff(names(prepared_dfx), set_by$by.x))) {
    stop("by.y is part of the non-index columns of dfx.")
  }

  # MERGED DATA REPORT ----
  # 5. Merge ----
  # - use collapse to merge and keep matching and non-matching observations.

  ## Merge using Join
  merged_data <- collapse::join(prepared_dfx,
                                prepared_dfy,
                                on=stats::setNames(set_by$by.x, set_by$by.y),
                                how='full',
                                sort = TRUE, # now we sort the data by the key
                                multiple = TRUE,
                                suffix = c(".x",".y"),
                                keep.col.order = FALSE,
                                verbose = 0,
                                column = list("join", c("x", "y", "x_y")),
                                attr = TRUE)

  merged_data
}

