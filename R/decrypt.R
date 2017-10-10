#' Decrypt multiple columns from a crypted dataframe
#'
#' Given a maskr crypted dataframe and some column variables, returns a decrypted
#' data frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param .dic Dictionary containing the cryptograms
#' @param ... Columns to be decrypted
#'
#' @importFrom rlang set_names
#' @importFrom lazyeval interp
#' @importFrom rlang f_rhs
#' @import dplyr
#'
#' @examples
#' data(mtcars)
#' dic <- dictionary(mtcars, cyl, vs)
#' mtcars_encrypted <- encrypt(mtcars, dic, cyl, vs)
#' mtcars_decrypted <- decrypt(mtcars_encrypted, dic, cyl, vs)
#'
#' @export

decrypt <- function(.data, .dic, ...) {

  # Use decrypt specific method according to object's class

  UseMethod("decrypt")

}

#' @export

decrypt.data.frame <- function(.data, .dic, ...) {

  # Extract variables to be process as quosures

  .vars <- quos(...)

  # Take ".data" and for each encrypted variable
  # append dictionary using a match between "cryptogram" and ".var"
  # set ".var" columns value to "word" one's
  # drop "word" column

  mutate_call <- interp(~word)

  for (i in 1:length(.vars) ) {

    .var <- .vars[i]

    .data <-
      .data %>%
        left_join(.dic[[i]], set_names("cryptogram",
          deparse(f_rhs(.var[[1]]) ) ) ) %>%
        mutate_(.dots = set_names(list(mutate_call),
          deparse(f_rhs(.var[[1]]) ) ) ) %>%
        select_(~-word)
  }

  return(.data)

}
