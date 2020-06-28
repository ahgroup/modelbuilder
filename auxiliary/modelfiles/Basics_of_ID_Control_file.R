############################## 
#R script to generate a modelbuilder model with code, save and export it. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Basics of ID Control'
 mbmodel$description = 'A reproductive number model built from expanding the basic SIR model. '
 mbmodel$author = 'Alexis Vittengl '
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected, and recovered compartments. The processes that are modeled are infection, recovery, birth, death, vaccine and immunity.' 

 #Information for all variables
 var = vector('list',5)
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-b*S*I', '+m', '-n*S', '+w*R')
 var[[1]]$flownames = c('infection of susceptibles', 'births', 'deaths of susceptibles', 'loss of immunity of recovered')
 
 var[[2]]$varname = 'I'
 var[[2]]$vartext = 'Infected'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+b*S*I', '-g*I', '-n*I')
 var[[2]]$flownames = c('infection of susceptibles', 'recovery of infected', 'deaths of infected')
 
 var[[3]]$varname = 'R'
 var[[3]]$vartext = 'Recovered'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+g*I', '-n*R', '-w*R')
 var[[3]]$flownames = c('recovery of infected', 'deaths of recovered', 'loss of immunity of recovered')
 
 var[[4]]$varname = 'Sv'
 var[[4]]$vartext = 'susceptible population left after vaccinating'
 var[[4]]$varval = 100
 var[[4]]$flows = c('+s', '-e*f*s')
 var[[4]]$flownames = c('initial susceptibles', 'Initial removed individuals')
 
 var[[5]]$varname = 'R0'
 var[[5]]$vartext = 'Vaccinated and Protected'
 var[[5]]$varval = 100
 var[[5]]$flows = c('+e*f*s')
 var[[5]]$flownames = c('Initial removed individuals')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',8)
 par[[1]]$parname = 'b'
 par[[1]]$partext = 'infection rate'
 par[[1]]$parval = 0.002
 
 par[[2]]$parname = 'g'
 par[[2]]$partext = 'recovery rate'
 par[[2]]$parval = 1
 
 par[[3]]$parname = 'm'
 par[[3]]$partext = 'birth rate'
 par[[3]]$parval = 1.2
 
 par[[4]]$parname = 'n'
 par[[4]]$partext = 'death rate'
 par[[4]]$parval = 0.05
 
 par[[5]]$parname = 'w'
 par[[5]]$partext = 'lose immunity'
 par[[5]]$parval = 0.02
 
 par[[6]]$parname = 'e'
 par[[6]]$partext = 'vaccine efficacy'
 par[[6]]$parval = 0.68
 
 par[[7]]$parname = 'f'
 par[[7]]$partext = 'fraction vaccinated'
 par[[7]]$parval = 0.8
 
 par[[8]]$parname = 's'
 par[[8]]$partext = 'Initial Susceptible '
 par[[8]]$parval = 1000
 
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