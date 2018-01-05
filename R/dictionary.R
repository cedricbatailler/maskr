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
#' @importFrom purrr map_df
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
  # Convert to dataframe
  # Then, create a new column which contains SHA1 hash of each observation

  .data %>%
      select(!!!.vars) %>%
      map(unique) %>%
      map_df(~data.frame(word = .x), .id = "variable") %>%
      group_by(word) %>%
      mutate(cryptogram = substr(sha1(word), 1, .trunc) )
}
