#the main function with all the functionality for the server
#this function is wrapped inside the shiny server function below to allow return to main menu when window is closed
refresh <- function(input, output){

    #load("inst/modelexamples/SIR_model.Rdata"); source("inst/modelexamples/SIR_model_desolve.R")

    result <- reactive({
        input$submitBtn


        #save all results to a list for processing plots and text
        listlength = 1;       #here we do all simulations in the same figure
        result = vector("list", listlength) #create empty list of right size for results

        #create the simulation function call
        filename=paste0(gsub(" ","_",model$title),"_desolve")



        nvars = length(model$var)
        varstring = "vars = c("
        for (n in 1:nvars)
        {
            isolate(input[[model$var[[n]]$varname]])
            varstring=paste0(varstring, model$var[[n]]$varname, " = ", isolate(input[[model$var[[n]]$varname]]),', ')
        }
        varstring = substr(varstring,1,nchar(varstring)-2)
        varstring = paste0(varstring,'), ') #close parentheses

        npars = length(model$par)
        parstring = "pars = c("
        for (n in 1:npars)
        {
            parstring=paste0(parstring, model$par[[n]]$parname," = ", isolate(input[[model$par[[n]]$parname]]),', ')
        }
        parstring = substr(parstring,1,nchar(parstring)-2)
        parstring = paste0(parstring,'), ') #close parentheses

        ntime = length(model$time)
        timestring = "time = c("
        for (n in 1:ntime)
        {
            timestring=paste0(timestring, model$time[[n]]$timename," = ", isolate(input[[model$time[[n]]$timename]]),', ')
        }
        timestring = substr(timestring,1,nchar(timestring)-2)
        timestring = paste0(timestring,') ')

        fct = match.fun(filename) #function to run
        fctargs = paste0(varstring, parstring, timestring) #arguments for function
        print(fctargs)
        browser()
        #shows a 'running simulation' message
        withProgress(message = 'Running Simulation', value = 0,
                     {
                         simresult <- fct(fctargs)
                         #simresult <- SIR_model_desolve(vars = c(S = 100, I = 1, R = 0), pars = c(b = 0.002, g = 1), time = c(tstart = 0, tfinal = 100, dt = 0.1) )
                     })

        #data for plots and text
        #needs to be in the right format to be passed to generate_plots and generate_text
        #see documentation for those functions for details
        result[[1]]$dat = simresult$ts
        #browser()

        return(result)

    }) #ends the reactive function that runs the simulation and returns output

    output$plot  <- renderPlot({
        input$submitBtn
        res=isolate(result())   #list of all results that are to be turned into plots
        generate_plots(res)      #create plots with a non-reactive function
    }, width = 'auto', height = 'auto'
    )    #finish render-plot statement

    output$text <- renderText({
        input$submitBtn
        res=isolate(result())        #list of all results that are to be turned into plots
        generate_text(res)     #create text for display with a non-reactive function
    })
} #ends the 'refresh' shiny server function that runs the simulation and returns output


server <- function(input, output, session)
{
    observeEvent(input$exitBtn, {
        input$exitBtn
        stopApp(returnValue = NULL)
    })

    #creates the UI part
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

    # This function is called to refresh the content of the Shiny App
    refresh(input, output)

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
                uiOutput("pars"),
                uiOutput("time")

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
