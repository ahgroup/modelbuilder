#this is a model encoded in the form used by the modelbuilder package
#this structure can be created graphically by the modelbuilder package or by hand
#this model is an SIR model with environmental transmission, created by hand


#main list structure
mbmodel = list()

#some meta-information
mbmodel$title = "Environmental Transmission model"
mbmodel$description = "An SIR model including environmental transmission"
mbmodel$author = "Andreas Handel"
mbmodel$date = Sys.Date()
mbmodel$details = 'The model includes susceptible, infected, recovered and environmental pathogen compartments. Infection can occur through direct contact with infected or through contact with pathogen in the environment. Infected individuals shed into the environment, pathogen decays there.'


var = vector("list",4)
var[[1]]$varname = "S"
var[[1]]$vartext = "Susceptible"
var[[1]]$varval = 10000
var[[1]]$flows = c('+n','-m*S','-bI*I*S','-bP*P*S')
var[[1]]$flownames = c('births','natural death','direct infection','environmental infection')

var[[2]]$varname = "I"
var[[2]]$vartext = "Infected"
var[[2]]$varval = 1
var[[2]]$flows = c('+bI*I*S','+bP*P*S','-m*I','-g*I')
var[[2]]$flownames = c('direct infection','environmental infection','natural death','recovery of infected')

var[[3]]$varname = "R"
var[[3]]$vartext = "Recovered"
var[[3]]$varval = 0
var[[3]]$flows = c('+g*I','-m*I')
var[[3]]$flownames = c( 'recovery of infected','natural death')

var[[4]]$varname = "P"
var[[4]]$vartext = "Pathogen in environment"
var[[4]]$varval = 0
var[[4]]$flows = c('+q*I','-c*P')
var[[4]]$flownames = c('shedding by infected','decay')

mbmodel$var = var

#list of elements for each model parameter.
par = vector("list",7)
par[[1]]$parname = 'bI'
par[[1]]$partext = 'direct transmission rate'
par[[1]]$parval = 1e-4

par[[2]]$parname = 'bP'
par[[2]]$partext = 'environmental transmission rate'
par[[2]]$parval = 0

par[[3]]$parname = 'n'
par[[3]]$partext = 'birth rate'
par[[3]]$parval =   0

par[[4]]$parname = 'm'
par[[4]]$partext = 'natural death rate'
par[[4]]$parval =  0

par[[5]]$parname = 'g'
par[[5]]$partext = 'recovery rate'
par[[5]]$parval =  0.2

par[[6]]$parname = 'q'
par[[6]]$partext = 'rate at which infected hosts shed pathogen into the environment'
par[[6]]$parval = 0

par[[7]]$parname = 'c'
par[[7]]$partext = 'rate at which pathogen in the environment decays'
par[[7]]$parval =  10

mbmodel$par = par

#time parvals
time = vector("list",3)
time[[1]]$timename = "tstart"
time[[1]]$timetext = "Start time of simulation"
time[[1]]$timeval = 0

time[[2]]$timename = "tfinal"
time[[2]]$timetext = "Final time of simulation"
time[[2]]$timeval = 500

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

