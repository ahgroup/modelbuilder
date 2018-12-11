context("test-generate_text.R")



modelpath = system.file("modelexamples", package = "modelbuilder")
load(paste0(modelpath,'/SIR_model.Rdata'))

modelsettings = list()
modelsettings$rngseed = 123
modelsettings$nreps = 1
modelsettings$plotscale = "lin"
modelsettings$vars = c( S = 1000, I = 1, R = 0)
modelsettings$pars = c(b = 2e-3, g = 1)
modelsettings$times = c(tstart  = 0, tfinal = 100, dt = 0.1)

modelsettings$modeltype = "ode"
result = modelbuilder::analyze_model(modelsettings = modelsettings, mbmodel = mbmodel)


test_that("generate_text returns text string",
{

  #no maketext provided, should be character of length 1
  expect_is( modelbuilder::generate_text(result), "html" )
  expect_is( modelbuilder::generate_text(result), "character" )
  expect_length( modelbuilder::generate_text(result), 1)
  #maketext false is same as above
  result[[1]]$maketext = FALSE
  expect_is( modelbuilder::generate_text(result), "html" )
  expect_is( modelbuilder::generate_text(result), "character" )
  expect_length( modelbuilder::generate_text(result), 1)
  #should now produce text
  result[[1]]$maketext = TRUE
  #should both be of class html and character
  expect_is( modelbuilder::generate_text(result), "html" )
  expect_is( modelbuilder::generate_text(result), "character" )
  result[[1]]$maketext = FALSE
  result[[1]]$showtext = 'Hello'
  expect_is( modelbuilder::generate_text(result), "html" )
  expect_is( modelbuilder::generate_text(result), "character" )
})
