#' @title A function that takes a modelbuilder model and checks it for errors
#' @description This function takes a modelbuilder model object,
#' and checks that all specifications and constraints for modelbuilder models are met and it is a valid model
#' @param mbmodel A model object or file name and location for the model to be loaded.
#' @return An error message if the model is not properly formulated. If model is ok, it returns NULL.
#' @details This function is a helper function
#' @export

check_model <- function(mbmodel) {

    mberror = NULL

    ################################
    #check title
    #needs to have every field to be non-empty, especially model$title
    if (mbmodel$title == "") {mberror = "Please provide a model title"; return(mberror) }
    #check that no non-standard characters are used in title. only letters and numbers and spaces are allowed.
    #underscore is also allowed
    pattern = "^[A-Za-z0-9_ ]+$"
    if (!grepl(pattern,mbmodel$title)) {mberror = "Please only use letters, numbers and spaces in title"; return(mberror) }
    #check that title starts with a letter. Needed since title will be name of R function and those need to start with letter.
    pattern = "^[A-Za-z]"
    if (!grepl(pattern,mbmodel$title[1])) {mberror = "Model name needs to start with a letter."; return(mberror) }


    ################################
    #check all time related fields
    times = unlist(mbmodel$time)
    #check that all time entries have completely filled fields
    if ( sum(times == "") > 0) {mberror = "Please fill all time fields"; return(mberror) }
    #time values need to be numeric and >0
    timevals = times[names(times) == "timeval"]
    if ( sum(!(as.numeric(timevals) >= 0)) ) {mberror = "All time values need to be numbers >=0"; return(mberror) }
    #end time needs to be larger than start time
    if (mbmodel$time[[1]]$timeval >= mbmodel$time[[2]]$timeval) {mberror = "End time needs to be larger than starting time"; return(mberror) }
    #time step needs to be smaller than end - start time
    if ( (mbmodel$time[[2]]$timeval - mbmodel$time[[1]]$timeval) <= mbmodel$time[[3]]$timeval ) {mberror = "Time step is too large"; return(mberror) }

    ################################
    #check all parameter related fields
    pars = unlist(mbmodel$par)
    #check that all parameters have completely filled fields
    if ( sum(pars == "") > 0) {mberror = "Please fill all parameter fields"; return(mberror) }
    #Parameter names have to start with a lower-case letter and can only contain letters and numbers
    #underscore is also allowed
    parnames = pars[names(pars) == "parname"]
    pattern = "^[a-z]+[A-Za-z0-9_]*$"
    if (sum(!grepl(pattern,parnames))>0) {mberror = "Please start with a lower case letter and use only use letters and numbers for parameters"; return(mberror) }
    #parameter values need to be numeric and >0
    parvals = pars[names(pars) == "parval"]
    if ( sum(!(as.numeric(parvals) >= 0)) ) {mberror = "All parameter values need to be numbers >=0"; return(mberror) }

    ################################
    ##check all variable related fields

    # set names of var to be NULL so that names of elements in var are not included in sub-element names
    varsTmp <- mbmodel$var
    names(varsTmp) <- NULL

    vars = unlist(varsTmp)
    #check that all variables have completely filled fields
    if ( sum(vars == "") > 0) {mberror = "Please fill all variable fields"; return(mberror) }
    # Variable names have to start with an upper-case letter and can only contain letters and numbers
    #underscore is also allowed
    varnames = vars[names(vars) == "varname"]
    pattern = "^[A-Z]+[A-Za-z0-9_]*$"
    if (sum(!grepl(pattern,varnames))>0) {mberror = "Please start with a upper case letter and use only use letters and numbers for variables"; return(mberror) }
    # variable starting conditions need to be numeric and >0
    varvals = vars[names(vars) == "varval"]
    if ( sum(!(as.numeric(varvals) >= 0)) ) {mberror = "All variable starting values need to be numbers >=0"; return(mberror) }
    #make sure that all flows only consist of specified variables, parameters and math symbols ( +,-,*,^,/,() ).
    #Other math notation such as e.g. sin() or cos() is not yet supported.

    #loop over each variable/compartment, check all flows
    for (n in 1:length(varnames))
    {
        varflows = unlist(mbmodel$var[[n]][grep("flows",names(mbmodel$var[[n]]))])
        pattern = "[-+\\++\\*+\\(+\\)+\\^+/+]"
        flowsymbols = unique(unlist(strsplit(varflows,pattern)))
        if ("t" %in% flowsymbols)  #add t to parnames if present in flows
        {
            parnames = c(parnames, c("parname" = "t"))
        }
        math_symbols <- c("+", "-", "*", "^", "/", "(", ")", " ","",
                          "sin", "exp", "log")
        allsymbols = c(math_symbols,varnames,parnames,0:9)
        if (sum(!(flowsymbols %in% allsymbols)) >0)
        {
            wrongflows = flowsymbols[which(!(flowsymbols %in% allsymbols))]

            # collapse wrongflows so that the error message is not repeated for each wrong flow
            mberror = paste0("Your flows for variable ",mbmodel$var[[n]]$varname, " contain these non-allowed symbols: ",
                             paste0(wrongflows, collapse = ", ")); return(mberror)
        }
    }

    #STILL NEED TO WRITE THE FOLLOWING CHECK
    #check that each flow shows up at most twice
    #branched flows, e.g. -bSI leaving a compartment and fbSI arriving in one and (1-f)bSI in another
    #are not allowed. Those flows need during the model building stage be written as 2 independent flows
    #-bfSI/bfSI and -(1-f)bSI/(1-f)bSI
    #STILL NEED TO WRITE THE FOLLOWING CHECK
    #make sure each parameter name is only used in disticnt flows, either once
    #or twice in a inflow/outflow pair

    return(mberror)
}
