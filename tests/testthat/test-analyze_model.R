context("test-analyze_model.R")

test_that("use SIR model to test analyze_model function",
{

  load('./inst/modelexamples/SIR_model.Rdata')
  modelsettings = list()
  modelsettings$rngseed = 123
  modelsettings$nreps = 1
  modelsettings$plotscale = "lin"
  modelsettings$vars = c( S = 1000, I = 1, R = 0)
  modelsettings$pars = c(b = 2e-3, g = 1)
  modelsettings$times = c(tstart  = 0, tfinal = 100, dt = 0.1)

  #test ODE code
  modelsettings$modeltype = "ode"
  result = modelbuilder::analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be 203 for specified model/setting
  testthat::expect_equal(round(tail(result[[1]]$dat$S,1)),203)

  #test discrete time code
  modelsettings$modeltype = "discrete"
  result = analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be 197 for specified model/setting
  testthat::expect_equal(round(tail(result[[1]]$dat$S,1)),197)

  #test stochastic code
  modelsettings$modeltype = "stochastic"
  modelsettings$vars = c( S = 1000, I = 10, R = 0)
  result = analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be 155 for specified model/setting
  testthat::expect_equal(round(tail(result[[1]]$dat$S,1)), 155)

})
