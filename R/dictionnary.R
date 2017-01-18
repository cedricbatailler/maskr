#' @import dplyr
#' @export

dictionnary <- function(.data, .var) {
  UseMethod("dictionnary")
}

#' @export
dictionnary.data.frame <- function(.data, .var) {

  .varname <-
    deparse(substitute(.var))

  .data %>%
    select_(.varname) %>%
    distinct() %>%
    mutate_(.dots= setNames(list(.varname), "word")) %>%
    select(word) %>%
    group_by(word) %>%
    mutate(cryptogram = digest::sha1(word)) %>%
    select(word, cryptogram)
}
