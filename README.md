# glmm-multilang-comparison

Comparing Bayesian languages to doing a Poisson GLMM, possibly with Laplace approximation and GPU computation

Languages include:

-   R lmer4 (non Bayesian)
-   [JAGS](https://mcmc-jags.sourceforge.io/)
-   [nimble](https://r-nimble.org/)
-   [nimble HMC (with and without Laplace approximation)](https://r-nimble.org/ad-beta)
-   [stan (alone and via brms)](https://mc-stan.org/)
-   [julia](https://juliastats.org/MixedModels.jl/dev/) - [can we access the GPU](https://juliapackages.com/p/advancedhmc)?
-   [tmb](https://kaskr.github.io/adcomp/)
