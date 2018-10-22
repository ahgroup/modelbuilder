#' @title A function that analyzes the model() object created or loaded in the main menu.
#'
#' @description This function takes the model specified in the main menu and
#' runs the simulation determined by the model parameters.
#'
#' @param modeltype A string indicating the type of model. Accepted values are "ode", "stochastic", and "discrete".
#' @param rngseed A random number seed for the simulation.
#' @param nreps Number of times to run the simulation.
#' @param plotscale Log or linear scale for the x-axis, y-axis, or both.
#' @param input The Shiny input list generated in the main menu app.
#' @param model The Shiny model() object generated in the main menu app.
#'
#' @return A list named "result" with the simulated dataframe and associated metadata.
#' @details This function is called by the Shiny server to produce the Shiny input UI elements.
#' @author Spencer D. Hall
#' @export

analyze_model <- function(modeltype, rngseed, nreps, plotscale, input, model) {
  # Set current working directory and load Rdata file
  # currentdir <- wd
  # rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  # load(rdatafile)

  #save all results to a list for processing plots and text
  listlength = 1
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results

  #temporary directory and files
  tempdir = tempdir()
  filename_ode=paste0("simulate_",gsub(" ","_",model$title),"_ode.R")
  filename_discrete=paste0("simulate_",gsub(" ","_",model$title),"_discrete.R")
  filename_stochastic=paste0("simulate_",gsub(" ","_",model$title),"_stochastic.R")

  #paths and names for all temporary files
  file_ode = file.path(tempdir,filename_ode)
  file_discrete = file.path(tempdir,filename_discrete)
  file_stochastic = file.path(tempdir,filename_stochastic)

  #as needed create, then source code and make fct call
  if (modeltype == 'ode')
  {
      if (!exists(file_ode)) #check if function/code is available, if not generate
      {
          #parses the model and creates the code to call/run the simulation
          generate_ode(model = model, location = file_ode)
      }
      source(file_ode) #source file
      fctcall <- generate_fctcall(input=input,model=model,modeltype='ode')
  }

  #as needed create, then source code and make fct call
  if (modeltype == 'discrete')
  {
      if (!exists(file_discrete)) #check if function/code is available, if not generate
      {
          #parses the model and creates the code to call/run the simulation
          generate_discrete(model = model, location = file_discrete)
      }
      source(file_discrete) #source file
      fctcall <- generate_fctcall(input=input,model=model,modeltype='discrete')
  }

  #as needed create, then source code and make fct call
  if (modeltype == 'stochastic')
  {
      if (!exists(file_stochastic)) #check if function/code is available, if not generate
      {
          #parses the model and creates the code to call/run the simulation
          generate_stochastic(model = model, location = file_stochastic)
      }
      source(file_stochastic) #source file
      fctcall <- generate_fctcall(input=input,model=model,modeltype='stochastic')
  }



  #run simulation, show a 'running simulation' message
  withProgress(message = 'Running Simulation',
               detail = "This may take a while", value = 0,
               {
                   eval(parse(text = fctcall)) #execute function
               })

  plotscale = isolate(input$plotscale)

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

  result[[1]]$xscale = 'identity'
  result[[1]]$yscale = 'identity'
  if (plotscale == 'x' | plotscale == 'both') { result[[1]]$xscale = 'log10'}
  if (plotscale == 'y' | plotscale == 'both') { result[[1]]$yscale = 'log10'}

  result[[1]]$maketext = TRUE #if true we want the generate_text function to process data and generate text, if 0 no result processing will occur insinde generate_text

  return(result)
}
