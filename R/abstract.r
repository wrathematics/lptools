#' Abstract an R Object
#' 
#' A simple function to "abstract" an R object into the R code which would
#' produce it.  A simple wrapper around \code{base::dump()}.
#' 
#' @param x
#' An R object
#' 
#' @examples
#' df <- data.frame(index=1:5, x=rnorm(5))
#' df
#' abstract(df)
#' 
#' @name abstract
#' @rdname abstract
#' @export
abstract <- function(x) dump(deparse(substitute(x)), stdout())
