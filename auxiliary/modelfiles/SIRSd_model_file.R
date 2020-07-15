############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'SIRSd model'
 mbmodel$description = 'A SIRSd model with 3 compartments. Processes are infection, recovery, births deaths and waning immunity.'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected, and recovered compartments. The processes which are modeled are infection, recovery, natural births and deaths and waning immunity.' 

 #Information for all variables
 var = vector('list',3)
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-b*S*I', '+w*R', '+n', '-m*S')
 var[[1]]$flownames = c('infection', 'waning immunity', 'births', 'natural deaths')
 
 var[[2]]$varname = 'I'
 var[[2]]$vartext = 'Infected'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+b*S*I', '-g*I', '-m*I')
 var[[2]]$flownames = c('infection', 'recovery', 'natural deaths')
 
 var[[3]]$varname = 'R'
 var[[3]]$vartext = 'Recovered'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+g*I', '-w*R', '-m*R')
 var[[3]]$flownames = c('recovery', 'waning immunity', 'natural death')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',5)
 par[[1]]$parname = 'b'
 par[[1]]$partext = 'infection rate'
 par[[1]]$parval = 0.002
 
 par[[2]]$parname = 'g'
 par[[2]]$partext = 'recovery rate'
 par[[2]]$parval = 1
 
 par[[3]]$parname = 'w'
 par[[3]]$partext = 'waning immunity rate'
 par[[3]]$parval = 1
 
 par[[4]]$parname = 'n'
 par[[4]]$partext = 'birth rate'
 par[[4]]$parval = 0
 
 par[[5]]$parname = 'm'
 par[[5]]$partext = 'death rate'
 par[[5]]$parval = 0
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0
 
 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 100
 
 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 0.1
 
 mbmodel$time = time