mcmcTP <- function(z, init.beta, init.theta, sim = 10000) {
  # z = numeric vector of data
  # init.beta = initial value for beta parameter
  # init.theta = initial value for theta parameter
  # sim = number of MCMC iterations (default = 10,000)
  
  # return log-likelihood of the 2-parameter TP distribution
  logLikeTP <- function(beta, theta) {
    n <- length(z)
    u <- min(z)
    ll <-
      n * beta * log(u) + (1 / theta) * (n * u - sum(z)) - beta *
      sum(log(z)) + sum(log(beta / z + 1 / theta))
    return(ll)
  }
  
  # construct empty arrays to store MCMC iterations
  ibeta <- array(0, sim)
  itheta <- array(0, sim)
  
  # initialize parameters
  ibeta[1] <- init.beta
  itheta[1] <- init.theta
  
  # std of the Gaussian priors
  stdbeta <- 10
  stdtheta <- 10
  
  for (i in 2:sim) {
    # random walk proposals
    beta.new <- ibeta[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    theta.new <- itheta[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    
    while (beta.new < 0 | theta.new < 0) {
      beta.new <- ibeta[i - 1] + rnorm(1, mean = 0, sd = 0.1)
      theta.new <- itheta[i - 1] + rnorm(1, mean = 0, sd = 0.1)
    }
    
    # compute acceptance probability
    acc.prob <-
      exp(logLikeTP(beta.new, theta.new) - logLikeTP(ibeta[i - 1], itheta[i - 1]))
    acc.prob <-
      acc.prob * dnorm(beta.new, mean = 0, sd = stdbeta) * dnorm(theta.new, mean = 0, sd = stdtheta)
    acc.prob <-
      acc.prob / dnorm(ibeta[i - 1], mean = 0, sd = stdbeta) / dnorm(itheta[i - 1], mean = 0, sd = stdtheta)
    if (is.nan(acc.prob)) {
      acc.prob <- 0
    }
    
    # update parameters
    if (runif(1) < acc.prob) {
      ibeta[i] <- beta.new
      itheta[i] <- theta.new
    }
    else{
      ibeta[i] <- ibeta[i - 1]
      itheta[i] <- itheta[i - 1]
    }
  }
  
  # save MCMC iterations to dataframe
  parameters <-
    data.frame(Shape = ibeta,
               Upper.Cutoff = itheta)
  return(parameters)
}