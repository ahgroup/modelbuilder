#a function that has as input a model following our structure and writes an R function based on this



create_ode <- function(model)
{

    #if the model is passed in as an Rdata file name, load it
    if(is.character(model)) {load(model)}

    filename=paste0(gsub(" ","_",model$title),"_desolve.R")
    nvars = length(model$var)  #number of variables/compartments in model
    npars = length(model$par)  #number of parameters in model
    #fixed text for top and bottom of ODE function
    s1 = paste( gsub(" ","_",model$title),'_ode <- function(t, y, parms) \n{',sep='')
    s2 = "  with( as.list(c(y,parms)), { #lets us access variables and parameters stored in y and parms by name \n"
    s3 = "} ) } #close with statement, end ODE function \n \n"

    #text for equations and final list
    seqs= NULL
    slist="    list(c("
    for (n in 1:nvars)
    {
        seqs = paste0(seqs,'    d',model$var[[n]]$varname,' = ',paste(model$var[[n]]$flows, collapse = ' ')," #",model$var[[n]]$vartext, '\n' )
        slist = paste0(slist, paste0('d',model$var[[n]]$varname,','))
    }

    slist = substr(slist,1,nchar(slist)-1) #get rid of final comma
    slist = paste0(slist,')) \n') #close parantheses


    #text for model description
    sdesc=paste0("#' ",model$description,"\n \n")
    sdesc=paste0(sdesc,"#' @description USER CAN ADD MORE DETAILS HERE \n")
    for (n in 1:nvars)
    {
        sdesc=paste0(sdesc,"#' @param ", model$var[[n]]$varname, ' starting value for ',model$var[[n]]$vartext, "\n")
    }
    for (n in 1:npars)
    {
        sdesc=paste0(sdesc,"#' @param ", model$par[[n]]$parname," ", model$par[[n]]$partext, "\n")
    }
    sdesc=paste0(sdesc,"#' @param t0 start time \n")
    sdesc=paste0(sdesc,"#' @param tf final time \n")
    sdesc=paste0(sdesc,"#' @param dt time steps \n")
    sdesc=paste0(sdesc,"#' @return The function returns the output from the odesolver as a matrix, \n")
    sdesc=paste0(sdesc,"#' with one column per compartment/variable. The first column is time.   \n")
    sdesc=paste0(sdesc,"#' @details USER CAN ADD MORE DETAILS HERE  \n")
    sdesc=paste0(sdesc,"#' @examples  \n")
    sdesc=paste0(sdesc,"#' # To run the simulation with default parameters just call the function:  \n")
    sdesc=paste0(sdesc,"#' result <- ",gsub(" ","_",model$title),"_desolve()", " \n")
    sdesc=paste0(sdesc,"#' @author ",model$author, " \n \n")


    #text for main body of function
    varstring = "var = c("
    for (n in 1:nvars)
    {
        varstring=paste0(varstring, model$var[[n]]$varname," = ", model$var[[n]]$startval,', ')
    }
    varstring = substr(varstring,1,nchar(varstring)-2)
    varstring = paste0(varstring,'), ') #close parantheses

    parstring = "par = c("
    for (n in 1:npars)
    {
        parstring=paste0(parstring, model$par[[n]]$parname," = ", model$par[[n]]$value,', ')
    }
    parstring = substr(parstring,1,nchar(parstring)-2)
    parstring = paste0(parstring,'), ') #close parantheses
    timestring = paste0('tvec = c(t0 = ',model$time$t0,', tf = ',model$time$tf,', dt = ',model$time$dt,')')

    smain = paste0(gsub(" ","_",model$title),"_desolve <- function(",varstring, parstring, timestring,') \n{ \n')
    smain = paste0(smain,'  times=seq(tvec[1],tvec[2],by=tvec[3]) \n')
    smain = paste0(smain,'  result = deSolve::ode(y = var, parms= par, times = times,  func = ',gsub(" ","_",model$title),'_ode) \n')
    smain = paste0(smain,'  return(result) \n')
    smain = paste0(smain,'} \n')

    #write all to file
    sink(filename)
    cat(s1)
    cat(s2)
    cat(seqs)
    cat(slist)
    cat(s3)
    cat(sdesc)
    cat(smain)
    sink()

}
