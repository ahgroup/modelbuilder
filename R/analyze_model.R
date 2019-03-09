#' @title A function that analyzes a modelbuilder model object.
#'
#' @description This function takes a modelbuilder model and model settings.
#' It runs the simulation determined by the model settings and returns simulation results.
#'
#' @param modelsettings vector of model settings:
#' \itemize{
#' \item modeltype : A string indicating the type of model. Accepted values are "ode", "stochastic", and "discrete".
#' \item rngseed : A random number seed for the simulation.
#' \item nreps : Number of times to run the simulation.
#' \item plotscale : Log or linear scale for the x-axis, y-axis, or both.
#' \item vars : named vector of initial conditions for variables
#' \item pars : named vector of initial conditions for parameters
#' \item times : named vector of values for tstart, tfinal, dt
#' }
#' @param mbmodel A modelbuilder model object.
#' @return A list named "result" with the simulated dataframe and associated metadata.
#' @details This function runs a modelbuilder model for specific settings.
#' @importFrom stats setNames
#' @export

analyze_model <- function(modelsettings, mbmodel) {


  #short function to call/run model
  runsimulation <- function(modelsettings, currentmodel)
  {
    #extract modeslettings inputs needed for simulator function
    modinput = unlist(modelsettings, recursive = TRUE)
    x = names(formals(currentmodel)$vars); x = x[x!=""] #get rid of empty element
    x2 = match(x, names(modinput))
    varargs = modinput[x2]
    x = names(formals(currentmodel)$pars); x = x[x!=""] #get rid of empty element
    x2 = match(x, names(modinput))
    parargs = modinput[x2]
    x = names(formals(currentmodel)$times); x = x[x!=""] #get rid of empty element
    x2 = match(x, names(modinput))
    timeargs = modinput[x2]
    currentargs = list(vars = setNames(as.numeric(varargs), names(varargs)), pars = setNames(as.numeric(parargs), names(parargs)), time = setNames(as.numeric(timeargs), names(timeargs)))
    #at random seed input for stochastic models
    if (modelsettings$currentmodel == "stochastic") {currentargs$rngseed = modelsettings$rngseed}
    #run simulation, try command catches error from running code.
    simresult <- try( do.call(currentmodel, args = currentargs ) )
    return(simresult)
  }

  #save all results to a list for processing plots and text
  #list corresponds to number of plots
  #1 plot for time-series only
  #2 plots if we sample over parameter
  listlength = ifelse(modelsettings$scanparam == 1, 2, 1)
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results
  datall = NULL #will hold data for all different models and replicates

  #make a temp directory to save file
  tempdir = tempdir()

  #################################################
  #check what type of model
  #if not present, create code for simulator
  if (grepl('_ode_',modelsettings$modeltype)) #need to always start with ode_ in model specification
  {
    modelsettings$currentmodel = 'ode'
    currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode")
    sim_filename = paste0(currentmodel,".R")
    sim_file = file.path(tempdir, sim_filename)
    if (!exists(sim_file)) {modelbuilder::generate_ode(mbmodel = mbmodel, location = sim_file)}
  }
  if (grepl('_discrete_',modelsettings$modeltype))
  {
    modelsettings$currentmodel = 'discrete'
    currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete")
    sim_filename = paste0(currentmodel,".R")
    sim_file = file.path(tempdir, sim_filename)
    if (!exists(sim_file)) {modelbuilder::generate_discrete(mbmodel = mbmodel, location = sim_file)}
  }
  if (grepl('_stochastic_',modelsettings$modeltype))
  {
    modelsettings$currentmodel = 'stochastic'
    currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic")
    sim_filename = paste0(currentmodel,".R")
    sim_file = file.path(tempdir, sim_filename)
    if (!exists(sim_file)) {modelbuilder::generate_stochastic(mbmodel = mbmodel, location = sim_file)}
  }
  #source file
  source(sim_file)



  ##################################
  #stochastic dynamical model execution
  ##################################
    for (nn in 1:modelsettings$nreps)
    {
      modelsettings$rngseed = modelsettings$rngseed + 1 #need to update RNG seed each time to get different runs
      simresult[[nn]] = runsimulation(modelsettings, currentmodel)
    }


      if (class(simresult)!="list")
      {
        result <- 'Model run failed. Maybe unreasonable parameter values?'
        return(result)
      }
      #data for plots and text
      #needs to be in the right format to be passed to generate_plots and generate_text
      #see documentation for those functions for details
      colnames(simresult$ts)[1] = 'xvals' #rename time to xvals for consistent plotting
      #reformat data to be in the right format for plotting
      dat = tidyr::gather(as.data.frame(simresult$ts), -xvals, value = "yvals", key = "varnames")
      dat$IDvar = paste(dat$varnames,nn,sep='') #make a variable for plotting same color lines for each run in ggplot2
      dat$nreps = nn
      datall = rbind(datall,dat)
    }


    if (modelsettings$scanparam == 1) #scan over parameter
    {
      npar = modelsettings$parnum
      if (modelsettings$pardist == 'lin') {parvals = seq(modelsettings$parmin,modelsettings$parmax,length=npar)}
      if (modelsettings$pardist == 'log') {parvals = 10^seq(log10(modelsettings$parmin),log10(modelsettings$parmax),length=npar)}
      maxvals = matrix(0 ,nrow = npar, ncol = length(mbmodel$var))
      finalvals = maxvals
      for (n in 1:npar)
      {
        x=which(names(modelsettings) == modelsettings$partoscan) #find parameter to vary
        modelsettings[[x]] = parvals[n] #set to new value
        simresult = runsimulation(modelsettings, currentmodel)
        simresult <- simresult$ts
        colnames(simresult)[1] = 'xvals' #rename time to xvals for consistent plotting
        #reformat data to be in the right format for plotting
        dat = tidyr::gather(as.data.frame(simresult), -xvals, value = "yvals", key = "varnames")
        dat$IDvar = paste(dat$varnames,n,sep='') #make a variable for plotting same color lines for each run in ggplot2
        dat$nreps = n
        datall = rbind(datall,dat)
        #get max and final values for a parameter scanning plot
        maxvals[n,] = sapply(simresult[,-1],max)
        finalvals[n,] = sapply(simresult[,-1],utils::tail,1)
        colnames(maxvals) <- paste0(colnames(simresult)[-1],'max')
        colnames(finalvals) <- paste0(colnames(simresult)[-1],'final')
        scandata = data.frame(xvals = parvals, cbind(maxvals,finalvals))
        #browser()
      }
    }
    else
    {
      simresult = runsimulation(modelsettings, currentmodel) #single run
      #if error occurs we exit
      if (class(simresult)!="list")
      {
        result <- 'Model run failed. Maybe unreasonable parameter values?'
        return(result)
      }
      simresult <- simresult$ts
      colnames(simresult)[1] = 'xvals' #rename time to xvals for consistent plotting
      #reformat data to be in the right format for plotting
      rawdat = as.data.frame(simresult)
      dat = stats::reshape(rawdat, varying = colnames(rawdat)[-1], v.names = 'yvals', timevar = "varnames", times = colnames(rawdat)[-1], direction = 'long', new.row.names = NULL); dat$id <- NULL
      dat$IDvar = dat$varnames #make variables in case data is combined with stochastic runs. not used for ode.
      dat$nreps = 1
      datall = rbind(datall,dat)
    }


  #time-series
  result[[1]]$dat = datall

  result[[1]]$maketext = TRUE #indicate if we want the generate_text function to process data and generate text
  result[[1]]$showtext = NULL #text can be added here which will be passed through to generate_text and displayed for EACH plot
  result[[1]]$finaltext = 'Numbers are rounded to 2 significant digits.' #text can be added here which will be passed through to generate_text and displayed once

  #Meta-information for each plot
  result[[1]]$plottype = "Lineplot"
  result[[1]]$xlab = "Time"
  result[[1]]$ylab = "Numbers"
  result[[1]]$legend = "Compartments"

  plotscale = modelsettings$plotscale
  result[[1]]$xscale = 'identity'
  result[[1]]$yscale = 'identity'
  if (plotscale == 'x' | plotscale == 'both') { result[[1]]$xscale = 'log10'}
  if (plotscale == 'y' | plotscale == 'both') { result[[1]]$yscale = 'log10'}


  if (modelsettings$scanparam == 1)
  {
    result[[2]]$dat = scandata
    result[[2]]$plottype = "Scatterplot"
    result[[2]]$xlab = modelsettings$samplepar
    result[[2]]$ylab = "Outcomes"
    result[[2]]$legend = "Outcomes"
    result[[2]]$linesize = 3
    plotscale = modelsettings$plotscale
    result[[2]]$xscale = 'identity'
    result[[2]]$yscale = 'identity'
    if (plotscale == 'x' | plotscale == 'both') { result[[2]]$xscale = 'log10'}
    if (plotscale == 'y' | plotscale == 'both') { result[[2]]$yscale = 'log10'}
    result[[2]]$maketext = FALSE #if true we want the generate_text function to process data and generate text, if 0 no result processing will occur insinde generate_text
    result[[2]]$showtext = NULL #text for each plot can be added here which will be passed through to generate_text and displayed for each plot
    result[[2]]$finaltext = NULL
    result[[1]]$maketext = FALSE #if true we want the generate_text function to process data and generate text, if 0 no result processing will occur insinde generate_text
    result[[1]]$showtext = NULL #text for each plot can be added here which will be passed through to generate_text and displayed for each plot
    result[[1]]$finaltext = NULL
    result[[1]]$ncols = 2
  }

  return(result)
}
