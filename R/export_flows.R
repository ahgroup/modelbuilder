#' Exports all flows to a text file
#'
#' @description The model needs to adhere to the structure specified by
#'     the modelbuilder package. Models built using the modelbuilder package
#'     automatically have the right structure. A user can also build a
#'     model list structure themselves following the modelbuilder
#'     specifications. If the user provides a file name, this file needs to
#'     be an RDS file and contain a valid modelbuilder model structure.
#' @param mbmodel modelbuilder model structure, either as list object
#'     or file name
#' @param location a path to save the simulation code to. If NULL,
#'     defaults to current directory.
#' @return The function does not return anything. Rather, it saves a
#'     text file in the specified location that includes all the flows
#'     line-by-line.
#' @author Andrew Tredennick and Andreas Handel
#' @export

export_flows <- function(mbmodel, location = NULL)
{
  filename = paste0("flows_", mbmodel$title,".txt")

  #if location is supplied, that's where the code will be saved to
  #if location is NULL, it will be the current directory
  file_path_and_name <- filename
  if (!is.null(location))
  {
    file_path_and_name <- file.path(location,filename)
  }

  #open the text file
  sink(file_path_and_name)

  #loop over vars and print the flows
  vars <- mbmodel$var
  for(i in 1:length(vars)) {
    cat(paste(vars[[i]]$flows, collapse = "\n"))
    cat("\n\n")
  }
  sink()
}
