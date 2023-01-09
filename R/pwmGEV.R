pwmGEV <- function(z, init.xi=NULL) {
  # z = numeric vector of data (typically, annual maxima values)
  # init.xi = initial value for xi parameter
  
  z <- sort(z)
  n <- length(z)
  
  # assign Weibull plotting position for probabilities of non-exceedance
  pjn <- (seq(1, length(z)) - 1) / (n)

  # compute sample probability-weighted moments (b0, b1, and b2)
  bo <- mean(z)
  br <- sum(pjn * z) / n
  brr <- sum(pjn ** 2 * z) / n
  
  # function to be optimized with respect to xi
  compXi <- function(par) {
    equ <-
      (3 * brr - bo) / (2 * br - bo) - (1 - 3 ** (-par)) / (1 - 2 ** (-par))
    return (equ)
  }
  
  # optimize xi
  xi <- uniroot(compXi, interval = c(-1, 1))[["root"]]
  
  # compute location and scale parameters
  sigma <- (2 * br - bo) * xi / (gamma(1 + xi) * (1 - 2 ** (-xi)))
  mu <- bo + sigma * (gamma(1 + xi) - 1) / xi
  
  return(list("Location"=mu, "Scale"=sigma, "Shape"=-xi))
}
