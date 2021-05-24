#Instructions for deployment of the package to shinyappsio
#to deploy, follow these steps:
#1. set working directory to folder where this file (app.R) resides
#3. install the package through CRAN or github if we want to use the github version
#devtools::install_github('ahgroup/modelbuilder')
#4. uncomment the library() command below
#this line of code needs to be uncommented  for shinyappsio deployment
#should not be present for regular package use
#library('modelbuilder')
#5. deploy by running the following
#run rsconnect::deployApp()

##############################################
#This is the Shiny App for the main menu of the modelbuilder package

packagename = "modelbuilder"

#make this a non-reactive global variable
mbmodel = NULL


#list of all example models that are provided and can be loaded
examplemodeldir = system.file("modelexamples", package = packagename) #find path to apps

allexamplemodels = c("none",list.files(examplemodeldir))

# Source all necessary functions
for(i in list.files("./R/")){
  source(paste0("./R/", i))
}

# Attach necessary packages
library(DiagrammeR)
library(ggplot2)
library(plotly)
library(shiny)

# End script
