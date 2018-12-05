#' @title A helper function that removes a the shiny UI elements for a flow of the build tab
#'
#' @description This function removes inputs for the flows of a specified variable.
#' This is a helper function called by the shiny app.
#' @param mbmodel a modelbuilder model structure
#' @param values a shiny variable keeping track of UI elements
#' @param input shiny input structure
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

remove_model_flow <- function(mbmodel, values, input, output)
{
    removeUI(
        selector = paste0("#var", input$targetvar, "flow", values$nflow[input$targetvar], 'slot'),
        immediate = TRUE
        ) #close removetUI

} #ends function
