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

  #################################################
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
    modelbuilder::generate_ode(mbmodel = mbmodel, location = file_ode)
  }
  if (!exists(file_discrete))
  {
    modelbuilder::generate_discrete(mbmodel = mbmodel, location = file_discrete)
  }
  if (!exists(file_stochastic))
  {
    modelbuilder::generate_stochastic(mbmodel = mbmodel, location = file_stochastic)
  }
  #source files
  source(file_ode)
  source(file_discrete)
  source(file_stochastic)


  datall = NULL #will hold data for all different models and replicates

  #save all results to a list for processing plots and text
  #list corresponds to number of plots
  #1 plot for time-series only
  #2 plots if we sample over parameter
  listlength = ifelse(modelsettings$scanparam == 1, 2, 1)
  #here we do all simulations in the same figure
  result = vector("list", listlength) #create empty list of right size for results


  ##################################
  #stochastic dynamical model execution
  ##################################
  if (grepl('_stochastic_',modelsettings$modeltype))
  {
    modelsettings$currentmodel = 'stochastic'
    currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic")
    for (nn in 1:modelsettings$nreps)
    {
      simresult = runsimulation(modelsettings, currentmodel)
      if (class(simresult)!="list")
      {
        result <- 'Model run failed. Maybe unreasonable parameter values?'
        return(result)
      }
      #data for plots and text
      #needs to be in the right format to be passed to generate_plots and generate_text
      #see documentation for those functions for details
      simresult <- simresult$ts
      colnames(simresult)[1] = 'xvals' #rename time to xvals for consistent plotting
      #reformat data to be in the right format for plotting
      dat = tidyr::gather(as.data.frame(simresult), -xvals, value = "yvals", key = "varnames")
      dat$IDvar = paste(dat$varnames,nn,sep='') #make a variable for plotting same color lines for each run in ggplot2
      dat$nreps = nn
      datall = rbind(datall,dat)
      modelsettings$rngseed = modelsettings$rngseed + 1 #need to update RNG seed each time to get different runs
    }
  }

  ##################################
  #ode or discrete dynamical model execution
  ##################################
  if (grepl('_ode_',modelsettings$modeltype) | grepl('_discrete_',modelsettings$modeltype))
  {
    if (grepl('_ode_',modelsettings$modeltype)) #need to always start with ode_ in model specification
    {
      modelsettings$currentmodel = 'ode'
      currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode")
    }
    if (grepl('_discrete_',modelsettings$modeltype))
    {
      modelsettings$currentmodel = 'discrete'
      currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete")
    }
    if (modelsettings$scanparam == 1)
    {
      if (modelsettings$pardist == 'lin') {parvals = seq(modelsettings$parmin,modelsettings$parmax,length=modelsettings$parnum)}
      if (modelsettings$pardist == 'log') {parvals = 10^seq(log10(modelsettings$parmin),log10(modelsettings$parmax),length=modelsettings$parnum)}
      for (n in 1:modelsettings$parnum)
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
        groupdat = dplyr::group_by(dat,varnames)
        finalvals = dplyr::summarize(groupdat,last(yvals))
        maxvals = dplyr::summarize(groupdat,last(yvals))
        #scandata = data.frame(xvals = parvals, )
        browser()
      }
    }
    else
    {
      simresult = runsimulation(modelsettings, currentmodel)
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
  }

  #time-series
  result[[1]]$dat = datall

  if (modelsettings$scanparam == 1)
  {
    result[[2]]$dat = scandata
  }


  ##################################
  #default for text display, used by most basic simulation models
  #can/will be potentially overwritten below for specific types of models
  ##################################

  result[[1]]$maketext = TRUE #indicate if we want the generate_text function to process data and generate text
  result[[1]]$showtext = NULL #text can be added here which will be passed through to generate_text and displayed for EACH plot
  result[[1]]$finaltext = 'Numbers are rounded to 2 significant digits.' #text can be added here which will be passed through to generate_text and displayed once

  ##################################
  #additional settings for all types of simulators
  ##################################


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

  return(result)
}
