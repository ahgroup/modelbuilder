#' Create a stochastic compartmental simulation model
#'
#' This function takes as input a modelbuilder model and writes code
#' for a stochastic simulator function implemented with adaptivetau
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package.
#' Models built using the modelbuilder package automatically have the right structure.
#' A user can also build a model list structure themselves following the modelbuilder specifications.
#' If the user provides a file name, this file needs to be an Rds file
#' and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object or file name
#' @param location a filename and path to save the simulation code to. Default is current directory.
#' @return The function does not return anything
#' Instead, it writes an R file into the specified directory
#' this R file contains a deSolve implementation of the model
#' the name of the file is simulate_model$title_ode.R
#' @author Andreas Handel
#' @export

generate_stochastic <- function(mbmodel, location = NULL)
{
    #if the model is passed in as a file name, load it
    #otherwise, it is assumed that 'mbmodel' is a list structure of the right type
    if (is.character(mbmodel)) {mbmodel = readRDS(mbmodel)}

    #if location is supplied, that's where the code will be saved to
    if (is.null(location))
    {
      savepath = paste0("./simulate_",gsub(" ","_",mbmodel$title),"_stochastic.R")
    }
    else
    {
      #the name of the function produced by this script is simulate_ + "model title" + "_ode.R"
      savepath <- location #default is current directory for saving the R function
    }

    modeltitle = gsub(" ","_",mbmodel$title) #title for model, replacing space with low dash to be used in function and file names

    #generates all the documentation/header information
    sdesc = generate_function_documentation(mbmodel,modeltype = "stochastic")

    #generates text for main function call line and for argument vectors
    textlist <- generate_function_inputs(mbmodel,modeltype = "stochastic")
    stitle = textlist$stitle
    varvec = textlist$varvec
    parvec = textlist$parvec


    ##############################################################################
    #the next block of commands produces the rate functions required by adaptivetau
    varnames = unlist(sapply(mbmodel$var, '[', 1)) #extract variable names as vector
    vartext = unlist(sapply(mbmodel$var, '[', 1)) #extract variable text as vector
    allflows = sapply(mbmodel$var, '[', 4) #extract flows
    #turns flow list into matrix, adding NA, found it online, not sure how exactly it works
    flowmat = t(sapply(allflows, `length<-`, max(lengths(allflows))))
    flowmatred = sub("\\+|-","",flowmat)   #strip leading +/- from flows
    signmat =  gsub("(\\+|-).*","\\1",flowmat) #extract only the + or - signs from flows so we know the direction
    #creating a dataframe of only the rates
    dfRates = as.data.frame(c(flowmat))
    #deleting "NA"s from the dataframe
    dfRates = stats::na.omit(cbind(rep(varnames, ncol(flowmat)), dfRates))
    #extracting coefficient from the rates/flows
    dfRates$coef = paste(substr(dfRates$`c(flowmat)`,1,1), "1", sep = "")
    #new variable of raw flows with no coefficients
    dfRates$noCoefs = stats::na.omit(c(flowmatred))
    #renaming variables in dataframe
    names(dfRates) = c("variable", "flows", "coefs", "rawFlows")
    #ordering the raw flow rates alphabetically
    dfRates = dfRates[order(dfRates$rawFlows),]
    #count() creates dataframe of raw flows and number of times they occur in the model
    rownames(dfRates) = c()
    countsFlows = data.frame(table(dfRates$rawFlows))
    colnames(countsFlows) = c('rawFlows','n')
    # ordering flows by number of occurences
    countsFlows1 = countsFlows[order(-countsFlows$n),]
    #removing rownames
    rownames(countsFlows1) = c()
    #rates list for rate function, pasting unique flows separated by a comma
    ratesList = paste(unique(countsFlows1$rawFlows), sep = ",", collapse =", ")

    # this next block of code produces the transitions between compartments required by adaptive tau
    #countFlows2 creates df of all raw flows, compartment they go into/out of and corresponding compartment/coefficientle
    countsFlows2 = merge(dfRates, countsFlows1, by.x = "rawFlows", by.y = "rawFlows")
    # sort counts of flows in decreasing order
    countsFlows2 = countsFlows2[order(-countsFlows2$n),]
    # new dataset of only flows where it appears more than once
    countsFlowsGT1 = countsFlows2[which(countsFlows2$n > 1), ]
    # deletes all duplicate flows. we are left with rates that are unique
    uniqueFlows = countsFlows2[!duplicated(countsFlows2$rawFlows), ]
    # if there is only one flow for a compartment, paste that transition (compartment 1 to comparment 2)
    # otherwise, replace with NA
    uniqueFlows$trans = ifelse(uniqueFlows$n == 1 , paste0("c(", uniqueFlows$variable, " = ", uniqueFlows$coefs, ")"), "NA")
    # in dataframe where rates that appear more than once, read every other line
    #  extract coefficient of those rates from the first compartment to the next in "trans" variable
    # if line not read by loop, replace it by a NA
    if (nrow(countsFlowsGT1)>0)
    {
      for (i in seq(from = 1, to = (nrow(countsFlowsGT1) - 1), by = 2))
      {
        countsFlowsGT1$trans[i] = paste0("c(", countsFlowsGT1$variable[i], " = ", countsFlowsGT1$coefs[i], ",", countsFlowsGT1$variable[i+1], " = ", countsFlowsGT1$coefs[i+1], ")")
        countsFlowsGT1$trans[i+1] = NA
      }
    }
    # sort the unique flows in decreasing number of appearence
    uniqueFlows = uniqueFlows[order(-uniqueFlows$n), ]
    # take lines where data was read in for loop in countsFlowsGT1 (every other line)
    # and replaces NA's in unique FLow
    uniqueFlows$trans = ifelse(uniqueFlows$trans == "NA", countsFlowsGT1$trans[c(T,F)], uniqueFlows$trans)
    # printing all trans in uniqueFlows separated by a comma
    transitionList = paste(uniqueFlows$trans, sep = ", \n \t \t \t\t\t\t", collapse =", \n \t \t \t\t\t\t")



    # this block of code gives all rates/flows specified in the model structure
    sdisc = "  #Block of ODE equations for adaptivetau \n"
    sdisc = paste0(sdisc,"  ", gsub(" ","_",mbmodel$title),'_fct <- function(y, parms, t) \n  {\n')
    sdisc = paste0(sdisc,"    with(as.list(c(y,parms)),   \n     { \n")#lets us access variables and parameters stored in y and parms by name
    sdisc = paste0(sdisc,"       #specify each rate/transition/reaction that can happen in the system \n")
    sdisc = paste0(sdisc,"     rates = c(", ratesList, ")", "\n")
    sdisc = paste0(sdisc,"     return(rates) \n      }\n", "\t \t)   \n  } # end function specifying rates used by adaptive tau \n")
    sdisc = paste0(sdisc, "\n ")
    sdisc = paste0(sdisc,"  #specify for each reaction/rate/transition how the different variables change \n")
    sdisc = paste0(sdisc,"  #needs to be in exactly the same order as the rates listed in the rate function \n")
    sdisc = paste0(sdisc,"  transitions = list(" )
    sdisc = paste0(sdisc, transitionList, ") \n \n")


    smain = "  ############################## \n"
    smain = paste0(smain,"  #Main function code block \n")
    smain = paste0(smain,"  ############################## \n")
    smain = paste0(smain,'  set.seed(rngseed) #set random number seed for reproducibility \n')
    smain = paste0(smain,"  #Creating named vectors \n")
    smain = paste0(smain,"  varvec = c(", varvec, ") \n")
    smain = paste0(smain,"  parvec = c(", parvec, ") \n")
    smain = paste0(smain,"  #Running the model \n")
    smain = paste0(smain,'  simout = adaptivetau::ssa.adaptivetau(init.values = varvec, transitions = transitions,
                  \t \t \t rateFunc = ',gsub(" ","_",mbmodel$title),'_fct, params = parvec, tf = tfinal) \n')
    smain = paste0(smain,"  #Setting up empty list and returning result as data frame called ts \n")
    smain = paste0(smain,'  result <- list() \n');
    smain = paste0(smain,'  result$ts <- as.data.frame(simout) \n')
    smain = paste0(smain,'  return(result) \n }')
    #finish block that creates main function part
    ##############################################################################

    ##############################################################################
    #write all text blocks to file
    sink(savepath)
    cat(sdesc)
    cat(stitle)
    cat(sdisc)
    cat(smain)
    sink()
}
