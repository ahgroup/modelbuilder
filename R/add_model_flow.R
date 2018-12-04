#' @title A helper function that adds flow UI inputs to the shiny UI elements of the build tab
#'
#' @description This function adds inputs for a new flow.
#' This is a helper function called by the shiny app.
#' @param mbmodel a modelbuilder model structure
#' @param values a shiny variable keeping track of UI elements
#' @param input shiny input structure
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

add_model_flow <- function(mbmodel, values, input, output)
{

    insertUI(
        selector = paste0("#var", input$targetvar, "flow", values$nflow[input$targetvar]-1, 'slot'), #current variable
        where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui =
            tags$div(
                fluidRow(
                    column(6,
                           textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'name'), "Flow")
                    ),
                    column(6,
                           textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'text'), "Flow description")
                    )
                ),
                id = paste0("var", input$targetvar, "flow", values$nflow[input$targetvar], 'slot')
            ) #close flow tag
    ) #close insertUI
} #ends function
