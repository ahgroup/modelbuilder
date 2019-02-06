context("test-generate_text.R")

#load SEIRS model for testing
modelpath = system.file("modelexamples", package = "modelbuilder")
load(paste0(modelpath,'/SEIRS_model.Rdata'))

#set settings for model to run
modelsettings = list(S = 1000, E = 0, I = 1, R = 0, bE = 1e-4, bI = 1e-3, gE = 1, gI = 1, w = 1, m = 100, n = 0.1, tstart  = 0, tfinal = 100, dt = 0.1)

modelsettings$nreps = 1
modelsettings$rngseed = 123
modelsettings$plotscale = 'lin'
modelsettings$modeltype = "_ode_"

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
