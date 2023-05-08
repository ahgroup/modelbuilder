############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.962731 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'SIR seasonal model'
 mbmodel$description = 'A basic seasonal SIR model with 3 compartments and infection and recovery processes'
 mbmodel$author = 'Andreas Handel and Andrew Tredennick'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'Add details.' 

 #Information for all variables
 var = vector('list',3)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible population'
 var[[id]]$varval = 99999
 var[[id]]$flows = c('+mu*(S+I+R)', '-beta0*(1+beta1*sin(omega*t))*S*I/(S+I+R)', '-mu*S')
 var[[id]]$flownames = c('all births', 'infections of susceptibles', 'Death of susceptibles')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected population'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+beta0*(1+beta1*sin(omega*t))*S*I/(S+I+R)', '-gamma*I', '-mu*I')
 var[[id]]$flownames = c('Infections from susceptibles', 'Recoveries', 'Deaths of infected population')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered population'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gamma*I', '-mu*R')
 var[[id]]$flownames = c('Recoveries from infected class', 'Deaths from recovered population')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',5)
 id = 0
 id = id + 1
 par[[id]]$parname = 'mu'
 par[[id]]$partext = 'birth and death rate'
 par[[id]]$parval = 2e-04
 
 id = id + 1
 par[[id]]$parname = 'beta0'
 par[[id]]$partext = 'baseline transmission rate'
 par[[id]]$parval = 0.03
 
 id = id + 1
 par[[id]]$parname = 'beta1'
 par[[id]]$partext = 'seasonal transmission adjustment'
 par[[id]]$parval = 0.05
 
 id = id + 1
 par[[id]]$parname = 'omega'
 par[[id]]$partext = 'periodicity'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'gamma'
 par[[id]]$partext = 'recovery rate'
 par[[id]]$parval = 0.01
 
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
 time[[id]]$timeval = 10000
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 1
 
 mbmodel$time = time