context("test-generate_plots.R")


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


test_that("generate_plots returns a plot without specifying anything",
{
  expect_is( modelbuilder::generate_plots(result), "ggplot" )
})

test_that("generate_plots returns a plot when choosing scatterplot or boxplot",
{
            result[[1]]$plottype = "Scatterplot"
            expect_is( modelbuilder::generate_plots(result), "ggplot" )
            result[[1]]$plottype = "Boxplot"
            expect_is( modelbuilder::generate_plots(result), "ggplot" )
})
