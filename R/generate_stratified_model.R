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
#' @examples
#' \dontrun{
#'mbmodel <- readRDS("auxiliary/modelfiles/Coronavirus_vaccine_model_v2.Rds")
#'strata_list <- list(
#'  list(
#'    stratumname = "age",
#'    names = c("children", "adults", "elderly"),
#'    labels = c("c", "a", "e"),
#'    comment = "This defines the age structure."
#'  ),
#'  list(
#'    stratumname = "risk",
#'    names = c("high risk", "low risk"),
#'    labels = c("h", "l"),
#'    comment = "This defines the risk structure."
#'  )
#')
#' }

generate_stratified_model <- function(mbmodel,
                                      stratum_list,
                                      par_stratify_list)
{
  #if the model is passed in as a file name, load it
  #otherwise, it is assumed that 'mbmodel' is a list structure
  #of the right type
  if (is.character(mbmodel)) {
    mbmodel = readRDS(mbmodel)
  }
  mb <- mbmodel

  #compute number of groups in stratum
  ngroups <- length(stratum_list$names)

  #error checking
  if(!is.null(stratum_list$labels))
  {  #if not null, then the labels and names need to be the same length
    if(ngroups != length(stratum_list$labels))
    {
      stop(paste("Labels and names for",
                 stratum_list$stratumname,
                 "are not of equal length"))
    }
  } else {  #make labels if NULL
    stratum_list$labels <- stratum_list$names  #labels are just the names if NULL
  }

  #get vector of all parameter names
  strat_pars <- unlist(lapply(par_stratify_list, "[[", 1))

  #get same vector of parameters from the model itself
  mod_pars <- unlist(lapply(mbmodel$par, "[[", 1))

  #make sure all parameters are present in the strat_pars
  test <- sum(!strat_pars %in% mod_pars)
  if(test != 0) {
    stop("All parameters must have a stratification specified.")
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

  #loop over model variable-flows and apply stratum subgroups
  nvars <- length(mb$var)
  ct <- 1  #counter for state variables
  for(v in 1:nvars) {
    var <- mb$var[[v]]
    focal_var <- var$varname

    for(g in 1:ngroups) {
      lab <- stratum_list$labels[g]
      nm <- stratum_list$names[g]

      #append group lable to the variable names
      newname <- paste(var$varname, lab, sep = "_")

      #loop over flows and expand as per the par_stratify_list
      nflows <- length(var$flows)
      #create an empty character object for the appended flows
      allnewflows <- character(length = nflows)
      for(f in 1:nflows) {
        flow <- var$flows[f]

        #extract just the variables and parameters, in order, from the flows
        #by splitting the string based upon math symbols
        mathpattern <- "[-+\\++\\*+\\(+\\)+\\^+/+]"
        flowsymbols <- unlist(strsplit(flow, mathpattern))
        to_rm <- which(flowsymbols == "")
        if(length(to_rm) != 0) {
          flowsymbols <- flowsymbols[-to_rm]
        }

        #extract just the math symbols, in order, from the flows by
        #removing all characters associated with the variables and parameters
        varparpattern <- paste0("[", paste(flowsymbols, collapse = ""), "]")
        flowmath <- gsub(pattern = varparpattern,
                         replacement = "",
                         x = flow)
        #break apart the math symbol string into a character vector
        #such that individual elements can be pasted back in order
        flowmath <- unlist(strsplit(flowmath, ""))

        #need to combine parenthese with the math symbol
        #before (opening) or after (closing) such that order
        #of operations is correct.
        #NOTE: THIS IS NOT GENERALIZABLE YET
        opens <- which(flowmath == "(")  #check for parenthese

        #if parentheses exist, conduct the following
        if(length(opens) != 0) {
          openers <- character(length = length(opens))

          #loop over opening parentheses and couple with
          #the preceding math symbol
          for(o in 1:length(opens)) {
            opener <- paste(flowmath[opens[o]-1], flowmath[opens[o]], collapse = "")
            flowmath[opens[o]-1] <- opener
          }
          #now drop the preceding math symbol that is not "attached"
          #to the parenthesis
          flowmath <- flowmath[-opens]

          #follow similar logic for the closing parenthes, but
          #attach the match symbols following the paranthesis
          closes <- which(flowmath == ")")
          if(length(closes) > 1) {
            #this chunk deals with "))" instances -- NOT ROBUST
            if(diff(closes) == 1) {
              closer <- paste(flowmath[closes[1]],
                              paste(flowmath[closes[1]+(1:2)], collapse = ""),
                              collapse = "")
              flowmath[closes[1]] <- closer
              flowmath <- flowmath[-(closes[1]+(1:2))]
            }
          } else {
            #this chunk deals with isolated ")"
            for(cl in 1:length(closes)) {
              closer <- paste(flowmath[closes[cl]], flowmath[closes[cl]+1], collapse = "")
              flowmath[closes[cl]] <- closer
            }
            flowmath <- flowmath[-(closes+1)]
          }
        }

        #identify as parameter or state variable
        types <- character(length(flowsymbols))
        types[] <- "par"
        stateids <- which(substr(flowsymbols, 1, 1) %in% LETTERS)
        types[stateids] <- "var"

        #get parameter stratification mappings
        these_pars <- which(lapply(par_stratify_list, "[[", 1) %in%
                              flowsymbols[types == "par"])
        par_maps <- par_stratify_list[these_pars]

        #flag if there are more than 1 state variable
        if(length(stateids) > 1) inter <- TRUE

        if(inter) {
          #create data frame matching names and subscripts
          expansion <- expand.grid(flowsymbols,
                                   stratum_list$labels,
                                   stringsAsFactors = FALSE)
          names(expansion) <- c("original_name", "group")
          expansion[!expansion$original_name %in% flowsymbols[stateids], "group"] <- ""
          expansion$flow_num <- rep(1:ngroups, each = length(flowsymbols))
          expansion$type <- rep(types, times = ngroups)

          #if the flow is out of the compartment, then we just need to
          #make sure that the focal variable recieves the focal subscript
          #in all flows
          if(unlist(strsplit(flowmath, ""))[1] == "-") {
            expansion[expansion$original_name == var$varname, "group"] <- lab
          }

          #if the flow is into the compartment and includes and interaction,
          #then we just need to make sure that "S" recieves the focal subscript
          #because all donations come from "S"
          #NOTE: THIS ONLY WORKS FOR SPECIFIC SIR STYLE MODELS
          #      I THINK WE CAN GENERALIZE BY ADDING A "DONOR"
          #      ELEMENT TO THE MBOBJECT
          if(unlist(strsplit(flowmath, ""))[1] == "+") {
            ids_to_update <- which(substr(expansion$original_name, 1, 1) == "S")
            expansion[ids_to_update, "subscript"] <- lab
          }
        } else {
          expansion <- expand.grid(flowsymbols[stateids],
                                   lab,
                                   stringsAsFactors = FALSE)
          names(expansion) <- c("original_name", "subscript")
        }

        #loop over parameter names and apply mapping
        npars <- length(par_maps)
        for(p in 1:npars) {
          map <- par_maps[[p]]
          if(length(map$stratify_by) == 1) {
            expansion[expansion$original_name == map$parname, "group"] <- lab
          } else {
            #loop over flow replicates and apply parameter mapping
            for(fn in 1:length(unique(expansion$flow_num))) {
              par_name <- map$parname
              map_vars <- map$stratify_by
              tmp <- expansion[expansion$flow_num == fn &
                                 expansion$original_name %in% map_vars, ]
              tmp2 <- tmp[ ,c("original_name","group")]
              new_sub <- paste(apply(tmp2, 1, paste, collapse = ""), collapse = "_")
              expansion[expansion$flow_num == fn &
                          expansion$original_name == par_name, "group"] <- new_sub
            }
          }
        }

        new_flowsymbols <- apply(expansion[ , c("original_name","group")],
                                 1,
                                 paste,
                                 collapse = "_")
        #loop over flow components and append subscripts accordingly
        new_flowsymbols <- character(length = nrow(expansion))
        for(fid in 1:nrow(expansion)) {
          tmpc <- expansion[fid,]
          if(tmpc["group"] == "") {
            #no appendage if numeric
            new_flowsymbols[fid] <- tmpc["original_name"]
          } else {
            #otherwise paste the two columns
            new_flowsymbols[fid] <- apply(tmpc[,c("original_name","group")], 1, paste, collapse = "_")
          }
        }

        #reassemble the flows using the math and the newflow parameters
        #and variables with appended labels for the group
        #start flowmath first followed by all but the first element of
        #the flow parameters and variables. this ensures correct ordering.
        #note that this assumes that all flows start with a math symbol.
        newvarflows <- paste(paste(flowmath, unlist(new_flowsymbols)), collapse = "")

        #now add in the first flow parameter or variable, which may
        #be an empty string (likely in most use cases)
        # newvarflows <- paste(newflows[1], newvarflows, collapse = "")

        #replace all the white space to get a flow in the correct
        #formate for modelbuilder
        newvarflows <- gsub(" ", "", newvarflows, fixed = TRUE)

        #store the new flow in the empty object
        allnewflows[f] <- newvarflows
      }  #end of flow loop

      #define the new state variable name
      newname <- paste(var$varname, lab, sep = "_")

      #append group name to the variable text
      newtext <- paste(var$vartext, nm, sep = " ")

      #append group name to the flow names
      newflownames <- paste(var$flownames, nm, sep = ", ")

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
    }  #end of stratum group loop
  }  #end of state variable loop
}  #end of function


