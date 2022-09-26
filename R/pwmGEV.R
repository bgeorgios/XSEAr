pwmGEV <- function(z, init.xi) {
  
  z <- sort(z)
  
  n <- length(z)
  bo <- mean(z)
  pjn <- seq(1, length(z)) / (n + 1)
  br <- sum(pjn * z) / n
  brr <- sum(pjn ** 2 * z) / n
  
  compXi <- function(par) {
    equ <-
      (3 * brr - bo) / (2 * br - bo) - (1 - 3 ** (-par)) / (1 - 2 ** (-par))
    return (equ)
  }
  
  xi <- optim(c(init.xi), compXi)[["value"]]
  
  sigma <- (2 * br - bo) * xi / (gamma(1 + xi) * (1 - 2 ** (-xi)))
  mu <- bo + sigma * (gamma(1 + xi) - 1) / xi
  return(list(mu, sigma, xi))
}
