#This is the Shiny App for the main menu of the modelbuilder package

#this function is the server part of the app
server <- function(input, output, session) {

  #######################################################
  #start code blocks that contain the build functionality
  #######################################################


    #define number of variables and parameters for model globally, is updated based on user pressing add/delete variables/parameters
    values = reactiveValues()
    values$nvar <- 1
    values$npar <- 1
    values$nflow <- rep(1,50) #number of flows for each variable, currently assuming model does not have more than 50 vars

  observe({
      output$buildmodel <- renderUI({
          fluidPage(
              p('General model information', class='mainsectionheader'),
              fluidRow(
                  column(4,
                         textInput("modeltitle", "Model Name")
                  ),
                  column(4,
                         textInput("modelauthor", "Author")
                  ),
                  column(4,
                         textInput("modeldescription", "One sentence model description")
                  ),
                  align = "center"
              ),
              fluidRow(
                  textAreaInput("modeldetails", "Long model description"),
                  align = "center"
              ),
              p('Model time information', class='mainsectionheader'),
              fluidRow(
                  column(4,
                         numericInput("tval", "Start time", value = 0)
                  ),
                  column(4,
                         numericInput("tfinal", "Final time", value = 100)
                  ),
                  column(4,
                         numericInput("dt", "Time step", value = 0.1)
                  )
              ),


              tags$p('All variables need to start with an uppercase letter, all parameters need to start with a lowercase letter. Only letters and numbers are allowed. Flows need to include variables, parameters and the following mathematical symbols: +,-,*,/,^,()'),
              #fluidRow(
              fluidRow(
                  column(6,
                         actionButton('makemodel', "Generate model", class="savebutton")
                  ),
                  column(6,
                         downloadButton('savemodel', "Save Model", class="savebutton")
                         #downloadButton("savediagram", "Save Diagram", class="savebutton")
                  ),
                  align = "center"
              ),
              tags$br(),
              fluidRow(
                  column(4,
                         actionButton("addvar", "Add variable", class="submitbutton")
                  ),
                  column(4,
                         actionButton("addpar", "Add parameter", class="submitbutton")
                  ),
                  column(4,
                         actionButton("addflow", "Add flow to variable", class="submitbutton")
                  ),
                  align = "center"
              ),
              fluidRow(
                  column(4,
                         actionButton("rmvar", "Remove last Variable", class="submitbutton")
                  ),
                  column(4,
                         actionButton("rmpar", "Remove last Parameter", class="submitbutton")
                  ),
                  column(4,
                         actionButton("rmflow", "Remove flow of variable", class="submitbutton"),
                         numericInput("targetvar", "Selected variable", value = 1)
                  ),
                  align = "center"
              ),
              fluidRow( class = 'myrow', #splits screen into 2 for input/output
                        column(6,
                               p('Model variable information', class='mainsectionheader'),
                               ## wrap element in a div with id
                               tags$div(
                                   h3(paste("Variable 1")),

                                   fluidRow( class = 'myrow',
                                             column(2,
                                                    textInput("var1name", "Variable name")
                                             ),
                                             column(3,
                                                    textInput("var1text", "Variable description")
                                             ),
                                             column(2,
                                                    numericInput("var1val", "Starting value", value = 0)
                                             )
                                   ),
                                   tags$div(
                                       fluidRow(
                                           column(6,
                                                  textInput("var1f1name", "Flow")
                                           ),
                                           column(6,
                                                  textInput("var1f1text", "Flow description")
                                           )
                                       ),
                                       id = 'var1flow1slot'), #close flow div
                                   id = 'var1slot'), #close var div
                               p('Model parameter information', class='mainsectionheader'),
                               tags$div(
                                   fluidRow( class = 'myrow',
                                             column(2,
                                                    textInput("par1name", "Parameter name")
                                             ),
                                             column(3,
                                                    textInput("par1text", "Parameter description")
                                             ),
                                             column(2,
                                                    numericInput("par1val", "Default value", value = 0)
                                             )
                                   ),
                                   id = 'par1slot')
                        ) , #end input column
                        #all the outcomes here
                        column(
                            6,

                            #################################
                            h2('Model Diagram'),
                            plotOutput(outputId = "diagram", height = "500px"),
                            # Placeholder for results of type text
                            h2('Model Equations'),
                            uiOutput(outputId = "equations")
                        ) #end column for outcomes
              ) #end split input/output section
          ) #end fluid page for build tab
      }) # End renderUI for build tab
  }, priority = 100) #end observe for build UI construction




  #add a new variable
  observeEvent(input$addvar, {
      values$nvar = values$nvar + 1
      insertUI(
          selector = paste0("#var", values$nvar - 1, 'slot'), #current variable
          where = "afterEnd",
          ## wrap element in a div with id for ease of removal
          ui = tags$div(
              h3(paste("Variable", values$nvar)),
              fluidRow( class = 'myrow',
                        column(2,
                               textInput(paste0("var", values$nvar,'name'), "Variable name")
                        ),
                        column(3,
                               textInput(paste0("var", values$nvar,'text'), "Variable description")
                        ),
                        column(2,
                               numericInput(paste0("var", values$nvar,'val'), "valing value", value = 0)
                        )
              ),
              tags$div(
                  fluidRow(
                      column(6,
                             textInput(paste0("var", values$nvar, 'f1name'), "Flow")
                      ),
                      column(6,
                             textInput(paste0("var", values$nvar, 'f1text'), "Flow description")
                      )
                  ),
                  id = paste0("var", values$nvar, "flow", values$nflow[values$nvar], 'slot')
              ), #close flow tag
              id = paste0("var", values$nvar, 'slot')
          ) #close tags$div
      ) #close insertUI
  }) #close observeevent


  #remove the last variable
  observeEvent(input$rmvar, {
      if (values$nvar == 1) return() #don't remove the last variable
      removeUI(
          selector = paste0("#var", values$nvar, 'slot'),
          immediate = TRUE
      )
      values$nvar = values$nvar - 1
  })


  #add a new flow
  observeEvent(input$addflow, {
      values$nflow[input$targetvar] = values$nflow[input$targetvar] + 1
      #browser()
      insertUI(
          selector = paste0("#var", input$targetvar, "flow", values$nflow[input$targetvar]-1, 'slot'), #current variable
          where = "afterEnd",
          ## wrap element in a div with id for ease of removal
          ui =
              tags$div(
                  fluidRow(
                      column(6,
                             textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'name'), "Flow")
                      ),
                      column(6,
                             textInput(paste0("var", input$targetvar, 'f' , values$nflow[input$targetvar],'text'), "Flow description")
                      )
                  ),
                  id = paste0("var", input$targetvar, "flow", values$nflow[input$targetvar], 'slot')
              ) #close flow tag
      ) #close insertUI
  }) #close observeevent


  #remove flow from specified variable
  observeEvent(input$rmflow, {
      if (values$nflow[input$targetvar] == 1) return() #don't remove the last flow
      removeUI(
          selector = paste0("#var", input$targetvar, "flow", values$nflow[input$targetvar], 'slot'),
          immediate = TRUE
      )
      values$nflow[input$targetvar] = values$nflow[input$targetvar] - 1
  })


  #add a new parameter
  observeEvent(input$addpar, {
      values$npar = values$npar + 1
      insertUI(
          selector = paste0("#par", values$npar - 1, 'slot'), #current variable
          where = "afterEnd",
          ## wrap element in a div with id for ease of removal
          ui = tags$div(

              fluidRow( class = 'myrow',
                        column(2,
                               textInput(paste0("par", values$npar, 'name'), "Parameter Name")
                        ),
                        column(3,
                               textInput(paste0("par", values$npar,'text'), "Parameter description")
                        ),
                        column(2,
                               numericInput(paste0("par", values$npar,'val'), "Default value", value = 0)
                        )
              ),
              id = paste0("par", values$npar, 'slot')
          ) #close tags$div
      ) #close insertUI
  }) #close observeevent

  #remove the last parameter
  observeEvent(input$rmpar, {
      if (values$npar == 1) return() #don't remove the last variable
      removeUI(
          selector = paste0("#par", values$npar, 'slot'),
          immediate = TRUE
      )
      values$npar = values$npar - 1
  })

  #when user presses the 'make model' button
  #one function reads all the inputs and writes them into the model structure
  #and returns the structure
  #the other function checks the created model object for errors
  dynmodel <- eventReactive(input$makemodel,
                            {
                             model <- generate_model(input, values)
                             #errors <- check_model(model)
                            })



  # make and display equations
  output$equations =  renderUI( withMathJax(generate_equations(dynmodel()) ) )

  # make and display plot
  #output$diagram = renderPlot( replayPlot(generate_diagram(dynmodel())) )

  #store dynmodel() object as reactive value
  #this lets me save it with code below, if i try to use dynmodel() directly in the save function it doesn't work
  #i'm not sure why this version works and why I can't save the model directly
  #https://stackoverflow.com/questions/23036739/downloading-rdata-files-with-shiny
  model <- reactiveValues()
  observe({
      if(!is.null(dynmodel()))
          isolate(
            model <<- dynmodel()
          )
  })
  #writes model to Rdata file
  output$savemodel <- downloadHandler(
      filename = function() {
          paste0(gsub(" ","_",model$title),".Rdata")
      },
      content = function(file) {
          stopifnot(!is.null(model))
          save(model, file = file)
      },
      contentType = "text/plain"
  )


  #######################################################
  #end code blocks that contain the build functionality
  #######################################################


  #######################################################
  #start code blocks that contain the analyze functionality
  #######################################################



observe({
    model() ## This line makes sure the observe() statement updates with each new model
    #if no model has been loaded yet, display a message
    if (is.null(model()$title))
    {
      output$analyzemodel <- renderUI({h1('Please load a model')})
      return()
    }

    generate_shinyinput(model(), output) #produce output elements for each variables, parameters, etc. should be reactive and update when a new model is loaded, but doesn't quite work
    output$analyzemodel <- renderUI({
      fluidPage(
          #section to add buttons
          fluidRow(column(
              12,
              actionButton("submitBtn", "Run Simulation", class = "submitbutton")
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
                      uiOutput("other")

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
          ) #end layout with side and main panel
      ) #end fluidpage for analyze tab
    }) # End renderUI for analyze tab
    #make the UI for the model, saves those into the output elements
    }, priority = 100) #end observe for UI construction



  #runs model simulation when 'run simulation' button is pressed
    observeEvent(input$submitBtn, {
      #extract current model settings from UI input element
      modelsettings <- find_modelsettings( input = input, mbmodel = model() )
      #run model with specified settings
      set.seed(modelsettings$rngseed) #set rngseed
      #run simulation, show a 'running simulation' message
      result <- withProgress(message = 'Running Simulation',
                   detail = "This may take a while", value = 0,
                   {
                     analyze_model(modelsettings = modelsettings, mbmodel = model() )
                   })
      #create plot from results
      output$plot  <- renderPlot({
          generate_plots(result)
      }, width = 'auto', height = 'auto')
      #create text from results
      output$text <- renderText({
          generate_text(result)     #create text for display with a non-reactive function
      })
    }) #end observe-event for analyze model submit button


    #######################################################
    #end code that contain the analyze functionality
    #######################################################




    #######################################################
    #start code blocks that contain the load/import/export functionality
    #######################################################

    #would like to have a load_model function that contains the code below
    #not quite working
    #model <- load_model()

    # Code to load a model saved as an Rdata file. Based on
    # https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file#

   dynmbmodel <- reactive({
     stopping <<- TRUE
     inFile <- input$currentmodel
     if (is.null(inFile)) return(NULL)
     loadRData <- function(filename) {
       load(filename)
       get(ls()[ls() != "filename"])
     }
     d <- loadRData(inFile$datapath)
   })

    #code somewhere here that checks that the loaded file is a proper modelbuilder model.
    #errors <- check_model(dynmbmodel() )

  output$exportode <- downloadHandler(
      filename = function() {
        paste0("simulate_",gsub(" ","_",dynmbmodel()$title),"_ode.R")
    },
    content = function(file) {
      generate_ode(model = dynmbmodel(), location = file)
    },
    contentType = "text/plain"
  )

  output$exportstochastic <- downloadHandler(
      filename = function() {
          paste0("simulate_",gsub(" ","_",model()$title),"_stochastic.R")
      },
      content = function(file) {
          generate_stochastic(model = model(), location = file)
      },
      contentType = "text/plain"
  )

  output$exportdiscrete <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",model()$title),"_discrete.R")
    },
    content = function(file) {
      generate_discrete(model = model(), location = file)
    },
    contentType = "text/plain"
  )

  output$exportrxode <- downloadHandler(
      filename = function() {
          paste0("simulate_",gsub(" ","_",model()$title),"_rxode.R")
      },
      content = function(file) {
          generate_rxode(model = model(), location = file)
      },
      contentType = "text/plain"
  )


  # NOT WORKING
  # these lines of code should turn on the export and analyze options off
  # and only if a model has been loaded will they turn on
  # see e.g. https://daattali.com/shiny/shinyjs-basic/
  # also see https://stackoverflow.com/questions/25247852/shiny-app-disable-downloadbutton
  shinyjs::disable("exportode")
  shinyjs::disable("exportstochastic")
  shinyjs::disable("exportdiscrete")
  shinyjs::disable("exportrxode")
  #if a model is loaded turn on the buttons
  observe({
       if (!is.null(model()$title))
       {
           shinyjs::enable(id = "exportode")
           shinyjs::enable("exportstochastic")
           shinyjs::enable("exportdiscrete")
           shinyjs::enable("exportrxode")
       }
   })

  #######################################################
  #end code blocks that contain the load/import/export functionality
  #######################################################

  #######################################################
  #start code blocks for SBML import/export functionality
  #######################################################

  #currently not implemented and disabled in GUI
  observeEvent(input$importsbml, {
  })

  observeEvent(input$exportsbml, {
  })

  #######################################################
  #end code blocks for SBML import/export functionality
  #######################################################

  #######################################################
  #start code that shuts down the app upon Exit button press
  #######################################################

  observeEvent(input$Exit, {
      stopping <<- TRUE
      stopApp('Exit')
  })

  session$onSessionEnded(function() {
      if (!stopping) {
          stopApp('Exit')
      }
  })

  #######################################################
  #end code that shuts down the app upon Exit button press
  #######################################################


} #ends the server function for the app


#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
  includeCSS("../media/modelbuilder.css"),
  #add header and title
  tags$div( includeHTML("../media/header.html"), align = "center"),
  p(paste('This is modelbuilder version ',utils::packageVersion("modelbuilder"),' last updated ', utils::packageDescription('modelbuilder')$Date,sep=''), class='infotext'),
  p('Have fun building and analyzing models!', class='maintext'),

  navbarPage(title = "modelbuilder",
              tabPanel(title = "Main",
                       fluidRow(
                         p('Load a Model', class='mainsectionheader'),
                         column(12,
                                  fileInput("currentmodel", label = "", accept = ".Rdata", buttonLabel = "Load Model", placeholder = "No model selected"),
                                  align = 'center' )
                       ),

                       fluidRow(
                           column(12,
                                  verbatimTextOutput("modeltitle"),
                                  align = 'center'),
                           class = "mainmenurow"
                       ),
                       p('Get the R code for the currently loaded model', class='mainsectionheader'),

                       fluidRow(
                           column(4,
                                  downloadButton("exportode", "Export ODE code")
                           ),
                           column(4,
                                  downloadButton("exportstochastic", "Export stochastic code")
                           ),
                           column(4,
                                  downloadButton("exportdiscrete", "Export discrete-time code")
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
             #browser(),

              tabPanel("Build",
                       fluidRow(
                           column(12,
                                  uiOutput('buildmodel')
                           ),
                           class = "mainmenurow"
                       )

               ), #close "Build" tab

             tabPanel("Analyze",
                       fluidRow(
                           column(12,
                                  uiOutput('analyzemodel')
                           ),
                           class = "mainmenurow"
                       ) #close fluidRow structure for input
              ) #close "Analyze" tab
  ),

  div(includeHTML("../media/footer.html"), align="center", style="font-size:small") #footer
) #end fluidpage

shinyApp(ui = ui, server = server)
