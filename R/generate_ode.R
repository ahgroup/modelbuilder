#' Create an ODE simulation model
#'
#' This function takes as input a modelbuilder model and writes code
#' for an ODE simulator implemented with deSolve
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package.
#' Models built using the modelbuilder package automatically have the right structure.
#' A user can also build a model list structure themselves following the modelbuilder specifications.
#' If the user provides a file name, this file needs to be an Rds file
#' and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object or file name
#' @param location a filename and path to save the simulation code to. Default is current directory.
#' @return The function does not return anything
#' Instead, it writes an R file into the specified directory
#' this R file contains a deSolve implementation of the model
#' the name of the file is simulate_model$title_ode.R
#' @author Andreas Handel
#' @export

generate_ode <- function(mbmodel, location = NULL)
{
    #if the model is passed in as a file name, load it
    #otherwise, it is assumed that 'mbmodel' is a list structure of the right type
    if (is.character(mbmodel)) {mbmodel = readRDS(mbmodel)}

    #if location is supplied, that's where the code will be saved to
    if (is.null(location))
    {
        savepath = paste0("./simulate_",gsub(" ","_",mbmodel$title),"_ode.R")
    }
    else
    {
        #the name of the function produced by this script is simulate_ + "model title" + "_ode.R"
        savepath <- location #default is current directory for saving the R function
    }

    modeltitle = gsub(" ","_",mbmodel$title) #title for model, replacing space with low dash to be used in function and file names

    #generates all the documentation/header information
    sdesc = generate_function_documentation(mbmodel,modeltype = "ode")

    #generates text for main function call line and for argument vectors
    textlist_mb <- generate_function_inputs(mbmodel,modeltype = "ode")
    stitle = textlist_mb$stitle
    varvec = textlist_mb$varvec
    parvec = textlist_mb$parvec

    ##############################################################################
    #the next block of commands produces the ODE function required by deSolve
    sode = "  ############################## \n"
    sode = paste0(sode, "  #Block of ODE equations for deSolve \n")
    sode = paste0(sode, "  ############################## \n")
    sode = paste0(sode,"  ", gsub(" ","_",mbmodel$title),'_ode_fct <- function(t, y, parms) \n  {\n')
    sode = paste0(sode,"    with( as.list(c(y,parms)), { #lets us access variables and parameters stored in y and parms by name \n")

    #text for equations and final list
    seqs= "    #StartODES\n"
    slist="    list(c("
    nvars = length(mbmodel$var)  #number of variables/compartments in model
    for (n in 1:nvars)
    {
        seqs = paste0(seqs,"    #",mbmodel$var[[n]]$vartext,' : ', paste(mbmodel$var[[n]]$flownames, collapse = ' : '),' :\n')
        seqs = paste0(seqs,'    d',mbmodel$var[[n]]$varname,'_mb = ',paste(mbmodel$var[[n]]$flows, collapse = ' '), '\n' )
        slist = paste0(slist, paste0('d',mbmodel$var[[n]]$varname,'_mb,'))
    }
    sode=paste0(sode,seqs)
    sode = paste0(sode,"    #EndODES\n")
    slist = substr(slist,1,nchar(slist)-1) #get rid of final comma
    slist = paste0(slist,')) \n') #close parentheses
    sode=paste0(sode,slist)
    sode = paste0(sode, "  } ) } #close with statement, end ODE code block \n \n")
    #finish block that creates the ODE function
    ##############################################################################


    smain = "  ############################## \n"
    smain = paste0(smain,"  #Main function code block \n")
    smain = paste0(smain,"  ############################## \n")
    smain = paste0(smain,"  #Creating named vectors \n")
    smain = paste0(smain,"  varvec_mb = c(", varvec, ") \n")
    smain = paste0(smain,"  parvec_mb = c(", parvec, ") \n")
    smain = paste0(smain,"  timevec_mb = seq(tstart, tfinal,by = dt) \n")
    smain = paste0(smain,"  #Running the model \n")
    smain = paste0(smain,'  simout = deSolve::ode(y = varvec_mb, parms = parvec_mb, times = timevec_mb,  func = ',gsub(" ","_",mbmodel$title),'_ode_fct, rtol = 1e-12, atol = 1e-12) \n')
    smain = paste0(smain,"  #Setting up empty list and returning result as data frame called ts \n")
    smain = paste0(smain,'  result <- list() \n');
    smain = paste0(smain,'  result$ts <- as.data.frame(simout) \n')
    smain = paste0(smain,'  return(result) \n')
    smain = paste0(smain,'} \n')
    #finish block that creates main function part
    ##############################################################################
    #write all text blocks to file
    sink(savepath)
    cat(sdesc)
    cat(stitle)
    cat(sode)
    cat(smain)
    sink()
}
