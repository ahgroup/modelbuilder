#' Launch a shiny app and pass an object to it
#'
#' This function takes as input an object and makes it available inside the shiny app
#'
#' @description USER CAN ADD MORE DETAILS HERE
#' @param modelfile Name of a model/Rdata file
#' @return Nothing
#' @author Andreas Handel
#' @export

#a solution to pass an object/argument to a shiny app
#adopted from here:
#https://stackoverflow.com/questions/44999615/passing-parameters-into-shiny-server
#https://github.com/asardaes/dtwclust/blob/master/R/SHINY-ssdtwclust.Rhttps://github.com/asardaes/dtwclust/blob/master/R/SHINY-ssdtwclust.R

launch_app <- function(modelfile) {
    #file_path <- system.file("uiapp.R", package = "modelbuilder")
    file_path <- "inst/createui/uiapp.R"
    #browser()

    #if (!nzchar(file_path)) stop("Shiny app not found")
    ui <- server <- NULL # avoid NOTE about undefined globals
    source(file_path, local = TRUE)
    server_env <- environment(server)

    # Here you add any variables that your server can find
    model_path <- paste0("inst/modelexamples/",modelfile)
    load(model_path)
    server_env$model <- model #the model structure
    filename=paste0(gsub(" ","_",model$title),"_desolve.R")
    fct_code <- paste0("inst/modelexamples/",filename)
    source(fct_code) #the function code

    app <- shiny::shinyApp(ui, server)
    shiny::runApp(app)
}
