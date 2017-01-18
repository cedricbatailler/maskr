#' @import dplyr
#' @export

encrypt <-
  function(.data, .var, dictionnary)
  {
    UseMethod("encrypt")
  }

#' @export

encrypt.data.frame <-
  function(.data, .var, dictionnary)
  {
    .varname <-
      deparse(substitute(.var))

    .data %>%
      left_join(dictionnary, setNames("word", .varname)) %>%
      rename_(.dots = setNames(.varname, "old")) %>%
      rename_(.dots = setNames("cryptogram", .varname)) %>%
      select(-old)

  }
