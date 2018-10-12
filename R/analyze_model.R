## analyze_model.R

analyze_model <- function(wd, modeltype, rngseed, nreps, plotscale, input) {
  # Set current working directory and load Rdata file
  print("Checkpoint 1")
  currentdir <- wd
  rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  load(rdatafile)

  print("Checkpoint 2")

  #save all results to a list for processing plots and text
  listlength = 1
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results

  #check if function/code is available, if not generate and source code as temp file
  if (modeltype == 'ode' & !exists( paste0("simulate_",gsub(" ","_",model$title),"_ode") ) )
  {
      print("Running first alternative")
      location = tempdir() #temporary directory to save file
      filename=paste0("simulate_",gsub(" ","_",model$title),"_ode.R")
      generate_ode(model = model, location = paste0(location,filename))
      source(paste0(location,filename)) #source file
  }

  location = tempdir() #temporary directory to save file
  filename=paste0("simulate_",gsub(" ","_",model$title),"_ode.R")
  source(paste0(wd, "/", filename)) #source file


  #parses the model and creates the code to call/run the simulation
  fctcall <- generate_fctcall(input=input,model=model,modeltype='ode')

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

  return(result)
}
