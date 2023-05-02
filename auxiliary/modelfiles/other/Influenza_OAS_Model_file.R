##############################
#R script to generate a modelbuilder model object with code.
#This file was generated on 2020-12-04 15:32:38
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Influenza OAS Model'
 mbmodel$description = 'Influenza Antibody Model with 2 types of B-cells/antibodies'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'An extension of Zarnitsyna et al 2016 PLoS Pathogens'

 #Information for all variables
 var = vector('list',6)
 id = 0
 id = id + 1
 var[[id]]$varname = 'Hf'
 var[[id]]$vartext = 'free antigen'
 var[[id]]$varval = 10000
 var[[id]]$flows = c('-k1*A1*Hf', '-k2*A2*Hf', '-df*Hf')
 var[[id]]$flownames = c('binding by antibody 1','binding by antibody 2', 'free antigen decay')

 id = id + 1
 var[[id]]$varname = 'Hb'
 var[[id]]$vartext = 'bound antigen'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+k1*A1*Hf', '+k2*A2*Hf', '-db*Hb')
 var[[id]]$flownames = c('binding by antibody 1','binding by antibody 2', 'bound antigen decay')

 id = id + 1
 var[[id]]$varname = 'B1'
 var[[id]]$vartext = 'Type 1 B cells'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+s1*B1*(Hf+del1*Hb)/(p1+Hf+del1*Hb)*(1/(1+a1*Hb))')
 var[[id]]$flownames = c('B1 cell activation')

 id = id + 1
 var[[id]]$varname = 'A1'
 var[[id]]$vartext = 'Type 1 antibodies'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+g1*B1', '-k1*A1*Hf', '-d1*A1')
 var[[id]]$flownames = c('A1 generation', 'A1 binding', 'A1 decay')

 id = id + 1
 var[[id]]$varname = 'B2'
 var[[id]]$vartext = 'Type 2 B cells'
 var[[id]]$varval = 10
 var[[id]]$flows = c('+s2*B2*(Hf+del2*Hb)/(p2+Hf+del2*Hb)*(1/(1+a2*Hb))')
 var[[id]]$flownames = c('B2 cell activation')

 id = id + 1
 var[[id]]$varname = 'A2'
 var[[id]]$vartext = 'Type 2 antibodies'
 var[[id]]$varval = 10
 var[[id]]$flows = c('+g2*B2', '-k2*A2*Hf', '-d2*A2')
 var[[id]]$flownames = c('A2 generation', 'A2 binding', 'A2 decay')


 mbmodel$var = var

 #Information for all parameters
 par = vector('list',16)
 id = 0
 id = id + 1
 par[[id]]$parname = 'k1'
 par[[id]]$partext = 'binding rate 1'
 par[[id]]$parval = 0.01

 id = id + 1
 par[[id]]$parname = 'k2'
 par[[id]]$partext = 'binding rate 2'
 par[[id]]$parval = 0.02

 id = id + 1
 par[[id]]$parname = 'df'
 par[[id]]$partext = 'free antigen decay rate'
 par[[id]]$parval = 0.5

 id = id + 1
 par[[id]]$parname = 'db'
 par[[id]]$partext = 'bound antigen decay rate'
 par[[id]]$parval = 0.7


 id = id + 1
 par[[id]]$parname = 's1'
 par[[id]]$partext = 'B1 cell generation rate'
 par[[id]]$parval = 1

 id = id + 1
 par[[id]]$parname = 'del1'
 par[[id]]$partext = 'bound antibody strength 1'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'p1'
 par[[id]]$partext = 'saturation level 1'
 par[[id]]$parval = 1000

 id = id + 1
 par[[id]]$parname = 'a1'
 par[[id]]$partext = 'FIM impact 1'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'g1'
 par[[id]]$partext = 'antibody 1 production rate'
 par[[id]]$parval = 0.1

 id = id + 1
 par[[id]]$parname = 'd1'
 par[[id]]$partext = 'antibody 1 decay rate'
 par[[id]]$parval = 0.1



 id = id + 1
 par[[id]]$parname = 's2'
 par[[id]]$partext = 'B2 cell generation rate'
 par[[id]]$parval = 0.5

 id = id + 1
 par[[id]]$parname = 'del2'
 par[[id]]$partext = 'bound antibody strength 2'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'p2'
 par[[id]]$partext = 'saturation level 2'
 par[[id]]$parval = 1000

 id = id + 1
 par[[id]]$parname = 'a2'
 par[[id]]$partext = 'FIM impact 2'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'g2'
 par[[id]]$partext = 'antibody 2 production rate'
 par[[id]]$parval = 0.1

 id = id + 1
 par[[id]]$parname = 'd2'
 par[[id]]$partext = 'antibody 2 decay rate'
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
