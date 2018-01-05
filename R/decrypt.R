#' Decrypt multiple columns from a crypted dataframe
#'
#' Given a maskr crypted dataframe and some column variables, returns a decrypted
#' data frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param .dic Dictionary containing the cryptograms
#'
#' @examples
#' data(mtcars)
#' dic <- dictionary(mtcars, cyl, vs)
#' mtcars_encrypted <- encrypt(mtcars, dic)
#' mtcars_decrypted <- decrypt(mtcars_encrypted, dic)
#'
#' @export

decrypt <- function(.data, .dic) {

  # Use decrypt specific method according to object's class

  UseMethod("decrypt")

}

#' @export

decrypt.data.frame <- function(.data, .dic) {

  for (i in 1:nrow(.dic) ) {

    var   <- .dic[[i, "variable"]]
    word  <- .dic[[i, "word"]]
    crypt <- .dic[[i, "cryptogram"]]

    .data[.data[[var]] == crypt, var] <- word

  }
  .data

}
