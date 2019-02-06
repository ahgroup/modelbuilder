#this R script generates the Rdata file for the Basic Bacteria model in the DSAIRM package

#main list structure
mbmodel = list()

#some meta-information
mbmodel$title = "Basic Bacteria model"
mbmodel$description = "A basic bacteria infection model with 2 compartments"
mbmodel$author = "Andreas Handel"
mbmodel$date = Sys.Date()
mbmodel$details = 'The model includes bacteria and an immune response. The processes are bacteria growth, death and killing, and immune response activation and decay. This is a predator-prey type model.'

#list of elements for each model variable. So a 3-variable model will have var[[1]], var[[2]] and var[[3]]
var = vector("list",2)
var[[1]]$varname = "B"
var[[1]]$vartext = "Bacteria"
var[[1]]$varval = 10
var[[1]]$flows = c('+g*B*(1-B/Bmax)','-dB*B','-k*B*I')
var[[1]]$flownames = c('bacteria growth','bacteria death','immune response killing')

var[[2]]$varname = "I"
var[[2]]$vartext = "Immune Response"
var[[2]]$varval = 1
var[[2]]$flows = c('+r*B*I','-dI*I')
var[[2]]$flownames = c('immune response growth','immune response decay')

mbmodel$var = var

#list of elements for each model parameter.
par = vector("list",6)

par[[1]]$parname = c('g')
par[[1]]$partext = 'maximum rate of bacteria growth'
par[[1]]$parval = 1

par[[2]]$parname = c('Bmax')
par[[2]]$partext = 'bacteria carrying capacity'
par[[2]]$parval = 1e6

par[[3]]$parname = c('dB')
par[[3]]$partext = 'bacteria death rate'
par[[3]]$parval = 1e-1

par[[4]]$parname = c('k')
par[[4]]$partext = 'bacteria kill rate'
par[[4]]$parval = 1e-7

par[[5]]$parname = c('r')
par[[5]]$partext = 'immune response growth rate'
par[[5]]$parval = 1e-3

par[[6]]$parname = c('dI')
par[[6]]$partext = 'immune response decay rate'
par[[6]]$parval = 1

mbmodel$par = par

#time parvals
time = vector("list",3)
time[[1]]$timename = "tstart"
time[[1]]$timetext = "Start time of simulation"
time[[1]]$timeval = 0

time[[2]]$timename = "tfinal"
time[[2]]$timetext = "Final time of simulation"
time[[2]]$timeval = 30

time[[3]]$timename = "dt"
time[[3]]$timetext = "Time step"
time[[3]]$timeval = 0.01

mbmodel$time = time

modelname = gsub(" ","_",mbmodel$title)
rdatafile = paste0(modelname,'.Rdata')
save(mbmodel,file = rdatafile)
