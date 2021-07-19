##############################
#R script to generate a modelbuilder model object with code.
#This file was generated on 2021-05-20 07:36:56
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Basic Inoculum Model'
 mbmodel$description = ''
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = ''

 #Information for all variables
 var = vector('list',4)
 id = 0
 id = id + 1
 var[[id]]$varname = 'H'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('-k*A*H', '-c*H')
 var[[id]]$flownames = c('removal', 'decay')

 id = id + 1
 var[[id]]$varname = 'F'
 var[[id]]$vartext = 'innate response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+p', '-m*F', '+q*fmax*H/(H+n)', '-q*F*H/(H+n)')
 var[[id]]$flownames = c('growth', 'decay', 'max growth', 'decay from max')

 id = id + 1
 var[[id]]$varname = 'B'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g*B*H*F/(s+H*F)')
 var[[id]]$flownames = c('induction')

 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k*A*H', '+r*B', '-d*A')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',11)
 id = 0
 id = id + 1
 par[[id]]$parname = 'k'
 par[[id]]$partext = 'killing rate'
 par[[id]]$parval = 1e-5

 id = id + 1
 par[[id]]$parname = 'c'
 par[[id]]$partext = 'antigen decay'
 par[[id]]$parval = 2

 id = id + 1
 par[[id]]$parname = 'p'
 par[[id]]$partext = 'innate growth'
 par[[id]]$parval = 24

 id = id + 1
 par[[id]]$parname = 'm'
 par[[id]]$partext = 'innate decay'
 par[[id]]$parval = 24

 id = id + 1
 par[[id]]$parname = 'q'
 par[[id]]$partext = 'innate induction'
 par[[id]]$parval = 3

 id = id + 1
 par[[id]]$parname = 'fmax'
 par[[id]]$partext = 'innate saturation'
 par[[id]]$parval = 1e5

 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'antigen halfpoint'
 par[[id]]$parval = 1e3

 id = id + 1
 par[[id]]$parname = 'g'
 par[[id]]$partext = 'b cell growth'
 par[[id]]$parval = 0.5

 id = id + 1
 par[[id]]$parname = 's'
 par[[id]]$partext = 'b cell halfpoint'
 par[[id]]$parval = 1e1

 id = id + 1
 par[[id]]$parname = 'r'
 par[[id]]$partext = 'antibody production'
 par[[id]]$parval = 10

 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'antibody decay'
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
