##############################
#R script to generate a modelbuilder model object with code.
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Vector transmission model'
 mbmodel$description = 'A basic model with several compartments to model vector-borne transmission'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model tracks the dynamics of susceptible, infected, and recovered hosts, and susceptible and infected vectors. Infection, recovery, and waning immunity processes are implemented for hosts. Births and deaths and infection processes are implemented for vectors.'

 #Information for all variables
 var = vector('list',5)
 var[[1]]$varname = 'Sh'
 var[[1]]$vartext = 'Susceptible hosts'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-b1*Sh*Iv', '+w*Rh')
 var[[1]]$flownames = c('infection of susceptible hosts', 'waning immunity')

 var[[2]]$varname = 'Ih'
 var[[2]]$vartext = 'Infected hosts'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+b1*Sh*Iv', '-g*Ih')
 var[[2]]$flownames = c('infection of susceptible hosts', 'recovery of infected')

 var[[3]]$varname = 'Rh'
 var[[3]]$vartext = 'Recovered hosts'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+g*Ih', '-w*Rh')
 var[[3]]$flownames = c('recovery of infected hosts', 'waning immunity')

 var[[4]]$varname = 'Sv'
 var[[4]]$vartext = 'Susceptible Vectors'
 var[[4]]$varval = 1000
 var[[4]]$flows = c('+n', '-b2*Sv*Ih', '-m*Sv')
 var[[4]]$flownames = c('vector births', 'infection of susceptible vectors', 'death of susceptible vectors')

 var[[5]]$varname = 'Iv'
 var[[5]]$vartext = 'Infected Vectors'
 var[[5]]$varval = 1
 var[[5]]$flows = c('+b2*Sv*Ih', '-m*Iv')
 var[[5]]$flownames = c('infection of susceptible vectors', 'death of infected vectors')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',6)
 par[[1]]$parname = 'b1'
 par[[1]]$partext = 'rate at which susceptible hosts are infected by vectors'
 par[[1]]$parval = 0.003

 par[[2]]$parname = 'b2'
 par[[2]]$partext = 'rate at which susceptible vectors are infected by hosts'
 par[[2]]$parval = 0.003

 par[[3]]$parname = 'g'
 par[[3]]$partext = 'recovery rate of hosts'
 par[[3]]$parval = 2

 par[[4]]$parname = 'w'
 par[[4]]$partext = 'wanning immunity rate'
 par[[4]]$parval = 0

 par[[5]]$parname = 'n'
 par[[5]]$partext = 'vector birth rate'
 par[[5]]$parval = 200

 par[[6]]$parname = 'm'
 par[[6]]$partext = 'vector death rate'
 par[[6]]$parval = 0.1

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
