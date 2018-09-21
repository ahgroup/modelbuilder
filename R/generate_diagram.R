#' Create a diagram for a model
#'
#' This function takes as input a modelbuilder model
#' and creates a diagram using the diagrammer pacakge
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package
#' models built using the modelbuilder package automatically have the right structure
#' a user can also build a model list structure themselves following the specifications
#' if the user provides an Rdata file name, this file needs to contain an object called 'model'
#' and contain a valid modelbuilder model structure
#' @param model model structure, either as list object or Rdata file name
#' @return The function returns the diagrammer diagram
#' @author Andreas Handel
#' @export

generate_diagram <- function(model)
{

    #if the model is passed in as an Rdata file name, load it
    #otherwise, it is assumed that 'model' is a list structure of the right type
    if(is.character(model)) {load(model)}

    nvars = length(model$var)  #number of variables/compartments in model
    npars = length(model$par)  #number of parameters in model
    ntime = length(model$time) #numer of parameters for time

    varnames = unlist(sapply(model$var, '[', 1)) #extract variable names as vector
    vartext = unlist(sapply(model$var, '[', 2)) #extract variable text as vector

    ndf <-
        create_node_df(
            n = nvars,
            label = vartext,
            shape = c("rectangle")
            )

    edf <-
        create_edge_df(
            from = c(1, 2),
            to = c(2, 3),
            rel = "leading_to")


    modelgraph <-create_graph(nodes_df = ndf, edges_df = edf)

    render_graph(modelgraph, layout = "tree")

}
