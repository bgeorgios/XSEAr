mleTP <- function(z, init.beta = NULL, init.theta = NULL) {
  # z = numeric vector of data
  # init.beta = initial value for beta parameter
  # init.theta = initial value for theta parameter
  
  # get lower truncation threshold
  u <- min(z)
  
  # return tapered Pareto log-likelihood
  logLikeTP <- function(par) {
    n <- length(z)
    ll <-
      n * par[1] * log(u) + (1 / par[2]) * (n * u - sum(z)) - par[1] *
      sum(log(z)) + sum(log(par[1] / z + 1 / par[2]))
    return(-ll)
  }
  
  # optimize beta & theta
  mleproc <- optim(c(init.beta, init.theta), logLikeTP)
  
  # put parameters into list
  parlist <- list("Beta" = mleproc[["par"]][1], "Theta" = mleproc[["par"]][2])
  
  return(parlist)
}
