#This is the Shiny App for the main menu of the modelbuilder package

library(magrittr)

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
              fluidRow(
                  actionButton('makemodel', "Generate model", class="savebutton"),
                  align = "center"
              ),
              fluidRow(
                  column(6,
                         downloadButton('savemodel', "Save Model", class="savebutton")
                  ),
                  column(6,
                         downloadButton("savediagram", "Save Diagram", class="savebutton")
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

  #
  #when user presses the 'make model' button
  #this function reads all the inputs and writes them into the model structure
  #and returns the structure
  #NEEDED: Before/while building the model, this routine needs to check all inputs and make sure everything is correct
  #All variables and parameters and flows need to follow naming rules
  #flows may only contain variables, parameters and math symbols
  #any variable or parameter listed in flows needs to be specified as variable or parameter
  dynmodel <- eventReactive(input$makemodel, {
      # Function to get the variable prefixes
      # for individual variables, e.g.,
      # "var1", "var2"
      var_prefixes <- sapply(1:values$nvar,
                             function(x) paste0("var", x)) %>%
          unlist(.)

      var_names <- paste0(var_prefixes, "name")
      var_texts <- paste0(var_prefixes, "text")

      # Function to get the variable flow prefixes
      # for the individual variable and parameter
      # combinations, e.g., "var1f2" "var2f3"
      varflow_prefixes <- sapply(1:values$nvar,
                           function(x) paste0("var", x, "f",
                                              1:values$nflow[x])) %>%
          unlist(.)

      varflow_names <- paste0(varflow_prefixes, "name")
      varflow_texts <- paste0(varflow_prefixes, "text")

      # This block of code checks to make sure all the variable
      # flows that have been initialized are actually filled.
      varflow_problem <- c(sapply(varflow_names,
                            function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(varflow_texts,
                              function(x) ifelse(input[[x]] == "", 1, 0))) %>%
          sum(.) %>%
          is_greater_than(0) %>%
          ifelse(., TRUE, FALSE)

      # This try() statement checks to see if any variable flow
      # names or texts are missing.
      try(if(varflow_problem == TRUE)
          stop("Variable flow name(s) and / or text(s) missing"))

      # name, text, var
      par_prefixes <- sapply(1:values$npar,
                           function(x) paste0("par", x))
      par_names <- paste0(par_prefixes, "name")
      par_text <- paste0(par_prefixes, "text")
      par_var <- paste0(par_prefixes, "var")

      par_problem <- c(sapply(par_names,
                              function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(par_text,
                              function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(par_var,
                              function(x) ifelse(input[[x]] == "", 1, 0))) %>%
          sum(.) %>%
          is_greater_than(0) %>%
          ifelse(., TRUE, FALSE)

      # This try() statement checks to see if any parameter names,
      # text, or variables are missing.
      try(if(par_problem == TRUE)
          stop("Parameter values are missing"))

      ## This block of code below checks three things:
      ## 1. All variable names begin with an upper-case letter
      ## 2. All parameter names begin with a lower-case letter
      ## 3. Variable and parameter names contain only letters and numbers

      # Function that uses sapply() to check all characters
      # in a string to make sure the string contains only
      # numbers and letters. Returns a boolean with
      # TRUE if the string contains only numbers and
      # letters, and FALSE if it contains an element
      # that doesn't fall into those two categories.
      check_string <- function(string) {
          # All the letters of the alphabet, upper-case and
          # lower-case.
          all_letters <- c(letters, toupper(letters))
          # Split the string into each atomic part
          elements <- unlist(strsplit(string, split = ""))
          # For each string part, check to see if it can
          # be converted to numeric, or if it is contained
          # in the vector of all upper-case and lower-case
          # letters
          condition <- sapply(elements,
                              function(x) suppressWarnings(!is.na(as.numeric(x))) |
                                  x %in% all_letters)
          # is_special_character is a boolean that determines
          # whether there are any special characters in string
          is_special_character <- !(FALSE %in% condition)
          return(is_special_character)
      }











      # NOT WORKING
      #we need code that reads all the inputs and checks for errors that need fixing
      #if there are errors, the user needs to be told what is wrong and asked to fix
      #the rest of this function should not execute
      #only if there are no errors should the rest of the code be executed
      #which writes the inputs into the model structure

      #test that no input fields are empty
      #if any is empty, stop and alert user to fill in field

      #test that:
      # Variable names have to start with an upper-case letter and can only contain letters and numbers
      # Parameter names have to start with a lower-case letter and can only contain letters and numbers

      #if a flow does not have a + or - sign in front, assume it's positive and add a + sign
      #make sure that all flows only consist of specified variables, parameters and math symbols ( +,-,*,^,/,() ). Other math notation such as e.g. sin() or cos() is not yet supported.

      #make sure every parameter listed in the flows is specified as a parameter

      #if tests above are ok, save model in a structure

      #structure that holds the model
      dynmodel = list()

      dynmodel$title <- isolate(input$modeltitle)
      dynmodel$author <- isolate(input$modelauthor)
      dynmodel$textription <- isolate(input$modeltextription)
      dynmodel$details = isolate(input$modeldetails)
      dynmodel$date = Sys.Date()
      var = vector("list",values$nvar)
      for (n in 1:values$nvar)
      {
          var[[n]]$varname = isolate(eval(parse(text = paste0("input$var",n,"name") )))
          var[[n]]$vartext = isolate(eval(parse(text = paste0("input$var",n,"text") )))
          var[[n]]$varval = isolate(eval(parse(text = paste0("input$var",n,"val") )))
          allflows = NULL
          allflowtext = NULL
          for (f in 1:values$nflow[n]) #turn all flows and descriptions into vector
          {
              newflow = isolate(eval(parse(text = paste0("input$var", n, 'f' , f,'name'))))
              newflowtext = isolate(eval(parse(text = paste0("input$var", n, 'f' , f,'text'))))
              allflows = c(allflows,newflow)
              allflowtext = c(allflowtext, newflowtext)
          }
          var[[n]]$flows = allflows
          var[[n]]$flownames = allflowtext
      }
      dynmodel$var = var

      par = vector("list",values$npar)
      for (n in 1:values$npar)
      {
          par[[n]]$parname = isolate(eval(parse(text = paste0("input$par",n,"name") )))
          par[[n]]$partext = isolate(eval(parse(text = paste0("input$par",n,"text") )))
          par[[n]]$parval = isolate(eval(parse(text = paste0("input$par",n,"val") )))

      }
      dynmodel$par = par

      time = vector("list",3)
      time[[1]]$timename = "tstart"
      time[[1]]$timetext = "Start time of simulation"
      time[[1]]$timeval = isolate(eval(parse(text = paste0("input$tval") )))

      time[[2]]$timename = "tfinal"
      time[[2]]$timetext = "Final time of simulation"
      time[[2]]$timeval = isolate(eval(parse(text = paste0("input$tfinal") )))

      time[[3]]$timename = "dt"
      time[[3]]$timetext = "Time step"
      time[[3]]$timeval = isolate(eval(parse(text = paste0("input$dt") )))

      dynmodel$time = time

      #add call to functions somewhere here that plot diagram and make equations
      return(dynmodel)
  })

  # make and display equations
  output$equations =  renderUI( withMathJax(generate_equations(dynmodel()) ) )

  # make and display plot
  #output$diagram = renderPlot( replayPlot(generate_diagram(dynmodel())) )

  #store dynmodel() object as reactive value
  #this lets me save it with code below, if i try to use dynmodel() directly in the save function it doesn't work
  #i'm not sure why this version works and why I can't save the model directly
  #https://stackoverflow.com/questions/23036739/downloading-rdata-files-with-shiny
  tmpmodel <- reactiveValues()
  observe({
      if(!is.null(dynmodel()))
          isolate(
              tmpmodel <<- dynmodel()
          )
  })
  #writes model to Rdata file
  output$savemodel <- downloadHandler(
      filename = function() {
          paste0(gsub(" ","_",tmpmodel$title),".Rdata")
      },
      content = function(file) {
          stopifnot(!is.null(tmpmodel))
          save(tmpmodel, file = file)
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
      result <- analyze_model(modeltype = input$modeltype,
                    rngseed = input$rngseed, nreps = input$nreps,
                    plotscale = input$plotscale, input = input, model = model() )
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
    #end code blocks that contain the analyze functionality
    #######################################################




    #######################################################
    #start code blocks that contain the load/import/export functionality
    #######################################################


  #currently only used to get into a browser environment
  observeEvent(input$importsbml, {
        browser()
        })

  model <- reactive({
    stopping <<- TRUE
    inFile <- input$currentmodel
    if (is.null(inFile)) return(NULL)
    # loadRData() below was suggesed on Stack Overflow 8/22/14 by user ricardo.
    # The code was provided for general use in answer to another user's question
    # about loading data into R. The original source for the code can be found
    # here: https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file
    loadRData <- function(filename) {
      load(filename)
      get(ls()[ls() != "filename"])
    }
    d <- loadRData(inFile$datapath)
    #write code somewhere here that checks that the loaded file is a proper modelbuilder model.
    #needs to have a non-empty model$title
    #needs to have a sub-list called var with non-empty fields
    #most of those checks need to also happen inside the build routine, maybe write a function that can be used
    #in both places
  })

  output$exportode <- downloadHandler(
      filename = function() {
        paste0("simulate_",gsub(" ","_",model()$title),"_ode.R")
    },
    content = function(file) {
      generate_ode(model = model(), location = file)
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

  observeEvent(input$Exit, {
      stopping <<- TRUE
      stopApp('Exit')
  })

  session$onSessionEnded(function() {
      if (!stopping) {
          stopApp('Exit')
      }
  })


} #ends the server function for the app


#This is the UI for the Main Menu of modelbuilder
ui <- fluidPage(
  includeCSS("../media/modelbuilder.css"),
  #add header and title
  div( includeHTML("../media/header.html"), align = "center"),
  p(paste('This is modelbuilder version ',utils::packageVersion("modelbuilder"),' last updated ', utils::packageDescription('modelbuilder')$Date,sep=''), class='infotext'),

  navbarPage("modelbuilder",
              tabPanel("Main",
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
                       ) #close fluidRow structure for input
               ), #close "Main" tab
              tabPanel("Build",
                       fluidRow(
                           column(12,
                                  #actionButton("buildmodel", "Build a new model", class="mainbutton")
                                  uiOutput('buildmodel')
                           ),
                           class = "mainmenurow"
                       )

               ), #close "Build" tab
              tabPanel("Analyze",
                       fluidRow(
                           column(12,
                                  #actionButton("analyzemodel", "Analyze current model", class = "mainbutton")
                                  uiOutput('analyzemodel')
                           ),
                           class = "mainmenurow"
                       ) #close fluidRow structure for input
              ) #close "Analyze" tab
  ),

  p('Have fun building and analyzing models!', class='maintext'),
  div(includeHTML("../media/footer.html"), align="center", style="font-size:small") #footer
) #end fluidpage

shinyApp(ui = ui, server = server)
