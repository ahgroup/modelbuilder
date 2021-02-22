
#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
  shinyjs::useShinyjs(),  # Set up shinyjs
  # tags$head(includeHTML(("google-analytics.html"))), #this is only needed for Google analytics when deployed as app to the UGA server. Should not affect R package use.
  includeCSS("packagestyle.css"),
  tags$div(id = "shinyheadertitle", "modelbuilder - FFFFFF Graphical building and analysis of simulation models"),
  tags$div(id = "infotext", paste0('This is ', packagename,  'version ',utils::packageVersion(packagename),' last updated ', utils::packageDescription(packagename)$Date,'.')),
  tags$div(id = "infotext", "Written and maintained by", a("Andreas Handel", href="http://handelgroup.uga.edu", target="_blank"), "with many contributions from", a("others.",  href="https://github.com/ahgroup/modelbuilder#contributors", target="_blank")),
  p('Have fun building and analyzing models!', class='maintext'),
  navbarPage(title = "modelbuilder", id = 'alltabs', selected = "main",
             tabPanel(title = "Main", value = "main",
                      fluidRow(
                        p('Load or clear a Model', class='mainsectionheader'),
                        column(4,
                               fileInput("loadcustommodel", label = "", buttonLabel = "Load model", placeholder = "No model file selected")
                        ),
                        column(4,
                               selectInput("examplemodel", "Example Models", allexamplemodels , selected = 'none')
                        ),
                        column(4,
                               actionButton("clearmodel", "Clear Model", class="mainbutton")
                        ),
                        class = "mainmenurow"
                      ), #close fluidRow structure for input

                      p('Get the R code for the currently loaded model', class='mainsectionheader'),

                      fluidRow(
                        column(3,
                               downloadButton("exportfile", "Export model generating code", class='downloadbt')
                        ),
                        column(3,
                               downloadButton("exportode", "Export ODE code", class='downloadbt')
                        ),
                        column(3,
                               downloadButton("exportstochastic", "Export stochastic code", class='downloadbt')
                        ),
                        column(3,
                               downloadButton("exportdiscrete", "Export discrete-time code", class='downloadbt')
                        ),
                        #hide for now
                        #column(3,
                        #     downloadButton("exportrxode", "Export RxODE code")
                        #),
                        class = "mainmenurow"
                      ), #close fluidRow structure for input

                      fluidRow(

                        column(12,
                               actionButton("Exit", "Exit", class="exitbutton")
                        ),
                        class = "mainmenurow"
                      ) #close fluidRow structure for input


                      #Hide for now unitl implemented
                      #p('Import or Export SBML models', class='mainsectionheader'),
                      #fluidRow(
                      #   column(6,
                      #         actionButton("importsbml", "Import a SBML model", class="mainbutton")
                      # ),
                      #column(6,
                      #      actionButton("exportsbml", "Export to SMBL model", class="mainbutton")
                      #),
                      #class = "mainmenurow"
                      #) #close fluidRow structure for input
             ), #close "Main" tab

             tabPanel("Build",  value = "build",
                      fluidRow(
                        column(12,
                               uiOutput('buildmodel')
                        ),
                        class = "mainmenurow"
                      )

             ), #close "Build" tab

             tabPanel("Analyze",  value = "analyze",
                      fluidRow(
                        column(12,
                               uiOutput('analyzemodel')
                        ),
                        class = "mainmenurow"
                      ) #close fluidRow structure for input
             ) #close "Analyze" tab
  ), #close NavBarPage
  tagList( hr(),
           p('All text and figures are licensed under a ',
             a("Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.", href="http://creativecommons.org/licenses/by-nc-sa/4.0/", target="_blank"),
             'Software/Code is licensed under ',
             a("GPL-3.", href="https://www.gnu.org/licenses/gpl-3.0.en.html" , target="_blank")
             ,
             br(),
             "The development of this package was partially supported by NIH grant U19AI117891.",
             align = "center", style="font-size:small") #end paragraph
  )
) #end fluidpage
