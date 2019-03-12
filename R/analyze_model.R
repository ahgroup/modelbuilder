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
  runsimulation <- function(modelsettings)
  {
    #extract modeslettings inputs needed for simulator function
    currentmodel = modelsettings$currentmodel
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
    if (grepl('_stochastic_',modelsettings$modeltype)) {currentargs$rngseed = modelsettings$rngseed}
    #run simulation, try command catches error from running code.
    simresult <- try( do.call(currentmodel, args = currentargs ) )
    return(simresult)
  }


  #make a temp directory to save file
  tempdir = tempdir()

  #################################################
  #check what type of model
  #if not present, create code for simulator
  if (grepl('_ode_',modelsettings$modeltype)) #need to always start with ode_ in model specification
  {
    modelsettings$currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode")
    sim_file = file.path(tempdir, paste0(modelsettings$currentmodel,".R"))
    if (!exists(sim_file)) {modelbuilder::generate_ode(mbmodel = mbmodel, location = sim_file)}
  }
  if (grepl('_discrete_',modelsettings$modeltype))
  {
    modelsettings$currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete")
    sim_file = file.path(tempdir, paste0(modelsettings$currentmodel,".R"))
    if (!exists(sim_file)) {modelbuilder::generate_discrete(mbmodel = mbmodel, location = sim_file)}
  }
  if (grepl('_stochastic_',modelsettings$modeltype))
  {
    modelsettings$currentmodel =  paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic")
    sim_file = file.path(tempdir, paste0(modelsettings$currentmodel,".R"))
    if (!exists(sim_file)) {modelbuilder::generate_stochastic(mbmodel = mbmodel, location = sim_file)}
  }
  #source file
  source(sim_file)

  ##################################
  #dynamical model execution
  ##################################
  if (grepl('_stochastic_',modelsettings$modeltype))
  {
    #1 plot for time-series only
    listlength =  1
    #replicate modelsettings as list based on number of reps for stochastic
    allmodset=rep(list(modelsettings),times = modelsettings$nreps)
    rngvec = seq(modelsettings$rngseed,modelsettings$rngseed+modelsettings$nreps-1)
    #give the rngseed entry in each list a consecutive value
    xx = purrr::map2(allmodset, rngvec, ~replace(.x, "rngseed", .y))
  }
  if (!grepl('_stochastic_',modelsettings$modeltype) && modelsettings$scanparam == 1) #scan over a parameter
  {
    #save all results to a list for processing plots and text
    #list corresponds to number of plots
    #2 plots if we sample over parameter
    listlength =  2
    npar = modelsettings$parnum
    if (modelsettings$pardist == 'lin') {parvals = seq(modelsettings$parmin,modelsettings$parmax,length=npar)}
    if (modelsettings$pardist == 'log') {parvals = 10^seq(log10(modelsettings$parmin),log10(modelsettings$parmax),length=npar)}
    #replicate modelsettings as list based on how many parameter samples there are
    allmodset = rep(list(modelsettings), times = npar)
    #give the parameter to be changed its values
    xx = purrr::map2(allmodset, parvals, ~replace(.x, modelsettings$partoscan, .y))

  }
  if (!grepl('_stochastic_',modelsettings$modeltype) && modelsettings$scanparam == 0) #no parameter scan
  {
    #1 plot for time-series only
    listlength =  1
    xx = rep(list(modelsettings),times = 1) #don't really replicate list, but get it into right structure
  }
  #run all simulations for each modelsetting, store in list simresult
  #since the simulation is returned as list, extract data frame only
  simresult <- purrr::map(xx,runsimulation) %>% unlist(recursive = FALSE, use.names = FALSE)
  if (class(simresult)!="list")
  {
    result <- 'Model run failed. Maybe unreasonable parameter values?'
    return(result)
  }
  #convert data to long format
  dat = purrr::map(simresult, tidyr::gather,  key = 'varnames', value = "yvals", -time)
  #rename time to xvals
  dat = purrr::map(dat, dplyr::rename, xvals = time)
  #convert list into single data frame, add IDvar variable
  dat = dplyr::bind_rows(dat, .id = "IDvar")
  #assign IDvar combination of number and variable name - the way the plotting functions need it
  datall = dplyr::mutate(dat, IDvar = paste0(varnames,IDvar))

  #time-series
  result = vector("list", listlength) #create empty list of right size for results
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


  if (!grepl('_stochastic_',modelsettings$modeltype) && modelsettings$scanparam == 1) #scan over a parameter
  {
    xx = dplyr::group_by(datall,IDvar,varnames)
    maxvals = dplyr::summarise(xx, yvals = max(yvals))
    maxvals = dplyr::mutate(maxvals, varnames = paste0(varnames,'max'))
    maxvals = dplyr::select(ungroup(maxvals), -IDvar)
    maxvals$xvals = parvals
    finalvals = dplyr::summarise(xx, yvals = dplyr::last(yvals))
    finalvals = dplyr::mutate(finalvals, varnames = paste0(varnames,'final'))
    finalvals = dplyr::select(dplyr::ungroup(finalvals), -IDvar)
    finalvals$xvals = parvals
    scandata = rbind(maxvals,finalvals)
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
