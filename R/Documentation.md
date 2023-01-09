
***mcmcGEV.R***

Function to implement a combined Markov Chain Monte Carlo (MCMC) and Metropolis-Hastings sampling scheme within the context of Bayesian inference for the 3-parameter Generalized Extreme Value (GEV) distribution. A prior joint distribution for the parameters is postulated as: $f(\mu,\sigma,\xi)=f(\mu)f(\sigma)f(\xi)$. Each marginal is a Gaussian distribution with zero mean and a standard deviation of 10 (uninformative priors). To propose new values, random walks are used: $\mu_{new}=\mu+\epsilon$ , $\sigma_{new}=\sigma+\epsilon$, $\xi_{new}=\xi+\epsilon$, where $\epsilon$ follows a Gaussian distribution with zero mean and a standard deviation of 0.1. The proposals and priors can be modified accordingly, as per needed.

***pwmGEV.R***

Function to fit a GEV distribution using the Probability Weighted Moments (PWM) method. An initial guess for the shape parameter (xi) is required since it is numerically optimized as a function of the first three sample PWMs.


***mleTP.R***

Function to fit a tapered Pareto distribution using the Maximum Likelihood Estimation (MLE) method. An initial guess for both the lower truncation threshold (beta) and the upper-cutoff (theta) parameters is required since they are numerically optimized.

***Boston-surge.csv***

Annual maxima storm surge values (m) extracted from NOAA (National Oceanic and Atmospheric Administration) tide gauge station at Boston, MA for 99 years.

***Crescent-tsunami.csv***
Tsunami amplitudes (m) extracted from NGDC/WDS Global Historical Tsunami Database for the tide gauge station at Crescent City, CA. Amplitudes less than 0.1 m that occured prior to 1960 have been filtered out.

