############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:22.010744 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Time dependent SIR model'
 mbmodel$description = 'A basic SIR model with 3 compartments and infection and recovery processes'
 mbmodel$author = 'Andreas Handel and Andrew Tredennick'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected, and recovered compartments. The two processes that are modeled are infection and recovery. Model also includes exponential decay of transmission rate as an example of time-varying parameters.' 

 #Information for all variables
 var = vector('list',3)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-b*(exp(-t/d))*S*I')
 var[[id]]$flownames = c('infection of susceptibles')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+b*(exp(-t/d))*S*I', '-g*I')
 var[[id]]$flownames = c('infection of susceptibles', 'recovery of infected')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+g*I')
 var[[id]]$flownames = c('recovery of infected')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',3)
 id = 0
 id = id + 1
 par[[id]]$parname = 'b'
 par[[id]]$partext = 'infection rate'
 par[[id]]$parval = 0.007
 
 id = id + 1
 par[[id]]$parname = 'g'
 par[[id]]$partext = 'recovery rate'
 par[[id]]$parval = 0.09
 
 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'exponential decay'
 par[[id]]$parval = 1
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 id = 0
 id = id + 1
 time[[id]]$timename = 'tstart'
 time[[id]]$timetext = 'Start time of simulation'
 time[[id]]$timeval = 0
 
 id = id + 1
 time[[id]]$timename = 'tfinal'
 time[[id]]$timetext = 'Final time of simulation'
 time[[id]]$timeval = 100
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time