#' Encrypt multiple columns from a dataframe
#'
#' Given a dataframe and some column variables, returns a crypted data frame.
#'
#' @param .data Dataframe containing the variables
#' @param ... Columns to be encrypted
#'
#' @import dplyr
#' @importFrom rlang f_rhs
#' @importFrom rlang set_names
#' @importFrom lazyeval interp
#' @importFrom data.table setattr
#'
#' @examples
#' data(mtcars)
#' mtcars_encrypted <- encrypt(mtcars, cyl)
#'
#' @export

encrypt <- function(.data, ... ){

  # Use encrypt specific method according to object's class

  UseMethod("encrypt")

}

#' @export

encrypt.data.frame <- function(.data, ... ){

    # Creating the code, using the dictionary function

    .dic <-
      dictionary(.data, ... )

    # Extract variables to be process as quosures

    .vars <-
      quos(...)

    # Take ".data" and for each to-be encrypted variable
    # append dictionary using a match between "word" and ".var"
    # set ".var" columns value to "cryptogram" one's
    # drop "cryptogram" column

    mutate_call <-
      interp(~cryptogram)

    for(i in 1:length(.vars) ) {

      .var <- .vars[i]

      .data <-
        .data %>%
          left_join(.dic[[i]], set_names("word", f_rhs(.var[[1]]) ) ) %>%
          mutate_(.dots = set_names(list(mutate_call), f_rhs(.var[[1]]) ) ) %>%
          select(-cryptogram)

    }

    # Assign .dic to the parent environment
    # in order to be retrieved later by decrypt

    assign(".dic", .dic, parent.frame() )

    return(.data)

}
