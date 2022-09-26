
***mcmcGEV***: 

Function to implement a combined Markov Chain Monte Carlo (MCMC) and Metropolis-Hastings sampling scheme within the context of Bayesian inference from the 3-parameter Generalized Extreme Value (GEV) distribution. A prior joint distribution for the parameters is postulated as: $f(\mu,\sigma,\xi)=f(\mu)f(\sigma)f(\xi)$. Each marginal is a Gaussian distribution with zero mean and a standard deviation of 10 (uninformative priors). To propose new values, random walks are used: $\mu_{new}=\mu+\epsilon$ , $\sigma_{new}=\sigma+\epsilon$, $\xi_{new}=\xi+\epsilon$, where $\epsilon$ follows a Gaussian distribution with zero mean and a standard deviation of 0.1. The proposals and priors can be modified accordingly, as per needed.

***pwmGEV***:

Function to fit a GEV distribution using the probability weighted moments (PWM). 
