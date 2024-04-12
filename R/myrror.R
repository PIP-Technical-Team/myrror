#' myrror main function
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param tolerance tolerance list. Can be: NULL, 'no_cap', 'no_symbols', 'no_whitespace'
#'
#' @return draft: selection of by variables
#' @export
#'
#' @examples
#' comparison <- myrror(iris, iris_var1)
myrror <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   tolerance = NULL) {


  # 0. Store original datasets ----

  original_dfx <- dfx
  original_dfy <- dfy

  # 1. Check dfx and dfy arguments ----
  # - df1 and df2 needs to be data.frames structures and not empty.
  # - if NULL, say that that there is a NULL, and stop.
  # - if list, check it could be transformed into a data.frame, and then transform.

  # Check if dfx or dfy are NULL
  if (is.null(dfx) || is.null(dfy)) {
    stop("Input data frame(s) cannot be NULL.")
  }

  # Check if dfx or dfy are data frames, if not, try to convert them if they are lists
  if (!is.data.frame(dfx)) {
    if (is.list(dfx)) {
      tryCatch({
        dfx <- as.data.frame(dfx)
      }, error = function(e) {
        stop("dfx is a list but cannot be converted to a data frame.")
      })
    } else {
      stop("dfx must be a data frame or a convertible list.")
    }
  }

  if (!is.data.frame(dfy)) {
    if (is.list(dfy)) {
      tryCatch({
        dfy <- as.data.frame(dfy)
      }, error = function(e) {
        stop("dfy is a list but cannot be converted to a data frame.")
      })
    } else {
      stop("dfy must be a data frame or a convertible list.")
    }
  }

  # Check if dfx or dfy are empty
  if ((!is.null(dfx) && nrow(dfx) == 0) || (!is.null(dfy) && nrow(dfy) == 0)) {
    stop("Input data frame(s) cannot be empty.")
  }

  # 2. Apply tolerance -----
  # - Check if tolerance vector is non-null.
  # - Apply specific adjustments (draft, to be updated).
  # - Record changes (can use tolerance vector)

  if (!is.null(tolerance)) {
    names(dfx) <- apply_tolerance_colnames(names(dfx), tolerance = tolerance)
    names(dfy) <- apply_tolerance_colnames(names(dfy), tolerance = tolerance)
  }

  # 3. Check by, by.x, by.y arguments: ----
  # - by, by.x, by.y needs to be of 'character' type
  # - either by specified, or by.y AND by.x specified, or NULL
  # - if NULL, it will become a row.names comparison
  # - if row.names comparison, then add row names as columns and assign them to keys

  # Validate by, by.x, by.y for non-empty character vectors
  if (!is.null(by) && (!is.character(by) || length(by) == 0)) {
    stop("The 'by' argument must be a non-empty character vector.")
  }
  if (!is.null(by.x) && (!is.character(by.x) || length(by.x) == 0)) {
    stop("The 'by.x' argument must be a non-empty character vector.")
  }
  if (!is.null(by.y) && (!is.character(by.y) || length(by.y) == 0)) {
    stop("The 'by.y' argument must be a non-empty character vector.")
  }

  # Check if 'row.names' is used as an actual column name
  if ("rownames" %in% colnames(dfx) || "rownames" %in% colnames(dfy)) {
    stop("'rownames' should not be used as a column name in the datasets.")
  }

  # Handle the keys for comparison
  if (!is.null(by)) {
    by.x <- by.y <- by
  } else if (is.null(by.x) || is.null(by.y)) {
    # Default to row.names if no other keys are provided
    if (!is.null(row.names(dfx)) && !is.null(row.names(dfy))) {
      by.x <- by.y <- "rownames"
      # Optionally add row names as columns if they are not already present
      if (!"rownames" %in% colnames(dfx)) {
        dfx$rownames <- row.names(dfx)
      }
      if (!"rownames" %in% colnames(dfy)) {
        dfy$rownames <- row.names(dfy)
      }
    }
  }



  # Preliminary outputs for checks
  output <- list()
  output$dfx <- original_dfx
  output$dfy <- original_dfy
  output$tolerance <- tolerance
  output$processed_dfx<-dfx
  output$processed_dfy<-dfy
  output$by.x <- by.x
  output$by.y <- by.y


  return(output)

}

