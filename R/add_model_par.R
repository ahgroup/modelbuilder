#' @title A helper function that adds a paramter to the shiny UI elements of the build tab
#'
#' @description This function adds inputs for a new parameter.
#' This is a helper function called by the shiny app.
#' @param values a shiny variable keeping track of UI elements
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

add_model_par <- function(values, output)
{

    insertUI(
        selector = paste0("#par", values$npar - 1, 'slot'), #current variable
        where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui = tags$div(

            fluidRow( class = 'myrow',
                      column(2,
                             textInput(paste0("par", values$npar, 'name'), "Parameter Name")
                      ),
                      column(3,
                             textInput(paste0("par", values$npar,'text'), "Parameter description")
                      ),
                      column(2,
                             numericInput(paste0("par", values$npar,'val'), "Default value", value = 0)
                      )
            ),
            id = paste0("par", values$npar, 'slot')
        ) #close tags$div
    ) #close insertUI
} #ends function
