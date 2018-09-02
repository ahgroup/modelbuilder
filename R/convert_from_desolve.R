#' Create model from desolve function
#'
#' This function takes as input a desolve function code and turns it into a model list structure
#'
#' @description This function performs the inverse action of convert_to_desolve()
#' If a model is turned into a desolve function with convert_to_desolve and then run through this function
#' the result should be identical to the starting model structure
#' comparison can be done with the setdiff() function
#' @param desolvefunction name of file that should be converted
#' @return A list structure containing the model
#' @author Andreas Handel
#' @date 2018-09-01
#' @export
#'

convert_from_desolve <- function(desolvefunction)
{

    #read in the whole function text into a vector with each line of code a vector element of type string/character
    x = readr::read_lines(desolvefunction)

    #strip all #' symbols from code
    x = gsub(pattern = "#' ", replacement = "", x)

    #create empty model main list structure
    model = list()

    #add model meta-information
    model$title = x[1] #first line of code is title
    model$description = x[3] #third line of code is description
    model$author =  na.omit(stringr::str_match(x, "@modelauthor (.*)"))[1,2] #pull out model author
    model$date =  as.Date(na.omit(stringr::str_match(x, "@modeldate (.*)"))[1,2]) #pull out model date

    #######################################
    #extract and process code that forms the ODE equation block
    startind = grep('StartODES',x) #start and stop lines for ode code block
    endind = grep('EndODES',x) #start and stop lines for ode code block
    odes=x[(startind+1):(endind-1)] #this is the ode text block, alterating lines of text and equations
    #split equations and equation text
    odetext=odes[seq(1,length(odes)-1,by=2)]
    odeeq=odes[seq(2,length(odes),by=2)]

    #########################################
    #get the bit of code that is the main function call, so we can extract variable and parameter default values
    #name of function, this strips the .R part and introduces a blank to prevent getting the example line
    fctname =paste0(substr(desolvefunction,1,nchar(desolvefunction)-2)," ")
    fcts = grep(fctname,x,value=TRUE) #string for the function definition line
    pattern = "\\(([^)|^(]+)\\)" #regex for capturing group matching one or more characters that are not ) inside parantheses
    vptvector = stringr::str_extract_all(fcts,pattern, simplify = TRUE) #extract variables, parameters, time vectors (in slots 1,2,3)

    ###############################
    #process variables
    pattern = "\\b[A-Z][A-Z0-9a-z]*\\b" #regex to get a variable names. Those must start with capital letter and only include letters and numbers
    varname = stringr::str_extract_all(vptvector[1],pattern, simplify = TRUE) #extract all variable names
    pattern = "([0-9]+\\.[0-9]*)|([0-9]*\\.[0-9]+)|([0-9]+)" #regex for a real number
    varval = stringr::str_extract_all(vptvector[1],pattern, simplify = TRUE) #extract all variable starting conditions

    nvars = length(varname)
    var = vector("list",nvars)
    for (n in (1:nvars))
    {
        var[[n]]$varname = varname[n]
        var[[n]]$vartext = stringr::str_extract(odetext[n],"(?<=\\#)(.*?)(?= \\:)") #extract everything between # and : symbols
        var[[n]]$varval = as.numeric(varval[n])
        flows = stringr::str_extract(odeeq[n] ,"(?<=\\= ).*") #remove text to left of flows
        var[[n]]$flows = as.vector(stringr::str_split(flows, " ", simplify=TRUE)) #add vector of flows
        flownames = stringr::str_extract_all(odetext[n],"(?<=\\: )(.*?)(?= \\:)",simplify = TRUE) #get all flows between : symbols
        var[[n]]$flownames = as.vector(flownames) #add vector of flow descriptions
    }
    model$var = var

    ###############################
    #process parameters
    pattern = "\\b[a-z][A-Z0-9a-z]*\\b" #regex to get parameter names. Those must start with a lowercase letter and only include letters and numbers
    parname = stringr::str_extract_all(vptvector[2],pattern, simplify = TRUE) #extract all parameter names
    pattern = "( [0-9]+\\.[0-9]*)|( [0-9]*\\.[0-9]+)|( [0-9]+)" #regex for a real number
    parval = stringr::str_extract_all(vptvector[2],pattern, simplify = TRUE) #extract all parameter values

    npars = length(parname)
    par = vector("list",npars)

    #pull out all lines in the description that start with @param
    allparlines = grep('\\@param',x,value=TRUE)
    parlines = allparlines[(nvars+1):(nvars+npars)] #pull out lines for parameters

    for (n in (1:npars))
    {
        par[[n]]$parname = parname[n]
        par[[n]]$partext = stringr::str_extract(parlines[n],"(?<=\\@param .{1,20} )(.*)") #extract text after "@param x " which is description. parameter name can't be more than 20 characters
        par[[n]]$parval = as.numeric(parval[n])

    }
    model$par = par

    ###############################
    #process time
    pattern = "\\b[a-z][A-Z0-9a-z]*\\b" #regex for time parameter names. Those must start with a lowercase letter and only include letters and numbers
    timename = stringr::str_extract_all(vptvector[3],pattern, simplify = TRUE) #extract all parameter names
    pattern = "( [0-9]+\\.[0-9]*)|( [0-9]*\\.[0-9]+)|( [0-9]+)" #regex for a real number with leading blank
    timeval = stringr::str_extract_all(vptvector[3],pattern, simplify = TRUE) #extract all parameter values

    ntime = length(timename)
    times = vector("list",ntime)

    #pull out all lines in the description that start with @param
    timelines = allparlines[(nvars+npars+1):length(allparlines)] #pull out lines for time

    #browser()

    for (n in (1:3))
    {
        times[[n]]$timename = timename[n]
        times[[n]]$timetext = stringr::str_extract(timelines[n],"(?<=\\@param .{1,20} )(.*)") #extract text after "@param x " which is description. parameter name can't be more than 20 characters
        times[[n]]$timeval = as.numeric(timeval[n])

    }
    model$time = times

    return(model)
}
