#This function converts the code of a model implemented as deSolve function
#back into a model structure
#the desolve code/function needs to be provided as an R file

convert_object_to_desolve <- function(desolvefunction)
{

  desolvefunction = "SIR_model_desolve.R"
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

 #name of function, this strips the .R part and introduces a blank to prevent getting the example line
 fctname =paste0(substr(desolvefunction,1,nchar(desolvefunction)-2)," ")
 fcts = grep(fctname,x,value=TRUE) #string for the function
 #extract name/value pairs for variables, parameters and time
 varparvec = unlist(str_extract_all(fcts,"\\w*( = )\\d+"))

 vplist = unlist(str_split(varparvec,' '))

 #xx= grep("vars = c(*)",x,value=TRUE)
 #x2 = grep("\\w*( = )\\d+",fcts,value=TRUE)




}
