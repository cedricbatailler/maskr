#' Encrypt multiple columns from a dataframe
#'
#' Given a dataframe and some column variables, returns a crypted data frame.
#'
#' @param .data Dataframe containing the variables
#' @param .dic Dictionary containing the cryptograms
#' @param .randomize Randomize row order from \code{.data}. Defaults to \code{.randomize = TRUE}.
#'
#' @examples
#' data(mtcars)
#' dic <- dictionary(mtcars, cyl, vs)
#' mtcars_encrypted <- encrypt(mtcars, dic)
#'
#' @importFrom dplyr sample_n
#' @export

encrypt <- function(.data, .dic, .randomize = TRUE) {

  # Use encrypt specific method according to object's class

  UseMethod("encrypt")

}

#' @export

encrypt.data.frame <- function(.data, .dic, .randomize = TRUE) {

  for (i in 1:nrow(.dic) ) {

    var   <- .dic[[i, "variable"]]
    word  <- .dic[[i, "word"]]
    crypt <- .dic[[i, "cryptogram"]]

    if(!is.character(.data[[var]]))
      message(paste0("warning: ", var ," has been coerced to character."))


    .data[.data[[var]] == word, var] <- crypt

  }

  if(!.randomize) {return(.data)}

  sample_n(.data, nrow(.data) )

}

summary
