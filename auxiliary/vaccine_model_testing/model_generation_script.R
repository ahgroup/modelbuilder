# Example script on how to build the (models)
# Make sure you have a recent version of modelbuilder - reinstall frequently
# Install the remotes package (once)
# Then install modelbuilder using remotes::install_github('ahgroup/modelbuilder')


#load modelbuilder since we use functionality from there
library("modelbuilder")
library("here") #for easy path access relative to project root directory

#load the base model we want to work with
#needs to be a modelbuilder mbmodel
#modelname <- here("code", "base_models","Coronavirus_vaccine_model_v2.Rds")
#modelname <- here("auxiliary/vaccine_model_testing", "base_models","SIRSd_model.Rds")
modelname <- here("auxiliary/vaccine_model_testing", "base_models","SIRSd2.Rds")
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

# First, we specify for each parameter the variables according to which it sould be stratified
# calling the function below generates defaults
# as default, every parameter is stratified based on the variables in the flow it appears
# e.g. if we had dS/dt = n - m*S - b*S*I
# the parameter n would not be stratified at all
# the parameter m would be stratified by S
# the parameter b would be stratified by S and I
# the following function sends in a model and returns the variables by which each parameter should be stratified
# the function returns a list, which each main list entry containing 2 elements,
# the name of the parameter and the name of the variables by which it should be stratified
# this list can be modified by the user before it is supplied to the function that generates the stratified model
par_stratify_list <- modelbuilder::generate_stratifier_list(mbmodel)


# Next, the user specifies the strata which should be generated
# This needs to be done manually for each stratification
# The structure is a list that contains the label given to the stratification,
# the name for each stratum, and labels, which will be appended to all stratified model parameters and variables

# This is an example of such a stratification with 2 risk groups

stratum_list <- list(
  stratumname = "risk",
  names = c("high risk", "low risk"),
  labels = c("h", "l"),
  comment = "This defines the risk structure."
)

# Now expand the model by strata the specified strata
# The model that is returned is again a modelbuilder structure (a long list object)
# The new name/title of the model is the old one appended with _stratumname
# All stratified parameters and variables are set to the same value as the original unstratified ones
mbmodel_new <- modelbuilder::generate_stratified_model(
                                  mbmodel = mbmodel,
                                  stratum_list = stratum_list,
                                  par_stratify_list = par_stratify_list
)

#code snippets to look at old and new model parameters
#for development/testing only
#unlist(lapply(mbmodel$par, "[[", "parname"))
#unlist(lapply(mbmodel_new$par, "[[", "parname"))

#check to make sure newly generated model is still a valid modelbuilder object
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(mbmodel_new)
if (!is.null(checkerror))
{
  print(checkerror)
}


#######################################################
#The stratification procedure is repeated for every new stratification we want to include
# Since the model produced by the generate_stratified_model function has exactly the same mbmodel structure as the start model,
# everything proceeds the same as going from the base model to the first stratified one
# the order of stratification should not matter, the produced model should be the same
# however, the naming of parameter and variables will change based on stratification order
# labels for new strata are always appended at the end of any variable/parameter name

# First we again generate a list of parameters and the variables according to which stratification should occur
# Could be adjusted manually if wanted
par_stratify_list <- modelbuilder::generate_stratifier_list(mbmodel_new)

# now specify next level of stratification, this time done by age
stratum_list <- list(
  stratumname = "age",
  names = c("children", "adults", "elderly"),
  labels = c("c", "a", "e"),
  comment = "This defines the age structure."
)

final_model <- modelbuilder::generate_stratified_model(
                                        mbmodel = mbmodel_new,
                                        stratum_list = stratum_list,
                                        par_stratify_list = par_stratify_list)

#check to make sure newly generated model is still a valid modelbuilder object
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(final_model)
if (!is.null(checkerror))
{
  print(checkerror)
}

# More stratifications could be applied here, following the same pattern as above
# 1. Specify for each parameter the variables that it should be stratified on
# This can happen with the generate_stratifier_list function or manually (or a mix of those)
# 2. Specify strata as a list
# 3. Send strata list and stratifier list to generate_stratified_model function


# Once all stratifications are done, save the new model
# Also generate/save tables of initial conditions and parameter values for manual filling

#save newly generated model as Rds file
#place it into the stratified models folder
filename = paste0(final_model$title,'.Rds')
saveRDS(final_model, file = here("code/stratified_models", filename))

# run a function that generates CSV files for initial conditions and parameters
# this function works for any modelbuilder object
# Parameter and initial condition values are set to the values of mbmodel
# these spreadsheets are meant to be moved by hand to the filled_tables folder and filled
savelocation = here('code/generated_tables/')
modelbuilder::generate_tables(mbmodel = final_model, location = savelocation)

# run a function that generates a text file of all the flows in the model
# this is not needed for any functionality
# this can be useful for development/debugging
# this can be useful for checking subscripting
#savelocation = here('code/stratified_models/')
#modelbuilder::export_flows(mbmodel = final_model, location = savelocation)

#create R code for the model
#this takes the model and writes the R code for a function implemented as ODE or discrete time or stochastic model
#the function will be saved to the current directory
savelocation = here('code/stratified_models/')
modelbuilder::generate_ode(mbmodel = final_model, location = savelocation)

#at this stage the new model has been generated and saved as an Rds file
#CSV files that contain tables for parameter values have been created for manual filling
#code that implements the model as a set of ODEs has been generated

#Next step is to use the model, as illustrated in the model_analysis_script


