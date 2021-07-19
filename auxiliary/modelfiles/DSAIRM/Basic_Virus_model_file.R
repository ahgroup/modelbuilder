############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2021-07-19 13:57:51 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Basic Virus Model'
 mbmodel$description = 'A basic virus infection model with 3 compartments'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes uninfected and infected target cells, as well as free virus. The processes that are modeled are infection, virus production, uninfected cell birth and death, infected cell and virus death.' 

 #Information for all variables
 var = vector('list',3)
 id = 0
 id = id + 1
 var[[id]]$varname = 'U'
 var[[id]]$vartext = 'Uninfected cells'
 var[[id]]$varval = 1e+05
 var[[id]]$flows = c('+n', '-dU*U', '-b*V*U')
 var[[id]]$flownames = c('Uninfected cell birth', 'Uninfected cell death', 'Infection of cells')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected cells'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+b*V*U', '-dI*I')
 var[[id]]$flownames = c('infection of cells', 'death of infected cells')
 
 id = id + 1
 var[[id]]$varname = 'V'
 var[[id]]$vartext = 'Virus'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+p*I', '-dV*V', '-b*g*V*U')
 var[[id]]$flownames = c('virus production', 'virus removal', 'infection of cells')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',7)
 id = 0
 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'rate of new uninfected cell replenishment'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'dU'
 par[[id]]$partext = 'rate at which uninfected cells die'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'dI'
 par[[id]]$partext = 'rate at which infected cells die'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'dV'
 par[[id]]$partext = 'rate at which virus is cleared'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'b'
 par[[id]]$partext = 'rate at which virus infects cells'
 par[[id]]$parval = 2e-05
 
 id = id + 1
 par[[id]]$parname = 'p'
 par[[id]]$partext = 'rate at which infected cells produce virus'
 par[[id]]$parval = 5
 
 id = id + 1
 par[[id]]$parname = 'g'
 par[[id]]$partext = 'possible conversion factor for virus units'
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
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time