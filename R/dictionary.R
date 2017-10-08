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
#' @importFrom purrr map
#' @importFrom digest sha1
#' @importFrom rlang set_names
#'
#' @examples
#' data(mtcars)
#' dictionary(mtcars, cyl)
#'
#' @export

dictionary <- function(.data, ... ) {

  # Use dictionary specific method according to object's class

  UseMethod("dictionary")

}

#' @export

dictionary.data.frame <- function(.data, ... ) {

  # Extract variables to be crypted as quosures

  .vars <- quos(...)

  # .dic <- list()
  #
  # for(i in 1:length(.vars) ) {
  #
  #   .var <- .vars[i]
  #
  #   .dic[[i]] <-
  #     .data %>%
  #     select(!!!.var) %>%
  #     distinct() %>%
  #     mutate_(.dots = set_names(.var, "word") ) %>%
  #     select(word) %>%
  #     group_by(word) %>%
  #     mutate(cryptogram = sha1(word) ) %>%
  #     select(word, cryptogram)
  # }
  #
  # return(.dic)

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
      map(~mutate(., cryptogram = sha1(word) )  ) %>%
      map(~select(., word, cryptogram) )

}
