server <- function(input, output)
{

    # Waits for the Exit Button to be pressed to stop the app and return to main menu
    observeEvent(input$exitBtn, {
        input$exitBtn
        stopApp(returnValue = NULL)
    })

    observeEvent(input$addvar, {
        insertUI(
            selector = paste0("#var", input$addvar, 'placeholder'),
            ## wrap element in a div with id for ease of removal
            ui = fluidRow( class = 'myrow',
                           column(2,
                                  textInput(paste0("var", input$addvar), "Variable Name")
                           ),
                           column(3,
                                  textInput(paste0("var", input$addvar,'desc'), "Variable Description")
                           ),
                           column(2,
                                  numericInput(paste0("var", input$addvar,'start'), "Starting value", value = 0)
                           ),
                           column(3,
                                  textInput(paste0("var", input$addvar, 'f'), "Flow 1")
                           ),
                           column(4,
                                  actionButton(paste0("var", input$addvar, 'addflow'), "Add flow", class="submitbutton")
                           ),
                           tags$div(id = 'flowplaceholder'),
                           tags$div(id = paste0("var", input$addvar, 'placeholder'))
                        ) #close fluidRow structure for input

        )
    })

    observeEvent(input$rmvar, {
        removeUI(
            selector = "#varplaceholder"
        )
    })


    #main list structure
    model = list()

    #some meta-information
    model$title = isolate(input$modelname)
    model$description = isolate(input$modeldesc)
    model$author = isolate(input$modelauth)
    model$date = Sys.Date()

    #nvar =
    #var = vector("list",nvar)
    #for (n in 1:nvar)
    #{
     #   var[[n]]$varname =
      #  var[[n]]$vartext = "Susceptible"
       # var[[n]]$varval = 1000
    #    var[[n]]$flows = c('-b*S*I')
     #   var[[n]]$flownames = c('infection of susceptibles')
    #}

}  #ends the main shiny server function


ui <- fluidPage(
    fluidRow( class = 'myrow',
              column(4,
                     textInput("modelname", "Model Name")
              ),
              column(4,
                     textInput("modeldesc", "Model Description")
              ),
              column(4,
                     textInput("modelauth", "Author")
              ),
              align = "center"
            ),
    fluidRow(
        column(4,
               actionButton("addvar", "Add Variable", class="submitbutton")
        ),
        column(4,
               actionButton("rmvar", "Remove last Variable", class="submitbutton")
        ),
        column(4,
               actionButton("exitBtn", "Exit App", class="exitbutton")
        ),
        align = "center"
    ), #end section to add buttons

    tags$div(id = 'var1placeholder')
)

shinyApp(ui = ui, server = server)
