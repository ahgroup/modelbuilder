#' @title A helper function that reads the shiny model builder UI inputs and saves information in a model object
#'
#' @description This function takes as input the shiny user inputs for the modelbuilder build functionality
#' and writes them inot a model object
#'
#' @param input Shiny UI inputs to be read
#' @param values Shiny UI variable that contains needed counters
#'
#' @return A modelbuilder model structure.
#' @details This function is a helper function
#' @author Spencer D. Hall, Andreas Handel
#' @export

generate_model <- function(input, values) {
    # browser()
    #structure that holds the model
    dynmodel = list()

    joe <<- reactiveValuesToList(input)
    joe1 <<- reactiveValuesToList(values)

    #input <- joe
    #values <- joe1

    dynmodel$title <- isolate(input$modeltitle)
    dynmodel$author <- isolate(input$modelauthor)
    dynmodel$description <- isolate(input$modeldescription)
    dynmodel$details = isolate(input$modeldetails)
    dynmodel$date = Sys.Date()

    var = vector("list", nrow(values$masterVarDF))
    names(var) <- values$masterVarDF$varNumber

    for (n in as.character(values$masterVarDF$varNumber))
    {
        var[[n]]$varname = isolate(eval(parse(text = paste0("input$var",n,"name") )))
        var[[n]]$vartext = isolate(eval(parse(text = paste0("input$var",n,"text") )))
        var[[n]]$varval = isolate(eval(parse(text = paste0("input$var",n,"val") )))
        allflows = NULL
        allflowtext = NULL
        for (f in unique(values$currentFlowButtons[[n]])) #turn all flows and descriptions into vector
        {
            newflow = isolate(eval(parse(text = paste0("input$var", n, 'f' , f,'name'))))
            #if a flow does not have a + or - sign in front, assume it's positive and add a + sign
            if (substr(newflow,1,1)!= '-' & substr(newflow,1,1)!= '+') { newflow = paste0('+',newflow)}
            newflowtext = isolate(eval(parse(text = paste0("input$var", n, 'f' , f,'text'))))
            allflows = c(allflows,newflow)
            allflowtext = c(allflowtext, newflowtext)
        }
        var[[n]]$flows = allflows
        var[[n]]$flownames = allflowtext

        #names(var) <- NULL
    }
    dynmodel$var = var
    # browser()

    par = vector("list",length(values$currentParButtons))
    for (n in 1:length(values$currentParButtons))
    {
        par[[n]]$parname = isolate(eval(parse(text = paste0("input$par",n,"name") )))
        par[[n]]$partext = isolate(eval(parse(text = paste0("input$par",n,"text") )))
        par[[n]]$parval = isolate(eval(parse(text = paste0("input$par",n,"val") )))

    }

    #print(par)

    dynmodel$par = par

    time = vector("list", 3)
    time[[1]]$timename = "tstart"
    time[[1]]$timetext = "Start time of simulation"
    time[[1]]$timeval = isolate(eval(parse(text = paste0("input$tstart_build"))))

    time[[2]]$timename = "tfinal"
    time[[2]]$timetext = "Final time of simulation"
    time[[2]]$timeval = isolate(eval(parse(text = paste0("input$tfinal_build") )))

    time[[3]]$timename = "dt"
    time[[3]]$timetext = "Time step"
    time[[3]]$timeval = isolate(eval(parse(text = paste0("input$dt_build") )))

    dynmodel$time = time

    return(dynmodel)

} #end generate model function
