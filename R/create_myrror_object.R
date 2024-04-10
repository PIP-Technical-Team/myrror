#' Create Myrror Object
#'
#' Creates an empty list of class 'myrror'.
#'
#' @return list
#' @export
#'
#' @examples
#' new_myrror_object <- create_myrror_object()
#'
#' new_myrror_object
create_myrror_object <-
  function() {

    myrror_object <- list()

    class(myrror_object) <- 'myrror'

    return(myrror_object)

  }
