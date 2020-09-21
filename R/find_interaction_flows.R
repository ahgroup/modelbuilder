#' Identifies flows with interactions among state variables
#'
#' This function takes as input a modelbuilder model and
#' identifies the flows that have interactions among state variables.
#' This is an internal function used by the generate_stratified_model
#' function.
#'
#' @description The model needs to adhere to the structure specified by
#'     the modelbuilder package. Models built using the modelbuilder package
#'     automatically have the right structure. A user can also build a
#'     model list structure themselves following the modelbuilder
#'     specifications. If the user provides a file name, this file needs to
#'     be an RDS file and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object
#'     or file name
#' @return The function returns a data frame identifying the flows (and
#'     their associated vars) with state variable interactions.
#' @author Andrew Tredennick and Andreas Handel
#' @export

find_interaction_flows <- function(mbmodel)
{
  interactions <- list()  #empty storage

  #get a vector of state variables
  state_vars <- unlist(lapply(mbmodel$var, "[[", 1))

  for(i in 1:length(mbmodel$var)) {
    tmpvar <- mbmodel$var[[i]]

    for(j in 1:length(tmpvar$flows)) {
      tmpflow <- tmpvar$flows[j]

      #extract just the variables and parameters, in order, from the flows
      #by splitting the string based upon math symbols
      mathpattern <- "[-+\\++\\*+\\(+\\)+\\^+/+]"
      flowsymbols <- unlist(strsplit(tmpflow, mathpattern))
      to_rm <- which(flowsymbols == "")
      if(length(to_rm) != 0) {
        flowsymbols <- flowsymbols[-to_rm]
      }

      #find how many state variables in the flow
      states <- which(flowsymbols %in% state_vars)
      flag <- FALSE  #default to no interactions
      if(length(states) > 1) {
        #set flag to TRUE if there are more than one state variable
        flag <- TRUE
      }

      #save the interaction flag by index
      out <- data.frame(var = i,
                        flow = j,
                        varname = tmpvar$varname,
                        inter = flag)

      #bind to storage data frame
      interactions <- rbind(interactions, out)
    }  #end flow loop
  }  #end var loop

  #just keep IDs for interactions
  out_ret <- interactions[interactions$inter == TRUE, ]
  out_ret <- out_ret[ , c("varname", "var", "flow")]

  return(out_ret)
}
