#' @export
masked_character <- function(word) {
  as_masked_character(word)
}

#' @export
as_masked_character <- function(x) {
  structure(x, class = "masked_character")
}

#' @export
c.masked_character <- function(x, ...) {
  as_masked_character(NextMethod())
}

#' @export
`[.masked_character` <- function(x, i) {
  as_masked_character(NextMethod())
}

#' @export
format.masked_character <- function(x, ...) {
  ret <- rep("######", length(x) )
  format(ret, justify = "right")
}

#' @export
print.masked_character <- function(x, ...) {
  cat(format(x), sep = "\n")
  invisible(x)
}

#' @export
type_sum.masked_character <- function(x) {
  "masked chr"
}

#' @export
pillar_shaft.masked_character <- function(x, ...) {
  out <- format(x)
  out[is.na(x)] <- NA
  pillar::new_pillar_shaft_simple(out, align = "right")
}
