# load required package
package <- c("coda")
load <- lapply(package, library, character.only = TRUE)

"%nin%" <- Negate("%in%")

quanticTest <- function(x, tau = 0.50) {
  # x = numeric vector of data
  
  # compute quantics
  quantic <- numeric(length = length(x))
  xi <- quantile(x, probs =  tau)
  idx <- which(x > xi)
  idy <- which(x < xi)
  quantic[idx] <- tau
  quantic[idy] <- tau - 1
  
  # compute test statistic eta
  if (sum(quantic, na.rm = TRUE) > 0) {
    iq.zero <-
      -sum(quantic, na.rm = TRUE) / length(which(is.na(quantic)))
  } else if (sum(quantic, na.rm = TRUE) < 0) {
    iq.zero <-
      sum(quantic, na.rm = TRUE) / length(which(is.na(quantic)))
  } else {
    iq.zero <- 0
  }
  
  quantic[which(is.na(quantic))] <- iq.zero
  T <- length(x)
  
  innerSigma <- function(t, q = quantic) {
    inner.sigma <- sum(q[1:t])
  }
  
  outerSigma <- function(T) {
    outer.sigma <- sapply(1:T, innerSigma, q = quantic)
    outer.sigma <- sum(outer.sigma ** 2)
  }
  
  outer.sigma <- outerSigma(T)
  
  eta <- 1 / (T ** 2 * tau * (1 - tau)) * outer.sigma
  
  # get p-value according to CvM(1) distribution
  pval <- 1 - pcramer(eta)
  
  # return FALSE if Ho is rejected, i.e., if the time series is non-stationary
  if (pval <= 0.05) {
    bool <- FALSE
  } else {
    bool <- TRUE
  }
  
  return(bool)
}
