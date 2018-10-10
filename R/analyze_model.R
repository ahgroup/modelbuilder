## analyze_model.R

analyze_model <- function(wd, modeltype, rngseed, nreps, plotscale, input, input_model) {
  # Set current working directory and load Rdata file
  currentdir <- wd
  rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  load(rdatafile)

  #save all results to a list for processing plots and text
  listlength = 1
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results

  #check if function/code is available, if not generate and source code as temp file
  if (modeltype == 'ode' & !exists( paste0("simulate_",gsub(" ","_",model$title),"_ode") ) )
  {
      location = tempdir() #temporary directory to save file
      filename=paste0("simulate_",gsub(" ","_",model$title),"_ode.R")
      generate_ode(model = model, location = paste0(location,filename))
      source(paste0(location,filename)) #source file
  }

  #parses the model and creates the code to call/run the simulation
  fctcall <- generate_fctcall(input=input,model=model,modeltype='ode',
                              input_model = input_model)

  #run simulation, show a 'running simulation' message
  withProgress(message = 'Running Simulation', value = 0,
               {
                   print("Run")
                   eval(parse(text = fctcall)) #execute function
               })

}
