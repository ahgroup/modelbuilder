server <- function(input, output)
{

    # Waits for the Exit Button to be pressed to stop the app and return to main menu
    observeEvent(input$exitBtn, {
        input$exitBtn
        stopApp(returnValue = NULL)
    })

    # #on save button, the model should be saved to an Rdata file
    # not working
    # output$savemodel <- downloadHandler(
    #     filename = function() {
    #         #paste0(gsub(" ","_",input$modeltitle), ".Rdata")
    #         paste("data-", Sys.Date(), ".Rdata", sep="")
    #     },
    #     content = function(file) {
    #         model = list()
    #         model$title = isolate(input$modeltitle)
    #         model$author = isolate(input$modelauthor)
    #         save(model, file)
    #     }
    # )


    # just to allow debugging right now
    observeEvent(input$saveequations, {
        browser()
    })

    #define number of variables and parameters globally, is updated based on user pressing add/delete variables/parameters
    values = reactiveValues()
    values$nvar <- 1
    values$npar <- 1

    #add a new variable
    observeEvent(input$addvar, {
        values$nvar = values$nvar + 1
        insertUI(
            selector = paste0("#var", values$nvar - 1, 'slot'), #current variable
            where = "afterEnd",
            ## wrap element in a div with id for ease of removal
            ui = tags$div(

                fluidRow( class = 'myrow',
                           column(2,
                                  textInput(paste0("var", values$nvar), "Variable Name")
                           ),
                           column(3,
                                  textInput(paste0("var", values$nvar,'desc'), "Variable Description")
                           ),
                           column(2,
                                  numericInput(paste0("var", values$nvar,'start'), "Starting value", value = 0)
                           )
                          ),
                fluidRow(
                        column(6,
                                  textInput(paste0("var", values$nvar, 'f'), "Flow")
                        ),
                        column(6,
                               textInput(paste0("var", values$nvar, 'fdesc'), "Flow descrpition")
                        )
                ),
                id = paste0("var", values$nvar, 'slot')
            ) #close tags$div
        ) #close insertUI
    }) #close observeevent


    #remove the last variable
     observeEvent(input$rmvar, {
         if (values$nvar == 1) return() #don't remove the last variable
         removeUI(
             selector = paste0("#var", values$nvar, 'slot'),
             immediate = TRUE
        )
       values$nvar = values$nvar - 1
     })


     #add a new parameter
     observeEvent(input$addpar, {
         values$npar = values$npar + 1
         insertUI(
             selector = paste0("#par", values$npar - 1, 'slot'), #current variable
             where = "afterEnd",
             ## wrap element in a div with id for ease of removal
             ui = tags$div(

                 fluidRow( class = 'myrow',
                           column(2,
                                  textInput(paste0("par", values$nvar), "Parameter Name")
                           ),
                           column(3,
                                  textInput(paste0("par", values$nvar,'desc'), "Parameter Description")
                           ),
                           column(2,
                                  numericInput(paste0("par", values$nvar,'start'), "Default value", value = 0)
                           )
                 ),
                 id = paste0("par", values$npar, 'slot')
             ) #close tags$div
         ) #close insertUI
     }) #close observeevent

     #remove the last parameter
     observeEvent(input$rmpar, {
         if (values$npar == 1) return() #don't remove the last variable
         removeUI(
             selector = paste0("#par", values$npar, 'slot'),
             immediate = TRUE
         )
         values$npar = values$npar - 1
     })


}  #ends the main shiny server function

#The UI for the app that allows building of models
ui <- fluidPage(
    includeCSS("../media/modelbuilder.css"),
    #add header and title
    div( includeHTML("../media/header.html"), align = "center"),
    fluidRow(
        actionButton("exitBtn", "Exit to main menu", class="exitbutton"),
        align = "center"
    ),
    tags$br(),
    fluidRow(
        column(4,
               downloadButton('savemodel', "Save Model", class="savebutton")
        ),
        column(4,
               downloadButton("savediagram", "Save Diagram", class="savebutton")
        ),
        column(4,
               downloadButton("saveequations", "Save Equations", class="savebutton")
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
               numericInput("delvar", "Selected variable", value = 1)
        ),
        align = "center"
    ),
    fluidRow( class = 'myrow', #splits screen into 2 for input/output
              column(
                  6,
                p('General model information', class='mainsectionheader'),
                fluidRow(

                column(6,
                    textInput("modeltitle", "Model Name")
                ),
                column(6,
                       textInput("modelauthor", "Author")
                )),

                textInput("modeldescription", "One sentence model Description"),
                textAreaInput("modeldetails", "Long model Description"),

              p('Model time information', class='mainsectionheader'),
              fluidRow(

                  column(4,
                         numericInput("tstart", "Start time", value = 0)
                  ),
                  column(4,
                         numericInput("tfinal", "Final time", value = 100)
                         ),
                  column(4,
                         numericInput("dt", "Time step", value = 0.1)
                         )
                ),
              p('Model variable information', class='mainsectionheader'),
              ## wrap element in a div with id
              tags$div(

                      fluidRow( class = 'myrow',
                                column(2,
                                       textInput("var1", "Variable Name")
                                ),
                                column(3,
                                       textInput("var1desc", "Variable Description")
                                ),
                                column(2,
                                       numericInput("var1start", "Starting value", value = 0)
                                )
                      ),
                      fluidRow(
                          textInput("var1f", "Flows")
                      ),
                      id = 'var1slot'),
              p('Model parameter information', class='mainsectionheader'),
              tags$div(

                  fluidRow( class = 'myrow',
                            column(2,
                                   textInput("par1", "Parameter Name")
                            ),
                            column(3,
                                   textInput("par1desc", "Parameter Description")
                            ),
                            column(2,
                                   numericInput("par1start", "Default value", value = 0)
                            )
                  ),
                  id = 'par1slot')
        ) , #end input column
        #all the outcomes here
        column(
            6,

            #################################
            h2('Model Diagram'),
            #plotOutput(outputId = "plot", height = "500px"),
            # PLaceholder for results of type text
            h2('Model Equations')
            #htmlOutput(outputId = "text"),
        ) #end column for outcomes
    ) #end split input/output section
) #end fluid page


shinyApp(ui = ui, server = server)
