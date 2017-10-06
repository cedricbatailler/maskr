#' Create a SHA1 dictionary from a dataframe column
#'
#' Given a dataframe variable, returns a dictionary to be used to crypt and
#' decrypt this variable using \code{crypt()} and \code{decrypt()} functions
#'
#' @param .data Dataframe containing the variable
#' @param .var Column to be used to create the dictionary
#'
#' @import dplyr
#' @importFrom digest sha1
#' @importFrom stats setNames
#' @export
#'

dictionary <- function(.data, .var) {
  # Use dictionary specific method according to object's class
  UseMethod("dictionary")
}

#' @export
dictionary.data.frame <- function(.data, .var) {

  # Extract variable to be process as a string
  .varname <-
    deparse(substitute(.var) )

  # Within .data
  # Keep ".var" column
  # Then keep distinct observations
  # Then create a column "word" from the ".var" column
  # Select this new column
  # Then, create a new column which contains SHA1 hash of each observation
  # Finaly, return a dataframe with "word" and "cryptogram" column

  .data %>%
    select_(.varname) %>%
    distinct() %>%
    mutate_(.dots = setNames(list(.varname), "word") ) %>%
    select(word) %>%
    group_by(word) %>%
    mutate(cryptogram = sha1(word) ) %>%
    select(word, cryptogram)
}
