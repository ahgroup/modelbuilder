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

  #FOR SPENCER
  #this function should load the model as list object 'model',
  #contained in the .Rdata file selected by the user through the fileInput buttion
  #example .Rdata model files that are properly formated are in \inst\modelexamples
  # model <- reactive({
  #     # input$currentmodel will be NULL initially. After the user selects
  #     # and uploads a file, it will be a data frame with 'name',
  #     # 'size', 'type', and 'datapath' columns. The 'datapath'
  #     # column will contain the local filenames where the data can
  #     # be found.
  #     stopping <<- TRUE
  #     inFile <- input$currentmodel
  #
  #     if (is.null(inFile))  return(NULL)
  #     load(inFile$datapath)
  # })


  #FOR SPENCER
  #when the user clicks the appropriate downloadButton,
  #this function should check if a model is loaded.
  #if yes, it should take the loaded model object, send it to the generate_ode function to produce
  #R code for an ODE function, and save the function with the filename produced by generate_ode (or specified by user)
  #in a location of the user's choice
  # output$exportode <- downloadHandler(
  #     filename = ,
  #     content = function(file) {generate_ode(data = model, location = file)},
  #     contentType = 'text/plain'
  # )

  session$onSessionEnded(function(){
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
  h1("Testing to make sure revisions are working correcty"),
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
                 fileInput("currentmodel", label = "Load a Model", accept = c('.Rdata'), buttonLabel = "Load Model", placeholder = "No model selected"),
               align = 'center' ),
        class = "mainmenurow"
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

