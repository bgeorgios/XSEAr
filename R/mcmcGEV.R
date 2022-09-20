mcmcGEV <- function(z, init.mu, init.sigma, init.xi, sim = 10000) {
  
  # return log-likelihood of the 3-parameter GEV distribution
  logLikeGEV <- function(mu, sigma, xi) {
    ll <-
      -n * log(sigma) - (1 + 1 / xi) * sum(log(1 + xi * (z - mu) / sigma)) - sum((1 + xi * (z - mu) / sigma) ** (-1 / xi))
    return(ll)
  }
  
  # get number of data values
  n <- length(z)
  
  # construct empty arrays to store MCMC iterations
  imu <- array(0, sim)
  isigma <- array(0, sim)
  ixi <- array(0, sim)
  
  # initialize parameters
  imu[1] <- init.mu
  isigma[1] <- init.sigma
  ixi[1] <- init.xi
  
  # std of the Gaussian priors
  stdmu <- 10
  stdsigma <- 10
  stdxi <- 10
  
  for (i in 2:sim) {
    
    # random walk proposals
    mu.new <- imu[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    sigma.new <- isigma[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    xi.new <- ixi[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    
    while (min(1 + xi.new * (z - mu.new) / sigma.new) < 0) {
      mu.new <- imu[i - 1] + rnorm(1, mean = 0, sd = 0.1)
      sigma.new <- isigma[i - 1] + rnorm(1, mean = 0, sd = 0.1)
      xi.new <- ixi[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    }
    
    # compute acceptance probability
    acc.prob <-
      exp(logLikeGEV(mu.new, sigma.new, xi.new) - logLikeGEV(imu[i - 1], isigma[i -
                                                                                  1], ixi[i - 1]))
    acc.prob <-
      acc.prob * dnorm(mu.new, x = 0, sd = stdmu) * dnorm(sigma.new, x = 0, sd = stdsigma) * dnorm(xi.new, x = 0, sd = stdxi)
    acc.prob <-
      acc.prob / dnorm(imu[i - 1], x = 0, sd = stdmu) / dnorm(isigma[i - 1], x = 0, sd = stdsigma) / dnorm(ixi[i -
                                                                                                                 1], x = 0, sd = stdxi)
    if (is.nan(acc.prob)) {
      acc.prob = 0
    }
    
    # update parameters
    if (runif(1) < acc.prob) {
      imu[i] = mu.new
      isigma[i] = sigma.new
      ixi[i] = xi.new
    }
    else{
      imu[i] = imu[i - 1]
      isigma[i] = isigma[i - 1]
      ixi[i] = ixi[i - 1]
    }
  }
  
  # save MCMC iterations to dataframe
  parameters <-
    data.frame(Location = imu,
               Scale = isigma,
               Shape = ixi)
  
  return(parameters)
  
}
