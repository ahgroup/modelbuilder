# Script to test development generate_flowchart function

library(modelbuilder)

mbmodel <- readRDS("./inst/modelexamples/SIRSd_model.rds")
flowchart <- generate_flowchart(mbmodel, code_path = "./auxiliary/development/")

# print the flowchart
flowchart$flowchart

# examine input dataframes
flowchart$dataframes

# look at ggplot2 code
ggcode <- readLines("./auxiliary/development/ggplot2_code.txt")
ggcode  # best option is to copy the code from the text file into an R script
