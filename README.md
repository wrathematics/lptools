<!-- Warning! Do not directly edit this file; see README.Rmd -->
# lptools 

* **Version:** 0.1
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/lptools.png)](https://travis-ci.org/wrathematics/lptools)
* **License:** [![License](http://img.shields.io/badge/license-BSD%202--Clause-orange.svg?style=flat)](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt


Linear programming tools to make doing my homework easier.


## Example

Say we have the system inspired from a linear program:


```r
library(lptools)

A <- matrix(c(1, 1, 1, 1, 0, -1, 1, 2, 0 , 1), byrow=TRUE, nrow=2)
b <- c(5, 6)
```

TODO


```r
latex(A)
```

```
## \begin{align*}
## A &= \left[
## \begin{array}{rrrrr}
## 1 &1 &1 &1 &0 \\
## -1 &1 &2 &0 &1 \\
## \end{array}\right]
## \end{align*}
```

TODO


```r
bfs <- find.bfs(A, b)
latex(bfs)
```

```
## \begin{align*}
## B^{-1}b = [a_1, a_2]^{-1}b &= [-0.5,5.5]^T\\
## B^{-1}b = [a_1, a_3]^{-1}b &= [1.333,3.667]^T\\
## B^{-1}b = [a_1, a_4]^{-1}b &= [-6,11]^T\\
## B^{-1}b = [a_1, a_5]^{-1}b &= [5,11]^T\\
## B^{-1}b = [a_2, a_3]^{-1}b &= [4,1]^T\\
## B^{-1}b = [a_2, a_4]^{-1}b &= [6,-1]^T\\
## B^{-1}b = [a_2, a_5]^{-1}b &= [5,1]^T\\
## B^{-1}b = [a_3, a_4]^{-1}b &= [3,2]^T\\
## B^{-1}b = [a_3, a_5]^{-1}b &= [5,-4]^T\\
## B^{-1}b = [a_4, a_5]^{-1}b &= [5,6]^T\\
## \end{align*}
```

TODO


```r
ep <- find.ep(bfs)
latex(ep)
```

```
## \begin{align*}
## & [ 1.333,0,3.667,0,0 ]^T\\
## & [ 5,0,0,0,11 ]^T\\
## & [ 0,4,1,0,0 ]^T\\
## & [ 0,5,0,0,1 ]^T\\
## & [ 0,0,3,2,0 ]^T\\
## & [ 0,0,0,5,6 ]^T\\
## \end{align*}
```



## Matrix Printing

There are numerous options for displaying matrices in LaTeX.  By default, the matrix will print inside of an `align*` environment and have its R name preceeding it.  However, we can print "inline" (without the automatic math mode), without showing the object name, or even print the transpose instead:


```r
x <- matrix(1:30, nrow=10)
latex(x, inline=TRUE, asTranspose=TRUE, showName=FALSE)
```

```
##   \left[
## \begin{array}{rrrrrrrrrr}
## 1 &2 &3 &4 &5 &6 &7 &8 &9 &10 \\
## 11 &12 &13 &14 &15 &16 &17 &18 &19 &20 \\
## 21 &22 &23 &24 &25 &26 &27 &28 &29 &30 \\
## \end{array}\right]^T
```

