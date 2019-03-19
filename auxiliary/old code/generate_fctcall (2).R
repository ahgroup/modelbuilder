#' @title A helper function that takes a model and settings and generates the function call needed to run it
#'
#' @description This function generates a text string that contains the function call for a given model
#' This is a helper function.
#' @param modelsettings values for model settings
#' @param mbmodel a modelbuilder model structure
#' @return a string that can be evaluated to run the model
#' @details This function produces a function text string.
#' @author Andreas Handel
#' @export

generate_fctcall <- function(modelsettings, mbmodel)
{
    modeltype = modelsettings$modeltype

    #process all variables, parameters and times from the model structure
    #to create the input string for the main function call
    nvars = length(mbmodel$var)
    varstring = "vars = c("
    for (n in 1:nvars)
    {
        varstring = paste0(varstring,
                           mbmodel$var[[n]]$varname,
                           " = ",
                           modelsettings$var[n],
                           ', ')
    }
    varstring = substr(varstring, 1, nchar(varstring) - 2)
    varstring = paste0(varstring, '), ') #close parentheses

    npars = length(mbmodel$par)
    parstring = "pars = c("
    for (n in 1:npars)
    {
        parstring = paste0(parstring,
                           mbmodel$par[[n]]$parname,
                           " = ",
                           modelsettings$par[n],
                           ', ')
    }
    parstring = substr(parstring, 1, nchar(parstring) - 2)
    parstring = paste0(parstring, '), ') #close parentheses

    ntime = length(mbmodel$time)
    timestring = "time = c("
    for (n in 1:ntime)
    {
        timestring = paste0(timestring,
                            mbmodel$time[[n]]$timename,
                            " = ",
                            modelsettings$time[n],
                            ', ')
    }
    timestring = substr(timestring, 1, nchar(timestring) - 2)
    timestring = paste0(timestring, ') ')

    filename = paste0('simulate_',gsub(" ", "_", mbmodel$title), "_",modeltype) #name of function to be called
    fctargs = paste0(varstring, parstring, timestring) #arguments for function
    fctcall = paste0('simresult <- ', filename, '(', fctargs, ')') # complete string for function call

    return(fctcall)
}
