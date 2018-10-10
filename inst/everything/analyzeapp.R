#basic SIR model app
server <- function(input, output, session)
{

    #if the model object exists in workspace, use it
    #otherwise, load model from Rdata file
    #currently, Rdata file needs to be in same folder
    #could be made more flexible
    if (!exists("model"))
    {
        currentdir = getwd()
        rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
        load(rdatafile)
    }



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


        #check if function/code is available, if not generate and source code as temp file
        if (modeltype == 'ode' & !exists( paste0("simulate_",gsub(" ","_",model$title),"_ode") ) )
        {
            location = tempdir() #temporary directory to save file
            filename=paste0("simulate_",gsub(" ","_",model$title),"_ode.R")
            generate_ode(model = model, location = paste0(location,filename))
            source(paste0(location,filename)) #source file
        }

        #parses the model and creates the code to call/run the simulation
        print(model) # Debugging
        fctcall <- generate_fctcall(input=input,model=model,modeltype='ode')


        #run simulation, show a 'running simulation' message
        withProgress(message = 'Running Simulation', value = 0,
        {
             eval(parse(text = fctcall)) #execute function
        })

        plotscale = isolate(input$plotscale)

        #data for plots and text
        #needs to be in the right format to be passed to generate_plots and generate_text
        #see documentation for those functions for details
        result[[1]]$dat = simresult$ts

        #Meta-information for each plot
        #Might not want to hard-code here, can decide later
        result[[1]]$plottype = "Lineplot"
        result[[1]]$xlab = "Time"
        result[[1]]$ylab = "Numbers"
        result[[1]]$legend = "Compartments"

        result[[1]]$xscale = 'identity'
        result[[1]]$yscale = 'identity'
        if (plotscale == 'x' | plotscale == 'both') { result[[1]]$xscale = 'log10'}
        if (plotscale == 'y' | plotscale == 'both') { result[[1]]$yscale = 'log10'}


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
  includeCSS("../media/modelbuilder.css"),
  #add header and title
  #withMathJax(),
  #
  tags$head(tags$style(".myrow{vertical-align: bottom;}")),
  div( includeHTML("../media/header.html"), align = "center"),
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
            column(
              6,
              uiOutput("vars"),
              uiOutput("time")
            ),
            column(
              6,
              uiOutput("pars"),
              numericInput("nreps", "Number of simulations", min = 1, max = 50, value = 1, step = 1),
              selectInput("modeltype", "Models to run",c("ODE" = "ode", 'stochastic' = 'stochastic', 'discrete time' = 'discrete'), selected = '1'),
              numericInput("rngseed", "Random number seed", min = 1, max = 1000, value = 123, step = 1),
              selectInput("plotscale", "Log-scale for plot:",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both"))
        )),
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
  ), #end layout with side and main panel

  #################################
  #Instructions section at bottom as tabs
  h2('Instructions'),
  #use external function to generate all tabs with instruction content
  #browser(),
  #do.call(tabsetPanel, generate_documentation() ),
  div(includeHTML("../media/footer.html"), align="center", style="font-size:small") #footer

) #end fluidpage

shinyApp(ui = ui, server = server)
