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

#*** Attach necessary packages (remove after dev)
library(devtools)
library(DiagrammeR)
library(ggplot2)
library(plotly)
library(shiny)
library(shinyjs)
library(shinydashboard)

## Update namespace if functions were added to R folder
devtools::document()
devtools::load_all()

#this function is the server part of the app
server <- function(input, output, session) {

  #to get plot engine be object to always be processed
  output$plotengine <- renderText('ggplot')
  outputOptions(output, "plotengine", suspendWhenHidden = FALSE)

  #might not need those as reactives, but seems to work so leave for now
  values = reactiveValues(nvar = 1, npar = 1, nflow = rep(1, 100))


  ### Instantiate buildUiTrigger
  # WHAT: This object is used to decide whether or not to generate the ui for the build tab.
  #
  # HOW: The object is instantiated with a value of 0. If the user navigates to the build tab, then the
  # value is changed to 1. If a user uploads a model or chooses an example model, then the value is changed
  # to 0. The build tab's ui will only be regenerated if the buildUiTrigger object has a value of 0.
  #
  # WHY: The build ui is generated everytime the user navigates to the build tab (observeEvent with a trigger
  # on input$allTabs == 'build'). The user's changes are lost if he makes changes to the model in the build tab
  # and then navigates away / back from the build tab. The buildUiTrigger keeps track of whether or not the build
  # tab's ui needs to be regennerated.
  #

  values$buildUiTrigger <- 0


  ## Update displayed variable names
  observe({

    # NOTE: This needs to be an lapply instead of a for loop, otherwise last value of i is used in each case
    lapply(as.character(values$masterVarDF$varNumber), function(i) {

      enteredVarName <- input[[paste0("var", i, "name")]]

      # display entered variable name if the variable name is not empty
      if(!is.null(enteredVarName) && gsub(" ", "", enteredVarName) != ""){
        newVarName <- enteredVarName
      } else {
        # if no variable name has been entered, then display a default name of "Variable #"
        newVarName <- paste0("Variable ", i)
      }# end else

      # store new variable name in masterVarDF
      values$masterVarDF[values$masterVarDF$varNumber == i, "varName"] <- newVarName

      # render new variable name
      output[[paste0("var", i, "DisplayName")]] <- renderText({ newVarName })

    })# end lapply

  })# end observe

  #######################################################
  #start code blocks that contain the build functionality
  #######################################################

  #when build tab is selected
  #generate the UI to either build a new model or
  #edit a loaded model
  observeEvent( input$alltabs == 'build', {

    # only regenerate the build ui if the buildUiTrigger object is 0, otherwise changes the user made to the model
    # will be overwritten when the user navigates away / back from the build tab.
    if ( values$buildUiTrigger == 0 )
    {

      #set number of variables/parameters/flows for loaded model (if one is loaded)
      if ( !is.null(mbmodel ) )
      {

        ## Initialize masterVarDF for loaded model
        # This DF will serve as the master list of all available variables.
        # It will be added onto / removed from whenever the user adds/removes variables
        values$masterVarDF <- data.frame()

        values$nvar <- max(1, length(mbmodel$var))
        values$npar <- max(1, length(mbmodel$par))

        ## Initialize currentParButtons for loaded model
        # This list will be the record of all current paramters. Parameters will be added to / removed from
        # this list as they are added to / removed from the model
        values$currentParButtons <- list()

        for (i in 1:length(mbmodel$par))
        {
          values$currentParButtons[length(values$currentParButtons) + 1] <- i
        }


        ## Initialize values$currentFlowButtons for loaded model
        values$currentFlowButtons <- list()

        for (i in 1:length(mbmodel$var))
        {
          values$currentFlowButtons[i] <- i
          names(values$currentFlowButtons)[i] <- as.numeric(i)

          for (j in 1:length(mbmodel$var[[i]]$flows))
          {
            values$currentFlowButtons[[length(values$currentFlowButtons)]][j] <- j
          }

        }

        #generate_buildUI generates the output elements that make up the build UI for the model
        generate_buildUI(mbmodel, output)


        # TODO: the plot is in the wrong format to be rendered using DiagrammeR
        # output$flowdiagram  <- shiny::renderPlot({ generate_flowchart_ggplot(mbmodel) })
        #output$flowdiagram <- DiagrammeR::renderGrViz({
        #  #DiagrammeR::render_graph(generate_flowchart(mbmodel))
        #  generate_flowchart(mbmodel)
        #})


        output$equations <- renderUI(withMathJax(generate_equations(mbmodel)))

        # Go through all variables in the loaded model and add them to the ui
        lapply(1:length(mbmodel$var), function(i) {

          enteredVarName <- mbmodel$var[[i]]$varName

          # display entered variable name if the variable name is not empty
          if(!is.null(enteredVarName) && gsub(" ", "", enteredVarName) != ""){
            newVarName <- enteredVarName
          } else {
            # if no variable name has been entered, then display a default name of "Variable #"
            newVarName <- paste0("Variable ", i)
          }# end else

          # Add variables to masterVarDF from the uploaded model
          values$masterVarDF[nrow(values$masterVarDF) + 1, "varNumber"] <- i
          values$masterVarDF[nrow(values$masterVarDF), "varName"] <- newVarName

          # render new variable name
          output[[paste0("var", i, "DisplayName")]] <- renderText({ newVarName })

          # update current var buttons
          values$currentVarButtons[length(values$currentVarButtons) + 1] <- i
          valuesHold <<- values$currentVarButtons

        })# end lapply

      }
      else
      {

        # Start mastervarDF with a single variable and no name. This dataframe will be updated each time a variable is added/removed/renamed
        values$masterVarDF <- data.frame(varNumber = 1, varName = "")
        values$currentVarButtons <- list(1)

        values$currentParButtons <- list(1)
        #names(values$currentParButtons) <- 1

        generate_buildUI(NULL, output)
        output$flowdiagram  = NULL
        output$equations = NULL

        ## Initialize the list of currentFlowButtons with a value of 1 when building a model from scratch
        values$currentFlowButtons <- list(1)
        names(values$currentFlowButtons) <- 1

      }

      # set buildUiTrigger to 1 after ui has been generated.
      # Note: This object is used to decide whether the ui in the build tab should be generated or left alone
      values$buildUiTrigger <- 1

    }

  }) #end observe for build UI setup

  ### Set defaulted initial parameter and variable to 0 instead of NA
  # WHAT: Setting default parameter and variable to 0. This will only happen when starting to build a
  # model. After this initial parameter and variable are set to 0, none will be able to be NA
  # HOW: Using a updateNumericInput and hardcoded inputIds because this will be the only
  # time a parameter/variable can have a value of NA.
  # WHY: When a model of NULL is passed into generate_buildUI, a the default value for the first
  # parameter and variable is NULL. This is an issue when exporting a model because of check_model.
  # generate_buildUI is used for creating a model from scratch as well as
  # uploading a previous model. Therefore we can't change this in generate_buildUI.
  observe({
    # update initial variable
    if(!is.null(input$var1val) && is.na(input$var1val)){
      updateNumericInput(session, "var1val", value = 0)
    }

    # update initial parameter
    if(!is.null(input$par1val) && is.na(input$par1val)){
      updateNumericInput(session, "par1val", value = 0)
    }
  })# end observe

  # Add a variable (and its corresponding flows/parameters) or show the remove variable confirmation modal
  # each time the clikTime_btn object is changed
  # NOTE: See comment later in code for explanation of clickTime_btn and last_btn
  observeEvent(input$clickTime_btn, {

    # ------------------------------ Variables ------------------------------- #
    # Remove variable
    if(grepl("rmvar_", input$last_btn) & length(values$currentVarButtons) > 1)
    {

      redVar <- gsub("rmvar_", "", input$last_btn)
      values$varInd <- redVar

      #print(redVar)

      showModal(remove_model_variableModal(values$masterVarDF[values$masterVarDF$varNumber == redVar, "varName"]))

      values$removeVariableNumber <- redVar
      values$currentVarButtons

    } # End 'if'

    # Add variable
    if(grepl("addvar_", input$last_btn))
    {

      #*** Adjust flow indicator to be one
      values$flowInd <- 1

      redVar <- as.numeric(as.character(gsub("addvar_", "", input$last_btn)))
      values$varInd <- redVar

      newVarNumber <- as.character(max(as.numeric(values$masterVarDF$varNumber)) + 1)
      newVarVector <- c(varNumber = newVarNumber, varName = "")

      # Add buttons that have been added
      values$currentVarButtons[length(values$currentVarButtons) + 1] <- newVarNumber

      values$currentFlowButtons[length(values$currentFlowButtons) + 1] <- 1
      names(values$currentFlowButtons)[length(values$currentFlowButtons)] <- newVarNumber

      valuesHold <<- values$currentVarButtons

      add_model_var(values, output, input, newVarNumber)

      # add new variable to masterVarDF
      values$masterVarDF <- rbind(values$masterVarDF, newVarVector)

    } # End 'if'

    # ------------------------------ Parameters ------------------------------ #
    #observe({
    #  print(values$currentParButtons)
    #})
    # Remove parameters
    if(grepl("rmpar_", input$last_btn) & length(values$currentParButtons) > 1)
    {
      redPar <- gsub("rmpar_", "", input$last_btn)

      values$parInd <- redPar
      remove_model_par(values, output)

      # Get rid of record of buttons that have been removed
      values$currentParButtons <- values$currentParButtons[which(values$currentParButtons != redPar)]

    } # End 'if'

    # Add parameters
    if(grepl("addpar_", input$last_btn))
    {
      # new parameter will be one more than the current highest parameter to avoid indexing issues
      redPar <- max(as.numeric(as.character(unlist(values$currentParButtons)))) + 1
      values$parInd <- redPar
      values$buttonClicked <- as.numeric(as.character(gsub("addpar_", "", input$last_btn)))

      # Add buttons that have been added
      values$currentParButtons[length(values$currentParButtons) + 1] <- redPar
      valuesHold <<- values$currentParButtons

      add_model_par(values, output)

    } # End 'if'

    # -------------------------------- Flows --------------------------------- #
    # Remove flows
    if(grepl("rmflow_", input$last_btn))
      {
        # Grab variable and flow indicators (first numeric element is always variable, second is flow)
        # from the last button clicked
        redVar <- as.numeric(as.character(strsplit(input$last_btn, "_")[[1]][2]))

        # Only allow flow to be removed if there are more than one flows for the given variable
        if(length(values$currentFlowButtons[names(values$currentFlowButtons) == redVar][[1]]) > 1)
          {
          values$varInd <- redVar

          redFlow <- as.numeric(as.character(strsplit(input$last_btn, "_")[[1]][3]))

          values$flowInd <- redFlow

          remove_model_flow(values, output)

          # Get rid of record of buttons that have been removed
          #*** Note, the below line is so complicated to deal with getting rid of a single sub-list element within a greater list
          values$currentFlowButtons[names(values$currentFlowButtons) == redVar][[1]] <- values$currentFlowButtons[names(values$currentFlowButtons) == redVar][[1]][-which(values$currentFlowButtons[names(values$currentFlowButtons) == redVar][[1]] == redFlow)]

        } # End 'if'
      } # End 'if'

    # Add flows
    if(grepl("addflow_", input$last_btn))
    {
      # Grab variable and flow indicators (first numeric element is always variable, second is flow)
      redVar <- as.numeric(as.character(strsplit(input$last_btn, "_")[[1]][2]))
      values$varInd <- redVar

      values$flowButtonClicked <- as.numeric(as.character(strsplit(input$last_btn, "_")[[1]][3]))
      values$flowInd <- max(values$currentFlowButtons[[as.character(redVar)]]) + 1


      # Add buttons that have been added
      values$currentFlowButtons[[as.character(redVar)]][length(values$currentFlowButtons[[as.character(redVar)]]) + 1] <- values$flowInd

      valuesHold <<- values$currentFlowButtons

      add_model_flow(values, output)

    } # End 'if'

  }) # End clickTime_btn observeEvent

  # Close modal after the user clicks 'cancel'
  observeEvent(input$remove_model_variableCancel, {

    removeModal()

  }) # End remove_model_variableCancel observeEvent


  # Only remove variable after the user confirms it should be deleted in the remove_model_variableModal
  observeEvent(input$remove_model_variableConfirm, {

    # close modal after user clicks 'Yes'
    removeModal()

    redVar <- values$removeVariableNumber

    # Get rid of record of buttons that have been removed
    values$currentVarButtons[values$currentVarButtons == redVar] <- NULL
    values$currentFlowButtons[names(values$currentFlowButtons) == redVar] <- NULL

    valuesHold[valuesHold == redVar]

    # remove variable
    remove_model_var(values, output)

    # remove variable row from masterVarDF
    values$masterVarDF <- values$masterVarDF[which(values$masterVarDF$varNumber != as.character(redVar)),]

  }) # End remove_model_variableConfirm observeEvent

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
        #output$flowdiagram <- DiagrammeR::renderGrViz({
        #  DiagrammeR::render_graph(generate_flowchart(mbmodel))
        #})
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

        # set buildUiTrigger to 0 after a model has been uploaded
        # Note: This object is used to decide whether the ui in the build tab should be generated or left alone
        values$buildUiTrigger <- 0
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

      # set buildUiTrigger to 0 after an example model has been selected
      # Note: This object is used to decide whether the ui in the build tab should be generated or left alone
      values$buildUiTrigger <- 0
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

    # set buildUiTrigger to 0 so that the build tab is wiped after clearing a model
    values$buildUiTrigger <- 0
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


#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
    shinyjs::useShinyjs(),  # Set up shinyjsd
    tags$head(includeHTML(("google-analytics.html"))), #this is only needed for Google analytics when deployed as app to the UGA server. Should not affect R package use.
    includeCSS("packagestyle.css"),

    #***
    # What: Creating input objects (referenced by input$) to keep track of the last button clicked and the datetime of each button click
    # How: Created an html function that assigns the id of the button that was just clicked to 'last_btn' and assigns
    #      the current datetime to 'clickTime_btn'
    # Why: Both of these objects are used to add/remove variables. Because each variable has its own set of add/remove buttons,
    #      we need to know which add/remove button was clicked (stored in last_btn). Then we can put code that adds/removes a variable
    #      inside an observeEvent that gets triggered everytime a button is clicked. The last_btn object is not changed
    #      if the same button is clicked more than once in a row, so last_btn should not be used as the trigger for the observeEvent
    #      around the adding/removing of variables. The clickTime_btn will always be updated upon each button click
    #      (even if you click the same button twice), making it the ideal trigger for the observeEvent mentioned above.

    tags$head(tags$script(HTML("$(document).on('click', '.submitbutton', function () {
                               Shiny.onInputChange('last_btn', this.id);
                               Shiny.onInputChange('clickTime_btn', Date());
                               });"))),

    tags$div(id = "shinyheadertitle", "modelbuilder - Graphical building and analysis of simulation models"),
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

shinyApp(ui = ui, server = server)
