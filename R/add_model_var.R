#' @title A helper function that adds a variable to the shiny UI elements of the build tab
#'
#' @description This function adds inputs for a new variable.
#' This is a helper function called by the shiny app.
#' @param values a shiny variable keeping track of UI elements
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

add_model_var <- function(values, output, input, newVarNumber)
{

  # print(input$vartext2)

    insertUI(

      selector = paste0("#var", values$varInd, 'slot'), #current variable

        where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui = tags$div(style = "padding: 0em 0em 0em 0em;",

            fluidRow(

              # This textOutput will be updated when a variable name is entered
              column(3, h2(textOutput(paste0("var", newVarNumber, "DisplayName"))), align = "left"),

              column(1, actionButton(paste0("addvar_", newVarNumber), "", class="submitbutton", icon = icon("plus-square"),
                                     style="margin-left: -80px; margin-top: 20px; width: 50px; color: #fff; background-color: #2e879b; border-color: #2e6da4"),
                     align = "right"),

              column(1, actionButton(paste0("rmvar_", newVarNumber), "", class="submitbutton", icon = icon("trash-alt"),
                                     style="margin-left: -95px; margin-top: 20px; width: 50px; color: #fff; background-color: #d42300; border-color: gray"),
                     align = "right")
            ),


            fluidRow( class = 'myrow',

                      # this textInput updates the displayed variable name
                      column(3,
                             textInput(paste0("var", newVarNumber, 'name'), "Variable name")
                      ),
                      column(4,
                             textInput(paste0("var", newVarNumber, 'text'), "Variable description")
                      ),
                      column(3,
                             numericInput(paste0("var", newVarNumber, 'val'), "Start value", value = 0)
                      )
            ),
            tags$div(
                fluidRow(
                    column(3,
                           textInput(paste0("var", newVarNumber, 'f1name'), "Flow")
                    ),
                    column(4,
                           textInput(paste0("var", newVarNumber, 'f1text'), "Flow description")
                    ),

                    #*** Include add/remove flow buttons
                    column(2, actionButton(paste0("addflow_", newVarNumber, "_", 1), "", class="submitbutton", icon = icon("plus-square"),
                                           style="margin-left: 0px; margin-top: 25px; width: 50px; color: #fff; background-color: #2e879b; border-color: #2e6da4")),

                    column(1, actionButton(paste0("rmflow_", newVarNumber, "_", 1), "", class="submitbutton", icon = icon("trash-alt"),
                                           style="margin-left: -60px; margin-top: 25px; width: 50px; color: #fff; background-color: #d42300; border-color: gray"))


                ), # End fluidRow

                id = paste0("var", newVarNumber, "flow", values$nflow[values$varInd], 'slot')
            ), #close flow tag
            id = paste0("var", newVarNumber, 'slot')
        ) #close tags$div
    ) #close insertUI
} #ends function
