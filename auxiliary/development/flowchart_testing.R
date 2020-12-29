# Script to test development generate_flowchart function

library(modelbuilder)
library(tidyverse)

mbmodel <- readRDS("./inst/modelexamples/Basic_Bacteria_model.Rds")
flowchart <- generate_flowchart(mbmodel)

# print the flowchart
flowchart$flowchart

# examine input dataframes
flowchart$dataframes

# look at ggplot2 code
cat(flowchart$ggplot_code)

# add to the ggplot
flowchart$flowchart +
  ggtitle("My Awesome Diagram", subtitle = "")
