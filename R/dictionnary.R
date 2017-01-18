#' @import dplyr
#' @importFrom digest sha1
#' @export
#'

dictionnary <- function(.data, .var) {
  # Use dictionnary specific method according to object's class
  UseMethod("dictionnary")
}

#' @export
dictionnary.data.frame <- function(.data, .var) {

  # Extract variable to be process as a string
  .varname <-
    deparse(substitute(.var))

  # Within .data
  # Keep ".var" column
  # Then keep distinct obsevations
  # Then create a column "word" from the ".var" column
  # Select this new column
  # Then, create a new column which contains SHA1 hash of each observation
  # Finaly, return a dataframe with "word" and "cryptogram" column

  .data %>%
    select_(.varname) %>%
    distinct() %>%
    mutate_(.dots= setNames(list(.varname), "word")) %>%
    select(word) %>%
    group_by(word) %>%
    mutate(cryptogram = sha1(word)) %>%
    select(word, cryptogram)
}
