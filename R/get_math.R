#' Extract the math symbols from a flow
#'
#' This function takes as input a modelbuilder flow and
#' extracts the math symbols/notation.
#'
#' @description The flow must be a character string of typical modelbuilder
#'     model structure. The function also concatenates parentheses and
#'     the notation before and after them as necessary.
#' @param flow A modelbuilder flow, which is a character string.
#' @param flowsymbols A character vector of the flow variables and parameters,
#'    as returned from \code{get_vars_pars}.
#' @return A character vector of the math symbols, in order.
#' @author Andrew Tredennick and Andreas Handel
#' @export

get_math <- function(flow, flowsymbols) {
  #extract just the math symbols, in order, from the flows by
  #removing all characters associated with the variables and parameters
  varparpattern <- paste0("[", paste(flowsymbols, collapse = ""), "]")
  flowmath <- gsub(pattern = varparpattern,
                   replacement = "",
                   x = flow)
  #break apart the math symbol string into a character vector
  #such that individual elements can be pasted back in order
  flowmath <- unlist(strsplit(flowmath, ""))

  #need to combine parentheses with the math symbol
  #before (opening) or after (closing) such that order
  #of operations is correct.
  #NOTE: THIS IS NOT GENERALIZABLE YET
  opens <- which(flowmath == "(")  #check for parentheses

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

    #follow similar logic for the closing parentheses, but
    #attach the match symbols following the parenthesis
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

  return(flowmath)
}
