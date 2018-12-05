#' @title A helper function that adds a variable to the shiny UI elements of the build tab
#'
#' @description This function adds inputs for a new variable.
#' This is a helper function called by the shiny app.
#' @param mbmodel a modelbuilder model structure
#' @param values a shiny variable keeping track of UI elements
#' @param input shiny input structure
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

add_model_var <- function(mbmodel, values, input, output)
{

    insertUI(
        selector = paste0("#var", values$nvar - 1, 'slot'), #current variable
        where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui = tags$div(
            h3(paste("Variable", values$nvar)),
            fluidRow( class = 'myrow',
                      column(2,
                             textInput(paste0("var", values$nvar,'name'), "Variable name")
                      ),
                      column(3,
                             textInput(paste0("var", values$nvar,'text'), "Variable description")
                      ),
                      column(2,
                             numericInput(paste0("var", values$nvar,'val'), "Starting value", value = 0)
                      )
            ),
            tags$div(
                fluidRow(
                    column(6,
                           textInput(paste0("var", values$nvar, 'f1name'), "Flow")
                    ),
                    column(6,
                           textInput(paste0("var", values$nvar, 'f1text'), "Flow description")
                    )
                ),
                id = paste0("var", values$nvar, "flow", values$nflow[values$nvar], 'slot')
            ), #close flow tag
            id = paste0("var", values$nvar, 'slot')
        ) #close tags$div
    ) #close insertUI
} #ends function
