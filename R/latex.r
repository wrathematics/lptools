#' LaTeX printing
#' 
#' Displaying objects of the appropriate type, typeset in
#' LaTeX.  For use with knitr/sweave.
#' 
#' @param object
#' Object to print in LaTeX.
#' @param inline
#' Logical; should the latex be written inline (TRUE), i.e. you have started
#' math mode yourself, or not inline (FALSE), i.e. an \code{align*}
#' environment is set up for you.
#' @param ...
#' Additional arguments.
#' @param digits
#' Number of rounding digits
#' 
#' @rdname latex
#' @name latex
#' @export
latex <- function(object, inline=FALSE, ...) UseMethod("latex")



#' @param showName
#' Logical; should the name of the matrix be printed?
#' @param asTranspose
#' Display as the transpose?
#' @param dispname
#' Optional display name.
#' 
#' @examples
#' x <- matrix(1:25, 5)
#' latex(x)
#' 
#' @rdname latex
#' @export
latex.matrix <- function(object, inline=FALSE, digits=3, showName=TRUE, asTranspose=FALSE, ..., dispname)
{
  if (missing(dispname))
  {
    if (showName)
      dispname <- deparse(substitute(object))
    else
      dispname <- ""
  }
  else
  {
    if (!showName)
      dispname <- ""
  }
  
  if (asTranspose)
    object <- t(object)
  
  cols <- paste(rep("r", ncol(object)), collapse="")
  
  if (!inline)
  {
    cat("\\begin{align*}\n")
    sepchar <- "&"
  }
  else
    sepchar <- ""
  
  if (showName)
    sepchar <- paste0(sepchar, "=")
  
  cat(paste0(dispname, " ", sepchar, " \\left[\n\\begin{array}{", cols, "}\n"))
  
  for (row in 1:nrow(object))
  {
    printrow <- paste(round(object[row, ], digits=digits), "&", collapse="")
    cat(substr(printrow, start=1, stop=nchar(printrow)-2), "\\\\\n")
  }
  cat("\\end{array}\\right]")
  if (asTranspose)
    cat("^T\n")
  else
    cat("\n")
  
  if (!inline)
    cat("\\end{align*}\n")
  
  invisible()
}



#' @rdname latex
#' @export
latex.numeric <- function(object, inline=FALSE, digits=3, showName=TRUE, asTranspose=FALSE, ...)
{
  dispname <- deparse(substitute(object))
  object <- as.matrix(object)
  latex.matrix(object=object, inline=inline, digits=digits, showName=showName, asTranspose=asTranspose, dispname=dispname)
}



#' @rdname latex
#' @export
latex.bfs <- function(object, inline=FALSE, digits=3, ...)
{
  if (!inline)
    cat("\\begin{align*}\n")
  
  for (ind in 1:length(object$bfs))
  {
    Binv_b <- object$bfs[[ind]]
    
    inds <- object$indices[[ind]]
    
    cat(paste0("B^{-1}b = [", paste0("a_", inds, collapse=", "), "]^{-1}b &= "))
    cat(paste0("[", paste(round(Binv_b, digits=digits), collapse=","), "]^T\\\\\n"))
  }
  
  if (!inline)
    cat("\\end{align*}\n")
  
  invisible()
}



#' @rdname latex
#' @export
latex.ep <- function(object, inline=FALSE, digits=3, ...)
{
  if (!inline)
    cat("\\begin{align*}\n")
  
  for(ep in object)
    cat(paste("&", "[", paste(round(ep, digits=digits), collapse=","), "]^T\\\\\n"))
  
  if (!inline)
    cat("\\end{align*}\n")
  
  invisible()
}



#' @rdname latex
#' @export
latex.lp_solution <- function(object, digits=3, ...)
{
  cat(paste("So the", object$type, "of the linear programming problem is "))
  cat(paste0("$", round(object$optimum, digits=digits), "$, which occurs at point "))
  cat("$")
  latex(object$soln, inline=TRUE, asTranspose=TRUE, showName=FALSE, digits=digits)
  cat("$")
  
  invisible()
}

