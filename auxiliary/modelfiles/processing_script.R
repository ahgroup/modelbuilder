basepath = here::here()

#code exists that can start with an R file which encodes a modelbuilder object in plain (R) text,
#or with and Rds object that stores a modelbuilder object

#If one edits/updates a model through the UI and saves as Rds, one should run the code that turns Rds into R script and the exports as functions (as needed)
#if one edits/updates a model by editing the file.R code, one should run the code below that turns it into an Rds file, then export as functions (as needed)

############################################################
#load RDS files, create file.R files that encode model
#"inverse" of next code snippet
files = list.files(path = paste0(basepath, "/auxiliary/modelfiles/"), pattern = "\\.Rds$", full.names = TRUE)
for (n in 1: length(files))
{
    generate_model_file(files[n])
}


############################################################
#load file.R text model files, save them as Rds files
#"inverse" of above code
files = list.files(path = paste0(basepath, "/auxiliary/modelfiles/"), pattern = "file.R$", full.names = TRUE)
for (n in 1: length(files))
{
    source(files[n])
    mbmodelerrors <- modelbuilder::check_model(mbmodel)
    if (!is.null(mbmodelerrors))
    {
        print(mbmodelerrors)
        stop()
    }
    modelname = gsub(' ','_',mbmodel$title)
    rdatafile = paste0(basepath, "/auxiliary/modelfiles/",modelname,'.Rds')
    saveRDS(mbmodel,file = rdatafile)
}


############################################################
#load RDS files, export as code
files = list.files(path = paste0(basepath, "/auxiliary/modelfiles/"), pattern = "\\.Rds$", full.names = TRUE)
for (n in 1: length(files))
{
    mbmodel = readRDS(files[n])
    destpath = paste0(here::here('auxiliary/modelfiles'),'/')
    generate_discrete(mbmodel,location = destpath, filename = NULL)
    generate_ode(mbmodel,location = destpath, filename = NULL)
    generate_stochastic(mbmodel,location = destpath, filename = NULL)
}



