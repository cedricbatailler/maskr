#' Decrypt one column from a crypted dataframe using a dictionnary
#'
#' Given a maskr crypted dataframe and a dictionnary, returns a decrypted data
#' frame.
#'
#' @param .data Dataframe containing crypted variable
#' @param .var Column to be decrypted
#' @param .dictionnary Dictionnary to be used to decrypt the crypted variable
#'
#' @import dplyr
#' @export

decrypt <-
  function(.data, .var, dictionnary)
  {
    # Use decrypt specific method according to object's class
    UseMethod("decrypt")
  }

#' @export

decrypt.data.frame <-
  function(.data, .var, dictionnary)
  {
    # Extract variable to be process as a string

    .varname <-
      deparse(substitute(.var))

    # Take ".data"
    # and append dictionnary using a match between "cryptogram" and ".var"
    # rename ".var" as old
    # rename "word" from dictionnary as ".var"
    # drop "old" column

    .data %>%
      left_join(dictionnary, setNames("cryptogram", .varname)) %>%
      rename_(.dots = setNames(.varname, "old")) %>%
      rename_(.dots = setNames("word", .varname)) %>%
      select(-old)
  }
