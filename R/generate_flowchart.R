#' @title This function takes as input a modelbuilder model
#'     and creates a diagram using DiagrammeR.
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package
#' models built using the modelbuilder package automatically have the right structure
#' a user can also build a model list structure themselves following the specifications
#' if the user provides an Rds file name, this file needs to contain an object called 'mbmodel'
#' and contain a valid modelbuilder model structure
#' @param mbmodel model structure, either as list object or Rds file name
#' @return The function returns the diagram stored in a variable
#' @author Andreas Handel and Andrew Tredennick
#' @export

generate_flowchart <- function(mbmodel) {
  # Extract relevant details from the mbmodel and make a matrix
  # of variables X flows for iterating and indexing the nodes and
  # connections.
  nvars = length(mbmodel$var)  #number of variables/compartments in model
  varnames <- unlist(lapply(mbmodel$var, "[[", 1))
  vartext = unlist(sapply(mbmodel$var, '[', 2)) #extract variable text as vector
  allflows = sapply(mbmodel$var, '[', 4) #extract flows

  #turns flow list into matrix, adding NA, found it online,
  # not sure how exactly it works
  flowmat = t(sapply(allflows, `length<-`, max(lengths(allflows))))
  flowmatred = sub("\\+|-","",flowmat)   #strip leading +/- from flows
  signmat =  gsub("(\\+|-).*","\\1",flowmat) #extract only the + or - signs from flows so we know the direction

  # Create a node data frame
  ndf <-
    create_node_df(
      n = nvars,  #number of nodes
      label = varnames,  #labels of nodes
      type  = "upper",  #upper case letters for variables
      style = "open",  #an open rectangle
      color = "black",  #rectangle outline
      shape = "rectangle"  #shape of the nodes
    )

  # Create the edge data frame by looping through the variables
  # and associated flows.
  edf <- list()  #an empty list to be coerced to a data frame via rbind
  for(i in 1:nrow(flowmatred)) {
    varflowsfull = flowmat[i,] #all flows with sign for current variable
    varflows = flowmatred[i,] #all flows for current variable
    varflowsigns = signmat[i,] #signs of flows for current variable
    varflows = varflows[!is.na(varflows)] #remove NA entries

    for(j in 1:length(varflows)) {
      currentflowfull = varflowsfull[j] #loop through all flows for variable
      currentflow = varflows[j] #loop through all flows for variable
      currentsign = varflowsigns[j] #loop through all flows for variable

      # Find the variables for which the current flow appears, i.e., what
      # other rows of the matrix does it show up in.
      connectvars <- unname(which(flowmatred == currentflow, arr.ind = TRUE)[,1])

      # If current sign is negative, it is an outflow and goes either the
      # connectvar that is not equal to the current variable id (indexed by i)
      # or it goes to NA (this happens when there is an unspecified death
      # compartment, for example).
      if(currentsign == "-") {
        if(length(connectvars) == 1) {
          cn <- NA  #placeholder for unspecified compartment (deaths, typically)
        } else {
          cn <- connectvars[connectvars!=i]
        }
        tmp <- data.frame(from = i,
                          to = cn,
                          rel = "out",
                          label = currentflow,
                          fontname = "Arial")
        edf <- rbind(edf, tmp)
      }

      # If the current sign is positive AND the flow only shows up in
      # one row of the flow matrix, then this is an inflow external to the
      # system or as a function of the current variable itself. Currently,
      # we assume these arise from the variable itself, but we can extend
      # this functionality later on.
      if(currentsign == "+" & length(connectvars) == 1) {
        if(connectvars == i) {
          tmp <- data.frame(from = NA,
                            to = i,
                            rel = "out",
                            label = currentflow,
                            fontname = "Arial")
          edf <- rbind(edf, tmp)
        }
      }
    }  #end flow loop
  }  #end variable loop

  # Make dummy compartment for all flows in and out of the system.
  # Out of the system first
  numnas <- length(edf[is.na(edf$to), "to"])
  outdummies <- as.numeric(paste0("999", c(1:numnas)))
  edf[is.na(edf$to), "to"] <- outdummies

  # In to the system second
  numnas <- length(edf[is.na(edf$from), "from"])
  indummies <- as.numeric(paste0("888", c(1:numnas)))
  edf[is.na(edf$from), "from"] <- indummies

  # Add dummy compartments to nodes dataframe
  transparent <- rgb(1, 1, 1, 0, names = NULL, maxColorValue = 1)
  exnodes <- data.frame(id = c(outdummies, indummies),
                        type = "upper",
                        label = "",
                        style = "open",
                        color = transparent,
                        shape = "circle")

  ndf <- rbind(ndf, exnodes)

  # Create the DiagrammeR graph object based on the node
  # and edge data frames. We default to graphs being built
  # left-to-right (attr_theme = "lr)
  graph <- create_graph(
    attr_theme = "lr",
    nodes_df = ndf,
    edges_df = edf,
    directed = TRUE
  )

  # Update font for nodes
  graph <- set_node_attrs(
    graph = graph,
    node_attr = "fontname",
    values = "Arial"  #chose Arial b/c it works across operating systems
  )

  # Update edge attributes for color and size of arrows
  graph <- set_edge_attrs(
    graph = graph,
    edge_attr = "color",
    values = "grey35"
  )

  graph <- set_edge_attrs(
    graph = graph,
    edge_attr = "arrowsize",
    values = 0.5
  )

  return(graph)
}

# library(DiagrammeRsvg)
# library(rsvg)
render_graph(graph)
# render_graph(plot)
# })
# export_graph(graph = graph, file_type = "png",
#                        file_name = "../../Desktop/my_crazy_graph.png")
