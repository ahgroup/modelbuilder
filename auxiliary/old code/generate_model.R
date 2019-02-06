#' @title A helper function that takes a model as a list structure and generates a tar file with code
#'
#' @description This function generates a tar file that includes the model as Rdata file
#' and code for the model implemented as discrete-time, stochastic/adaptivetau and ODE/desolve functions
#' @param model a modelbuilder model structure
#' @param location a path/folder to save the model to. Default is modelexamples subfolder of package
#' @return no return, the function writes a tar file with the model code
#' @author Andreas Handel
#' @export

generate_model <- function(model, location = NULL)
{

    currentdir = getwd()
    if (is.null(location))
    {
        location = system.file("modelexamples", package = "modelbuilder")
    }
    setwd(location)
    unlink('./modeltemp', recursive = TRUE, force = TRUE) #delete temp folder in case it exists
    dir.create('./modeltemp') #create temp folder to store model files

    modelname = gsub(" ","_",model$title)
    rdatafile = paste0('./modeltemp/',modelname,'.Rdata')
    save(model,file = rdatafile)
    #create all 3 model versions, ODE/deSolve, discrete, stochastic/adaptivetau
    convert_to_desolve(model = model, location = './modeltemp')
    #convert_to_discrete(model = model, location = './modeltemp')
    #convert_to_adaptivetau(model = model, location = './modeltemp')

    zipfile = paste0(modelname,".zip") #path and name of zip file that will contain all model files

    #writes all files to a zip file
    #note that opening the zip file in windows shows it's empty, but the files are in there
    #using the unzip R command, one can extract them
    zip::zip(zipfile, './modeltemp')

    unlink('./modeltemp', recursive = TRUE, force = TRUE) #delete temp folder
    setwd(currentdir) #set working directory back to where it was
}
