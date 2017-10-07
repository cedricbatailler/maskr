#' Encrypt one column from a dataframe
#'
#' Given a dataframe and a column variable, returns a crypted data frame.
#'
#' @param .data Dataframe containing the variable
#' @param ... Columns to be encrypted
#'
#' @import dplyr
#' @importFrom rlang set_names
#' @importFrom lazyeval interp
#' @importFrom data.table setattr
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#'
#' @export

encrypt <- function(.data, ...){

  # Use encrypt specific method according to object's class

  UseMethod("encrypt")

}

#' @export

encrypt.data.frame <- function(.data, ...){

    # Creating the code, using the dictionary function

    .dic <-
      dictionary(.data, ...)

    # Extract variables to be process as quosures

    .vars <- quos(...)

    # Store the old name of the original dataframe,
    # to assign it later as an attribute (fragile...)

    .data_old_name <-
      deparse(substitute(.data) )

    # Take ".data"
    # and append dictionary using a match between "word" and ".var"
    # set ".var" columns value to "cryptogram" one's
    # drop "cryptogram" column

    mutate_call <-
      interp(~cryptogram)

    .data %>%
      left_join(.dic, set_names("word", substr(paste(.vars), 2, 10) ) ) %>%
      mutate_(.dots = set_names(list(mutate_call), substr(paste(.vars), 2, 10) ) ) %>%
      select(-cryptogram) %>%
      setattr(., "old", .data_old_name) %>%
      setattr(., "dic", .dic)

}
