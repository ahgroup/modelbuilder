#' Create a discrete time simulation model
#'
#' This function takes as input a modelbuilder model and writes code
#' for a discrete time deterministic simulator function
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package.
#' Models built using the modelbuilder package automatically have the right structure.
#' A user can also build a model list structure themselves following the modelbuilder specifications.
#' If the user provides a file name, this file needs to be an Rds file
#' and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object or file name
#' @param location a path to save the simulation code to. If NULL, defaults to current directory.
#' @param filename a filename to save the simulation code to. If NULL, a default is generated (recommended).
#' @return The function does not return anything
#' Instead, it writes an R file into the specified directory
#' the default name of the file is simulate_model$title_ode.R
#' if the user specifies a file name, it will be that name
#' @author Andreas Handel
#' @export

generate_discrete <- function(mbmodel, location = NULL, filename = NULL)
{
    #if the model is passed in as a file name, load it
    #otherwise, it is assumed that 'mbmodel' is a list structure of the right type
    if (is.character(mbmodel)) {mbmodel = readRDS(mbmodel)}

    modeltitle = gsub(" ","_",mbmodel$title) #title for model, replacing space with low dash to be used in function and file names

    modeltype = "discrete"

    #if no filename is provided, create one
    #otherwise use the supplied one
    #the default is simulate_ + "model title" + "_" + modeltype + .R
    if (is.null(filename))
    {
        filename =  paste0("simulate_",modeltitle,"_",modeltype,".R")
    }

    #if location is supplied, that's where the code will be saved to
    #if location is NULL, it will be the current directory
    file_path_and_name <- filename
    if (!is.null(location))
    {
        file_path_and_name <- file.path(location,filename)
    }

    #generates all the documentation/header information
    sdesc = generate_function_documentation(mbmodel,modeltype)

    #generates text for main function call line and for argument vectors
    textlist <- generate_function_inputs(mbmodel,modeltype)
    stitle = textlist$stitle
    varvec = textlist$varvec
    parvec = textlist$parvec


    nvars = length(mbmodel$var)  #number of variables/compartments in model
    x = sapply(mbmodel$var, FUN = `[[`, "varname")
    varnames = paste0(x, collapse = ",")
    varnamestring = paste0("'",x,"'",collapse = ",")
    ##############################################################################
    #the next block of commands produces the simulator block as a function
    #which is expressed as a for-loop
    sdisc = "  #Function that encodes simulation loop \n"
    sdisc = paste0(sdisc,'  ',modeltitle,"_fct <- function(vars, pars, times) \n")
    sdisc = paste0(sdisc,"  {\n")
    sdisc = paste0(sdisc,"    with( as.list(c(vars,pars)), {  \n")
    sdisc = paste0(sdisc,'      ts = data.frame(cbind(times, matrix(0,nrow=length(times),ncol=length(vars)))) \n')
    sdisc = paste0(sdisc,"      colnames(ts) = c('time',",varnamestring,") \n")
    sdisc = paste0(sdisc,'      ct=1 #a counter to index array \n')
    sdisc = paste0(sdisc,"      for (t in times) \n")
    sdisc = paste0(sdisc,"      {\n")
    sdisc = paste0(sdisc,"        ts[ct,] = c(t,",varnames,") \n")
    for (n in 1:nvars)
    {
    sdisc = paste0(sdisc,'        ',mbmodel$var[[n]]$varname,'p = ',mbmodel$var[[n]]$varname,' + dt*(',paste(mbmodel$var[[n]]$flows, collapse = ' '), ') \n' )
    }
    for (n in 1:nvars)
    {
    sdisc = paste0(sdisc,'        ',mbmodel$var[[n]]$varname,' = ',mbmodel$var[[n]]$varname,'p \n')
    }
    sdisc = paste0(sdisc,"        ct = ct + 1 \n")
    sdisc = paste0(sdisc,"      } #finish loop \n")
    sdisc = paste0(sdisc,"      return(ts) \n")
    sdisc = paste0(sdisc,"    }) #close with statement \n")
    sdisc = paste0(sdisc," } #end function encoding loop \n \n")
    #finish block that creates the discrete time loop function


    smain = "  ############################## \n"
    smain = paste0(smain,"  #Main function code block \n")
    smain = paste0(smain,"  ############################## \n")
    smain = paste0(smain,"  #Creating named vectors \n")
    smain = paste0(smain,"  varvec = c(", varvec, ") \n")
    smain = paste0(smain,"  parvec = c(", parvec, ") \n")
    smain = paste0(smain,"  timevec = seq(tstart, tfinal,by = dt) \n")
    smain = paste0(smain,"  #Running the model \n")
    smain = paste0(smain,"  simout <- ",modeltitle,"_fct(vars = varvec, pars = parvec, times = timevec) \n")
    smain = paste0(smain,"  #Setting up empty list and returning result as data frame called ts \n")
    smain = paste0(smain,'  result <- list() \n');
    smain = paste0(smain,'  result$ts <- simout \n')
    smain = paste0(smain,'  return(result) \n')
    smain = paste0(smain,'} \n')
    #finish block that creates main function part
    ##############################################################################
    #write all text blocks to file
    sink(file_path_and_name)
    cat(sdesc)
    cat(stitle)
    cat(sdisc)
    cat(smain)
    sink()
}
