#' Encrypt one column from a dataframe
#'
#' Given a dataframe and a column variable, returns a crypted data frame.
#'
#' @param .data Dataframe containing the variable
#' @param .var Column to be crypted
#'
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom lazyeval interp
#' @importFrom data.table setattr
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#'
#' @export

encrypt <- function(.data, .var){

  # Use encrypt specific method according to object's class

  UseMethod("encrypt")

}

#' @export

encrypt.data.frame <- function(.data, .var){

    # Creating the code, using the dictionary function

    .dic <-
      dictionary(.data, .var)

    # Extract variable to be process as a string

    .varname <-
      deparse(substitute(.var) )

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
      left_join(.dic, setNames("word", .varname) ) %>%
      mutate_(.dots = setNames(list(mutate_call), .varname) ) %>%
      select(-cryptogram) %>%
      setattr(., "old", .data_old_name) %>%
      setattr(., "dic", .dic) %>%
      setattr(., "class", c("maskr.df", "data.frame") )

}
