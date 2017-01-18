#' @import dplyr
#' @export

decrypt <-
  function(.data, .var, dictionnary)
  {
    UseMethod("decrypt")
  }

#' @export

decrypt.data.frame <-
  function(.data, .var, dictionnary)
  {
    .varname <-
      deparse(substitute(.var))

    .data %>%
      left_join(dictionnary, setNames("cryptogram", .varname)) %>%
      rename_(.dots = setNames(.varname, "old")) %>%
      rename_(.dots = setNames("word", .varname)) %>%
      select(-old)
  }
