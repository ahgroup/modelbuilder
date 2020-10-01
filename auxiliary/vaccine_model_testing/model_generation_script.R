# Example script on how to build the (models)
# Make sure you have a recent version of modelbuilder - reinstall frequently
# Install the remotes package (once)
# Then install modelbuilder using remotes::install_github('ahgroup/modelbuilder')


#load modelbuilder since we use functionality from there
library("modelbuilder")
library("here") #for easy path access relative to project root directory

basepath = here("auxiliary/vaccine_model_testing")

#load the base model we want to work with
#needs to be a modelbuilder mbmodel
modelname <- paste0(basepath, "/base_models/Coronavirus_vaccine_model_v2.Rds"); covac=1;
modelname <- paste0(basepath, "/base_models/COVAX1.Rds"); covac=1;
#modelname <- paste0(basepath, "/base_models/SIRSd2.Rds")
mbmodel <- readRDS(modelname)

#this runs the model through a checker to make sure it has a valid structure
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(mbmodel)
if (!is.null(checkerror))
{
  print(checkerror)
}

###############################################################################
# If base model is valid, we can go on to specify the stratifications we want
# Specify various stratifications here
# One can choose below which ones to use
# The user specifies the strata which should be generated
# This needs to be done manually for each stratification
# The structure is a list that contains the label given to the stratification,
# the name for each stratum, and labels, which will be appended to all stratified model parameters and variables
###############################################################################

risk_stratum_list <- list(
  stratumname = "risk",
  names = c("high risk", "low risk"),
  labels = c("h", "l"),
  comment = "This defines the risk structure."
)

age_stratum_list <- list(
  stratumname = "age",
  names = c("children", "adults", "elderly"),
  labels = c("c", "a", "e"),
  comment = "This defines the age structure."
)

vaccine_stratum_list <- list(
  stratumname = "vaccine",
  names = c("unvaccinated", "vaccinated"),
  labels = c("uv", "v"),
  comment = "This defines the vaccination structure."
)


#combine all possible stratifications in a list of lists
complete_list = list(risk_stratum_list,age_stratum_list,vaccine_stratum_list)

# specify which ones we want to do
# need to be a subset of above defined strata and labeled by stratumname
wanted_stratifications = c("vaccine","age")

# loop to do each stratification at a time
for (st in 1:length(wanted_stratifications))
{
  # pull out the stratum list for the current stratification that's being processed
  id = which(unlist(lapply(complete_list, "[[", "stratumname")) == wanted_stratifications[st])
  stratum_list = complete_list[[id]]

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


  # for COVID models, a manual intervention to change the stratifier levels of the nu parameter
  # should only be stratified by "S"
  if (covac==1)
  {
    id = which(unlist(lapply(par_stratify_list, "[[", "parname")) == "nu")
    par_stratify_list[[id]]$stratify_by <- "S"
  }
  # for COVID model, a manual intervention to change the stratifier levels of the nu parameter
  # should only be stratified by "S"
  if (covac==1)
  {
    id = which(unlist(lapply(par_stratify_list, "[[", "parname")) == "nu_Sh")
    par_stratify_list[[id]]$stratify_by <- "Sh"
    id = which(unlist(lapply(par_stratify_list, "[[", "parname")) == "nu_Sl")
    par_stratify_list[[id]]$stratify_by <- "Sl"
  }

  # Now expand the model by the specified strata
  # The model that is returned is again a modelbuilder structure (a long list object)
  # The new name/title of the model is the old one appended with _stratumname
  # All stratified parameters and variables are set to the same value as the original unstratified ones
  mbmodel <- modelbuilder::generate_stratified_model(
    mbmodel = mbmodel,
    stratum_list = stratum_list,
    par_stratify_list = par_stratify_list
  )

  #code snippets to look at various model components before and after
  #stratification
  #for development/testing only
  #unlist(lapply(mbmodel$par, "[[", "parname"))
  #unlist(lapply(mbmodel$var, "[[", "flows"))

  #The stratification procedure is repeated for every new stratification we want to include
  # Since the model produced by the generate_stratified_model function has exactly the same mbmodel structure as the start model,
  # everything proceeds the same as going from the base model to the first stratified one
  # the order of stratification should not matter, the produced model should be the same
  # however, the naming of parameter and variables will change based on stratification order
  # labels for new strata are always appended at the end of any variable/parameter name

} #finish loop that does the various stratifications


#check to make sure the newly generated model is still a valid modelbuilder object
#if not valid, a hopefully meaningful error message is returned
# currently doesn't stop script, so rest will likely not work either
checkerror <- modelbuilder::check_model(mbmodel)
if (!is.null(checkerror))
{
  print(checkerror)
}

# Once all stratifications are done, save the new model
# Also generate/save tables of initial conditions and parameter values for manual filling

#save newly generated model as Rds file
#place it into the stratified models folder
filename = paste0(final_model$title,'.Rds')
saveRDS(final_model, file = paste0(basepath,"/stratified_models/", filename))

# run a function that generates CSV files for initial conditions and parameters
# this function works for any modelbuilder object
# Parameter and initial condition values are set to the values of mbmodel
# these spreadsheets are meant to be moved by hand to the filled_tables folder and filled
savelocation = paste0(basepath,'/generated_tables/')
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
savelocation = paste0(basepath,'/stratified_models/')
modelbuilder::generate_ode(mbmodel = final_model, location = savelocation)

#at this stage the new model has been generated and saved as an Rds file
#CSV files that contain tables for parameter values have been created for manual filling
#code that implements the model as a set of ODEs has been generated

#Next step is to use the model, as illustrated in the model_analysis_script


