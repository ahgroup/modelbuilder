server <- function(input, output, session)
{


    generate_shinyinput(model, output) #make the UI for the model


    ###########################################
    #server part that listens for exit button click
    observeEvent(input$exitBtn, {
        input$exitBtn
        stopApp(returnValue = NULL)
    })


    ###########################################
    #server part that listens for run simulation button click
    #on click, run simulation and update plots and text
    observeEvent(input$submitBtn,
    {

        modeltype = isolate(input$modeltype)
        rngseed = isolate(input$rngseed)
        nreps = isolate(input$nreps)
        plotscale = isolate(input$plotscale)

        #save all results to a list for processing plots and text
        listlength = 1
        #here we do all simulations in the same figure
        result = vector("list", listlength) #create empty list of right size for results


        #creates model code
        if (modeltype == 'ode')
        {
            location = tempdir() #temporary directory to save file
            convert_to_desolve(model = model, location = location)
            filename=paste0(gsub(" ","_",model$title),"_desolve.R")
            source(paste0(location,filename)) #source file
        }

        #parses the model and creates the code to call/run the simulation
        fctcall <- generate_fctcall(input=input,model=model,modeltype='desolve')

        #run simulation, show a 'running simulation' message
        withProgress(message = 'Running Simulation', value = 0,
        {
             eval(parse(text = fctcall)) #execute function
        })

        #data for plots and text
        #needs to be in the right format to be passed to generate_plots and generate_text
        #see documentation for those functions for details
        result[[1]]$dat = simresult$ts
        result[[1]]$maketext = TRUE

        #create plot from results
        output$plot  <- renderPlot({
             generate_plots(result)
        }, width = 'auto', height = 'auto')

        #create text from results
        output$text <- renderText({
             generate_text(result)     #create text for display with a non-reactive function
        })
    }) #end ObserveEvent submit button
}  #ends the main shiny server function


ui <- fluidPage(
    #UI does not 'know' about the model, all that is processed in the server function and only displayed here
    h1(uiOutput("title"), align = "center", style = "background-color:#123c66; color:#fff"),

    #section to add buttons
    fluidRow(column(
        6,
        actionButton("submitBtn", "Run Simulation", class = "submitbutton")
    ),
    column(
        6,
        actionButton("exitBtn", "Exit App", class = "exitbutton")
    ),
    align = "center"),
    #end section to add buttons

    tags$hr(),

    ################################
    #Split screen with input on left, output on right
    fluidRow(
        #all the inputs in here
        column(
            6,
            h2('Simulation Settings'),
            uiOutput("vars"),
            uiOutput("pars"),
            uiOutput("time"),
            numericInput("nreps", "Number of simulations", min = 1, max = 50, value = 1, step = 1),
            selectInput("plotscale", "Log-scale for plot:",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both")),
            selectInput("modeltype", "Models to run",c("ODE" = "ode", 'stochastic' = 'stochastic', 'discrete time' = 'discrete'), selected = '1'),
            numericInput("rngseed", "Random number seed", min = 1, max = 1000, value = 123, step = 1)
        ),
        #end sidebar column for inputs

        #all the outcomes here
        column(
            6,

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
