#' @title The main menu for the modelbuilder package
#'
#' @description This function opens a menu which allows the user to choose build or analyze apps
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
        appDir <- system.file("mainmenu", package = "modelbuilder")
        appname = shiny::runApp(appDir = appDir)
        if (!is.null(appname) & appname != "Exit")     #run the shiny app chosen
        {
            appDirname <- system.file(appname, package = "modelbuilder")
            shiny::runApp(appDir = appDirname)
        }
        if (appname == "Exit") {cond = 0} #leave while loop/menu
    }

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
