#' Create code that encodes a modelbuilder model
#'
#' This function takes as input an Rds file that has a modelbuilder model stored as list
#' it translates the list into generative code for easy, non-GUI edits to a model
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package.
#' Models built using the modelbuilder package automatically have the right structure.
#' A user can also build a model list structure themselves following the modelbuilder specifications.
#' The file name must contain a valid modelbuilder Rds file.
#' @param mbmodel modelbuilder model structure, either as list object or file name (with complete path)
#' @param location a path to save the code to. If NULL, defaults to current directory.
#' @param filename a filename to save the code to. If NULL, a default is generated (recommended).
#' @return The function does not return anything
#' Instead, it writes an R file into the specified directory
#' the default name of the file is model$title_file.R
#' if the user specifies a file name, it will be that name
#' @author Andreas Handel
#' @export

generate_model_file <- function(mbmodel, location = NULL, filename = NULL)
{
    #if the model is passed in as a file name, load it
    #otherwise, it is assumed that 'mbmodel' is a list structure of the right type
    if (is.character(mbmodel)) {mbmodel = readRDS(mbmodel)}

    modeltitle = gsub(" ","_",mbmodel$title) #title for model, replacing space with low dash to be used in function and file names

    #if no filename is provided, create one
    #otherwise use the supplied one
    if (is.null(filename))
    {
        filename =  paste0(modeltitle,"_file.R")
    }

    #if location is supplied, that's where the code will be saved to
    #if location is NULL, it will be the current directory
    file_path_and_name <- filename
    if (!is.null(location))
    {
        file_path_and_name <- file.path(location,filename)
    }


    ##############################################################################
    #code to produce header
    ##############################################################################

    header_text = "############################## \n"
    header_text = paste0(header_text, "#R script to generate a modelbuilder model object with code. \n")
    header_text = paste0(header_text, "############################## \n \n")
    #header_text = paste0(header_text, " #Load modelbuilder library  \n")
    #header_text = paste0(header_text, " library(modelbuilder)  \n \n")
    header_text = paste0(header_text, " mbmodel = list() #create empty list \n \n")


    ##############################################################################
    #code to produce meta-information text
    ##############################################################################


    model_meta_text = paste0(" #Model meta-information")
    model_meta_text = paste0(model_meta_text, "\n mbmodel$title = '", mbmodel$title,"'")
    model_meta_text = paste0(model_meta_text, "\n mbmodel$description = '", mbmodel$description,"'")
    model_meta_text = paste0(model_meta_text, "\n mbmodel$author = '", mbmodel$author,"'")
    model_meta_text = paste0(model_meta_text, "\n mbmodel$date = Sys.Date()")
    model_meta_text = paste0(model_meta_text, "\n mbmodel$details = '", mbmodel$details,"' \n")

    ##############################################################################
    #code to produce model variable text
    ##############################################################################


    nvars = length(mbmodel$var)  #number of variables/compartments in model

    model_var_text = paste0("\n #Information for all variables")
    model_var_text = paste0(model_var_text, "\n var = vector('list',",nvars,")")

    for (n in 1:nvars)
    {
        model_var_text = paste0(model_var_text, "\n var[[",n,"]]$varname = '",mbmodel$var[[n]]$varname,"'")
        model_var_text = paste0(model_var_text, "\n var[[",n,"]]$vartext = '",mbmodel$var[[n]]$vartext,"'")
        model_var_text = paste0(model_var_text, "\n var[[",n,"]]$varval = ",mbmodel$var[[n]]$varval)
        flowtext = paste(mbmodel$var[[n]]$flows, collapse = "', '")
        model_var_text = paste0(model_var_text, "\n var[[",n,"]]$flows = c('",flowtext,"')")
        flownametext = paste(mbmodel$var[[n]]$flownames, collapse = "', '")
        model_var_text = paste0(model_var_text, "\n var[[",n,"]]$flownames = c('",flownametext,"')")
        model_var_text = paste0(model_var_text, "\n ")
    }
    model_var_text = paste0(model_var_text, "\n mbmodel$var = var" )



    ##############################################################################
    #code to produce model parameter text
    ##############################################################################

    npars = length(mbmodel$par)  #number of variables/compartments in model
    model_par_text = paste0("\n \n #Information for all parameters")
    model_par_text = paste0(model_par_text, "\n par = vector('list',",npars,")")

    for (n in 1:npars)
    {
        model_par_text = paste0(model_par_text, "\n par[[",n,"]]$parname = '",mbmodel$par[[n]]$parname,"'")
        model_par_text = paste0(model_par_text, "\n par[[",n,"]]$partext = '",mbmodel$par[[n]]$partext,"'")
        model_par_text = paste0(model_par_text, "\n par[[",n,"]]$parval = ",mbmodel$par[[n]]$parval)
        model_par_text = paste0(model_par_text, "\n ")
    }
    model_par_text = paste0(model_par_text, "\n mbmodel$par = par" )



    ##############################################################################
    #code to produce model time text
    ##############################################################################

    ntime = length(mbmodel$time) #number of parameters for time
    model_time_text = paste0("\n \n #Information for time parameters")
    model_time_text = paste0(model_time_text, "\n time = vector('list',",ntime,")")

    for (n in 1:ntime)
    {
        model_time_text = paste0(model_time_text, "\n time[[",n,"]]$timename = '",mbmodel$time[[n]]$timename,"'")
        model_time_text = paste0(model_time_text, "\n time[[",n,"]]$timetext = '",mbmodel$time[[n]]$timetext,"'")
        model_time_text = paste0(model_time_text, "\n time[[",n,"]]$timeval = ",mbmodel$time[[n]]$timeval)
        model_time_text = paste0(model_time_text, "\n ")
    }
    model_time_text = paste0(model_time_text, "\n mbmodel$time = time" )


    ##############################################################################
    #code to produce model saving and exporting snippets
    ##############################################################################


    # model_save_text = paste0("\n \n #Check, save and export model.")
    # model_save_text = paste0(model_save_text, "\n mbmodelerrors <- modelbuilder::check_model(mbmodel)")
    # model_save_text = paste0(model_save_text, "\n if (!is.null(mbmodelerrors)) {stop(mbmodelerrors)}")
    # model_save_text = paste0(model_save_text, "\n modelname = gsub(' ','_',mbmodel$title)")
    # model_save_text = paste0(model_save_text, "\n rdatafile = paste0(here::here('inst/modelexamples'),'/',modelname,'.rds')")
    # model_save_text = paste0(model_save_text, "\n saveRDS(mbmodel,file = rdatafile)")
    # model_save_text = paste0(model_save_text, "\n destpath = paste0(here::here('auxiliary/modelfiles'),'/')")
    # model_save_text = paste0(model_save_text, "\n generate_discrete(mbmodel,location = destpath, filename = NULL)")
    # model_save_text = paste0(model_save_text, "\n generate_ode(mbmodel,location = destpath, filename = NULL)")
    # model_save_text = paste0(model_save_text, "\n generate_stochastic(mbmodel,location = destpath, filename = NULL)")


    ##############################################################################
    #write all text blocks to file
    sink(file_path_and_name)
    cat(header_text)
    cat(model_meta_text)
    cat(model_var_text)
    cat(model_par_text)
    cat(model_time_text)
    #cat(model_save_text)
    sink()
}
