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

    if (is.null(location))
    {
        location = system.file("modelexamples", package = "modelbuilder")
    }

    modelfolder = paste0(location,'/temp') #create temp folder to store files
    unlink(modelfolder, recursive = TRUE, force = TRUE) #delete temp folder in case it exists
    dir.create(modelfolder) #create folder with name of model


    modelname = gsub(" ","_",model$title)
    rdatafile = paste0(modelfolder,'/',modelname,'.Rdata')
    save(model,file = rdatafile)
    convert_to_desolve(model = model, location = modelfolder)

    zipfile = paste0(location,'/',modelname,".zip") #path and name of zip file that will contain all model fiels

    browser()

    zip::zip(zipfile, modelfolder) #writes all files


    unlink(modelfolder, recursive = TRUE, force = TRUE) #delete temp folder in case it exists

}
