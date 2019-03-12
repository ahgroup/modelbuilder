#' @title Load the main menu for the modelbuilder package
#'
#' @description This function opens a shiny app menu which allows the user to build or analyze models
#'
#' @details Run this function with no arguments to start the main menu
#' @examples
#' \dontrun{modelbuilder()}
#' @author Andreas Handel
#' @import shiny
#' @export

modelbuilder <- function() {
  cond <- 1
  while (cond == 1)
  {
    appname <- NULL
    appDir <- system.file("modelbuilder", package = "modelbuilder")
    appname = shiny::runApp(appDir = appDir, launch.browser= TRUE)
    if (!is.null(appname) & appname != "Exit")     #run the shiny app chosen
    {
      appDirname <- system.file(appname, package = "modelbuilder")
      shiny::runApp(appDir = appDirname, launch.browser= TRUE)
    }
    if (appname == "Exit") {cond = 0} #leave while loop/menu
  }
  print('*************************************************')
  print('Exiting the modelbuilder interface.')
  print('Good luck with all your modeling efforts!')
  print('*************************************************')
}

#needed to prevent NOTE messages on CRAN checks
utils::globalVariables(c("xvals", "yvals", "varnames","IDvar","style","time"))


.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to the modelbuilder package. Type modelbuilder() to get started.")
}
