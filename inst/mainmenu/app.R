#This is the Shiny App for the main menu

#this function is the server part of the app
server <- function(input, output, session) {

  appNames <- c('buildmodels','analyzemodels','Exit') #options

  stopping <- FALSE

  lapply(appNames, function(appName) {
    observeEvent(input[[appName]], {
      stopping <<- TRUE
      stopApp(appName)
    })
  })

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
           actionButton("buildmodels", "Build a model", class="mainbutton")
    ),
    column(6,
           actionButton("analyzemodels", "Analyze a model", class="mainbutton")
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

