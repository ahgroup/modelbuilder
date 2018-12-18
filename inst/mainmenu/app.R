#This is the Shiny App for the main menu of the modelbuilder package

#this function is the server part of the app
server <- function(input, output, session) {


  #test code to supply additional inputs
#  testinput <- tagList(
#    numericInput("testnreps", "Test Number of simulations", min = 1, max = 50, value = 1, step = 1),
#    selectInput("testmodeltype", "Test Model to run",c("ODE" = "ode", 'discrete time' = 'discrete'), selected = 'ode')  ) #end taglist


  #######################################################
  #######################################################
  #start code blocks that contain the build functionality
  #######################################################
  #######################################################

  values = reactiveValues(dynmbmodel = NULL)

    #when build tab is selected
    #generate the UI to either build a new model or
    #edit a loaded model
    observeEvent( input$alltabs == 'build', {

      # dynmbmodel() ## This line makes sure the observe() statement updates with each new model
      #keep track of number of variables/parameters/flows for model
      #this is updated based on user pressing add/delete variables/parameters
      #this is re-initialized if the underlying model changes
      values$nvar <- 1
      values$npar <- 1
      values$nflow <- rep(1, 100) #number of flows for each variable, currently assuming model does not have more than 100 vars

      #set number of variables/parameters/flows for loaded model (if one is loaded)
      if (exists("dynmbmodel()")) {
          values$nvar <- max(1, length(dynmbmodel()$var))
          values$npar <- max(1,length(dynmbmodel()$par))
          for (n in 1:length(dynmbmodel()$var)) #set number of flows for each variable
          {
              values$nflow[n] = max(1, length(dynmbmodel()$var[[n]]$flows))
          }
          #generate_buildUI generates the output elements that make up the build UI for the model
          generate_buildUI(dynmbmodel(), output)
      } else if (!exists("dynmbmodel()")) {
          null_model <- reactive({load_model(NULL)})
          generate_buildUI(null_model(), output)
      }
    }) #end observe for build UI construction


  #add a new variable
  observeEvent(input$addvar, {
      values$nvar = values$nvar + 1 #increment counter to newly added variable
      add_model_var(values, output)
  }) #close observeevent

  #remove the last variable
  observeEvent(input$rmvar, {
      if (values$nvar == 1) return() #don't remove the last variable
      remove_model_var(values, output)
      values$nvar = values$nvar - 1 #reduce counter for number of variables - needs to happen last
  })

  #add a new flow
  #the change to the values variable can't be moved into the function, otherwise it doesn't get assigned properly
  observeEvent(input$addflow, {
    if (input$targetvar > values$nvar) return() #if user tries to add flows to non-existing variables, ignore
    values$nflow[input$targetvar] = values$nflow[input$targetvar] + 1 #increase counter for number of flows for specified
    add_model_flow(values, input, output)
  }) #close observeevent


  #remove flow from specified variable
  observeEvent(input$rmflow, {
    if (input$targetvar > values$nvar) return() #if user tries to remove flows from non-existing variables, ignore
    if (values$nflow[input$targetvar] == 1) return() #don't remove the last flow
      remove_model_flow(values, input, output)
      values$nflow[input$targetvar] = values$nflow[input$targetvar] - 1
  }) #close observeevent


  #add a new parameter
  observeEvent(input$addpar, {
    values$npar = values$npar + 1 #increment counter to newly added parameter. needs to happen 1st.
    add_model_par(values, output)
  }) #close observeevent

  #remove the last parameter
  observeEvent(input$rmpar, {
      if (values$npar == 1) return() #don't remove the last variable
      remove_model_par(values, output)
      values$npar = values$npar - 1 #decrease parameter counter
  })

  #when user presses the 'make model' button
  #one function reads all the UI inputs and writes them into the model structure
  #and returns the structure
  #another function checks the created model object for errors
  #if errors are present, user will be informed and function stops
  #if no errors, equations and diagram will be displayed
  #and the new model will replace the current model stored in dynmbmodel
  #one could use eventReactive here and assign the new model
  #to the dynmbmodel variable. The problem with this is that eventReactive
  #is not triggered when the event changes, only invalidated and triggered later
  #

  # observeEvent(input$makemodel, {
  #                            mbmodel <- generate_model(input, values)
  #                            #errors <- check_model(model)
  #                            # make and display equations
  #                            output$equations =  renderUI( withMathJax(generate_equations(mbmodel) ) )
  #                            # make and display plot
  #                            #output$diagram = renderPlot( replayPlot(generate_diagram(mbmodel())) )
  #                            #THIS DOES NOT WORK, dynmbmodel does not get updated as it should
  #                            dynmbmodel <- mbmodel
  #                            makeReactiveBinding("dynmbmodel")
  #                            print(dynmbmodel()$title) ### Debugging line
  #                            print(paste0("Analyze:", exists("dynmbmodel()"))) ### Debugging line
  #                           })

  # dynmbmodel <- observeEvent(input$makemodel, {
  #     mbmodel <- generate_model(input, values)
  #     output$equations <- renderUI(withMathJax(generate_equations(mbmodel)))
  #     return(mbmodel)
  # })

  observeEvent(input$makemodel, {
      dynmbmodel <<- reactive({
          mbmodel <- generate_model(input, values)
          output$equations <- renderUI(withMathJax(generate_equations(mbmodel)))
          return(mbmodel)
      })
      makeReactiveBinding("dynmbmodel()")
  })


  #the next few lines of code are needed so the model save functionality below work
  #if i try to use dynmbmodel() directly inside the downloadHandler function it doesn't work
  #i'm not sure why this version works and why I can't save the model directly
  #especially since the equivalent code for exporting the functions below works
  #https://stackoverflow.com/questions/23036739/downloading-rdata-files-with-shiny

   # observe({
   #     if(!is.null(dynmbmodel()))
   #         isolate(
   #           tmpmodel <<- dynmbmodel()
   #         )
   # })

  # # writes model to Rdata file
  # output$savemodel <- downloadHandler(
  #     filename = function() {
  #         paste0(gsub(" ","_",tmpmodel$title),".Rdata")
  #     },
  #     content = function(file) {
  #         stopifnot(!is.null(tmpmodel))
  #         save(mbmodel = tmpmodel, file = file)
  #     },
  #     contentType = "text/plain"
  # )



  #######################################################
  #######################################################
  #end code blocks that contain the build functionality
  #######################################################
  #######################################################


  #######################################################
  #######################################################
  #start code blocks that contain the analyze functionality
  #######################################################
  #######################################################
  observeEvent( input$alltabs == 'analyze', {

    # dynmbmodel() ## This line makes sure the observe() statement updates with each new model

    #if no model has been loaded yet, display a message
    if (!exists("dynmbmodel()"))
    {
      output$analyzemodel <- renderUI({h1('Please load a model')})
      return()
    }


    #produce Shiny input UI elements for the model.
    if (exists("dynmbmodel()"))
    {
        print(dynmbmodel()$title) ### Debugging line
        generate_shinyinput(dynmbmodel(), otherinputs = NULL, output)
    }
    #set output to empty
    output$text = NULL
    output$plot = NULL

    output$modelinput <- renderUI({
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
                      uiOutput("standard")
                      #uiOutput("other")
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
  }, priority = 100) #end observeEvent for the analyze tab


  #runs model simulation when 'run simulation' button is pressed
    observeEvent(input$submitBtn, {
      #extract current model settings from UI input element
      modelsettings <- find_modelsettings( input = input, mbmodel = dynmbmodel() )
      #run model with specified settings
      set.seed(modelsettings$rngseed) #set rngseed
      #run simulation, show a 'running simulation' message
      result <- withProgress(message = 'Running Simulation',
                   detail = "This may take a while", value = 0,
                   {
                     analyze_model(modelsettings = modelsettings, mbmodel = dynmbmodel() )
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
    #######################################################
    #end code that contain the analyze functionality
    #######################################################
    #######################################################


    #######################################################
    #######################################################
    #end code that contains the main tab functionality
    #######################################################
    #######################################################


    #######################################################
    #start code blocks that contain the load/check/clear functionality
    #######################################################
    #load a model

    dynmbmodel <- reactive({load_model(input$currentmodel)}) # Original
    # dynmbmodel <- reactive({load_model(NULL)})

    # observeEvent(input$currentmodel, {
    #     dynmbmodel <- reactive({load_model(input$currentmodel)})
    # })

    #check that the loaded file is a proper modelbuilder model.
    #NOT WORKING
    #errors <- check_model(dynmbmodel())
    #clear a loaded model by loading 'nothing'
    # NOT WORKING
    #######################################################

    # observeEvent(input$clearmodel, {
    #   dynmbmodel <- reactive({load_model(NULL)})
    # })

    #######################################################
    #start code blocks that contain the import/export functionality
    #######################################################

    # these lines of code turn the export options off
    # and only if a model has been loaded will they turn on
    shinyjs::disable(id = "exportode")
    shinyjs::disable("exportstochastic")
    shinyjs::disable("exportdiscrete")
    #shinyjs::disable("exportrxode")
    #if a model is loaded turn on the buttons
    observe({
      # if (!is.null(dynmbmodel()$title))
      if (exists("dynmbmodel()"))
      {
        shinyjs::enable(id = "exportode")
        shinyjs::enable("exportstochastic")
        shinyjs::enable("exportdiscrete")
        # shinyjs::enable("exportrxode")
      }
    })

  output$exportode <- downloadHandler(
      filename = function() {
        paste0("simulate_",gsub(" ","_",dynmbmodel()$title),"_ode.R")
    },
    content = function(file) {
      generate_ode(mbmodel = dynmbmodel(), location = file)
    },
    contentType = "text/plain"
  )

  output$exportstochastic <- downloadHandler(
      filename = function() {
          paste0("simulate_",gsub(" ","_",dynmbmodel()$title),"_stochastic.R")
      },
      content = function(file) {
          generate_stochastic(mbmodel = dynmbmodel(), location = file)
      },
      contentType = "text/plain"
  )

  output$exportdiscrete <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",dynmbmodel()$title),"_discrete.R")
    },
    content = function(file) {
      generate_discrete(mbmodel = dynmbmodel(), location = file)
    },
    contentType = "text/plain"
  )

  # output$exportrxode <- downloadHandler(
  #     filename = function() {
  #         paste0("simulate_",gsub(" ","_",dynmbmodel()$title),"_rxode.R")
  #     },
  #     content = function(file) {
  #         generate_rxode(mbmodel = dynmbmodel(), location = file)
  #     },
  #     contentType = "text/plain"
  # )

  #######################################################
  #end code blocks that contain the import/export functionality
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
  stopping <<- TRUE

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
  #######################################################
  #end code that contains the main tab functionality
  #######################################################
  #######################################################

} #ends the server function for the app


#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
    shinyjs::useShinyjs(),
    includeCSS("../media/modelbuilder.css"),
  #add header and title
  tags$div( includeHTML("../media/header.html"), align = "center"),
  p(paste('This is modelbuilder version ',utils::packageVersion("modelbuilder"),' last updated ', utils::packageDescription('modelbuilder')$Date,sep=''), class='infotext'),
  p('Have fun building and analyzing models!', class='maintext'),

  navbarPage(title = "modelbuilder", id = 'alltabs', selected = "main",
              tabPanel(title = "Main", value = "main",
                       fluidRow(
                         p('Load or clear a Model', class='mainsectionheader'),
                         column(12,
                                  fileInput("currentmodel", label = "", accept = ".Rdata", buttonLabel = "Load Model", placeholder = "No model selected"),
                                  align = 'center' )
                       ),
                       fluidRow(
                         column(12,
                                actionButton("clearmodel", "Clear Model", class="mainbutton")
                         ),
                         class = "mainmenurow"
                       ), #close fluidRow structure for input

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

  div(includeHTML("../media/footer.html"), align="center", style="font-size:small") #footer
) #end fluidpage

shinyApp(ui = ui, server = server)
