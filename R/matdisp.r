#' Display a Matrix in LaTeX
#' 
#' @param A
#' Matrix to display.
#' 
#' @return
#' A character string of the matrix data inside an \code{align*} 
#' environment.
#'
#' @examples
#' x <- matrix(1:25, 5)
#' matdisp(x)
#' 
#' @export
matdisp <- function(A)
{
  dispname <- deparse(substitute(A))
  
  cat("\\begin{align*}")
  cols <- paste(rep("r", ncol(A)), collapse="")
  cat(paste0(dispname, " &= \\left[\\begin{array}{", cols, "}\n"))
  for (row in 1:nrow(A))
  {
    printrow <- paste(A[row, ], "&", collapse="")
    cat(substr(printrow, start=1, stop=nchar(printrow)-2), "\\\\\n")
  }
  cat("\\end{array}\\right]")
  cat("\\end{align*}")
  
  invisible()
}
