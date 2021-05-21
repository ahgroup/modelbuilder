#' @title A helper function that removes a variable to the shiny UI elements of the build tab
#'
#' @description This function removes inputs for the last variable.
#' This is a helper function called by the shiny app.
#' @param values a shiny variable keeping track of UI elements
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

remove_model_var <- function(values, output)
{
    removeUI(
      # Alter the slot value to use the variable indicator instead of the next variable incrementally
      selector = paste0("#var", values$varInd, 'slot'), #current variable

        immediate = TRUE
    ) #close removetUI

} #ends function
