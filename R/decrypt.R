#' Decrypt one column from a crypted dataframe
#'
#' Given a maskr crypted dataframe and a column variable, returns a decrypted
#' data frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param .var Column to be decrypted
#'
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom lazyeval interp
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#' mtcars_decrypted <- decrypt(mtcars_encrypted, cyl)
#' identical(mtcars, mtcars_decrypted)
#'
#' @export

## quiets concerns of R CMD check
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".","word","cryptogram") )

decrypt <- function(.data, .var){

  # Use decrypt specific method according to object's class

  UseMethod("decrypt")

}

#' @export

decrypt.data.frame <- function(.data, .var){

  # Retreving the code, using the dictionary function

  .old_data <-
    attributes(.data)$old %>%
    get

  .dic <-
    dictionary(.old_data, .var)

  # Extract variable to be process as a string

  .varname <-
    deparse(substitute(.var) )

  # Take ".data"
  # and append dictionary using a match between "cryptogram" and ".var"
  # set ".var" columns value to "word" one's
  # drop "word" column

  mutate_call <-
    interp(~word)

  .data %>%
    left_join(.dic, setNames("cryptogram", .varname) ) %>%
    mutate_(.dots = setNames(list(mutate_call), .varname) ) %>%
    select(-word) %>%
    setattr(., "row.names", rownames(.old_data) )

}
