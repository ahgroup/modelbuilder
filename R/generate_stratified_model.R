#' Stratify an mb model by groups
#'
#' This function takes as input a modelbuilder model and
#' expands it according to specified stratifications (e.g.
#' age groups).
#'
#' @description The model needs to adhere to the structure specified by
#'     the modelbuilder package. Models built using the modelbuilder package
#'     automatically have the right structure. A user can also build a
#'     model list structure themselves following the modelbuilder
#'     specifications. If the user provides a file name, this file needs to
#'     be an RDS file and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object
#'     or file name
#' @param strata_list A list of lists defining the stratification structure
#'     to be applied to the model. At a minimum, the list must contain one
#'     sublist with the following structure: \code{stratumname} a character
#'     string giving the name of the stratum (e.g., "age"); \code{names} a
#'     vector of character strings defining the names for each group within
#'     the stratum (e.g., c("child", "adult")); \code{labels} a vector of
#'     character strings defining the labels that correspond to each group
#'     within the stratum, which are applied to the model codes (e.g.,
#'     c("c", "a")); \code{comment} a character string of any comments or
#'     notes for the stratum. The \code{labels} are appended to model state
#'     variables (e.g., S becomes S_c) and parameters (e.g., b becomes b_c).
#' @return The function returns a modelbuilder model object (a list).
#' @author Andrew Tredennick and Andreas Handel
#' @export

generate_stratified_model <- function(mbmodel,
                                      strata_list)
{

  #if the model is passed in as a file name, load it
  #otherwise, it is assumed that 'mbmodel' is a list structure
  #of the right type
  if (is.character(mbmodel)) {
    mbmodel = readRDS(mbmodel)
  }


  #loop over specified strata, then loop over variables and parameters
  nstrata <- length(strata_list)
  for(i in 1:nstrata) {
    if(i == 1)
    {
      #for the first stratum (i=1) set the mb object to the original
      #modelbuilder model sent to the function
      mb <- mbmodel
    } else {
      #for all strata after the first (i!=1) set the mb object to the
      #newmb object that gets made and overwritten below
      mb <- newmb
    }

    #set up a new modelbuilder list object
    #this gets made anew (and overwritten) each iteration through
    #a stratum. newmb is always the most recent, and final, object
    #containing the appended variables, flows, and parameters.
    #the mb object is always the "to-be-stratified" object, which is
    #either the original object sent to this function or the most
    #recent iteration of newmb. see if/then/else statement above.
    newmb <- as.list(c(mb$title,
                       mb$description,
                       mb$author,
                       mb$date,
                       mb$details))
    names(newmb) <- c("title", "description", "author", "date", "details")

    #extract the information for stratum i
    stratum <- strata_list[[i]]

    #store the number of groups within the stratum i
    ngroups <- length(stratum$names)

    #error checking
    if(!is.null(stratum$labels))
    {  #if not null, then the labels and names need to be the same length
      if(ngroups != length(stratum$labels))
      {
        stop(paste("Labels and names for",
                   stratum$stratumname,
                   "are not of equal length"))
      }
    } else {  #make labels if NULL
      stratum$labels <- stratum$names  #labels are just the names if NULL
    }

    #loop over groups within stratum
    ct <- 1  #counter for state variables
    pt <- 1  #counter for parameters
    for(j in 1:ngroups) {
      lab <- stratum$labels[j]  #extract label for group j within stratum i
      nm <- stratum$names[j]  #extract name for group j within stratum i

      #store number of variables in the to-be-stratified modelbuilder
      #object, which is defined via lines 44-54
      nvars <- length(mb$var)

      #loop over variables in the modelbuilder object
      for(k in 1:nvars) {
        var <- mb$var[[k]]  #variable k from the mb object to be stratified

        #append group lable to the variable names
        newname <- paste(var$varname, lab, sep = "_")

        #append group name to the variable text
        newtext <- paste(var$vartext, nm, sep = " ")

        #append group name to the flow names
        newflownames <- paste(var$flownames, nm, sep = ", ")

        #store the flows as a character vector
        varflows <- unlist(var$flows)

        #create an empty character object for the appended flows
        allnewflows <- character(length = length(varflows))

        #loop over flows
        for(l in 1:length(varflows)) {
          #extract just the variables and parameters, in order, from the flows
          #by splitting the string based upon math symbols
          mathpattern <- "[-+\\++\\*+\\(+\\)+\\^+/+]"
          flowsymbols <- unlist(strsplit(varflows[l], mathpattern))
          to_rm <- which(flowsymbols == "")
          if(length(to_rm) != 0) {
            flowsymbols <- flowsymbols[-to_rm]
          }

          #append group label to the flow symbols (variables and parameters)
          newflows <- paste(flowsymbols, lab, sep = "_")

          #extract just the math symbols, in order, from the flows by
          #removing all characters associated with the variables and parameters
          varparpattern <- paste0("[", paste(flowsymbols, collapse = ""), "]")
          flowmath <- stringr::str_remove_all(varflows[l], pattern = varparpattern)

          #break apart the math symbol string into a character vector
          #such that individual elements can be pasted back in order
          flowmath <- unlist(strsplit(flowmath, ""))

          #check if first flow should be blank. this occurs when the first
          #character in a flow is a math symbol. this will almost always be
          #the case, but we are going to run it through a check rather than
          #just discarding the first character in case a user writes a flow
          #that starts with parameter or variable
          # firstflow <- newflows[1]  #first string in the flow vector
          # firstchar <- substr(firstflow, 1, 1)  #first character in that flow
          # if(firstchar == "_")
          # {  #remove the underscore if that is the first character
          #   newflows[1] <- ""
          # }

          #need to combine parenthese with the math symbol
          #before (opening) or after (closing) such that order
          #of operations is correct.
          #NOTE: THIS IS NOT GENERALIZABLE YET
          opens <- which(flowmath == "(")  #check for parenthese
          #if parenthese exist, conduct the following
          if(length(opens) != 0) {
            #combine the math symbol before "(" with the "("
            open_combine <- c(opens-1, opens)
            openers <- paste(flowmath[open_combine], collapse = "")
            #replace the pre-parentheses math symbol with the combined char
            flowmath[open_combine[1]] <- openers
            #delete the lone "(" character
            flowmath <- flowmath[-open_combine[2]]

            closes <- which(flowmath == ")")
            #combine the math symbol after ")" with the ")"
            close_combine <- c(closes, closes+1)
            closers <- paste(flowmath[close_combine], collapse = "")
            #replace the closing parentheses with the combined char
            flowmath[close_combine[1]] <- closers
            #delete the lone math symbol character
            flowmath <- flowmath[-close_combine[2]]
          }

          #reassemble the flows using the math and the newflow parameters
          #and variables with appended labels for the group
          #start flowmath first followed by all but the first element of
          #the flow parameters and variables. this ensures correct ordering.
          #note that this assumes that all flows start with a math symbol.
          newvarflows <- paste(paste(flowmath, newflows), collapse = "")

          #now add in the first flow parameter or variable, which may
          #be an empty string (likely in most use cases)
          # newvarflows <- paste(newflows[1], newvarflows, collapse = "")

          #replace all the white space to get a flow in the correct
          #formate for modelbuilder
          newvarflows <- gsub(" ", "", newvarflows, fixed = TRUE)

          #store the new flow in the empty object
          allnewflows[l] <- newvarflows
        }  #end var flows loop


        #create the variable sublist with the new, appended objects
        #this follows the modelbuilder structure
        newvar <- list(newname,
                       newtext,
                       var$varval,
                       allnewflows,
                       newflownames)
        names(newvar) <- names(var)  #set to the appropriate names

        #add the appended, stratified variable list to the newmb object
        #indexed by ct
        newmb[["var"]][[ct]] <- newvar

        ct <- ct+1  #advance the state variable counter
      }  #end variable loop

      #loop over parameters
      npars <- length(mb$par)  #store number of parameters in the object
      for(m in 1:npars) {
        param <- mb$par[[m]]  #extract the m'th parameter list

        #append group label to the parameter name
        newparname <- paste(param$parname, lab, sep = "_")

        #append the group name to the parameter text
        newpartext <- paste(param$partext, nm, sep = ", ")

        #create a new list for the model object
        #this follows the modelbuilder structure for par list
        newpar <- list(newparname,
                       newpartext,
                       param$parval)
        names(newpar) <- names(param)  #set the names appropriately

        #store the new parameter list in the newmb object
        #indexed by pt
        newmb[["par"]][[pt]] <- newpar

        pt <- pt+1  #advance the param counter
      }  #end of paramter loop

    }  #end group-within-strata loop

  }  #end of strata loop

  #add in times back to the new modelbuilder object
  #time does not change due to stratification, so this can come from
  #the original modelbuilder object sent to the function
  newmb$time <- mbmodel$time

  #title for model, replacing space with low dash to be used
  #in function and file names
  modeltitle <- paste0(gsub(" ", "_", mbmodel$title),"_stratified")

  #give new title to model by appending 'stratified'
  newmb$title <- modeltitle

  #return the newmb object, which is always the most recently
  #stratified object
  return(newmb)

}  #end of function definition
