#this is a proposed list structure for models
#a simple SIR model is implemented
#this structure should be created by the shiny app, as needed saved as Rdata file
#and read by various functions and turned into desolve/adaptivetau/discrete time/RxODE code


#main list structure
model = list()

#some meta-information
model$title = "SIR model"
model$description = "A basic SIR model with 3 compartments and infection and recovery processes"
model$author = "Andreas Handel"
model$date = Sys.Date()

#list of elements for each model variable. So a 3-variable model will have var[[1]], var[[2]] and var[[3]]
var = vector("list",3)
var[[1]]$varname = "S"
var[[1]]$vartext = "Susceptible"
var[[1]]$varval = 1000
var[[1]]$flows = c('-b*S*I')
var[[1]]$flownames = c('infection of susceptibles')

var[[2]]$varname = "I"
var[[2]]$vartext = "Infected"
var[[2]]$varval = 1
var[[2]]$flows = c('+b*S*I','-g*I')
var[[2]]$flownames = c('infection of susceptibles','recovery of infected')

var[[3]]$varname = "R"
var[[3]]$vartext = "Recovered"
var[[3]]$varval = 0
var[[3]]$flows = c('+g*I')
var[[3]]$flownames = c('recovery of infected')

model$var = var

#list of elements for each model parameter.
par = vector("list",2)
par[[1]]$parname = c('b')
par[[1]]$partext = 'infection rate'
par[[1]]$parval = 2e-3

par[[2]]$parname = c('g')
par[[2]]$partext = 'recovery rate'
par[[2]]$parval = 1

model$par = par

#time parvals
model$time$tstart = 0
model$time$tfinal = 100
model$time$dt = 0.1

filename =paste(gsub(" ","_",model$title),'.Rdata',sep='')

save(model,file = filename)
