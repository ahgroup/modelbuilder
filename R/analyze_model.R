#' @title A function that analyzes a modelbuilder model object.
#'
#' @description This function takes a modelbuilder model.
#' It runs the simulation determined by the model settings and returns simulation results.
#'
#' @param modelsettings vector of model settings:
#' \itemize{
#' \item modeltype : A string indicating the type of model. Accepted values are "ode", "stochastic", and "discrete".
#' \item rngseed : A random number seed for the simulation.
#' \item nreps : Number of times to run the simulation.
#' \item plotscale : Log or linear scale for the x-axis, y-axis, or both.
#' \item vars : initial condition for variables
#' \item pars : initial condition for parameters
#' \item times : settings for time
#' }
#' @param mbmodel A modelbuilder model object.
#' @return A list named "result" with the simulated dataframe and associated metadata.
#' @details This function runs a modelbuilder model for specific settings.
#' @author Spencer D. Hall, Andreas Handel
#' @export

analyze_model <- function(modelsettings, mbmodel) {

  #if not present, create code for all 3 simulators
  #temporary directory and files
  tempdir = tempdir()
  filename_ode=paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode.R")
  filename_discrete=paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete.R")
  filename_stochastic=paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic.R")

  #paths and names for all temporary files
  file_ode = file.path(tempdir,filename_ode)
  file_discrete = file.path(tempdir,filename_discrete)
  file_stochastic = file.path(tempdir,filename_stochastic)

  #if not present, create code for all 3 simulators
  if (!exists(file_ode)) #check if function/code is available, if not generate
  {
    generate_ode(model = mbmodel, location = file_ode)
  }
  if (!exists(file_discrete))
  {
    generate_discrete(model = mbmodel, location = file_discrete)
  }
  if (!exists(file_stochastic))
  {
    generate_stochastic(model = mbmodel, location = file_stochastic)
  }
  #source files
  source(file_ode)
  source(file_discrete)
  source(file_stochastic)

  fctcall <- generate_fctcall(modelsettings = modelsettings, mbmodel = mbmodel)

  #save all results to a list for processing plots and text
  listlength = 1
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results

  #run simulation, show a 'running simulation' message
  withProgress(message = 'Running Simulation',
               detail = "This may take a while", value = 0,
               {
                   eval(parse(text = fctcall)) #execute function
               })

  #data for plots and text
  #needs to be in the right format to be passed to generate_plots and generate_text
  #see documentation for those functions for details
  result[[1]]$dat = simresult$ts

  #Meta-information for each plot
  #Might not want to hard-code here, can decide later
  result[[1]]$plottype = "Lineplot"
  result[[1]]$xlab = "Time"
  result[[1]]$ylab = "Numbers"
  result[[1]]$legend = "Compartments"

  plotscale = modelsettings$plotscale

  result[[1]]$xscale = 'identity'
  result[[1]]$yscale = 'identity'
  if (plotscale == 'x' | plotscale == 'both') { result[[1]]$xscale = 'log10'}
  if (plotscale == 'y' | plotscale == 'both') { result[[1]]$yscale = 'log10'}

  result[[1]]$maketext = TRUE #if true we want the generate_text function to process data and generate text, if 0 no result processing will occur insinde generate_text

  return(result)
}
