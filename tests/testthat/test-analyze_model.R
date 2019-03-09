context("test-analyze_model.R")

test_that("use SIR model to test analyze_model function",
{


  #load SIR model for testing
  modelpath = system.file("modelexamples", package = "modelbuilder")
  load(paste0(modelpath,'/SIR_model.Rdata'))

  #set settings for model to run
  modelsettings = list( S = 1000, I = 1, R = 0, b = 2e-3, g = 1, tstart  = 0, tfinal = 100, dt = 0.1)

  modelsettings$nreps = 1
  modelsettings$plotscale = 'lin'
  modelsettings$rngseed = 115
  modelsettings$scanparam = 0

  #test ODE code
  modelsettings$modeltype = "_ode_"
  simresult = modelbuilder::analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be specified number for this model/setting
  susceptibles = dplyr::filter(simresult[[1]]$dat, varnames == 'S')
  sfinal = round(tail(susceptibles$yvals,1))
  testthat::expect_equal(sfinal,203)

  #test discrete time code
  modelsettings$modeltype = "_discrete_"
  simresult = modelbuilder::analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be specified number  for this model/setting
  susceptibles = dplyr::filter(simresult[[1]]$dat, varnames == 'S')
  sfinal = round(tail(susceptibles$yvals,1))
  testthat::expect_equal(sfinal,197)

  #test stochastic code
  modelsettings$modeltype = "_stochastic_"
  simresult = modelbuilder::analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)
  #final number of susceptible need to be specified number for this model/setting/rngseed
  susceptibles = dplyr::filter(simresult[[1]]$dat, varnames == 'S')
  sfinal = round(tail(susceptibles$yvals,1))
  testthat::expect_equal(sfinal,148)


})
