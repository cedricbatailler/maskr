#' Encrypt multiple columns from a dataframe
#'
#' Given a dataframe and some column variables, returns a crypted data frame.
#'
#' @param .data Dataframe containing the variables
#' @param .dic Dictionary containing the cryptograms
#' @param ... Columns to be encrypted
#'
#' @importFrom data.table setattr
#' @importFrom lazyeval interp
#' @importFrom rlang set_names
#' @importFrom rlang f_rhs
#' @import dplyr
#'
#' @examples
#' data(mtcars)
#' dic <- dictionary(mtcars, cyl, vs)
#' mtcars_encrypted <- encrypt(mtcars, dic, cyl, vs)
#'
#' @export

encrypt <- function(.data, .dic, ...) {

  # Use encrypt specific method according to object's class

  UseMethod("encrypt")

}

#' @export

encrypt.data.frame <- function(.data, .dic, ...) {

    # Extract variables to be process as quosures

    .vars <- quos(...)

    # Take ".data" and for each to-be encrypted variable
    # append dictionary using a match between "word" and ".var"
    # set ".var" columns value to "cryptogram" one's
    # drop "cryptogram" column

    mutate_call <- interp(~cryptogram)

    for (i in 1:length(.vars) ) {

      .var <- .vars[i]

      .data <-
        .data %>%
          left_join(.dic[[i]], set_names("word", f_rhs(.var[[1]]) ) ) %>%
          mutate_(.dots = set_names(list(mutate_call), f_rhs(.var[[1]]) ) ) %>%
          select_(~-cryptogram)

    }

    return(.data)

}
