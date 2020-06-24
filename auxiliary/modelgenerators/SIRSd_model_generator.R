#a SIRSd model is implemented
#this structure should be created by the shiny app, as needed saved as Rdata file
#and read by various functions and turned into desolve/adaptivetau/discrete time/RxODE code

library('modelbuilder')

#main list structure
mbmodel = list()

#some meta-information
mbmodel$title = "SIRSd model"
mbmodel$description = "A SIRSd model with 3 compartments. Processes are infection, recovery, births deaths and waning immunity."
mbmodel$author = "Andreas Handel"
mbmodel$date = Sys.Date()
mbmodel$details = "The model includes susceptible, infected, and recovered compartments. The processes which are modeled are infection, recovery, natural births and deaths and waning immunity."

#list of elements for each model variable. So a 3-variable model will have var[[1]], var[[2]] and var[[3]]
var = vector("list",3)
ct=1
var[[ct]]$varname = "S"
var[[ct]]$vartext = "Susceptible"
var[[ct]]$varval = 1000
var[[ct]]$flows = c('-b*S*I','+w*R','+n','-m*S')
var[[ct]]$flownames = c('infection','waning immunity','births','natural deaths')

ct=2
var[[ct]]$varname = "I"
var[[ct]]$vartext = "Infected"
var[[ct]]$varval = 1
var[[ct]]$flows = c('+b*S*I','-g*I','-m*I')
var[[ct]]$flownames = c('infection','recovery','natural deaths')

ct=3
var[[ct]]$varname = "R"
var[[ct]]$vartext = "Recovered"
var[[ct]]$varval = 0
var[[ct]]$flows = c('+g*I','-w*R','-m*R')
var[[ct]]$flownames = c('recovery','waning immunity','natural death')

mbmodel$var = var

#list of elements for each model parameter.
par = vector("list",5)
ct=1
par[[ct]]$parname = c('b')
par[[ct]]$partext = 'infection rate'
par[[ct]]$parval = 2e-3

ct=2
par[[ct]]$parname = c('g')
par[[ct]]$partext = 'recovery rate'
par[[ct]]$parval = 1

ct=3
par[[ct]]$parname = c('w')
par[[ct]]$partext = 'waning immunity rate'
par[[ct]]$parval = 1

ct=4
par[[4]]$parname = c('n')
par[[4]]$partext = 'birth rate'
par[[4]]$parval = 0

ct=5
par[[5]]$parname = c('m')
par[[5]]$partext = 'death rate'
par[[5]]$parval = 0

mbmodel$par = par

#time parvals
time = vector("list",3)
time[[1]]$timename = "tstart"
time[[1]]$timetext = "Start time of simulation"
time[[1]]$timeval = 0

time[[2]]$timename = "tfinal"
time[[2]]$timetext = "Final time of simulation"
time[[2]]$timeval = 100

time[[3]]$timename = "dt"
time[[3]]$timetext = "Time step"
time[[3]]$timeval = 0.1

mbmodel$time = time

#run the model through the check_model function to make sure it's a valid modelbuilder model
#note that this only checks that the model follows the required modelbuilder structure
#it's not a check that the model makes biological/scientific sense
mbmodelerrors <- modelbuilder::check_model(mbmodel)
if (!is.null(mbmodelerrors))
{
    stop(mbmodelerrors)
}

modelname = gsub(" ","_",mbmodel$title)

#this code writes the model list object into an rds file into the specified directory
rdatafile = paste0(here::here('inst/modelexamples'),'/',modelname,'.rds')
saveRDS(mbmodel,file = rdatafile)

#this code writes the model function code
destpath = paste0(here::here('auxiliary/modelfiles'),'/')
generate_discrete(mbmodel,location = destpath, filename = NULL)
generate_ode(mbmodel,location = destpath, filename = NULL)
generate_stochastic(mbmodel,location = destpath, filename = NULL)

