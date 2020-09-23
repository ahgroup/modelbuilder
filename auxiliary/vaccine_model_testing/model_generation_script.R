# Example script on how to build the (models)
# Make sure you have a recent version of modelbuilder - reinstall frequently
# Install the remotes package (once)
# Then install modelbuilder using remotes::install_github('ahgroup/modelbuilder')


#load modelbuilder since we use functionality from there
library("modelbuilder")
library("here") #for easy path access relative to project root directory

#load the base model we want to work with
#needs to be a modelbuilder mbmodel
modelname <- here("code/base_models","Coronavirus_vaccine_model_v2.Rds")
mbmodel <- readRDS(modelname) 

#this runs the model through a checker to make sure it has a valid structure
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(mbmodel)
if (!is.null(checkerror))
{
  print(checkerror)
}

# If base model is valid, we can go on to specify the stratifications we want
# Set up the stratification list
# This is just an example...
strata_list <- list(
  list(
    stratumname = "age",
    names = c("children", "adults", "elderly"),
    labels = c("c", "a", "e"),
    comment = "This defines the age structure."
  ),
  list(
    stratumname = "risk",
    names = c("high risk", "low risk"),
    labels = c("h", "l"),
    comment = "This defines the risk structure."
  )
)


# Now expand the model by strata the specified strata
# The model that is returned is again a modelbuilder structure (a long list object) 
mbmodel_new <- modelbuilder::generate_stratified_model(
  mbmodel = mbmodel, 
  strata_list = strata_list
)

#check to make sure newly generated model is still a valid modelbuilder object
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(mbmodel_new)
if (!is.null(checkerror))
{
  print(checkerror)
}

#save newly generated model into rds file
filename = paste0(mbmodel_new$title,'.Rds')
saveRDS(mbmodel_new, file = here("code/stratified_models", filename))

# run a function that generates CSV files for initial conditions and paramaeters
# are being filled with the current values of mbmodel, can be adjusted
savelocation = here('code/generated_tables/')
modelbuilder::generate_tables(mbmodel = mbmodel_new, location = savelocation)

# run a function that generates a text file of all the flows in the model
# this can be useful for checking subscripting
savelocation = here('code/stratified_models/')
modelbuilder::export_flows(mbmodel = mbmodel_new, location = savelocation)

#create R code for the model
#will be saved to the current directory
savelocation = here('code/stratified_models/')
modelbuilder::generate_ode(mbmodel = mbmodel_new, location = savelocation)

#at this stage the new model has been generated and saved as an Rds file
#CSV files that contain tables for parameter values have been created for manual filling
#code that implements the model as a set of ODEs has been generated

#Next step is to use the model, as illustrated in the model_analysis_script

