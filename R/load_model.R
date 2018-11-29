#' @title A function that loads a model saved as Rdata file
#'
#' @description This function takes the name of an Rdata file that contains a modelbuilder model
#' and loads it as a reactive model
#'
#' @param currentmodel A file name and location for the model to be loaded.
#'
#' @return The model object stored in the Rdata file as a reactive
#' @details This function is a helper function
#' @author Spencer D. Hall, Andreas Handel
#' @export

load_model <- function(currentmodel) {


  # Code to load a model saved as an Rdata file. Based on
  # https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file#

  model <- reactive({
    stopping <<- TRUE
    inFile <- input$currentmodel
    if (is.null(inFile)) return(NULL)
    loadRData <- function(filename) {
      load(filename)
      get(ls()[ls() != "filename"])
    }
    d <- loadRData(inFile$datapath)
  })

  # add code here that sends model to a check function to make sure it's a proper modelbuilder model
  # check function should be free=standing

  return(model)
}
