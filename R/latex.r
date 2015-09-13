#' LaTeX printing
#' 
#' Displaying objects of the appropriate type, typeset in
#' LaTeX.  For use with knitr/sweave.
#' 
#' @param object
#' Object to print in LaTeX.
#' @param ...
#' Additional arguments.
#' @param digits
#' Number of rounding digits
#' 
#' @rdname latex
#' @name latex
#' @export
latex <- function(object, ...) UseMethod("latex")



#' @param asTranspose
#' Display as the transpose?
#' 
#' @examples
#' x <- matrix(1:25, 5)
#' latex(x)
#' 
#' @rdname latex
#' @export
latex.matrix <- function(object, digits=3, asTranspose=FALSE, ...)
{
  dispname <- deparse(substitute(object))
  if (asTranspose)
    object <- t(object)
  
  cat("\\begin{align*}")
  
  cols <- paste(rep("r", ncol(object)), collapse="")
  cat(paste0(dispname, " &= \\left[\\begin{array}{", cols, "}\n"))
  
  for (row in 1:nrow(object))
  {
    printrow <- paste(round(object[row, ], digits=digits), "&", collapse="")
    cat(substr(printrow, start=1, stop=nchar(printrow)-2), "\\\\\n")
  }
  cat("\\end{array}\\right]")
  if (asTranspose)
    cat("^T")
  cat("\\end{align*}")
  
  invisible()
}



#' @rdname latex
#' @export
latex.bfs <- function(object, digits=3, ...)
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



#' @rdname latex
#' @export
latex.ep <- function(object, digits=3, ...)
{
  cat("\\begin{align*}\n")
  
  for(ep in object)
    cat(paste("&", "[", paste(round(ep, digits=digits), collapse=","), "]^T\\\\\n"))
  
  cat("\\end{align*}\n")
  
  invisible()
}


