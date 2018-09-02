server <- function(input, output)
{

    output$vars <- renderUI({
        nvars = length(model$var)  #number of variables/compartments in model
        allv = lapply(1:nvars, function(n) { numericInput(model$var[[n]]$varname, model$var[[n]]$vartext, value = model$var[[n]]$varval) } )
        do.call(mainPanel, allv)
    })

    output$pars <- renderUI({
        npars = length(model$par)  #number of parameters in model
        allp = lapply(1:npars, function(n) { numericInput(model$par[[n]]$parname, model$par[[n]]$partext, value = model$par[[n]]$parval) } )
        do.call(mainPanel, allp)
    })

    output$time <- renderUI({
        ntime = length(model$time)  #number of time variables in model
        allt = lapply(1:ntime, function(n) { numericInput(model$time[[n]]$timename, model$time[[n]]$timetext, value = model$time[[n]]$timeval) } )
        do.call(mainPanel, allt)
    })


}  #ends the main shiny server function


ui <- fluidPage(

    h1(model$title, align = "center", style = "background-color:#123c66; color:#fff"),

    #section to add buttons
    fluidRow(
        column(6,
               actionButton("submitBtn", "Run Simulation", class="submitbutton")
        ),
        column(6,
               actionButton("exitBtn", "Exit App", class="exitbutton")
        ),
        align = "center"
    ), #end section to add buttons

    tags$hr(),

    ################################
    #Split screen with input on left, output on right
    fluidRow(
        #all the inputs in here
        column(6,
                h2('Simulation Settings'),
                uiOutput("vars"),
                uiOutput("pars")
            ), #end sidebar column for inputs

        #all the outcomes here
        column(6,

               #################################
               #Start with results on top
               h2('Simulation Results'),
               plotOutput(outputId = "plot", height = "500px"),
               # PLaceholder for results of type text
               htmlOutput(outputId = "text"),
               tags$hr()
        ) #end main panel column with outcomes
    ) #end layout with side and main panel
) #end fluidpage


shinyApp(ui = ui, server = server)
