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
  ind <- 0
  len.out <- choose(ncol(A), nrow(A))
  bfs <- vector(mode="list", length=len.out)
  indices <- vector(mode="list", length=len.out)
  
  for (i in 1:(ncol(A)-1))
  {
    for (j in (i+1):ncol(A))
    {
      ind <- ind + 1
      
      B <- A[, c(i, j)]
      if (det(B) == 0)
      {
        bfs[[ind]] <- "Not defined"
        indices[[ind]] <- c(i, j)
        next
      }
      
      # B^{-1}b
      bfs[[ind]] <- solve(B) %*% b
      indices[[ind]] <- c(i, j)
    }
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
    i <- inds[1]
    j <- inds[2]
    
    if (all(Binv_b > 0))
    {
      sol <- rep(0, bfs$n)
      sol[c(i, j)] <- Binv_b
      
      eps[[epsind]] <- sol
      epsind <- epsind + 1L
    }
  }
  
  class(eps) <- "ep"
  eps
}


