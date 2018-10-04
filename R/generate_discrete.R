#' Create an discrete time simulation model
#'
#' This function takes as input a modelbuilder model and writes code
#' for a discrete time deterministc simulator function
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package
#' models built using the modelbuilder package automatically have the right structure
#' a user can also build a model list structure themselves following the specifications
#' if the user provides an Rdata file name, this file needs to contain an object called 'model'
#' and contain a valid modelbuilder model structure
#' @param model model structure, either as list object or Rdata file name
#' @param location a path/folder to save the simulation code to. Default is current directory
#' @return The function does not return anything
#' Instead, it writes an R file into the specified directory
#' this R file contains a discrete time/for-loop implementation of the model
#' the name of the file is simulate_model$title_discrete.R
#' @author Andreas Handel
#' @export

generate_discrete <- function(model, location = NULL)
{

    #if the model is passed in as an Rdata file name, load it
    #otherwise, it is assumed that 'model' is a list structure of the right type
    if(is.character(model)) {load(model)}

    #the name of the function produced by this script is simulate_ + "model title" + "_discrete.R"
    savepath = location #default is current directory for saving the R function

    #if location is supplied, that's where the code will be saved to
    # if (!is.null(location)) {savepath = paste0(location,'/',filename)}

    nvars = length(model$var)  #number of variables/compartments in model
    npars = length(model$par)  #number of parameters in model
    ntime = length(model$time) #numer of parameters for time
    modeltitle = gsub(" ","_",model$title) #title for model, replacing space with low dash to be used in function and file names
    #text for model description
    #all this should be provided in the model sctructure
    sdesc=paste0("#' ",model$title,"\n#' \n")
    sdesc=paste0(sdesc,"#' ",model$description,"\n#' \n")
    sdesc=paste0(sdesc,"#' @details ",model$details, "\n")
    sdesc=paste0(sdesc,"#' This code is based on a dynamical systems model created by the modelbuilder package.  \n")
    sdesc=paste0(sdesc,"#' The model is implemented here as a set of discrete-time, deterministic equations, \n")
    sdesc=paste0(sdesc,"#' coded as a simple for-loop. \n")
    sdesc=paste0(sdesc,"#' @param vars vector of starting conditions for model variables: \n")
    sdesc=paste0(sdesc,"#' \\itemize{ \n")
    for (n in 1:nvars)
    {
        sdesc=paste0(sdesc,"#' \\item ", model$var[[n]]$varname, ' : starting value for ',model$var[[n]]$vartext, "\n")
    }
    sdesc=paste0(sdesc,"#' } \n")
    sdesc=paste0(sdesc,"#' @param pars vector of values for model parameters: \n")
    sdesc=paste0(sdesc,"#' \\itemize{ \n")
    for (n in 1:npars)
    {
        sdesc=paste0(sdesc,"#' \\item ", model$par[[n]]$parname," : ", model$par[[n]]$partext, "\n")
    }
    sdesc=paste0(sdesc,"#' } \n")
    sdesc=paste0(sdesc,"#' @param times vector of values for model times: \n")
    sdesc=paste0(sdesc,"#' \\itemize{ \n")
    for (n in 1:ntime)
    {
        sdesc=paste0(sdesc,"#' \\item ", model$time[[n]]$timename," : ", model$time[[n]]$timetext, "\n")
    }
    sdesc=paste0(sdesc,"#' } \n")
    sdesc=paste0(sdesc,"#' @return The function returns the output as a list. \n")
    sdesc=paste0(sdesc,"#' The time-series from the simulation is returned as a dataframe saved as list element \\code{ts}. \n")
    sdesc=paste0(sdesc,"#' The \\code{ts} dataframe has one column per compartment/variable. The first column is time.   \n")
    sdesc=paste0(sdesc,"#' @examples  \n")
    sdesc=paste0(sdesc,"#' # To run the simulation with default parameters:  \n")
    sdesc=paste0(sdesc,"#' result <- simulate_",modeltitle,"_discrete()", " \n")
    sdesc=paste0(sdesc,"#' @section Warning: ","This function does not perform any error checking. So if you try to do something nonsensical (e.g. have negative values for parameters), the code will likely abort with an error message.", "\n")
    sdesc=paste0(sdesc,"#' @section Model Author: ",model$author, "\n")
    sdesc=paste0(sdesc,"#' @section Model creation date: ",model$date, "\n")
    sdesc=paste0(sdesc,"#' @section Code Author: generated by the \\code{generate_discrete} function \n")
    sdesc=paste0(sdesc,"#' @section Code creation date: ",Sys.Date(), "\n")
    sdesc=paste0(sdesc,"#' @export \n \n")


    ##############################################################################
    #this creates the lines of code for the main function
    #text for head of main body of function
    varstring = "vars = c("
    varnames = ""
    varnamestring = ""
    varstartvals = ""
    for (n in 1:nvars)
    {
        varstring=paste0(varstring, model$var[[n]]$varname," = ", model$var[[n]]$varval,', ')
        varnamestring=paste0(varnamestring,'"',model$var[[n]]$varname,'",')
        varnames=paste0(varnames,',',model$var[[n]]$varname)
    }
    varnamestring = substr(varnamestring,1,nchar(varnamestring)-1) #trim off final comma
    varstring = substr(varstring,1,nchar(varstring)-2)
    varstring = paste0(varstring,'), ') #close parantheses

    parstring = "pars = c("
    for (n in 1:npars)
    {
        parstring=paste0(parstring, model$par[[n]]$parname," = ", model$par[[n]]$parval,', ')
    }
    parstring = substr(parstring,1,nchar(parstring)-2)
    parstring = paste0(parstring,'), ') #close parantheses

    timestring = "times = c("
    for (n in 1:ntime)
    {
        timestring=paste0(timestring, model$time[[n]]$timename," = ", model$time[[n]]$timeval,', ')
    }
    timestring = substr(timestring,1,nchar(timestring)-2)
    timestring = paste0(timestring,') ') #close parantheses


    stitle = paste0('simulate_',modeltitle,"_discrete <- function(",varstring, parstring, timestring,') \n{ \n')
    #finished generating the heading/function call line

    ##############################################################################
    #the next block of commands produces the simulator block as a function
    #which is expressed as a for-loop
    sdisc = "  #Function that encodes simulation loop \n"
    sdisc = paste0(sdisc,'  ',modeltitle,"_discrete <- function(vars, pars, times) \n")
    sdisc = paste0(sdisc,"  {\n")
    sdisc = paste0(sdisc,"    with( as.list(c(vars,pars,times)), {  \n")

    sdisc = paste0(sdisc,'      tvec = seq(tstart,tfinal,by=dt) \n')
    sdisc = paste0(sdisc,'      ts = data.frame(cbind(tvec, matrix(0,nrow=length(tvec),ncol=length(vars)))) \n')
    sdisc = paste0(sdisc,'      colnames(ts) = c("time",',varnamestring,') \n');
    sdisc = paste0(sdisc,'      ct=1 #a counter to index array \n');
    sdisc = paste0(sdisc,"      for (t in tvec) \n")
    sdisc = paste0(sdisc,"      {\n")
    sdisc = paste0(sdisc,"        ts[ct,] = c(t",varnames,") \n")
    for (n in 1:nvars)
    {
    sdisc = paste0(sdisc,'        ',model$var[[n]]$varname,'p = ',model$var[[n]]$varname,' + dt*(',paste(model$var[[n]]$flows, collapse = ' '), ') \n' )
    }
    for (n in 1:nvars)
    {
    sdisc = paste0(sdisc,'        ',model$var[[n]]$varname,' = ',model$var[[n]]$varname,'p \n')
    }
    sdisc = paste0(sdisc,"        ct = ct + 1 \n")
    sdisc = paste0(sdisc,"      } #finish loop \n")
    sdisc = paste0(sdisc,"      return(ts) \n")
    sdisc = paste0(sdisc,"    }) #close with statement \n")
    sdisc = paste0(sdisc," } #end function encoding loop \n")
    #finish block that creates the discrete time loop function
    ##############################################################################

    smain = "  #Main function code block \n"
    smain = paste0(smain," ts <- ",modeltitle,"_discrete(vars = vars, pars = pars, times = times) \n")
    #write result to a list and return
    smain = paste0(smain,'  result <- list() \n')
    smain = paste0(smain,'  result$ts <- ts \n')
    smain = paste0(smain,'  return(result) \n')
    smain = paste0(smain,'} \n')

    ##############################################################################
    #write all text blocks to file
    sink(savepath)
    cat(sdesc)
    cat(stitle)
    cat(sdisc)
    cat(smain)
    sink()
}