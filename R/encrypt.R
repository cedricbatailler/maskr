#' Crypt one column from a  dataframe using a dictionnary
#'
#' Given a maskr dataframe and a dictionnary, returns a crypted data
#' frame.
#'
#' @param .data Dataframe containing the variable
#' @param .var Column to be crypted
#' @param .dictionnary Dictionnary to be used to crypt the variable
#'
#' @import dplyr
#' @importFrom stats SetNames
#' @importFrom lazyeval interp
#' @export

encrypt <-
  function(.data, .var, dictionnary)
  {
    # Use encrypt specific method according to object's class
    UseMethod("encrypt")
  }

#' @export

encrypt.data.frame <-
  function(.data, .var, dictionnary)
  {
    # Extract variable to be process as a string
    .varname <-
      deparse(substitute(.var))

    # Take ".data"
    # and append dictionnary using a match between "word" and ".var"
    # set ".var" columns value to "cryptogram" one's
    # drop "cryptogram" column

    mutate_call <-
      interp(~cryptogram)

    .data %>%
      left_join(dictionnary, setNames("word", .varname)) %>%
      mutate_(.dots = setNames(list(mutate_call), .varname)) %>%
      select(-cryptogram)

  }
