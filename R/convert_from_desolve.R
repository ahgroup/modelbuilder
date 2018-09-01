#This function converts the code of a model implemented as deSolve function
#back into a model structure
#the desolve code/function needs to be provided as an R file

convert_from_desolve <- function(desolvefunction)
{

  #desolvefunction = "SIR_model_desolve.R"
  desolvefunction = "Vector_transmission_model_desolve.R"
  x = readr::read_lines(desolvefunction) #read in the whole function text into a vector with each line a vector element of type string/character

  #strip all #' symbols from code
  x = gsub(pattern = "#' ", replacement = "", x)

  #main list structure
  model = list()

  #some meta-information
  model$title = x[1]
  model$description = x[3]
  model$author =  na.omit(stringr::str_match(x, "@modelauthor (.*)"))[1,2] #not sure this is a robust way of doing it, also would be better to use base R grep/sub, etc functions
  model$date =  na.omit(stringr::str_match(x, "@modeldate (.*)"))[1,2] #not sure this is a robust way of doing it, also would be better to use base R grep/sub, etc functions

 #pull out lines for the equation block

 ind = grep('list\\(c',x) #start and stop lines for ode code block
 odes=x[(ind[1]+1):(ind[2]-1)] #this is the ode text block


 #name of function, this strips the .R part and introduces a blank to prevent getting the example line
 fctname =paste0(substr(desolvefunction,1,nchar(desolvefunction)-2)," ")
 fcts = grep(fctname,x,value=TRUE) #string for the function definition line

 pattern = "\\(([^)|^(]+)\\)" #regex for capturing group matching one or more characters that are not ) inside parantheses
 vptvector = stringr::str_extract_all(fcts,pattern, simplify = TRUE) #extract variables, parameters, time vectors (in slots 1,2,3)
 #stringr::str_view_all(fcts,"c\\(([^)]+)\\)")

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
     var[[n]]$vartext = str_extract(odes[n],"(?<=#).*") #extract everything after # in the ODE equation block
     var[[n]]$varval = varval[n]
     #var[[n]]$flows = c('-b*S*I')
     #var[[n]]$flownames = c('infection of susceptibles')

 }
 model$var = var

###############################
  #process parameters
 pattern = "\\b[a-z][A-Z0-9q-z]*\\b" #regex to get parameter names. Those must start with a lowercase letter and only include letters and numbers
 parname = stringr::str_extract_all(vptvector[2],pattern, simplify = TRUE) #extract all parameter names
 pattern = "([0-9]+\\.[0-9]*)|([0-9]*\\.[0-9]+)|([0-9]+)" #regex for a real number
 parval = stringr::str_extract_all(vptvector[2],pattern, simplify = TRUE) #extract all parameter values

 npars = length(parname)
 par = vector("list",npars)
 for (n in (1:npars))
 {
     par[[n]]$parname = parname[n]
     #par[[n]]$partext = "Susceptible"
     par[[n]]$parval = parval[n]

 }

 model$par = par

 ###############################
 #process time
 pattern = "([0-9]+\\.[0-9]*)|([0-9]*\\.[0-9]+)|([0-9]+)" #regex for a real number
 timeval = stringr::str_extract_all(vptvector[3],pattern, simplify = TRUE) #extract all parameter values

 #time parvals
 model$time$tstart = timeval[1]
 model$time$tfinal = timeval[2]
 model$time$dt = timeval[3]

 # stringr::str_view_all(varvec,pattern)

 #browser()

 return(model)

}
