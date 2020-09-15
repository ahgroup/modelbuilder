#' Generate a table of state variables, parameters, and initial values
#'
#' This function takes as input a modelbuilder model and
#' exports a CSV table of parameter/variable names, definitions,
#' and initial values.
#'
#' @description The model needs to adhere to the structure specified by
#'     the modelbuilder package. Models built using the modelbuilder package
#'     automatically have the right structure. A user can also build a
#'     model list structure themselves following the modelbuilder
#'     specifications. If the user provides a file name, this file needs to
#'     be an RDS file and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object
#'     or file name
#' @param location a path to save the simulation code to. If NULL,
#'     defaults to current directory.
#' @param filename a filename to save the simulation code to. If NULL,
#'     a default is generated (recommended).
#' @return The function does not return anything
#'     Instead, it writes a CSV file into the specified directory;
#'     the default nams of the files are parameter_table_model$title.csv and
#'     parameter_table_model$title.csv; if the user specifies a file name,
#'     it will be that name
#' @importFrom utils write.csv
#' @author Andrew Tredennick and Andreas Handel
#' @export

generate_tables <- function(mbmodel, location = NULL, filename = NULL)
{
    #if the model is passed in as a file name, load it
    #otherwise, it is assumed that 'mbmodel' is a list structure of the right type
    if (is.character(mbmodel)) {mbmodel = readRDS(mbmodel)}

    modeltitle = gsub(" ","_",mbmodel$title) #title for model, replacing space with low dash to be used in function and file names

    #if no filename is provided, create one
    #otherwise use the supplied one
    #the default is variable_table_ + "model title" + ".csv"
    #               parameter_table_ + "model title" + ".csv"
    if (is.null(filename))
    {
        varfilename =  paste0("variable_table_",modeltitle,".csv")
        parfilename =  paste0("parameter_table_",modeltitle,".csv")
    }

    #if location is supplied, that's where the code will be saved to
    #if location is NULL, it will be the current directory
    var_file_path_and_name <- varfilename
    par_file_path_and_name <- varfilename
    if (!is.null(location))
    {
        var_file_path_and_name <- file.path(location,varfilename)
        par_file_path_and_name <- file.path(location,parfilename)
    }

    #remove t from par, if present
    tmp_pars <- mbmodel$par
    tmp_par_names <- unlist(lapply(tmp_pars, "[[", 1))
    if ("t" %in% tmp_par_names)
    {
        id_to_remove <- which(tmp_par_names == "t")
        tmp_pars[[id_to_remove]] <- NULL
        mbmodel$par <- tmp_pars
    }
    rm(tmp_pars, tmp_par_names)

    #extract all state variables and associated initial values
    var_abbr <- sapply(mbmodel$var, "[[", 1)
    var_name <- sapply(mbmodel$var, "[[", 2)
    var_value <- sapply(mbmodel$var, "[[", 3)

    #extract all parameters and associated initial values
    par_abbr <- sapply(mbmodel$par, "[[", 1)
    par_name <- sapply(mbmodel$par, "[[", 2)
    par_value <- sapply(mbmodel$par, "[[", 3)

    #combine all into a dataframe
    dfvar <- data.frame(Abbreviation = c(var_abbr),
                        Name = c(var_name),
                        Initial_Value = c(var_value),
                        Source = "",
                        Comment = "")
    dfpar <- data.frame(Abbreviation = c(par_abbr),
                        Name = c(par_name),
                        Initial_Value = c(par_value),
                        Source = "",
                        Comment = "")

    #save the dataframes as a CSVs in the specified location
    write.csv(x = dfvar, file = var_file_path_and_name, row.names = FALSE)
    write.csv(x = dfpar, file = par_file_path_and_name, row.names = FALSE)

    #report location to the user
    cat(paste0("Table of parameters saved here: ", par_file_path_and_name),
        paste0("Table of variables saved here: ", var_file_path_and_name),
        sep = "\n")
}
