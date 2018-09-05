#' @title The main menu for the modelbuilder package
#'
#' @description This function opens a GUI which allows the user to build and analyze compartmental models
#'
#' @details Run this function with no arguments to start the main menu
#' @examples
#' \dontrun{modelbuilder()}
#' @author Andreas Handel
#' @import shiny
#' @export

modelbuilder <- function() {
    #appDir <- system.file("createmodels", package = "DSAIDE")
    #appname = shiny::runApp(appDir = appDir)
    #appDirname <- system.file("shinyapps", appname, package = "DSAIDE")

    shiny::runApp(appDir = appDirname)

  print('*************************************************')
  print('Exiting the modelbuilder GUI.')
  print('Good luck with your further modeling efforts!')
  print('*************************************************')
}

#needed to prevent NOTE messages on CRAN checks
utils::globalVariables(c("xvals", "yvals", "varnames","IDvar","style"))

.onAttach <- function(libname, pkgname){
  packageStartupMessage("Welcome to the modelbuilder package. Type modelbuilder() to get started.")
}
