#' Decrypt one column from a crypted dataframe using a dictionary
#'
#' Given a maskr crypted dataframe and a dictionary, returns a decrypted data
#' frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param .var Column to be decrypted
#' @param dictionary Dictionary to be used to decrypt the crypted variable
#'
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom lazyeval interp
#' @export

decrypt <-
  function(.data, .var, dictionary)
  {
    # Use decrypt specific method according to object's class
    UseMethod("decrypt")
  }

#' @export

decrypt.data.frame <-
  function(.data, .var, dictionary)
  {
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
      left_join(dictionary, setNames("cryptogram", .varname) ) %>%
      mutate_(.dots = setNames(list(mutate_call), .varname) ) %>%
      select(-word)
  }
