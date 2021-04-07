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
        #*** Alter selection to be based on the paramater indicator
        selector = paste0("#par", values$buttonClicked, 'slot'), #current variable

        where = "afterEnd",
        ## wrap element in a div with id for ease of removal
        ui = tags$div(style = "padding: 1em 0em 0em 2em;",

          #*** Alter text input to use the paramater indicator instead of the next parameter incrementally
          fluidRow( class = 'myrow',
                    column(2,
                           textInput(paste0("par", values$parInd, 'name'), "Parameter Name")
                    ),
                    column(3,
                           textInput(paste0("par", values$parInd, 'text'), "Parameter description")
                    ),
                    column(2,
                           numericInput(paste0("par", values$parInd, 'val'), "Default value", value = 0)
                    ),

                    #*** Include add/remove paramater buttons
                    column(1, actionButton(paste0("addpar_", values$parInd), "", class="submitbutton", icon = icon("plus-square"),
                                           style="margin-left: 0px; margin-top: 25px; width: 50px; color: #fff; background-color: #2e879b; border-color: #2e6da4")),

                    column(1, actionButton(paste0("rmpar_", values$parInd), "", class="submitbutton", icon = icon("trash-alt"),
                                           style="margin-left: -10px; margin-top: 25px; width: 50px; color: #fff; background-color: #d42300; border-color: gray"))



          ), # End fluidRow



            #*** Alter the slot value to use the paramater indicator instead of the next parameter incrementally
            id = paste0("par", values$parInd, 'slot')
        ) #close tags$div
    ) #close insertUI
} #ends function
