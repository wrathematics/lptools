#' Add Slack Variables
#' 
#' From a coefficient matrix, add slack variables.
#' 
#' This operation comes in two flavors, goverened by functions
#' \code{slack()} and \code{slackdir()}.  For the former, given a 
#' coefficient matrix \code{A} and an index of rows \code{rows},
#' this will return the coefficient matrix with slack variables
#' added appropriately.  The latter does the same, but for
#' extreme direction problems; in particular, it adds the constraint
#' for the sum of the \code{d}'s.
#' 
#' @param A
#' Coefficient matrix.
#' @param rows
#' Index of rows which are _not_ equality constraints.  If left blank,
#' all are assumed to be inequality constraints.
#' 
#' @name slack
#' @rdname slack
#' @export
slack <- function(A, rows)
{
  if (missing(rows))
    rows <- 1:nrow(A)
  
  if (any(rows < 1) || any(rows > nrow(A)))
    stop("Argument 'rows' must be a vector of indices no less than 1 and no greater than the number of rows of matrix A")
  
  rows <- unique(sort(rows))
  I <- diag(1, length(rows))
  
  noslack <- setdiff(1:nrow(A), rows)
  if (length(noslack) > 0)
  {
    tmp <- matrix(0, nrow=nrow(A), ncol=ncol(I))
    tmp[rows, ] <- I
    tmp[noslack, ] <- 0
    
    I <- tmp
  }
  
  cbind(A, I)
}

#slack(A)
#slack(A, 1:3)

#' @rdname slack
#' @export
#' @export
slackdir <- function(A, rows)
{
  D <- slack(A=A, rows=rows)
  
  rbind(D, c(rep(1, ncol(A)), rep(0, ncol(D)-ncol(A))))
}

