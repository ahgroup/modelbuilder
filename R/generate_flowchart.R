#' @title This function takes as input a modelbuilder model
#'     and creates a diagram using DiagrammeR.
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package
#' models built using the modelbuilder package automatically have the right structure
#' a user can also build a model list structure themselves following the specifications
#' if the user provides an Rds file name, this file needs to contain an object called 'mbmodel'
#' and contain a valid modelbuilder model structure
#' @param mbmodel model structure, either as list object or Rds file name
#' @param code_path path where ggplot2 code will be written
#' @return The function returns the diagram stored in a variable
#' @author Andreas Handel and Andrew Tredennick
#' @import ggplot2
#' @importFrom grDevices rgb
#' @export

generate_flowchart <- function(mbmodel, code_path = NULL) {

  # define path for ggplot2 code if not provided and warn the
  # user of path this function sees
  if(is.null(code_path)) {
    code_path <- getwd()
    warning(paste("ggplot2 code being written to current working directory,\n",
                  getwd()))
  } else {
    warning(paste("ggplot2 code being written to", code_path))
  }

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
    data.frame(
      id = 1:nvars,  #number of nodes
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

      # Extract the variable names
      varspars <- unique(get_vars_pars(currentflowfull))
      vars <- varspars[which(varspars %in% LETTERS)]

      # If the flow does not show up in any other rows BUT starts with
      # a plus sign, then the donating node will be the state variable
      # in the flow
      if(currentsign == "+") {
        if(length(connectvars) == 1 & length(vars) == 0) {
          connectvars <- i
        }
        if(length(connectvars) == 1 & length(vars) >= 1){
          if(!varnames[i] %in% vars) {
            connectvars <- i
          }
          if(varnames[i] %in% vars) {
            connectvars <- c(i, i)
          }
        }
        if(length(connectvars) > 1) {
          connectvars <- connectvars
        }
      }

      # if(length(connectvars) == 1 & currentsign == "+") {
      #   varspars <- get_vars_pars(currentflow)
      #   var <- varspars[which(varspars %in% LETTERS)]
      #   cnnew <- which(varnames == var)
      #   if(length(cnnew) == 1) {
      #     connectvars <- c(connectvars, cnnew)
      #   } else {
      #     connectvars <- c(i, i)
      #   }
      # }

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
      if(currentsign == "+" & length(connectvars) == 2) {
        if(length(unique(connectvars)) == 1) {
          tmp <- data.frame(from = i,
                            to = i,
                            rel = "out",
                            label = currentflow,
                            fontname = "Arial")
        } else {
          tmp <- data.frame(from = connectvars[connectvars!=i],
                            to = i,
                            rel = "out",
                            label = currentflow,
                            fontname = "Arial")
        }
        edf <- rbind(edf, tmp)
      }
    }  #end flow loop
  }  #end variable loop

  # Make dummy compartment for all flows in and out of the system.
  # Out of the system first
  exdummies <- NULL
  numnas <- length(edf[is.na(edf$to), "to"])
  if(numnas > 0) {
    outdummies <- as.numeric(paste0("999", c(1:numnas)))
    edf[is.na(edf$to), "to"] <- outdummies
  }

  # In to the system second
  indummies <- NULL
  numnas <- length(edf[is.na(edf$from), "from"])
  if(numnas > 0) {
    indummies <- as.numeric(paste0("-999", c(1:numnas)))
    edf[is.na(edf$from), "from"] <- indummies
  }


  # Add dummy compartments to nodes dataframe
  if(is.numeric(exdummies) | is.numeric(indummies)) {
    transparent <- rgb(1, 1, 1, 0, names = NULL, maxColorValue = 1)
    exnodes <- data.frame(id = c(outdummies, indummies),
                          type = "upper",
                          label = "",
                          style = "open",
                          color = transparent,
                          shape = "circle")
    ndf <- rbind(ndf, exnodes)
  }

  # Keep only distinct rows
  edf <- unique(edf)

  # Add x and y locations for the nodes
  ndf <- ndf[order(ndf$id), ]
  ndf$x <- 1:nrow(ndf)*3
  ndf$y <- 1

  # update inflow node positions from nowhere
  inflownodes <- subset(ndf, id < -9990)$id
  for(id in inflownodes) {
    newxyid <- edf[which(edf$from == id), "to"]
    newxy <- ndf[which(ndf$id == newxyid), c("x", "y")]
    newxy$y <- newxy$y + 2
    ndf[which(ndf$id == id), c("x", "y")] <- newxy
  }

  # update outflow node positions to nowhere
  outflownodes <- subset(ndf, id > 9990)$id
  for(id in outflownodes) {
    newxyid <- edf[which(edf$to == id), "from"]
    newxy <- ndf[which(ndf$id == newxyid), c("x", "y")]
    newxy$y <- newxy$y - 2
    ndf[which(ndf$id == id), c("x", "y")] <- newxy
  }

  # Create segment coordinates
  edf <- merge(edf, ndf[ , c("x", "y", "id")], by.x = "from", by.y = "id")
  edf <- merge(edf, ndf[ , c("x", "y", "id")], by.x = "to", by.y = "id",
               suffixes = c("start", "end"))
  edf$xmid <- with(edf, (xend + xstart) / 2)
  edf$ymid <- with(edf, (yend + ystart) / 2) + 0.25
  edf$diff <- with(edf, abs(to-from))

  cdf <- subset(edf, diff > 1 & diff < 9000)
  sdf <- subset(edf, diff <= 1 | diff >= 9000)
  vdf <- subset(sdf, abs(diff) >= 9990)
  sdf <- subset(sdf, abs(diff) < 9990)
  nrow(vdf) + nrow(sdf) + nrow(cdf) == nrow(edf)

  # now drop "hidden" nodes without labels
  ndf <- subset(ndf, label != "")


  outplot <- ggplot() +
    geom_tile(data = ndf,
              aes(x = x, y = y),
              color = "black",
              fill = "white",
              width = 1,
              height = 1) +
    geom_text(data = ndf,
              aes(x = x, y = y, label = label),
              size = 8) +
    geom_segment(data = sdf,
                 aes(x = xstart+0.5, y = ystart, xend = xend-0.5, yend = yend),
                 arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
                 arrow.fill = "black",
                 lineend = "round",
                 linejoin = "mitre") +
    geom_text(data = sdf,
              aes(x = xmid, y = ymid, label = label)) +
    geom_segment(data = vdf,
                 aes(x = xstart, y = ystart-0.5, xend = xend, yend = yend+0.5),
                 arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
                 arrow.fill = "black",
                 lineend = "round",
                 linejoin = "mitre") +
    geom_text(data = vdf,
              aes(x = xmid+0.25, y = ymid, label = label)) +
    geom_curve(data = cdf,
               aes(x = xstart, y = ystart+0.5, xend = xend, yend = yend+0.5),
               arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
               arrow.fill = "black",
               lineend = "round") +
    geom_text(data = cdf,
              aes(x = xmid, y = ymid + 2, label = label)) +
    coord_equal() +
    theme_void()

  ggcode <- 'ggplot() +
    geom_tile(data = ndf,
              aes(x = x, y = y),
              color = "black",
              fill = "white",
              width = 1,
              height = 1) +
    geom_text(data = ndf,
              aes(x = x, y = y, label = label),
              size = 8) +
    geom_segment(data = sdf,
                 aes(x = xstart+0.5, y = ystart, xend = xend-0.5, yend = yend),
                 arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
                 arrow.fill = "black",
                 lineend = "round",
                 linejoin = "mitre") +
    geom_text(data = sdf,
              aes(x = xmid, y = ymid, label = label)) +
    geom_segment(data = vdf,
                 aes(x = xstart, y = ystart-0.5, xend = xend, yend = yend+0.5),
                 arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
                 arrow.fill = "black",
                 lineend = "round",
                 linejoin = "mitre") +
    geom_text(data = vdf,
              aes(x = xmid+0.25, y = ymid, label = label)) +
    geom_curve(data = cdf,
               aes(x = xstart, y = ystart+0.5, xend = xend, yend = yend+0.5),
               arrow = arrow(length = unit(0.25,"cm"), type = "closed"),
               arrow.fill = "black",
               lineend = "round") +
    geom_text(data = cdf,
              aes(x = xmid, y = ymid + 2, label = label)) +
    coord_equal() +
    theme_void()'

  sink(paste0(code_path, "ggplot2_code.txt"))
  cat(ggcode)
  sink()

  outlist <- list(flowchart = outplot,
                  dataframes = list(nodes = ndf,
                                    horizontal_edges = sdf,
                                    vertical_edge = vdf,
                                    curved_edges = cdf))

  return(outlist)
}

# library(DiagrammeRsvg)
# library(rsvg)
# render_graph(graph)
# render_graph(plot)
# })
# export_graph(graph = graph, file_type = "png",
#                        file_name = "../../Desktop/my_crazy_graph.png")







# # Create the DiagrammeR graph object based on the node
# # and edge data frames. We default to graphs being built
# # left-to-right (attr_theme = "lr)
# graph <- create_graph(
#   attr_theme = "lr",
#   nodes_df = ndf,
#   edges_df = edf,
#   directed = TRUE
# )
#
# # Update font for nodes
# graph <- set_node_attrs(
#   graph = graph,
#   node_attr = "fontname",
#   values = "Arial"  #chose Arial b/c it works across operating systems
# )
#
# # Update edge attributes for color and size of arrows
# graph <- set_edge_attrs(
#   graph = graph,
#   edge_attr = "color",
#   values = "grey35"
# )
#
# graph <- set_edge_attrs(
#   graph = graph,
#   edge_attr = "arrowsize",
#   values = 0.5
# )
#
# return(graph)
