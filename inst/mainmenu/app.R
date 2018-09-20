#This is the Shiny App for the main menu of the modelbuilder package

#this function is the server part of the app
server <- function(input, output, session) {

  appNames <- c('buildmodel','analyzemodel','Exit') #options

  stopping <- FALSE


  observeEvent(input$buildmodel, {
      stopping <<- TRUE
      stopApp('buildmodel')
  })

  observeEvent(input$analyzemodel, {
      browser()
      stopping <<- TRUE
      stopApp('analyzemodel')
  })

  observeEvent(input$Exit, {
      stopping <<- TRUE
      stopApp('Exit')
  })
  
  model <- reactive({
    stopping <<- TRUE
    inFile <- input$currentmodel
    if (is.null(inFile)) return(NULL)
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
             actionButton("analyzemodel", "Analyze current model", class="mainbutton")
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

