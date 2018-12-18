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

# generate_buildUI <- function(mbmodel, output)
# {
#     output$buildmodel <- renderUI({
#         fluidPage(
#             p('General model information', class='mainsectionheader'),
#             fluidRow(
#                 column(6,
#                        textInput("modeltitle", "Model Name", value = mbmodel$title),
#                        textInput("modeldescription", "One sentence model description", value = mbmodel$description),
#                        textInput("modelauthor", "Author", value = mbmodel$author)
#
#                     ),
#                 column(6,
#                    textAreaInput("modeldetails", "Detailed model description", value = mbmodel$details, rows = 6, width = '100%')
#                     )
#                 ),
#             p('Model time information', class='mainsectionheader'),
#             fluidRow(
#                 column(4,
#                        numericInput("tstart", "Start time", value = ifelse(is.null(mbmodel$title),0, mbmodel$time[[1]]$timeval) )
#                 ),
#                 column(4,
#                        numericInput("tfinal", "Final time", value = ifelse(is.null(mbmodel$title),100, mbmodel$time[[2]]$timeval) )
#                 ),
#                 column(4,
#                        numericInput("dt", "Time step", value = ifelse(is.null(mbmodel$title),0.1, mbmodel$time[[3]]$timeval) )
#                 )
#             ),
#
#
#             tags$p('All variables need to start with an uppercase letter, all parameters need to start with a lowercase letter. Only letters and numbers are allowed. Flows need to include variables, parameters and the following mathematical symbols: +,-,*,/,^,()'),
#             #fluidRow(
#             fluidRow(
#                 column(6,
#                        # actionButton("makemodel", "Make model", class="submitbutton"),
#                        actionButton("defaultmodel", "Make default model", class = "submitbutton")
#                 ),
#                 column(6,
#                        downloadButton('savemodel', "Save Model", class="savebutton")
#                        #downloadButton("savediagram", "Save Diagram", class="savebutton")
#                 ),
#                 align = "center"
#             ),
#             tags$br(),
#             fluidRow(
#                 column(4,
#                        actionButton("addvar", "Add variable", class="submitbutton")
#                 ),
#                 column(4,
#                        actionButton("addpar", "Add parameter", class="submitbutton")
#                 ),
#                 column(4,
#                        actionButton("addflow", "Add flow to variable", class="submitbutton")
#                 ),
#                 align = "center"
#             ),
#             fluidRow(
#                 column(4,
#                        actionButton("rmvar", "Remove last Variable", class="submitbutton")
#                 ),
#                 column(4,
#                        actionButton("rmpar", "Remove last Parameter", class="submitbutton")
#                 ),
#                 column(4,
#                        actionButton("rmflow", "Remove flow of variable", class="submitbutton"),
#                        numericInput("targetvar", "Selected variable", value = 1)
#                 ),
#                 align = "center"
#             ),
#             fluidRow( class = 'myrow', #splits screen into 2 for input/output
#                       column(6,
#                              p('Model variable information', class='mainsectionheader'),
#                              ## wrap element in a div with id
#                              lapply(1:max(1,length(mbmodel$var)), function(n) {
#                              tags$div(
#                                  h3(paste("Variable",n)),
#                                  fluidRow( class = 'myrow',
#                                            column(2,
#                                                   textInput(paste0("var",n,"name"), "Variable name", value = mbmodel$var[[n]]$varname)
#                                            ),
#                                            column(3,
#                                                   textInput(paste0("var",n,"text"), "Variable description", value = mbmodel$var[[n]]$vartext)
#                                            ),
#                                            column(2,
#                                                   numericInput(paste0("Var",n,"val"), "Starting value", value = mbmodel$var[[n]]$varval)
#                                            )
#                                  ),
#                                  #loop over flows for each variable
#                                  lapply(1:max(1, length(mbmodel$var[[n]]$flows)), function(nn) {
#                                      tags$div(
#                                      fluidRow(
#                                          column(6,
#                                                 textInput(paste0("var",n,"f",nn,"name"), "Flow", value = mbmodel$var[[n]]$flows[nn])
#                                          ),
#                                          column(6,
#                                                 textInput(paste0("var",n,"f",nn,"text"), "Flow description", value = mbmodel$var[[n]]$flownames[nn])
#                                          )
#                                      ),
#                                      id = paste0('var',n,'flow',nn,'slot')  ) #close flow div
#                                  }), #end apply loop over flows for each  variable
#                                  id = paste0("var",n,"slot") ) #close var div
#                              }), #end apply loop over all variables
#                              p('Model parameter information', class='mainsectionheader'),
#                              lapply(1:max(1,length(mbmodel$par)), function(n) {
#                              tags$div(
#                                  fluidRow( class = 'myrow',
#                                            column(2,
#                                                   textInput(paste0("par",n,"name"), "Parameter name", value = mbmodel$par[[n]]$parname)
#                                            ),
#                                            column(3,
#                                                   textInput(paste0("par",n,"text"), "Parameter description", value = mbmodel$par[[n]]$partext)
#                                            ),
#                                            column(2,
#                                                   numericInput(paste0("par",n,"val"), "Default value", value = mbmodel$par[[n]]$parval)
#                                            )
#                                  ),
#                                  id = paste0("par",n,"slot"))
#                              })
#                       ) , #end input column
#                       #all the outcomes here
#                       column(
#                           6,
#
#                           #################################
#                           h2('Model Diagram'),
#                           plotOutput(outputId = "diagram", height = "500px"),
#                           # Placeholder for results of type text
#                           h2('Model Equations'),
#                           uiOutput(outputId = "equations")
#                       ) #end column for outcomes
#             ) #end split input/output section
#         ) #end fluid page for build tab
#     }) # End renderUI for build tab
# } #ends generate_buildUI function
