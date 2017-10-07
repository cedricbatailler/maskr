#' Create a SHA1 dictionary
#'
#' Given a dataframe and some column variables, returns a dictionary to be used
#' to crypt and decrypt these variables using \code{encrypt()} and
#' \code{decrypt()} functions.
#'
#' @param .data Dataframe containing the variables
#' @param ... Column variables to be used to create the dictionary
#'
#' @import dplyr
#' @importFrom digest sha1
#' @importFrom rlang set_names
#'
#' @examples
#' data(mtcars)
#' dictionary(mtcars, cyl)
#'
#' @export

dictionary <- function(.data, ...) {

  # Use dictionary specific method according to object's class

  UseMethod("dictionary")

}

#' @export

dictionary.data.frame <- function(.data, ...) {

  # Extract variables to be crypted as quosures

  .vars <- quos(...)

  # Within .data
  # Keep ".var" column
  # Then keep distinct observations
  # Then create a column "word" from the ".var" column
  # Select this new column
  # Then, create a new column which contains SHA1 hash of each observation
  # Finaly, return a dataframe with "word" and "cryptogram" column

  .data %>%
    select(!!!.vars) %>%
    distinct() %>%
    mutate_(.dots = set_names(.vars, "word") ) %>%
    select(word) %>%
    group_by(word) %>%
    mutate(cryptogram = sha1(word) ) %>%
    select(word, cryptogram)

}
