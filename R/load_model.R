#' @title A function that loads a model saved as file
#' @description This function takes the name of a file that contains a modelbuilder model
#' and loads the model object
#' @param currentmodel A file name and path for the model to be loaded.
#' @return A modelbuilder model object
#' @details This function is a helper function
#' @author Spencer D. Hall, Andreas Handel
#' @export

load_model <- function(currentmodel) {

  # Code to load a model saved as a file. Based on
  # https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file#

    inFile <- currentmodel
    if (is.null(inFile)) return(NULL)
    loadmodel <- function(filename) {
      load(filename)
      get(ls()[ls() != "filename"])
    }
    mbmodel <- loadmodel(inFile)

    return(mbmodel)
}
