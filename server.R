#this function is the server part of the app
server <- function(input, output, session) {

  #to get plot engine be object to always be processed
  output$plotengine <- renderText('ggplot')
  outputOptions(output, "plotengine", suspendWhenHidden = FALSE)

  #might not need those as reactives, but seems to work so leave for now
  values = reactiveValues(nvar = 1, npar = 1, nflow = rep(1, 100))


  #######################################################
  #start code blocks that contain the build functionality
  #######################################################

  #when build tab is selected
  #generate the UI to either build a new model or
  #edit a loaded model
  observeEvent( input$alltabs == 'build', {
    #set number of variables/parameters/flows for loaded model (if one is loaded)
    if ( !is.null(mbmodel ) )
    {
      values$nvar <- max(1, length(mbmodel$var))
      values$npar <- max(1, length(mbmodel$par))
      for (n in 1:length(mbmodel$var)) #set number of flows for each variable
      {
        values$nflow[n] = max(1, length(mbmodel$var[[n]]$flows))
      }
      #generate_buildUI generates the output elements that make up the build UI for the model
      generate_buildUI(mbmodel, output)
      # output$flowdiagram  <- shiny::renderPlot({ generate_flowchart_ggplot(mbmodel) })
      output$flowdiagram <- DiagrammeR::renderGrViz({
        DiagrammeR::render_graph(generate_flowchart(mbmodel))
      })
      output$equations <- renderUI(withMathJax(generate_equations(mbmodel)))

    }
    else
    {
      generate_buildUI(NULL, output)
      output$flowdiagram  = NULL
      output$equations = NULL
    }
  }) #end observe for build UI setup


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
  #and the new model will replace the current model stored in mbmodel

  observeEvent(input$makemodel, {
    #create model, save in temporary structure
    mbmodeltmp <- generate_model(input, values)
    #check if the model is a correct mbmodel structure with all required content provided
    mbmodelerrors = check_model(mbmodeltmp)
    if (is.null(mbmodelerrors)) #if no error message, create the model
    {
      mbmodel <<- mbmodeltmp
      output$equations <- renderUI(withMathJax(generate_equations(mbmodel)))
      # output$flowdiagram  <- shiny::renderPlot({ generate_flowchart_ggplot(mbmodel) })
      output$flowdiagram <- DiagrammeR::renderGrViz({
        DiagrammeR::render_graph(generate_flowchart(mbmodel))
      })
      shinyjs::enable(id = "exportode")
      shinyjs::enable("exportstochastic")
      shinyjs::enable("exportdiscrete")
      showModal(modalDialog(
        "The model has been created, you should save it now",
        downloadButton('savemodel', "Save Model"),
        easyClose = FALSE
      ))
    }
    else
    {
      showModal(modalDialog(
        mbmodelerrors,
        easyClose = FALSE
      ))
    }
  })

  # writes model to file
  output$savemodel <- downloadHandler(
    filename = function() {
      paste0(gsub(" ","_",mbmodel$title),".rds")
    },
    content = function(file) {
      stopifnot(!is.null(mbmodel))
      saveRDS(mbmodel, file = file)
    },
    contentType = "text/plain"
  )



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

    #if no model has been loaded yet, display a message
    if (is.null(mbmodel ))
    {
      output$analyzemodel <- renderUI({h1('Please load a model')})
      return()
    }
    else
    {
      #extract function and other inputs and turn them into a taglist
      modelinputs <- generate_shinyinput(use_mbmodel = TRUE, mbmodel = mbmodel, use_doc = FALSE, model_file = NULL,
                                         model_function = NULL, otherinputs = NULL, packagename = packagename)
      output$modelinputs <- renderUI({modelinputs})
    }
    #set output to empty
    output$text = NULL
    output$plot = NULL


    #display all extracted inputs on the analyze tab
    output$analyzemodel <- renderUI({
      tagList(
        tags$div(id = "shinyapptitle", mbmodel$title),
        tags$hr(),
        #Split screen with input on left, output on right
        fluidRow(
          column(6,
                 h2('Simulation Settings'),
                 wellPanel(uiOutput("modelinputs"))
          ), #end sidebar column for inputs
          column(6,
                 h2('Simulation Results'),
                 conditionalPanel("output.plotengine == 'ggplot'", shiny::plotOutput(outputId = "ggplot") ),
                 conditionalPanel("output.plotengine == 'plotly'", plotly::plotlyOutput(outputId = "plotly") ),
                 htmlOutput(outputId = "text")
          ) #end column with outcomes
        ) #end fluidrow containing input and output
        #Instructions section at bottom as tabs
        #h2('Instructions'),
        #use external function to generate all tabs with instruction content
        #withMathJax(do.call(tabsetPanel, generate_documentation(currentdocfilename)))
      ) #end tag list
    }) # End renderUI for analyze tab
  }) # End observeEvent for click on analyze tab

  ###############
  #Code to reset the model settings
  ###############
  observeEvent(input$reset, {
    modelinputs <- generate_shinyinput(use_mbmodel = TRUE, mbmodel = mbmodel, use_doc = FALSE, model_file = NULL,
                                       model_function = NULL, otherinputs = NULL, packagename = packagename)
    output$modelinputs <- renderUI({modelinputs})
    output$plotly <- NULL
    output$ggplot <- NULL
    output$text <- NULL
  })



  #runs model simulation when 'run simulation' button is pressed
  observeEvent(input$submitBtn, {

    #run model with specified settings
    #run simulation, show a 'running simulation' message
    withProgress(message = 'Running Simulation',
                 detail = "This may take a while", value = 0,
                 {
                   #remove previous plots and text
                   output$ggplot <- NULL
                   output$plotly <- NULL
                   output$text <- NULL
                   modelsettings = isolate(reactiveValuesToList(input)) #get all shiny inputs
                   result <- analyze_model(modelsettings = modelsettings, mbmodel = mbmodel )
                   #if things worked, result contains a list structure for processing with the plot and text functions
                   #if things failed, result contains a string with an error message
                   if (is.character(result))
                   {
                     output$text <- renderText({ paste("<font color=\"#FF0000\"><b>", result, "</b></font>") })
                   }
                   else #create plots and text, for plots, do either ggplot or plotly
                   {
                     if (modelsettings$plotengine == 'ggplot')
                     {
                       output$plotengine <- renderText('ggplot')
                       output$ggplot  <- shiny::renderPlot({ generate_ggplot(result) })
                     }
                     if (modelsettings$plotengine == 'plotly')
                     {
                       output$plotengine <- renderText('plotly')
                       output$plotly  <- plotly::renderPlotly({ generate_plotly(result) })
                     }
                     #create text from results
                     output$text <- renderText({ generate_text(result) })
                   }
                 }) #end with-progress wrapper
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
  observeEvent(input$loadcustommodel, {

    fx = tools::file_ext(input$loadcustommodel$datapath)
    #if it's an R file, assume it contains a mbmodel and source it
    if (fx == "R" || fx == "r") #that's currently not working
    {
      source(input$loadcustommodel$datapath)
    }
    #if it's an Rds file, read it
    if (fx == "Rds" || fx == "rds" || fx == "RDS")
    {
      mbmodel <- readRDS(input$loadcustommodel$datapath)
    }


    mbmodelerrors <- check_model(mbmodel) #check if model is a proper mbmodel
    if (!is.null(mbmodelerrors)) #if errors occur, do not load model
    {
      showModal(modalDialog(
        "The file does not contain a valid modelbuilder model and could not be loaded."
      ))
      shinyjs::reset(id  = "loadcustommodel")
      mbmodel <<- NULL
    }
    else #if no errors occur, save model into mbmodel structure
    {
      mbmodel <<- mbmodel
      shinyjs::enable(id = "exportode")
      shinyjs::enable(id = "exportfile")
      shinyjs::enable(id = "exportstochastic")
      shinyjs::enable(id = "exportdiscrete")
      updateSelectInput(session, "examplemodel", selected = 'none')
    }
  })

  #example models are valid
  observeEvent(input$examplemodel, {
    if (input$examplemodel != 'none')
    {
      examplefile = paste0(system.file("modelexamples", package = packagename),'/',input$examplemodel)
      mbmodel <<- readRDS(examplefile) #load model from file
      shinyjs::enable(id = "exportode")
      shinyjs::enable(id = "exportfile")
      shinyjs::enable(id = "exportstochastic")
      shinyjs::enable(id = "exportdiscrete")
    }
  }) #end observeevent



  #######################################################
  #clear a loaded model
  #######################################################
  observeEvent(input$clearmodel, {
    shinyjs::reset(id  = "loadcustommodel")
    shinyjs::disable(id = "exportode")
    shinyjs::disable(id = "exportfile")
    shinyjs::disable(id = "exportstochastic")
    shinyjs::disable(id = "exportdiscrete")
    updateSelectInput(session, "examplemodel", selected = 'none')
    mbmodel <<- NULL
  })

  #######################################################
  #start code blocks that contain the import/export functionality
  #######################################################

  # these lines of code turn the export options off
  # and only if a model has been loaded will they turn on
  if (is.null(mbmodel))
  {
    shinyjs::disable(id = "exportode")
    shinyjs::disable(id = "exportfile")
    shinyjs::disable(id = "exportstochastic")
    shinyjs::disable(id = "exportdiscrete")
  }

  output$exportode <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode.R")
    },
    content = function(file) {
      generate_ode(mbmodel = mbmodel, location = NULL, filename = file)
    },
    contentType = "text/plain"
  )

  output$exportstochastic <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic.R")
    },
    content = function(file) {
      generate_stochastic(mbmodel = mbmodel, location = NULL, filename = file)
    },
    contentType = "text/plain"
  )

  output$exportdiscrete <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete.R")
    },
    content = function(file) {
      generate_discrete(mbmodel = mbmodel, location = NULL, filename = file)
    },
    contentType = "text/plain"
  )

  output$exportfile <- downloadHandler(
    filename = function() {
      paste0(gsub(" ","_",mbmodel$title),"_file.R")
    },
    content = function(file) {
      generate_model_file(mbmodel = mbmodel, location = NULL, filename = file)
    },
    contentType = "text/plain"
  )



  #######################################################
  #end code blocks that contain the import/export functionality
  #######################################################

  #######################################################
  #start code blocks for SBML import/export functionality
  #######################################################

  #currently not implemented and disabled in GUI
  #observeEvent(input$importsbml, {
  #})

  #observeEvent(input$exportsbml, {
  #})

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
