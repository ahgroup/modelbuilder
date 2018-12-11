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

  values = reactiveValues()

    #when build tab is selected
    #generate the UI to either build a new model or
    #edit a loaded model
    observeEvent( input$alltabs == 'build', {

      dynmbmodel() ## This line makes sure the observe() statement updates with each new model

      #keep track of number of variables/parameters/flows for model
      #this is updated based on user pressing add/delete variables/parameters
      #this is re-initialized if the underlying model changes
      values$nvar <- 1
      values$npar <- 1
      values$nflow <- rep(1,100) #number of flows for each variable, currently assuming model does not have more than 100 vars

      #set number of variables/parameters/flows for loaded model (if one is loaded)
      values$nvar <- max(1,length(dynmbmodel()$var))
      values$npar <- max(1,length(dynmbmodel()$par))
      for (n in 1:length(dynmbmodel()$var)) #set number of flows for each variable
      {
        values$nflow[n] = max(1,length(dynmbmodel()$var[[n]]$flows))
      }
      #generate_buildUI generates the output elements that make up the build UI for the model
      generate_buildUI(dynmbmodel(), output)
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
  observeEvent(input$makemodel, {
                             mbmodel <- generate_model(input, values)
                             #errors <- check_model(model)
                             # make and display equations
                             output$equations =  renderUI( withMathJax(generate_equations(mbmodel) ) )
                             # make and display plot
                             #output$diagram = renderPlot( replayPlot(generate_diagram(mbmodel())) )
                             #THIS DOES NOT WORK, dynmbmodel does not get updated as it should
                             dynmbmodel <- mbmodel
                            })


  #the next few lines of code are needed so the model save functionality below work
  #if i try to use dynmbmodel() directly inside the downloadHandler function it doesn't work
  #i'm not sure why this version works and why I can't save the model directly
  #especially since the equivalent code for exporting the functions below works
  #https://stackoverflow.com/questions/23036739/downloading-rdata-files-with-shiny
=======
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

      # This block of code checks to make sure all the
      # variables that have been initialized are actually
      # filled.
      var_problem <- c(sapply(var_names,
                              function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(var_texts,
                              function(x) ifelse(input[[x]] == "", 1, 0))) %>%
          sum(.) %>%
          is_greater_than(0) %>%
          ifelse(., TRUE, FALSE)

      try(if(var_problem == TRUE)
          stop("Variable names or text missing"))

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
      par_val <- paste0(par_prefixes, "val")

      par_problem <- c(sapply(par_names,
                              function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(par_text,
                              function(x) ifelse(input[[x]] == "", 1, 0)),
                       sapply(par_val,
                              function(x) ifelse(input[[x]] == "", 1, 0))) %>%
          sum(.) %>%
          is_greater_than(0) %>%
          ifelse(., TRUE, FALSE)

      # This try() statement checks to see if any parameter names,
      # text, or variables are missing.
      try(if(par_problem == TRUE)
          stop("Parameter values are missing"))

      # Checks to see whether any variable or parameter names
      # are repeated.

      # Variables
      var_names_content <- sapply(var_names,
                                  function(x) input[[x]])
      var_names_repeat <- ifelse(length(var_names_content) >
                                     length(unique(var_names_content)),
                                 TRUE, FALSE)
      try(if(var_names_repeat == TRUE)
          stop("A variable name has been duplicated"))

      # Parameters
      par_names_content <- sapply(par_names,
                                 function(x) input[[x]])
      par_names_repeat <- ifelse(length(par_names_content) >
                                     length(unique(par_names_content)),
                                 TRUE, FALSE)
      try(if(par_names_repeat == TRUE)
          stop("A parameter name has been duplicated"))

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

      # +,-,*,^,/,()
      check_string <- function(string, add_characters = vector()) {
          # All the letters of the alphabet, upper-case and
          # lower-case
          all_letters <- c(letters, toupper(letters), add_characters)
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

      # This function checks to make sure that the first
      # element of a string is an uppercase letter.
      first_letter_uppercase <- function(x) {
          # All the letters of the alphabet, upper-case and
          # lower-case
          all_letters <- c(letters, toupper(letters))
          # All letters of the alphabet, upper case and lower case
          first_element <- unlist(strsplit(x, split = ""))[1]
          condition <- ifelse(first_element %in% all_letters,
                              ifelse(toupper(first_element) == first_element,
                                     TRUE, FALSE), FALSE)
          return(condition)
      }

      # Check to see that variable names meet proper criteria, namely:
      # 1. Starts with an upper-case letter
      # 2. Contains only letters and numbers

      okay_var_names <- sapply(var_names,
                               function(x) (first_letter_uppercase(input[[x]]) &
                                                check_string(input[[x]])))

      try(if(FALSE %in% okay_var_names)
          stop("Make sure variable name starts with upper case letter and contains only letters and numbers"))

      # Check to see that parameter names meet proper criteria, namely:
      # 1. Starts with a lower-case letter
      # 2. Contains only letters and numbers

      okay_par_names <- sapply(par_names,
                               function(x) (!first_letter_uppercase(input[[x]]) &
                                                check_string(input[[x]])))

      try(if(FALSE %in% okay_par_names)
          stop("Make sure parameter name starts with lower case letter and contains only letters and numbers"))

      # Check to see that the parameter flows meet proper criteria, namely:
      # 1. They contain only numbers, letters, and mathematical symbols
      #    (+,-,*,^,/,()).
      # 2. They begin with a "+" or "-".
      # 3. They only contain parameters that have been defined.

      # Condition 1
      math_symbols <- c("+", "-", "*", "^", "/", "(", ")", " ")
      okay_varflow_names <- sapply(varflow_names,
                                   function(x) check_string(input[[x]],
                                                            math_symbols))
      try(if(FALSE %in% okay_varflow_names)
          stop("Make sure flows contain only letters, numbers, and mathematical symbols"))

      # Condition 2 - confused about what needs to be done here

      # Function to make sure flow begins with a "+" or "-"
      check_flow <- function(x) {
          first_element <- unlist(strsplit(input[[x]], split = ""))[1]
          input[[x]] <- ifelse((first_element == "+" | first_element == "-"),
                      input[[x]], paste0("+", input[[x]]))
          return(input[[x]])
      }

      # Condition 3
      # To check to make sure that only parameters already defined
      # are found in the flow, we first extract the letters, which
      # represent the parameters. Then we see if those letters
      # are found in the defined parameter names.

      check_params <- function(x) {
          # x is a variable flow equation
          split_x <- strsplit(x, split = "") %>%
              unlist(.)
          # All the letters of the alphabet, upper-case and
          # lower-case
          all_letters <- c(letters, toupper(letters))
          defined_variables <- sapply(var_names,
                                      function(x) input[[x]])
          defined_parameters <- sapply(par_names,
                                       function(x) input[[x]])
          # First we remove any letters in x which
          # correspond to variables.
          which_variables <- split_x %in% defined_variables
          potential_params <- split_x[!which_variables] %>%
              is_in(all_letters)
          params_in_flow <- unname((split_x[!which_variables])[potential_params])

          # Now check each parameter in the flow
          # to see if it's one of the defined
          # parameters.
          sapply(params_in_flow,
                 function(x) x %in% defined_parameters) %>%
              return(.)
      }

      # Use check_params to make sure only defined parameters are
      # used in the flows
      defined_params_in_flows <- sapply(varflow_names,
                                        function(x) check_params(input[[x]]))
      try(if(FALSE %in% defined_params_in_flows)
          stop("One or more parameters in flows are undefined"))

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

    dynmbmodel() ## This line makes sure the observe() statement updates with each new model

    #if no model has been loaded yet, display a message
    if (is.null(dynmbmodel()$title))
    {
      output$analyzemodel <- renderUI({h1('Please load a model')})
      return()
    }


    #produce Shiny input UI elements for the model.
    generate_shinyinput(dynmbmodel(), otherinputs = NULL, output)
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
    dynmbmodel <- reactive({load_model(input$currentmodel)})
    #check that the loaded file is a proper modelbuilder model.
    #NOT WORKING
    #errors <- check_model(dynmbmodel())
    #clear a loaded model by loading 'nothing'
    # NOT WORKING
    #######################################################
    observeEvent(input$clearmodel, {
      dynmbmodel <- reactive({load_model(NULL)})
    })

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
      if (!is.null(dynmbmodel()$title))
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
