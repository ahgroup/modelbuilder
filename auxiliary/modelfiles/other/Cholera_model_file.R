############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.927062 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Cholera model'
 mbmodel$description = 'A Cholera model based on Codeco 2001 BMC ID'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected, and environmental compartments. See reference for more details.' 

 #Information for all variables
 var = vector('list',3)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 10000
 var[[id]]$flows = c('+n*h', '-n*S', '-a*B/(k+B)*S')
 var[[id]]$flownames = c('births', 'deaths', 'infection of susceptibles')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+a*B/(k+B)*S', '-r*I')
 var[[id]]$flownames = c('infection of susceptibles', 'recovery of infected')
 
 id = id + 1
 var[[id]]$varname = 'B'
 var[[id]]$vartext = 'Bacteria'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+nb*B', '-mb*B', '+e*I')
 var[[id]]$flownames = c('bacteria growth', 'bacteria decay', 'bacteria shedding')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',8)
 id = 0
 id = id + 1
 par[[id]]$parname = 'h'
 par[[id]]$partext = 'population size'
 par[[id]]$parval = 10000
 
 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'birth rate'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'a'
 par[[id]]$partext = 'infection rate'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'k'
 par[[id]]$partext = '50% infection rate'
 par[[id]]$parval = 1e+06
 
 id = id + 1
 par[[id]]$parname = 'r'
 par[[id]]$partext = 'recovery rate'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'nb'
 par[[id]]$partext = 'bacteria growth rate'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'mb'
 par[[id]]$partext = 'bacteria death rate'
 par[[id]]$parval = 1.33
 
 id = id + 1
 par[[id]]$parname = 'e'
 par[[id]]$partext = 'bacteria shedding rate'
 par[[id]]$parval = 10
 
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
 time[[id]]$timeval = 500
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time