# benchmarking tools

set.seed(123)


# simulate data ---------------------------------------------------------------------

# number cases per group
I <- 10

# number groups
J <- 5

# parameters
intercept <- 0
beta <- 0.2
sigma <- 0.5

# covariate
X <- matrix(rnorm(I * J), nrow = I)

# random effects
ran_eff <- rnorm(I, 0, sigma)

# linear predictor
lambda <- intercept + beta * X + ran_eff

# repsonse variable
y <- matrix(rpois(I * J, exp(lambda)), nrow = I, byrow = TRUE)


# R ---------------------------------------------------------------------------------




# jags ------------------------------------------------------------------------------

library(dclone)
library(rjags)

model_code <- function() {
  # priors 
  intercept ~ dnorm(0, sd = 1/100)
  beta ~ dnorm(0, sd = 1/100)
  sigma ~ dunif(0, 10)
  # random effects and data  
  for(i in 1:10) {
    # random effects
    ran_eff[i] ~ dnorm(0, sd = sigma)
    for(j in 1:5) {
      # data
      y[i,j] ~ dpois(exp(intercept + beta*X[i,j] + ran_eff[i]))
    }
  }
}



# nimble ----------------------------------------------------------------------------

# remotes::install_github("nimble-dev/nimble", ref="AD-rc0", subdir="packages/nimble", quiet=TRUE)

library(nimble)
library(nimbleHMC)
nimbleOptions(enableDerivs = TRUE)

model_code <- nimbleCode({
  # priors 
  intercept ~ dnorm(0, sd = 100)
  beta ~ dnorm(0, sd = 100)
  sigma ~ dunif(0, 10)
  # random effects and data  
  for(i in 1:10) {
    # random effects
    ran_eff[i] ~ dnorm(0, sd = sigma)
    for(j in 1:5) {
      # data
      y[i,j] ~ dpois(exp(intercept + beta*X[i,j] + ran_eff[i]))
    }
  }
})

model <- nimbleModel(model_code, data = list(y = y), constants = list(X = X), calculate = FALSE,
                     buildDerivs = TRUE)

HMC <- buildHMC(model)

Cmodel <- compileNimble(model)

CHMC <- compileNimble(HMC, project = model)

samples <- runMCMC(CHMC, niter = 1000, nburnin = 500) # short run for illustration

summary(coda::as.mcmc(samples))


glmm_laplace <- buildLaplace(model, c('intercept','beta','sigma'))
Cglmm_laplace <- compileNimble(glmm_laplace, project = model)

Cglmm_laplace$Laplace(c(0, 0.5, 1))

Cglmm_laplace$gr_Laplace(c(0, 0, 1))

MLE <- Cglmm_laplace$LaplaceMLE(c(0, 0, 1))


# stan ------------------------------------------------------------------------------


# julia -----------------------------------------------------------------------------


# inla ------------------------------------------------------------------------------


# tmb -------------------------------------------------------------------------------


