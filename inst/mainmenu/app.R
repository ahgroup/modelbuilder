#This is the Shiny App for the main menu

#this function is the server part of the app
server <- function(input, output, session) {

  appNames <- c('buildmodel','analyzemodel','Exit') #options

  stopping <- FALSE

  observeEvent(input$buildmodel, {
      stopping <<- TRUE
      stopApp('buildmodel')
  })

  observeEvent(input$analyzemodel, {
      stopping <<- TRUE
      stopApp('analyzemodel')
  })

  observeEvent(input$Exit, {
      stopping <<- TRUE
      stopApp('Exit')
  })

  output$downloadData <- downloadHandler(
      filename = function() {
          paste(input$dataset, ".csv", sep = "")
      },
      content = function(file) {
          write.csv(datasetInput(), file, row.names = FALSE)
      }
  )


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
  fluidRow(
      column(6,
             fileInput("currentmodel", label = "Load a Model", accept = c('Rdata'), buttonLabel = "Load Model", placeholder = "No model selected")
             ),
      column(6,
             downloadButton("exportmodel", "Export Model Files")
      ),
      class = "mainmenurow"
  ), #close fluidRow structure for input

 fluidRow(
    column(6,
           actionButton("buildmodel", "Build a model", class="mainbutton")
    ),
    column(6,
           actionButton("analyzemodel", "Analyze a model", class="mainbutton")
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

