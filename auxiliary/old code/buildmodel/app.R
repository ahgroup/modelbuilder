server <- function(input, output)
{


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



    #when user presses the 'make model' button
    #this function reads all the inputs and writes them into the model structure
    #and returns the structure
    #NEEDED: Before/while building the model, this routine needs to check all inputs and make sure everything is correct
    #All variables and parameters and flows need to follow naming rules
    #flows may only contain variables, parameters and math symbols
    #any variable or parameter listed in flows needs to be specified as variable or parameter
    dynmodel <- eventReactive(input$makemodel, {


        #this code reads all the inputs and checks for errors that need fixing
        #if there are errors, the function needs to terminate with an error message
        #only if there are no errors should the rest of the code be executed
        #which writes the inputs into the model structure

        #test that no input fields are empty
        #if any is empty, stop and alert user

        #test that all


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


    #define number of variables and parameters globally, is updated based on user pressing add/delete variables/parameters
    values = reactiveValues()
    values$nvar <- 1
    values$npar <- 1
    values$nflow <- rep(1,50) #number of flows for each variable, currently assuming model does not have more than 50 vars



}  #ends the main shiny server function

#The UI for the app that allows building of models
ui <-

shinyApp(ui = ui, server = server)
