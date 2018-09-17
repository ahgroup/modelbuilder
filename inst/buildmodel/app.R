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

    #add a new variable
    observeEvent(input$addvar, {
        insertUI(
            selector = paste0("#var", input$addvar, 'slot'),
            where = "afterEnd",
            ## wrap element in a div with id for ease of removal
            ui = tags$div(

                fluidRow( class = 'myrow',
                           column(2,
                                  textInput(paste0("var", input$addvar), "Variable Name")
                           ),
                           column(3,
                                  textInput(paste0("var", input$addvar,'desc'), "Variable Description")
                           ),
                           column(2,
                                  numericInput(paste0("var", input$addvar,'start'), "Starting value", value = 0)
                           )
                          ),
                fluidRow(
                                  textInput(paste0("var", input$addvar, 'f'), "Flows")
                           ),
                id = paste0("var", input$addvar, 'slot')
            ) #close tags$div
        ) #close insertUI
    }) #close observeevent


    #remove the last variable
     observeEvent(input$rmvar, {
         removeUI(
             selector = paste0("var", input$addvar + 1, 'slot')
        )
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
               actionButton("saveequations", "Save Equations", class="savebutton")
        ),
        align = "center"
    ),
    tags$br(),
    fluidRow(
        column(6,
               actionButton("addvar", "Add Variable", class="submitbutton")
        ),
        column(6,
               actionButton("rmvar", "Remove last Variable", class="submitbutton")
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
              tags$div(id = 'var1slot'),

              p('Model parameter information', class='mainsectionheader')

        ), #end input column
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
