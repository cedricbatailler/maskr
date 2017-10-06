#' Encrypt one column from a  dataframe using a dictionary
#'
#' Given a maskr dataframe and a dictionary, returns a crypted data
#' frame.
#'
#' @param .data Dataframe containing the variable
#' @param .var Column to be crypted
#'
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom lazyeval interp
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

    # Take ".data"
    # and append dictionary using a match between "word" and ".var"
    # set ".var" columns value to "cryptogram" one's
    # drop "cryptogram" column

    mutate_call <-
      interp(~cryptogram)

    .data_old_name <-
      deparse(substitute(.data) )

    .data %>%
      left_join(.dic, setNames("word", .varname) ) %>%
      mutate_(.dots = setNames(list(mutate_call), .varname) ) %>%
      select(-cryptogram) %>%
      setattr(., "old", .data_old_name)

}
