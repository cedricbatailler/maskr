#' Decrypt one column from a crypted dataframe
#'
#' Given a maskr crypted dataframe and a column variable, returns a decrypted
#' data frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param ... Columns to be decrypted
#'
#' @import dplyr
#' @importFrom rlang set_names
#' @importFrom lazyeval interp
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#' mtcars_decrypted <- decrypt(mtcars_encrypted, cyl)
#' identical(mtcars, mtcars_decrypted)
#'
#' @export

## quiets concerns notes of R CMD check
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".","word","cryptogram","set_names") )

decrypt <- function(.data, ...){

  # Use decrypt specific method according to object's class

  UseMethod("decrypt")

}

#' @export

decrypt.data.frame <- function(.data, ...){

  # Retreving the code, using the dictionary function

  .old_data <-
    attributes(.data)$old %>%
    get

  .dic <-
    attributes(.data)$dic

  # Extract variables to be process as quosures

  .vars <- quos(...)

  # Take ".data"
  # and append dictionary using a match between "cryptogram" and ".var"
  # set ".var" columns value to "word" one's
  # drop "word" column

  mutate_call <-
    interp(~word)

  .data %>%
    left_join(.dic, set_names("cryptogram", substr(paste(.vars), 2, 10) ) ) %>%
    mutate_(.dots = set_names(list(mutate_call), substr(paste(.vars), 2, 10) ) ) %>%
    select(-word) %>%
    setattr(., "row.names", rownames(.old_data) )

}
