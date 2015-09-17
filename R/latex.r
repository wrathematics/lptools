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
latex <- function(object, ...) UseMethod("latex")



#' @param showName
#' Logical; should the name of the matrix be printed?
#' @param asTranspose
#' Display as the transpose?
#' @param dispname
#' Optional display name.
#' @param system
#' Logical; is this a system of equations? If so, a pipe is added to
#' separate the last column as a right hand side.
#' 
#' @examples
#' x <- matrix(1:25, 5)
#' latex(x)
#' 
#' @rdname latex
#' @export
latex.matrix <- function(object, inline=FALSE, digits=3, showName=TRUE, asTranspose=FALSE, system=FALSE, ..., dispname)
{
  if (missing(dispname) && showName)
  {
    dispname <- deparse(substitute(object))
    
    if (system)
      dispname <- paste0(dispname, "|b")
  }
  else
  {
    if (!showName)
      dispname <- ""
  }
  
  if (asTranspose)
    object <- t(object)
  
  cols <- paste(rep("r", ncol(object)-1), collapse="")
  if (system)
    cols <- paste0(cols, "|", collapse="")
  cols <- paste0(cols, "r", collapse="")
  
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
    cat("\\end{align*}")
  
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
    if (is.character(Binv_b))
      next
    
    inds <- object$indices[[ind]]
    
    cat(paste0("B^{-1}b = [", paste0("a_", inds, collapse=", "), "]^{-1}b &= "))
    latex(Binv_b, digits=digits, inline=TRUE, showName=FALSE, asTranspose=TRUE)
    cat("\\\\\n")
    #cat(paste0("[", paste(round(Binv_b, digits=digits), collapse=" "), "]^T\\\\\n"))
  }
  
  if (!inline)
    cat("\\end{align*}")
  
  invisible()
}


#' @param coordinates
#' An integer value from 1 to the length of any ep. Restricts the
#' display (so you can throw away non-basic variables).  If missing,
#' all are displayed.
#' @param xchar
#' Character (or string I guess!) to name the solution for display purposes.
#' 
#' @rdname latex
#' @export
latex.ep <- function(object, inline=FALSE, digits=3, coordinates, xchar="x", ...)
{
  if (!inline)
    cat("\\begin{align*}\n")
  
  if (missing(coordinates))
    coordinates <- 1:length(object[[1]])
  else
    coordinates <- 1:coordinates
  
  iter <- 1L
  
  for(ep in object)
  {
    cat(paste0("\\bf{", xchar, "}_", iter), " = ")
    iter <- iter + 1L
    
    cat(paste0("\\left[\\begin{array}{", paste0(rep("r", length(coordinates)), collapse=""), "}"))
    xvec <- paste(paste0("x_", coordinates), "&", collapse="")
    cat(substr(xvec, start=1, stop=nchar(xvec)-1))
    cat("\\end{array}\\right]^T\n")
    
    cat(" &= ") 
    
    latex(matrix(ep[coordinates]), showName=FALSE, inline=TRUE, asTranspose=TRUE, digits=digits)
    cat("\\\\\n")
  }
  
  if (!inline)
    cat("\\end{align*}")
  
  invisible()
}



#' @rdname latex
#' @export
latex.lp_solution <- function(object, digits=3, coordinates, ...)
{
  if (missing(coordinates))
    coordinates <- length(object$soln)
  
  cat(paste("the", object$type, "of the linear programming problem is "))
  cat(paste0("$", round(object$optimum, digits=digits), "$, which occurs at point "))
  cat("$")
  latex(object$soln[1:coordinates], inline=TRUE, asTranspose=TRUE, showName=FALSE, digits=digits)
  cat("$")
  
  invisible()
}

