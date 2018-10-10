#This is the Shiny App for the main menu of the modelbuilder package

#this function is the server part of the app
server <- function(input, output, session) {

  appNames <- c('buildmodel','Exit') #options
  # Changed from appNames <- c('buildmodel', 'analyzemodel', 'Exit')

  stopping <- FALSE


  #should eventually be replaced by calling the 'build module' instead of a different shiny app
  #currently not working/existing, can be ignored for now
  observeEvent(input$buildmodel, {
      stopping <<- TRUE
      stopApp('buildmodel')
  })

  #should be replaced by calling the 'analyze module' instead of a different shiny app
  observeEvent(input$analyzemodel, {
      insertUI(
          selector = "#analyzemodel",
          where = "afterEnd",
          ui = tags$div(
              fluidRow(
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
                          selectInput("modeltype", "Models to run", c("ODE" = "ode", 'stochastic' = 'stochastic', 'discrete time' = 'discrete'), selected = '1'),
                          numericInput("rngseed", "Random number seed", min = 1, max = 1000, value = 123, step = 1),
                          selectInput("plotscale", "Log-scale for plot:",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both")),
                          actionButton("process", "Process inputs", class = "mainbutton")
                      ))
              ) # End of fluidRow
          ) # End of ui
      ) # End of insertUI
  }) # End of observeEvent() for analyzemodel

  observeEvent(input$process, {
      wd <- getwd()
      r <- analyze_model(wd = wd, modeltype = input$modeltype,
                    rngseed = input$rngseed, nreps = input$nreps,
                    plotscale = input$plotscale, input = input,
                    input_model = model())
      #create plot from results
      output$plot  <- renderPlot({
          generate_plots(r)
      }, width = 'auto', height = 'auto')

      #create text from results
      output$text <- renderText({
          generate_text(r)     #create text for display with a non-reactive function
      })
      insertUI(selector = "#process",
               where = "afterEnd",
               ui = tags$div(
                   fluidRow(
                       column(
                           12,
                           #################################
                           #Start with results on top
                           h2('Simulation Results'),
                           plotOutput(outputId = "plot", height = "500px"),
                           # Placeholder for results of type text
                           htmlOutput(outputId = "text"),
                           tags$hr()
                       ) #end main panel column with outcomes
                   )
               )) # End of insertUI
  })

  observeEvent(input$Exit, {
      stopping <<- TRUE
      stopApp('Exit')
  })

  model <- reactive({
    stopping <<- TRUE
    inFile <- input$currentmodel
    if (is.null(inFile)) return(NULL)
    # loadRData() below was suggesed on Stack Overflow 8/22/14 by user ricardo.
    # The code was provided for general use in answer to another user's question
    # about loading data into R. The original source for the code can be found
    # here: https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file
    loadRData <- function(filename) {
      load(filename)
      get(ls()[ls() != "filename"])
    }
    d <- loadRData(inFile$datapath)
  })

  output$exportode <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",model()$title),"_ode.R")
    },
    content = function(file) {
      stopifnot(!is.null(model()))
      generate_ode(model = model(), location = file)
    },
    contentType = "text/plain"
  )

  output$exportstochastic <- downloadHandler(
    filename = function() {
      paste0(gsub(" ","_",model$title),"_RxODE.R")
    },
    content = function(file) {
      stopifnot(!is.null(model()))
      convert_to_rxode(model = model(), location = file)
    },
    contentType = "text/plain"
  )

  output$exportdiscrete <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",model()$title),"_discrete.R")
    },
    content = function(file) {
      stopifnot(!is.null(model()))
      generate_discrete(model = model(), location = file)
    },
    contentType = "text/plain"
  )

  session$onSessionEnded(function() {
    if (!stopping) {
      stopApp('Exit')
    }
  })

}



#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
  includeCSS("../media/modelbuilder.css"),
  #add header and title
  div( includeHTML("../media/header.html"), align = "center"),
  p(paste('This is modelbuilder version ',utils::packageVersion("modelbuilder"),' last updated ', utils::packageDescription('modelbuilder')$Date,sep=''), class='infotext'),

  h1('Main Menu', align = "center", style = "background-color:#123c66; color:#fff"),
  p('Build a new model', class='mainsectionheader'),
    fluidRow(
        column(12,
             actionButton("buildmodel", "Build a new model", class="mainbutton")
      ),
      class = "mainmenurow"
    ),
  p('Load an existing model', class='mainsectionheader'),
  fluidRow(
        column(12,
                 fileInput("currentmodel", label = "Load a Model", accept = ".Rdata", buttonLabel = "Load Model", placeholder = "No model selected"),
               align = 'center' )
  ),
  fluidRow(
      column(12,
             verbatimTextOutput("modeltitle"),
             align = 'center'),
      class = "mainmenurow"
  ),

  p('Work on the currently loaded model', class='mainsectionheader'),
  fluidRow(
      column(6,
             actionButton("buildmodel", "Modify current model", class="mainbutton")
      ),
      column(6,
             actionButton("analyzemodel", "Analyze current model", class = "mainbutton")
      ),
      class = "mainmenurow"
  ), #close fluidRow structure for input

  p('Get the R code for the currently loaded model', class='mainsectionheader'),
    fluidRow(
      column(3,
             downloadButton("exportode", "Export ODE code")
            ),
      column(3,
             downloadButton("exportstochastic", "Export stochastic code")
      ),
      column(3,
             downloadButton("exportdiscrete", "Export discrete-time code")
      ),
      column(3,
             downloadButton("exportrxode", "Export RxODE code")
      ),
      class = "mainmenurow"
  ), #close fluidRow structure for input

  p('Import or Export SBML models', class='mainsectionheader'),
  fluidRow(
      column(6,
             actionButton("importsbml", "Import a SBML model", class="mainbutton")
      ),
      column(6,
             actionButton("exportsbml", "Export to SMBL model", class="mainbutton")
      ),
      class = "mainmenurow"
  ), #close fluidRow structure for input



 fluidRow(

    column(12,
           actionButton("Exit", "Exit", class="exitbutton")
    ),
    class = "mainmenurow"
  ), #close fluidRow structure for input

  p('Have fun building and analyzing models!', class='maintext'),
  div(includeHTML("../media/footer.html"), align="center", style="font-size:small") #footer
) #end fluidpage

shinyApp(ui = ui, server = server)

