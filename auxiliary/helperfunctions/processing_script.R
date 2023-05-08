library(here)
library(modelbuilder)

#modelfilepath = here::here('auxiliary/modelfiles')
#modelfilepath = here::here('auxiliary/modelfiles/DSAIDE')
#modelfilepath = here::here('auxiliary/modelfiles/DSAIRM')
modelfilepath = here::here('auxiliary/modelfiles/other')

#code exists that can start with an R file which encodes a modelbuilder object in plain (R) text,
#or with and Rds object that stores a modelbuilder object

#If one edits/updates a model through the UI and saves as Rds, one should run the code that turns Rds into R script and the exports as functions (as needed)
#if one edits/updates a model by editing the file.R code, one should run the code below that turns it into an Rds file, then export as functions (as needed)


############################################################
#load file.R text model files, save them as Rds files
#"inverse" of below  code
files = list.files(path = modelfilepath, pattern = "file.R$", full.names = TRUE)
#files = "D:/Github/ahgroup/modelbuilder/auxiliary/modelfiles/Stratified_Inoculum_Model_file.R"
#files = "D:/Github/ahgroup/modelbuilder/auxiliary/modelfiles/other/Influenza_OAS_Model_file.R"
for (n in 1: length(files))
{
    source(files[n])
    #print(files[n])
    mbmodelerrors <- modelbuilder::check_model(mbmodel)
    if (!is.null(mbmodelerrors))
    {
        print(mbmodelerrors)
        stop()
    }
    modelname = gsub(' ','_',mbmodel$title)
    rdatafile = paste0(modelfilepath, "/",modelname,'.Rds')
    saveRDS(mbmodel,file = rdatafile)
}



############################################################
#load RDS files, create file.R files that encode model
#"inverse" of next code snippet
files = list.files(path = modelfilepath, pattern = "\\.Rds$", full.names = TRUE)
#files = "D:/Github/ahgroup/modelbuilder/auxiliary/modelfiles/Basic_Inoculum_Model.rds"
for (n in 1: length(files))
{
    modelbuilder::generate_model_file(files[n], location = modelfilepath )
}


############################################################
#load RDS files, export as code
files = list.files(path = modelfilepath, pattern = "\\.Rds$", full.names = TRUE)
#files = "D:/Github/ahgroup/modelbuilder/auxiliary/modelfiles/Stratified_Inoculum_Model.Rds"
#files = "D:/Github/ahgroup/modelbuilder/auxiliary/modelfiles/Basic_Inoculum_Model.rds"
simfilepath = paste0(modelfilepath,'/simulators')
for (n in 1: length(files))
{
    mbmodel = readRDS(files[n])
    modelbuilder::generate_discrete(mbmodel,location = simfilepath, filename = NULL)
    modelbuilder::generate_ode(mbmodel,location = simfilepath, filename = NULL)
    modelbuilder::generate_stochastic(mbmodel,location = simfilepath, filename = NULL)
}


