#' Find Basic Feasible Solutions
#' 
#' @param A
#' Coefficient matrix of the convex set.
#' @param b
#' Right hand side.
#' 
#' @return
#' A 'bfs' object.
#' 
#' @export
find.bfs <- function(A, b)
{
  combs <- combn(ncol(A), nrow(A))
  len.out <- ncol(combs)
  
  bfs <- vector(mode="list", length=len.out)
  indices <- vector(mode="list", length=len.out)
  
  for (ind in 1:len.out)
  {
    columns <- combs[, ind]
    
    B <- A[, columns]
    
    if (det(B) == 0)
    {
      bfs[[ind]] <- "Not defined"
      indices[[ind]] <- columns
      next
    }
    
    # B^{-1}b
    bfs[[ind]] <- solve(B) %*% b
    indices[[ind]] <- columns
  }
  
  ret <- list(bfs=bfs, indices=indices, n=ncol(A))
  class(ret) <- "bfs"
  ret
}



#' Find Extreme Points
#'
#' Find extreme points.
#' 
#' @param bfs
#' A bfs object, returned from \code{find.bfs()}.
#' 
#' @return 
#' An 'ep' class object.
#' 
#' @export
find.ep <- function(bfs)
{
  if (class(bfs) != "bfs")
    stop("Argument 'bfs' must be a 'bfs' object.")
  
  eps <- list()
  epsind <- 1L
  
  for (ind in 1:length(bfs$bfs))
  {
    Binv_b <- bfs$bfs[[ind]]
    
    inds <- bfs$indices[[ind]]
    
    if (all(Binv_b >= 0))
    {
      sol <- rep(0, bfs$n)
      sol[inds] <- Binv_b
      
      eps[[epsind]] <- sol
      epsind <- epsind + 1L
    }
  }
  
  class(eps) <- "ep"
  eps
}



optimize_lp <- function(z, ep, optfun)
{
  if (class(ep) != "ep")
    stop("Argument 'ep' must be of class 'ep'")
  
  if (length(z) != length(ep[[1]]))
    stop("Objective function coefficients 'z' must match the number of coefficients of the ep's")
  
  if (class(optfun) != "function")
    stop("Argument 'optfun' must be a function of a single variable")
  
  zfun <- function(x) crossprod(z, x)
  vals <- sapply(ep, zfun)
  op <- optfun(vals)
  at <- which(op == vals)
  
  
  optimum <- list(optimum=op, soln=ep[[at]])
  class(optimum) <- "lp_solution"
  
  optimum
}



#' Optimize Linear Programming Problem
#' 
#' Given a set of extreme points and the coefficients of an
#' objective function
#' 
#' @param z
#' The coefficients of the objective function, including zeros from
#' slack variables if applicable.
#' @param ep
#' A set of extreme points (the output of \code{find.ep()}).
#' 
#' @name optimize
#' @rdname optimize
#' @export
minimize <- function(z, ep)
{
  optimum <- optimize_lp(z=z, ep=ep, optfun=min)
  optimum$type <- "minimum"
  
  optimum
}



#' @rdname optimize
#' @export
maximize <- function(z, ep)
{
  optimum <- optimize_lp(z=z, ep=ep, optfun=max)
  optimum$type <- "maximum"
  
  optimum
}


