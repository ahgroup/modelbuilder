# Example script for analyzing a model

#load modelbuilder
library("modelbuilder")
library("here") #for easy path access relative to project root directory

#specify the simulation model code to use
#the model/code has likely been generated with the generation script, but that doesn't need to be the case
#any code for an mbmodel (or really any code function that has the right structure) should work
#they are assumed to live in the 'stratified_models' folder
modelname <- "Coronavirus_vaccine_model_v2_risk_age"
#modelname <- "SIRSd_model_risk_age"

#generate file name for ODE model, also assumed to be in stratified_models folder
#then source the file/function
path = here("code/stratified_models")
modelfilename <- paste0(path,"/simulate_",modelname,"_ode.R")
source(modelfilename)

#these are initial and parameter value spreadsheets
#they contain the parameters for the model
#note that the model has default parameters, so if some are not provided
#defaults are used. that might not be wanted
#the file names should be changed to be those needed for the model
#also note that the files are not read from the folder into which they are placed when
#they are produced with the generation script. this is to prevent accidental overwrites
#of already filled tables
path = here("code/filled_tables")
inivalfile = paste0(path,'/variable_table_',modelname,'.csv')
parvalfile = paste0(path,'/parameter_table_',modelname,'.csv')

inivals_raw <- read.csv(inivalfile)
parvals_raw <- read.csv(parvalfile)

#those csv files may contain columns that are not needed to run the model
#these lines of code get the initial values and parameter values into the right format
#also time values (start/final/dt) are produced
inivals = inivals_raw$Initial_Value
names(inivals) = inivals_raw$Abbreviation
inivals = as.list(inivals)

parvals = parvals_raw$Initial_Value
names(parvals) = parvals_raw$Abbreviation
parvals = as.list(parvals)

#set times for simulation
timevals = list(tstart = 0, tfinal = 100, dt = 0.1)

#combine all the value lists into one large argument list
#this is fed into the function that contains the ode model
args_list <- c(inivals, parvals, timevals)

#loop over some parameter we want to explore
#remaining parameter are fixed based on loaded values
par_vec = seq(0,1,length=10)  

#will contain outcome of interest
outcome = rep(0,length(par_vec))

for (i in 1:length(par_vec))
{
  
  #args_list$w_l_e <- par_vec[i]  #substitute the value for the parameter we want to change
  args_list$nu_Sl_Il_S_le_I_lc <- par_vec[i]  #substitute the value for the parameter we want to change
  
  #run model
  sim = do.call(paste0("simulate_",modelname,"_ode"), args_list)
  #pull out some part of interest from the simulation
  #the return from the function (i.e. what's stored in sim)
  #is always a list, with $ts the time-series matrix (what one gets if one just ran deSolve)
  outcome[i] = tail(sim$ts$S_l_e,1) #final number of susceptible
}

plot(par_vec, outcome,type='b')


