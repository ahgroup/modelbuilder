#' @title A helper function that takes a model and generates the shiny UI elements for the analyze tab
#'
#' @description This function generates numeric shiny UI inputs for a supplied model.
#' This is a helper function called by the shiny app.
#' @param mbmodel a modelbuilder model structure
#' @param otherinputs a list of other shiny inputs to include
#' @param packagename name of package using this function
#' @return A renderUI object that can be added to the shiny output object for display in a Shiny UI
#' @details This function is called by the Shiny app to produce the Shiny input UI elements.
#' It is assumed that mbmodel is a mbmodel object and will be parsed to create the UI elements.
#' @export


generate_shinyinput <- function(mbmodel, otherinputs = NULL, packagename)
{

    #function to wrap input elements in specified class
    #allows further styling with CSS
    myclassfct = function (x) {
        tags$div(class="myinput", x)
    }

    ###########################################
    #create UI elements as input/output for the shiny app
	#done by parsing a modelbuilder model structure

    #numeric input elements for all variable initial conditions
    nvars = length(mbmodel$var)  #number of variables/compartments in model
    allv = lapply(1:nvars, function(n)
        {
            myclassfct(numericInput(mbmodel$var[[n]]$varname,
                         paste0(mbmodel$var[[n]]$vartext,' (',mbmodel$var[[n]]$varname,')'),
                         value = mbmodel$var[[n]]$varval,
                         min = 0,
                         step = mbmodel$var[[n]]$varval/100)
                    )
        })

    #numeric input elements for all parameter values
    npars = length(mbmodel$par)  #number of parameters in model
    allp = lapply(1:npars, function(n)
        {
            myclassfct(numericInput(
                mbmodel$par[[n]]$parname,
                paste0(mbmodel$par[[n]]$partext,' (',mbmodel$par[[n]]$parname,')'),
                value = mbmodel$par[[n]]$parval,
                min = 0,
                step = mbmodel$par[[n]]$parval/100
            ))
        })

    #numeric input elements for time
    ntime = length(mbmodel$time)  #number of time variables in model
    allt = lapply(1:ntime, function(n) {
            myclassfct(numericInput(
                mbmodel$time[[n]]$timename,
                paste0(mbmodel$time[[n]]$timetext,' (',mbmodel$time[[n]]$timename,')'),
                value = mbmodel$time[[n]]$timeval,
                min = 0,
                step = mbmodel$time[[n]]$timeval/100
            ))
    })

	#browser()

    #standard additional input elements for each model
    standardui <- shiny::tagList(
            shiny::selectInput("plotscale", "Log-scale for plot:",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both")),
            shiny::selectInput("plotengine", "plot engine",c("ggplot" = "ggplot", "plotly" = "plotly")),
            shiny::selectInput("modeltype", "Model to run",c("ODE" = "_ode_", 'stochastic' = '_stochastic_', 'discrete time' = '_discrete_'), selected = '_ode_')
    ) #end taglist

    standardui = lapply(standardui,myclassfct)

    #standard additional input elements for each model
    stochasticui <- shiny::tagList(
        shiny::numericInput("nreps", "Number of simulations", min = 1, max = 500, value = 1, step = 1),
        shiny::numericInput("rngseed", "Random number seed", min = 1, max = 1000, value = 123, step = 1)
    ) #end taglist

    stochasticui = lapply(stochasticui,myclassfct)

    scanparui <- shiny::tagList(
        shiny::selectInput("scanparam", "Scan parameter", c("No" = 0, "Yes" = 1)),
        shiny::selectInput("partoscan", "Parameter to scan", sapply(mbmodel$par, function(x) x[[1]]) ),
        shiny::numericInput("parmin", "Lower value of parameter", min = 0, max = 1000, value = 1, step = 1),
        shiny::numericInput("parmax", "Upper value of parameter", min = 0, max = 1000, value = 10, step = 1),
        shiny::numericInput("parnum", "Number of samples", min = 1, max = 1000, value = 10, step = 1),
        shiny::selectInput("pardist", "Spacing of parameter values", c('linear' = 'lin', 'logarithmic' = 'log'))
    ) #end taglist

    scanparui = lapply(scanparui,myclassfct)


    otherargs = NULL
    if (!is.null(otherinputs))
    {
        otherargs = lapply(otherinputs,myclassfct)
    }

    #return structure
    modelinputs <- tagList(
        p(
            actionButton("submitBtn", "Run Simulation", class = "submitbutton"),
            actionButton(inputId = "reset", label = "Reset Inputs", class = "submitbutton"),
            align = 'center'),
        allv,
        allp,
        allt,
        standardui,
        p('Settings for stochastic model:'),
        stochasticui,
        p('Settings for optional parameter scan for ODE/discrete models:'),
        p(scanparui),
        otherargs
    ) #end tagList

    return(modelinputs)

} #end overall function

