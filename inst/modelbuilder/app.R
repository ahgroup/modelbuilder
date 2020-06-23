#Instructions for deployment of the package to shinyappsio
#to deploy, follow these steps:
#1. set working directory to folder where this file (app.R) resides
#3. install the package through CRAN or github if we want to use the github version
#devtools::install_github('ahgroup/modelbuilder')
#4. uncomment the library() command below
#this line of code needs to be uncommented  for shinyappsio deployment
#should not be present for regular package use
#library('modelbuilder')
#5. deploy by running the following
#run rsconnect::deployApp()

##############################################
#This is the Shiny App for the main menu of the modelbuilder package

packagename = "modelbuilder"

#make this a non-reactive global variable
mbmodel = NULL


#list of all example models that are provided and can be loaded
examplemodeldir = system.file("modelexamples", package = packagename) #find path to apps

allexamplemodels = c("none",list.files(examplemodeldir))


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
      output$flowdiagram  <- shiny::renderPlot({ generate_flowchart_ggplot(mbmodel) })
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
        output$flowdiagram  <- shiny::renderPlot({ generate_flowchart_ggplot(mbmodel) })
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
        mbmodel <- readRDS(input$loadcustommodel$datapath)
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
          shinyjs::enable("exportstochastic")
          shinyjs::enable("exportdiscrete")
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
      shinyjs::enable("exportstochastic")
      shinyjs::enable("exportdiscrete")
    }
  }) #end observeevent



  #######################################################
  #clear a loaded model
  #######################################################
  observeEvent(input$clearmodel, {
    shinyjs::reset(id  = "loadcustommodel")
    shinyjs::disable(id = "exportode")
    shinyjs::disable("exportstochastic")
    shinyjs::disable("exportdiscrete")
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
    shinyjs::disable("exportstochastic")
    shinyjs::disable("exportdiscrete")
  }

  output$exportode <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_ode.R")
    },
    content = function(file) {
      generate_ode(mbmodel = mbmodel, location = file)
    },
    contentType = "text/plain"
  )

  output$exportstochastic <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_stochastic.R")
    },
    content = function(file) {
      generate_stochastic(mbmodel = mbmodel, location = file)
    },
    contentType = "text/plain"
  )

  output$exportdiscrete <- downloadHandler(
    filename = function() {
      paste0("simulate_",gsub(" ","_",mbmodel$title),"_discrete.R")
    },
    content = function(file) {
      generate_discrete(mbmodel = mbmodel, location = file)
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


#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
  shinyjs::useShinyjs(),
  includeCSS("packagestyle.css"),
  tags$div(id = "shinyheadertitle", "modelbuilder - Graphical building and analysis of simulation models"),
  tags$div(id = "infotext", paste0('This is ', packagename,  'version ',utils::packageVersion(packagename),' last updated ', utils::packageDescription(packagename)$Date,'.')),
  tags$div(id = "infotext", "Written and maintained by", a("Andreas Handel", href="http://handelgroup.uga.edu", target="_blank"), "with many contributions from", a("others.",  href="https://github.com/ahgroup/modelbuilder#contributors", target="_blank")),
  p('Have fun building and analyzing models!', class='maintext'),
  navbarPage(title = "modelbuilder", id = 'alltabs', selected = "main",
             tabPanel(title = "Main", value = "main",
                      fluidRow(
                        p('Load or clear a Model', class='mainsectionheader'),
                        column(4,
                               fileInput("loadcustommodel", label = "", accept = ".rds", buttonLabel = "Load model", placeholder = "No model file selected")
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
                        column(4,
                               downloadButton("exportode", "Export ODE code", class='downloadbt')
                        ),
                        column(4,
                               downloadButton("exportstochastic", "Export stochastic code", class='downloadbt')
                        ),
                        column(4,
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

shinyApp(ui = ui, server = server)
