#' Create a SHA1 dictionary
#'
#' Given a dataframe and some column variables, returns a dictionary to be used
#' to crypt and decrypt these variables using \code{encrypt()} and
#' \code{decrypt()} functions.
#'
#' @param .data Dataframe containing the variables
#' @param ... Column variables to be used to create the dictionary
#' @param .trunc Integer defining how many charachters the hash should be. Defaults to \code{.trunc = 6}
#'
#' @importFrom rlang set_names
#' @importFrom digest sha1
#' @importFrom purrr map
#' @import dplyr
#'
#' @examples
#' data(mtcars)
#' dictionary(mtcars, cyl, vs)
#'
#' @export

dictionary <- function(.data, ..., .trunc) {

  # Use dictionary specific method according to object's class

  UseMethod("dictionary")

}

#' @export

dictionary.data.frame <- function(.data, ... , .trunc = 6) {

  # Extract variables to be crypted as quosures

  .vars <- quos(...)

  # Within ".data", select ".vars" columns
  # Then keep unique observations
  # Convert to dataframe for subsequent use of dplyr
  # Then create a column "word" from the ".vars"
  # Select this new column
  # Then, create a new column which contains SHA1 hash of each observation
  # Finaly, return a dataframe with "word" and "cryptogram" columns

  .dic <-
    .data %>%
      select(!!!.vars) %>%
      map(., unique) %>%
      map(., data.frame) %>%
      map(~mutate(., word = .[, 1]) ) %>%
      map(~select(., word) ) %>%
      map(~group_by(., word) ) %>%
      map(~mutate(., cryptogram = substr(sha1(word), 1, .trunc) ) ) %>%
      map(~select(., word, cryptogram) )

}
