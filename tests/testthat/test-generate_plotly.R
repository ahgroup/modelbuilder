context("test-generate_plotly.R")


#load a model for testing

#list of all example models that are provided and can be loaded
modelpath = system.file("modelexamples", package = "modelbuilder")
allexamplemodels = list.files(modelpath, full.names = TRUE)

#find some SIRS model and load it
modeltoload = allexamplemodels[min(grep('SIRS',allexamplemodels))]
mbmodel <- readRDS(modeltoload)

#set settings for model to run
modelsettings = list( S = 1000, I = 9, b = 2e-3, g = 1, tstart  = 0, tfinal = 100, dt = 0.1)

modelsettings$nreps = 1
modelsettings$rngseed = 123
modelsettings$plotscale = 'lin'

modelsettings$modeltype = "ode"
modelsettings$scanparam = 0

simresult <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)

test_that("generate_plotly returns a plot for an ODE model without specifying anything",
          {
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
          })

test_that("generate_plotly returns a plot when choosing scatterplot or boxplot",
          {
              simresult[[1]]$plottype = "Scatterplot"
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
              simresult[[1]]$plottype = "Boxplot"
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
          })


modelsettings$modeltype = "stochastic"
modelsettings$scanparam = 0

simresult <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)

test_that("generate_plotly returns a plot for a stochastic model without specifying anything",
          {
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
          })

modelsettings$modeltype = "discrete"
modelsettings$scanparam = 0

simresult <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)

test_that("generate_plotly returns a plot for a discrete model without specifying anything",
          {
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
          })

modelsettings$scanparam = 1
modelsettings$pardist = "lin"
modelsettings$parnum = 10
modelsettings$parmin = 0.1
modelsettings$parmax = 1
modelsettings$partoscan = "g"

simresult <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)

test_that("generate_plotly returns 2 plots when setting scanparam to 1 for ODE model",
          {
              expect_is( modelbuilder::generate_plotly(simresult), "plotly" )
          })

