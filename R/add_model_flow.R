#' @title A helper function that adds flow UI inputs to the shiny UI elements of the build tab
#'
#' @description This function adds inputs for a new flow.
#' This is a helper function called by the shiny app.
#' @param values a shiny variable keeping track of UI elements
#' @param input shiny input structure
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

add_model_flow <- function(values, input, output)
{
    insertUI(
        # selector = paste0("#var", input$targetvar, "flow", values$nflow[input$targetvar]-1, 'slot'), #current variable
      selector = paste0("#var", values$varInd, "flow", values$flowButtonClicked, 'slot'), #current variable
      where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui =
            tags$div(
                fluidRow(
                    column(3,
                           # textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'name'), "Flow")
                           textInput(paste0("var", values$varInd, 'f' , values$flowInd, 'name'), "Flow")
                    ),
                    column(4,
                           # textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'text'), "Flow description")
                           textInput(paste0("var", values$varInd, 'f' , values$flowInd, 'text'), "Flow description")
                    ),

                    #*** Include add/remove flow buttons
                    column(2, actionButton(paste0("addflow_", values$varInd, "_", values$flowInd), "", class="submitbutton", icon = icon("plus-square"),
                                           style="margin-left: 0px; margin-top: 25px; width: 50px; color: #fff; background-color: #2e879b; border-color: #2e6da4")),

                    column(1, actionButton(paste0("rmflow_", values$varInd, "_", values$flowInd), "", class="submitbutton", icon = icon("trash-alt"),
                                           style="margin-left: -60px; margin-top: 25px; width: 50px; color: #fff; background-color: #d42300; border-color: gray"))

                ),
                # id = paste0("var", input$targetvar, "flow", values$nflow[input$targetvar], 'slot')
                id = paste0("var", values$varInd, "flow", values$flowInd, 'slot')
            ) #close flow tag
    ) #close insertUI

} #ends function
