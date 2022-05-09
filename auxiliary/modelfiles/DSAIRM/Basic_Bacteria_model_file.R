############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2022-05-09 09:26:48 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Basic Bacteria Model'
 mbmodel$description = 'A basic bacteria infection model with 2 compartments'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes bacteria and an immune response. The processes are bacteria growth, death and killing, and immune response activation and decay. This is a predator-prey type model.' 

 #Information for all variables
 var = vector('list',2)
 id = 0
 id = id + 1
 var[[id]]$varname = 'B'
 var[[id]]$vartext = 'Bacteria'
 var[[id]]$varval = 10
 var[[id]]$flows = c('+g*B*(1-B/maxB)', '-dB*B', '-k*B*I')
 var[[id]]$flownames = c('bacteria growth', 'bacteria death', 'immune response killing')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Immune Response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+r*B*I', '-dI*I')
 var[[id]]$flownames = c('immune response growth', 'immune response decay')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',6)
 id = 0
 id = id + 1
 par[[id]]$parname = 'g'
 par[[id]]$partext = 'maximum rate of bacteria growth'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'maxB'
 par[[id]]$partext = 'bacteria carrying capacity'
 par[[id]]$parval = 1e+06
 
 id = id + 1
 par[[id]]$parname = 'dB'
 par[[id]]$partext = 'bacteria death rate'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'k'
 par[[id]]$partext = 'bacteria kill rate'
 par[[id]]$parval = 1e-07
 
 id = id + 1
 par[[id]]$parname = 'r'
 par[[id]]$partext = 'immune response growth rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'dI'
 par[[id]]$partext = 'immune response decay rate'
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
 time[[id]]$timeval = 30
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.01
 
 mbmodel$time = time