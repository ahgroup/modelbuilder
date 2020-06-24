context("test-generate_text.R")


#load a model for testing

#list of all example models that are provided and can be loaded
modelpath = system.file("modelexamples", package = "modelbuilder")
allexamplemodels = list.files(modelpath, full.names = TRUE)

#find some SIRS model and load it
modeltoload = allexamplemodels[min(grep('SIRSd',allexamplemodels))]
mbmodel <- readRDS(modeltoload)

#set settings for model to run
modelsettings = list(S = 1000, I = 1, b = 1e-4, g = 1, w = 1, m = 100, n = 0.1, tstart  = 0, tfinal = 100, dt = 0.1)

modelsettings$nreps = 1
modelsettings$rngseed = 123
modelsettings$plotscale = 'lin'
modelsettings$modeltype = "ode"
modelsettings$scanparam = 0

simresult <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)

test_that("generate_text returns text string",
{

  #no maketext provided, should be character of length 1
  expect_is( modelbuilder::generate_text(simresult), "html" )
  expect_is( modelbuilder::generate_text(simresult), "character" )
  expect_length( modelbuilder::generate_text(simresult), 1)
  #maketext false is same as above
  simresult[[1]]$maketext = FALSE
  expect_is( modelbuilder::generate_text(simresult), "html" )
  expect_is( modelbuilder::generate_text(simresult), "character" )
  expect_length( modelbuilder::generate_text(simresult), 1)
  #should now produce text
  simresult[[1]]$maketext = TRUE
  #should both be of class html and character
  expect_is( modelbuilder::generate_text(simresult), "html" )
  expect_is( modelbuilder::generate_text(simresult), "character" )
  simresult[[1]]$maketext = FALSE
  simresult[[1]]$showtext = 'Hello'
  expect_is( modelbuilder::generate_text(simresult), "html" )
  expect_is( modelbuilder::generate_text(simresult), "character" )
})
