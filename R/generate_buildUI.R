#' @title A helper function that takes a model and generates the shiny UI elements for the build tab
#'
#' @description This function generates empty inputs or inputs for a supplied model.
#' This is a helper function called by the shiny app.
#' @param mbmodel a modelbuilder model structure
#' @param output shiny output structure
#' @return No direct return. output structure is modified to contain text for display in a Shiny UI
#' @details This function is called by the Shiny server to produce the Shiny input UI elements for the build tab.
#' @author Andreas Handel
#' @export

generate_buildUI <- function(mbmodel, output)
{



    output$buildmodel <- renderUI({
        fluidPage(
            p('General model information', class='mainsectionheader'),
            fluidRow(
                column(4,
                       textInput("modeltitle", "Model Name")
                ),
                column(4,
                       textInput("modelauthor", "Author")
                ),
                column(4,
                       textInput("modeldescription", "One sentence model description")
                ),
                align = "center"
            ),
            fluidRow(
                textAreaInput("modeldetails", "Long model description"),
                align = "center"
            ),
            p('Model time information', class='mainsectionheader'),
            fluidRow(
                column(4,
                       numericInput("tval", "Start time", value = 0)
                ),
                column(4,
                       numericInput("tfinal", "Final time", value = 100)
                ),
                column(4,
                       numericInput("dt", "Time step", value = 0.1)
                )
            ),


            tags$p('All variables need to start with an uppercase letter, all parameters need to start with a lowercase letter. Only letters and numbers are allowed. Flows need to include variables, parameters and the following mathematical symbols: +,-,*,/,^,()'),
            #fluidRow(
            fluidRow(
                column(6,
                       actionButton('makemodel', "Generate model", class="savebutton")
                ),
                column(6,
                       downloadButton('savemodel', "Save Model", class="savebutton")
                       #downloadButton("savediagram", "Save Diagram", class="savebutton")
                ),
                align = "center"
            ),
            tags$br(),
            fluidRow(
                column(4,
                       actionButton("addvar", "Add variable", class="submitbutton")
                ),
                column(4,
                       actionButton("addpar", "Add parameter", class="submitbutton")
                ),
                column(4,
                       actionButton("addflow", "Add flow to variable", class="submitbutton")
                ),
                align = "center"
            ),
            fluidRow(
                column(4,
                       actionButton("rmvar", "Remove last Variable", class="submitbutton")
                ),
                column(4,
                       actionButton("rmpar", "Remove last Parameter", class="submitbutton")
                ),
                column(4,
                       actionButton("rmflow", "Remove flow of variable", class="submitbutton"),
                       numericInput("targetvar", "Selected variable", value = 1)
                ),
                align = "center"
            ),
            fluidRow( class = 'myrow', #splits screen into 2 for input/output
                      column(6,
                             p('Model variable information', class='mainsectionheader'),
                             ## wrap element in a div with id
                             tags$div(
                                 h3(paste("Variable 1")),

                                 fluidRow( class = 'myrow',
                                           column(2,
                                                  textInput("var1name", "Variable name")
                                           ),
                                           column(3,
                                                  textInput("var1text", "Variable description")
                                           ),
                                           column(2,
                                                  numericInput("var1val", "Starting value", value = 0)
                                           )
                                 ),
                                 tags$div(
                                     fluidRow(
                                         column(6,
                                                textInput("var1f1name", "Flow")
                                         ),
                                         column(6,
                                                textInput("var1f1text", "Flow description")
                                         )
                                     ),
                                     id = 'var1flow1slot'), #close flow div
                                 id = 'var1slot'), #close var div
                             p('Model parameter information', class='mainsectionheader'),
                             tags$div(
                                 fluidRow( class = 'myrow',
                                           column(2,
                                                  textInput("par1name", "Parameter name")
                                           ),
                                           column(3,
                                                  textInput("par1text", "Parameter description")
                                           ),
                                           column(2,
                                                  numericInput("par1val", "Default value", value = 0)
                                           )
                                 ),
                                 id = 'par1slot')
                      ) , #end input column
                      #all the outcomes here
                      column(
                          6,

                          #################################
                          h2('Model Diagram'),
                          plotOutput(outputId = "diagram", height = "500px"),
                          # Placeholder for results of type text
                          h2('Model Equations'),
                          uiOutput(outputId = "equations")
                      ) #end column for outcomes
            ) #end split input/output section
        ) #end fluid page for build tab
    }) # End renderUI for build tab
} #ends generate_buildUI function
