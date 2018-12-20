#this R script generates the Rdata file for the Basic Bacteria model in the DSAIRM package

NOT YET DONE, ONLY STARTED

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
var[[1]]$varval = 1e5
var[[1]]$flows = c('+n','-dU*U','-b*V*U')
var[[1]]$flownames = c('cell birth','cell death','infection of cells')

var[[2]]$varname = "I"
var[[2]]$vartext = "Immune Response"
var[[2]]$varval = 0
var[[2]]$flows = c('+b*V*U','-dI*I')
var[[2]]$flownames = c('infection of cells','death of infected cells')

mbmodel$var = var

#list of elements for each model parameter.
par = vector("list",7)

par[[1]]$parname = c('n')
par[[1]]$partext = 'rate of new uninfected cell replenishment'
par[[1]]$parval = 0

par[[2]]$parname = c('dU')
par[[2]]$partext = 'rate at which uninfected cells die'
par[[2]]$parval = 0

par[[3]]$parname = c('dI')
par[[3]]$partext = 'rate at which infected cells die'
par[[3]]$parval = 1

par[[4]]$parname = c('dV')
par[[4]]$partext = 'rate at which virus is cleared'
par[[4]]$parval = 2

par[[5]]$parname = c('b')
par[[5]]$partext = 'rate at which virus infects cells'
par[[5]]$parval = 2e-5

par[[6]]$parname = c('p')
par[[6]]$partext = 'rate at which infected cells produce virus'
par[[6]]$parval = 5

par[[7]]$parname = c('g')
par[[7]]$partext = 'possible conversion factor for virus units'
par[[7]]$parval = 1


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
time[[3]]$timeval = 0.1

mbmodel$time = time

modelname = gsub(" ","_",mbmodel$title)
rdatafile = paste0(modelname,'.Rdata')
save(mbmodel,file = rdatafile)
