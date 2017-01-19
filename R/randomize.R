#' Randomize rows' order
#'
#' Randomize rows' order of a give data frame
#'
#' @param .data Dataframe containing rows' order to be randomized
#'
#' @import dplyr
#' @export
#'

randomize <-
  function(.data)
  {
    # Use randomize specific method according to object's class
    UseMethod("randomize")
  }

#' @export
randomize.data.frame <-
  function(.data)
  {
    .data %>%
      sample_n(n())
  }
