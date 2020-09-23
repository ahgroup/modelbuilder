# Example script for analyzing a model

#load modelbuilder 
library("modelbuilder")
library("here") #for easy path access relative to project root directory

#specify the simulation model code to use
#the model/code has likely been generated with the generation script, but that doesn't need to be the case
#any code for an mbmodel (or really any code function that has the right structure) should work


modelname <- here("code/stratified_models","simulate_Coronavirus_vaccine_model_v2_stratified_ode.R")
source(modelname) 

#these are initial and parameter value spreadsheets 
#they contain the parameters for the model
#note that the model has default parameters, so if some are not provided
#defaults are used. that might not be wanted
#the file names should be changed to be those needed for the model
#also note that the files are not read from the folder into which they are placed when
#they are produced with the generation script. this is to prevent accidental overwrites
#of already filled tables
inivalfile = here('code/filled_tables','variable_table_Coronavirus_vaccine_model_v2_stratified.csv')
parvalfile = here('code/filled_tables','parameter_table_Coronavirus_vaccine_model_v2_stratified.csv')

inivals_raw <- read.csv(inivalfile)
parvals_raw <- read.csv(parvalfile)

#those csv files contain columns that are not needed to run the model
#these lines of code get the initial values and parameter values into the right format
#also time values (start/final/dt) are produced
inivals = inivals_raw$Initial_Value
names(inivals) = inivals_raw$Abbreviation
inivals = as.list(inivals)

parvals = parvals_raw$Initial_Value
names(parvals) = parvals_raw$Abbreviation
parvals = as.list(parvals)

mbmodel = readRDS("code/stratified_models/Coronavirus_vaccine_model_v2_stratified.Rds")
timeinfo = mbmodel$time
timevals = list(tstart = timeinfo[[1]]$timeval,
                tfinal = timeinfo[[2]]$timeval,
                dt = timeinfo[[3]]$timeval)

#combine all the value lists into one large argument list 
#this is fed into the function that contains the ode model
args_list <- c(inivals, parvals, timevals)

#loop over some parameter we want to explore
#remaining parameter are fixed based on loaded values
sigma_e_l_vec = seq(0,1,length=10)  #this is a placeholder

#will contain outcome of interest
outcome = rep(0,length(sigma_e_l_vec))

for (i in 1:length(sigma_e_l_vec))
{
 
  args_list$sigma_e_l <- sigma_e_l_vec[i]  #substitute the value for the parameter we want to change
  
  #run model 
  sim = do.call(simulate_Coronavirus_vaccine_model_v2_stratified_ode, args_list)
  #pull out some part of interest from the simulation
  #the return from the function (i.e. what's stored in sim)
  #is always a list, with $ts the time-series matrix (what one gets if one just ran deSolve)
  outcome[i] = tail(sim$ts$S_e_l,1) #final number of susceptible
}

plot(sigma_e_l_vec, outcome,type='b')

