#' Produce a default stratifier list for use with the generate_stratification function
#'
#' This function takes as input a modelbuilder model and
#' returns a list of all parameters and the variables by which to stratify
#' the default is to stratify by each variable that shows up in a flow for that parameter
#'
#' @description The model needs to adhere to the structure specified by
#'     the modelbuilder package. Models built using the modelbuilder package
#'     automatically have the right structure. A user can also build a
#'     model list structure themselves following the modelbuilder
#'     specifications. If the user provides a file name, this file needs to
#'     be an RDS file and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object
#'     or file name
#' @return The function returns a stratifier object (a list).
#' @author Andrew Tredennick and Andreas Handel
#' @export

generate_stratifier_list <- function(mbmodel)
{
  #pull out all model parameters
  mod_pars <- unlist(lapply(mbmodel$par, "[[", "parname"))

  #pull out all flow terms
  mod_flows <- unlist(lapply(mbmodel$var, "[[", "flows"))

  #pull out all variable names
  mod_vars <- unlist(lapply(mbmodel$var, "[[", "varname"))

  #loop over parameters, find flows for each parameter
  #determine variables, add to stratification list

  new_strat_list <- list()
  for(ip in 1:length(mod_pars))
  {
    #find flows that contain current parameter
    parflows = mod_flows[grep(mod_pars[ip],mod_flows)]

    #find variables in those flows, add as stratifiers
    pattern = "[-+\\++\\*+\\(+\\)+\\^+/+]"
    flowsymbols = unique(unlist(strsplit(parflows,pattern)))

    #those are the variables that are in the flows for the current parameter
    strata = intersect(mod_vars,flowsymbols)

    new_strat_list[[ip]] <- list(parname = mod_pars[ip],
                               stratify_by = strata)

  } #finish loop over all parameters

  return(new_strat_list)
}  #end of function


