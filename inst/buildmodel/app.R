server <- function(input, output)
{

    # if a model exists, read it and populate UI with its values
    #if (!is.null(model))
    #{

   # }

    # Waits for the Exit Button to be pressed to stop the app and return to main menu
    observeEvent(input$exitBtn, {
        input$exitBtn
        stopApp(returnValue = NULL)
    })

    #writes model to Rdata file
    #not working
    output$savemodel <- downloadHandler(
        filename = function() {
            paste0(gsub(" ","_",model()$title),".Rdata")
        },
        content = function(file) {
            stopifnot(!is.null(model()))
            save(model = model(), file = file)
        },
        contentType = "text/plain"
    )


    #when user presses the 'make model' button
    #this function reads all the inputs and writes them into the model structure
    #and returns the structure
    #NEEDED: Before/while building the model, this routine needs to check all inputs and make sure everything is correct
    #All variables and parameters and flows need to follow naming rules
    #flows may only contain variables, parameters and math symbols
    #any variable or parameter listed in flows needs to be specified as variable or parameter
    model <- eventReactive(input$makemodel, {
        #structure that holds the model
        model = list()

        model$title <- isolate(input$modeltitle)
        model$author <- isolate(input$modelauthor)
        model$textription <- isolate(input$modeltextription)
        model$details = isolate(input$modeldetails)
        model$date = Sys.Date()
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
        model$var = var

        par = vector("list",values$npar)
        for (n in 1:values$npar)
        {
            par[[n]]$parname = isolate(eval(parse(text = paste0("input$par",n,"name") )))
            par[[n]]$partext = isolate(eval(parse(text = paste0("input$par",n,"text") )))
            par[[n]]$parval = isolate(eval(parse(text = paste0("input$par",n,"val") )))

        }
        model$par = par

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

        model$time = time

        #add call to functions somewhere here that plot diagram and make equations

        return(model)
    })

    # make and display equations
    output$equations =  renderUI( withMathJax(generate_equations(model()) ) )
    #reactive( {
    #    if (!is.null(model()))
    #    {
    #    output$equations =  renderUI( withMathJax(generate_equations(model()) ) )
    #    }
    #})

    output$diagram = renderPlot( generate_diagram(model()))


    #define number of variables and parameters globally, is updated based on user pressing add/delete variables/parameters
    values = reactiveValues()
    values$nvar <- 1
    values$npar <- 1
    values$nflow <- rep(1,50) #number of flows for each variable, currently assuming model does not have more than 50 vars

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
             selector = paste0("#var", input$targetvar, "flow", values$nflow[values$nvar], 'slot'),
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
                                  textInput(paste0("par", values$nvar, 'name'), "Parameter Name")
                           ),
                           column(3,
                                  textInput(paste0("par", values$nvar,'text'), "Parameter description")
                           ),
                           column(2,
                                  numericInput(paste0("par", values$nvar,'val'), "Default value", value = 0)
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


}  #ends the main shiny server function

#The UI for the app that allows building of models
ui <- fluidPage(
    includeCSS("../media/modelbuilder.css"),
    withMathJax(),
    #add header and title
    div( includeHTML("../media/header.html"), align = "center"),
    fluidRow(
        actionButton("exitBtn", "Exit to main menu", class="exitbutton"),
        align = "center"
    ),
    tags$br(),
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
            # PLaceholder for results of type text
            h2('Model Equations'),
            uiOutput(outputId = "equations")
        ) #end column for outcomes
    ) #end split input/output section
) #end fluid page


shinyApp(ui = ui, server = server)
