#' Decrypt multiple columns from a crypted dataframe
#'
#' Given a maskr crypted dataframe and some column variables, returns a decrypted
#' data frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param ... Columns to be decrypted
#'
#' @import dplyr
#' @importFrom rlang f_rhs
#' @importFrom rlang set_names
#' @importFrom lazyeval interp
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#' mtcars_decrypted <- decrypt(mtcars_encrypted, cyl)
#'
#' @export

## quiets concerns notes of R CMD check
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".",".dic",".old",
  "word","cryptogram","set_names") )

decrypt <- function(.data, ... ) {

  # Use decrypt specific method according to object's class

  UseMethod("decrypt")

}

#' @export

decrypt.data.frame <- function(.data, ... ) {

  # Extract variables to be process as quosures

  .vars <-
    quos(...)

  # Take ".data" and for each encrypted variable
  # append dictionary using a match between "cryptogram" and ".var"
  # set ".var" columns value to "word" one's
  # drop "word" column

  mutate_call <-
    interp(~word)

  for(i in 1:length(.vars) ) {

    .var <- .vars[i]

    .data <-
      .data %>%
        left_join(.dic[[i]], set_names("cryptogram", f_rhs(.var[[1]]) ) ) %>%
        mutate_(.dots = set_names(list(mutate_call), f_rhs(.var[[1]]) ) ) %>%
        select(-word)
  }

  return(.data)

}
