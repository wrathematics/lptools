#' @export
latex <- function(object, ...) UseMethod("latex")



#' Display a Matrix
#' 
#' Display a matrix in LaTeX.  For use with knitr/sweave.
#' 
#' @param A
#' Matrix to display.
#' @param digits
#' Number of rounding digits.
#' 
#' @examples
#' x <- matrix(1:25, 5)
#' display(x)
#' 
#' @export
latex.matrix <- function(object, digits=3)
{
  dispname <- deparse(substitute(object))
  
  cat("\\begin{align*}")
  cols <- paste(rep("r", ncol(object)), collapse="")
  cat(paste0(dispname, " &= \\left[\\begin{array}{", cols, "}\n"))
  for (row in 1:nrow(object))
  {
    printrow <- paste(round(object[row, ], digits=digits), "&", collapse="")
    cat(substr(printrow, start=1, stop=nchar(printrow)-2), "\\\\\n")
  }
  cat("\\end{array}\\right]")
  cat("\\end{align*}")
  
  invisible()
}



#' Display Basic Feasible Solutions
#' 
#' Display a bfs in LaTeX.  For use with knitr/sweave.
#' 
#' @param object
#' A 'bfs' object.
#' @param digits
#' Number of rounding digits.
#' 
#' @export
latex.bfs <- function(object, digits=3)
{
  cat("\\begin{align*}\n")
  
  for (ind in 1:length(object$bfs))
  {
    Binv_b <- object$bfs[[ind]]
    
    inds <- object$indices[[ind]]
    i <- inds[1]
    j <- inds[2]
    
    cat(paste0("B^{-1}b = [a_", i, ", a_", j, "]^{-1}b &= "))
    cat(paste0("[", paste(round(Binv_b, digits=digits), collapse=","), "]^T\\\\\n"))
  }
  
  cat("\\end{align*}\n")
  
  invisible()
}



#' Display Extreme Points
#' 
#' @param object
#' An 'ep' object.
#' @param digits
#' Number of rounding digits.
#' 
#' @export
latex.ep <- function(object, digits=3)
{
  cat("\\begin{align*}\n")
  
  for(ep in object)
    cat(paste("&", "[", paste(round(ep, digits=digits), collapse=","), "]^T\\\\\n"))
  
  cat("\\end{align*}\n")
  
  invisible()
}


