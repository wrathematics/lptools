#' Print a Simplex Table
#' 
#' Using the notation of Bazaraa et. al., given a table \code{x} and a
#' basis vector \code{Bs}, this will produce the LaTeX for a simplex
#' tableau.
#' 
#' @param x
#' A matrix of values for the simplex table.
#' @param Bs
#' The indices of the current basis.
#' @param digits
#' The number of decimal digits to use in the table.
#' 
#' @importFrom xtable xtable align
#' 
#' @export
tableau <- function(x, Bs, digits=0)
{
  namedBs <- sapply(Bs, function(i) ifelse(is.na(i), NA, paste0("$a_", i, "$")))
  df <- data.frame(cbind(x, namedBs))
  colnames(df) <- c("$z$", paste0("$x_", 1:(ncol(x)-2), "$"), "RHS", "$B_s$")
  
  tabl <- xtable::xtable(df, digits=digits)
  
  align <- paste0("r|r|", paste0(rep("r", ncol(x)-2), collapse=""), "|r|r|")
  xtable::align(tabl) <- align
  
  cat("\\begin{center}")
  print(tabl, floating=FALSE, include.rownames=FALSE, 
        hline.after=c(-1:1, nrow(x)), sanitize.text.function=function(x){x})
  cat("\\end{center}")
  
  invisible()
}
