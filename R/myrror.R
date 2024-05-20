#' myrror main function
#'
#' @param dfx a non-empty data.frame
#' @param dfy a non-empty data.frame
#' @param by character, key to be used for dfx and dfy
#' @param by.x character, key to be used for dfx
#' @param by.y character, key to be used for dfy
#' @param tolerance tolerance list. Can be: NULL, 'no_cap', 'no_symbols', 'no_whitespace'
#' @param factor_to_char TRUE or FALSE, default to TRUE.
#'
#' @return draft: selection of by variables
#' @export
#' @import collapse
#'
#' @examples
#' comparison <- myrror(iris, iris_var1)
myrror <- function(dfx,
                   dfy,
                   by = NULL,
                   by.x = NULL,
                   by.y = NULL,
                   tolerance = NULL,
                   factor_to_char = TRUE) {


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

  # 2. Apply tolerance to columns and by -----
  # - Check if tolerance vector is non-null.
  # - Apply specific adjustments (draft, to be updated) -> column names might change.
  # - Record changes (can use tolerance vector).

  if (!is.null(tolerance)) {
    names(dfx) <- apply_tolerance(names(dfx), tolerance = tolerance)
    names(dfy) <- apply_tolerance(names(dfy), tolerance = tolerance)

    if (!is.null(by)) {
      by <- apply_tolerance(by, tolerance = tolerance)
    }

    if (!is.null(by.x)) {
      by.x <- apply_tolerance(by.x, tolerance = tolerance)
    }

    if (!is.null(by.y)) {
      by.y <- apply_tolerance(by.y, tolerance = tolerance)
    }
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
    if (!is.null(rownames(dfx)) && !is.null(rownames(dfy))) {
      by.x <- by.y <- "rownames"
      # Optionally add row names as columns if they are not already present
      if (!"rownames" %in% colnames(dfx)) {
        dfx$rownames <- rownames(dfx)
      }
      if (!"rownames" %in% colnames(dfy)) {
        dfy$rownames <- rownames(dfy)
      }
    }
  }

  # 4. Prepare Dataset for Alignment ----
  # - make into data.table.
  # - make into valid column names.
  # - check that by variable are in the colnames of the given dataset.
  # - factor to character (keep track of this), default = TRUE

  prepared_dfx <- prepare_alignment(dfx, by = by.x, factor_to_char = factor_to_char)
  prepared_dfy <- prepare_alignment(dfy, by = by.y, factor_to_char = factor_to_char)

  # 5. Align Columns and Merge ----
  # - check that by.x is not in the non-key columns of dfy and vice versa.
  # - check that there are no duplicates in x and in y.
  # - Give row index to x and y
  # - use collapse to merge and keep all matching and non-matching observations


  ## Check that by.x is not in the non-key columns of dfy and vice versa
  if (by.x %in% setdiff(names(prepared_dfy), by.y)) {
    stop("by.x is part of the non-index columns of dfy.")
  }
  if (by.y %in% setdiff(names(prepared_dfx), by.x)) {
    stop("by.y is part of the non-index columns of dfx.")
  }

  ## Check for duplicate column names in both datasets
  if (length(unique(names(prepared_dfx))) != length(names(prepared_dfx))) {
    stop("Duplicate column names found in dfx.")
  }
  if (length(unique(names(prepared_dfy))) != length(names(prepared_dfy))) {
    stop("Duplicate column names found in dfy.")
  }

  ## Give row index to x and y (called row.x and row.y)
  prepared_dfx[, 'row_index' := .I]
  prepared_dfy[, 'row_index' := .I]

  ## Join
  #merged_data <- merge(prepared_dfx, prepared_dfy,
  #                     by.x = by.x, by.y = by.y,
  #                     all = TRUE, suffixes = c(".x", ".y"))

  merged_data <- collapse::join(prepared_dfx,
                                prepared_dfy,
                                on=setNames(by.x, by.y),
                                how='full',
                                sort = TRUE, # already sorted here !!
                                multiple = TRUE,
                                suffix = c(".x",".y"),
                                keep.col.order = FALSE,
                                verbose = 0,
                                column = list("join", c("x", "y", "x_y")),
                                attr = TRUE)

  ## Store
  merged_data_report <- list()
  merged_data_report$merged_data <- merged_data


  # 6. Get matched and non-matched ----
  ## Match
  # old: matched_data <- merged_data[!is.na('row.x') & !is.na('row.y')]
  matched_data <- merged_data |> fsubset(join == 'x_y')

  ## Identify non-matched rows from both dfx and dfy and combine them
  #non_matched_data <- rbind(
  #  merged_data[is.na('row.y'), .SD],
  #  merged_data[is.na('row.x'), .SD],
  # fill = TRUE  # Fill missing columns with NA in case dfx and dfy have different columns
  #)

  unmatched_data <- merged_data |> fsubset(join != 'x_y')

  ## Add a 'source' column to identify which dataset each row came from
  #non_matched_data[, source := ifelse(is.na('row.x'), "dfy", "dfx")]

  ## Store
  merged_data_report$unmatched_data <- unmatched_data


  # Preliminary outputs for checks (then to be moved to object)
  output <- list()
  output$dfx <- original_dfx
  output$dfy <- original_dfy
  output$tolerance <- tolerance
  output$processed_dfx<-dfx
  output$processed_dfy<-dfy
  output$prepared_dfy<-prepared_dfy
  output$prepared_dfx<-prepared_dfx
  output$by.x <- by.x
  output$by.y <- by.y
  output$merged_data_report <- merged_data_report


  return(output)

}

