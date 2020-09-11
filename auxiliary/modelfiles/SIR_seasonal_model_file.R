############################## 
#R script to generate a modelbuilder model object with code. 
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
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible population'
 var[[1]]$varval = 99999
 var[[1]]$flows = c('+mu*(S+I+R)', '-beta0*(1+beta1*sin(omega*t))*S*I/(S+I+R)', '-mu*S')
 var[[1]]$flownames = c('all births', 'infections of susceptibles', 'Death of susceptibles')
 
 var[[2]]$varname = 'I'
 var[[2]]$vartext = 'Infected population'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+beta0*(1+beta1*sin(omega*t))*S*I/(S+I+R)', '-gamma*I', '-mu*I')
 var[[2]]$flownames = c('Infections from susceptibles', 'Recoveries', 'Deaths of infected population')
 
 var[[3]]$varname = 'R'
 var[[3]]$vartext = 'Recovered population'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+gamma*I', '-mu*R')
 var[[3]]$flownames = c('Recoveries from infected class', 'Deaths from recovered population')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',5)
 par[[1]]$parname = 'mu'
 par[[1]]$partext = 'birth and death rate'
 par[[1]]$parval = 2e-04
 
 par[[2]]$parname = 'beta0'
 par[[2]]$partext = 'baseline transmission rate'
 par[[2]]$parval = 0.03
 
 par[[3]]$parname = 'beta1'
 par[[3]]$partext = 'seasonal transmission adjustment'
 par[[3]]$parval = 0.05
 
 par[[4]]$parname = 'omega'
 par[[4]]$partext = 'periodicity'
 par[[4]]$parval = 0.02
 
 par[[5]]$parname = 'gamma'
 par[[5]]$partext = 'recovery rate'
 par[[5]]$parval = 0.01
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0
 
 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 10000
 
 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 1
 
 mbmodel$time = time