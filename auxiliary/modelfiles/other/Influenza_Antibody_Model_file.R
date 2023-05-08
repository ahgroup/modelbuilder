############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.940711 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Influenza Antibody Model'
 mbmodel$description = 'Influenza Antibody Model'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'Model based on Zarnitsyna et al 2016 PLoS Pathogens' 

 #Information for all variables
 var = vector('list',4)
 id = 0
 id = id + 1
 var[[id]]$varname = 'Hf'
 var[[id]]$vartext = 'free antigen'
 var[[id]]$varval = 10000
 var[[id]]$flows = c('-k*A*Hf', '-df*Hf')
 var[[id]]$flownames = c('binding by antibodies', 'antibody decay')
 
 id = id + 1
 var[[id]]$varname = 'Hb'
 var[[id]]$vartext = 'bound antigen'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+k*A*Hf', '-db*Hb')
 var[[id]]$flownames = c('binding by antibodies', 'antibody removal')
 
 id = id + 1
 var[[id]]$varname = 'B'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+s*B*(Hf+del*Hb)/(p+Hf+del*Hb)*(1/(1+a*Hb))')
 var[[id]]$flownames = c('B cell activation')
 
 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g*B', '-k*A*Hf', '-dA*A')
 var[[id]]$flownames = c('generation', 'binding', 'decay')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',9)
 id = 0
 id = id + 1
 par[[id]]$parname = 'k'
 par[[id]]$partext = 'binding rate'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'df'
 par[[id]]$partext = 'free antigen decay rate'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'db'
 par[[id]]$partext = 'bound antigen decay rate'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 's'
 par[[id]]$partext = 'B cell generation rate'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'del'
 par[[id]]$partext = 'bound antibody strength'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'p'
 par[[id]]$partext = 'saturation level'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'a'
 par[[id]]$partext = 'FIM impact '
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'g'
 par[[id]]$partext = 'antibody production rate'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'dA'
 par[[id]]$partext = 'antibody decay rate'
 par[[id]]$parval = 0.1
 
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