############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Basic Virus model'
 mbmodel$description = 'A basic virus infection model with 3 compartments'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes uninfected and infected target cells, as well as free virus. The processes that are modeled are infection, virus production, uninfected cell birth and death, infected cell and virus death.' 

 #Information for all variables
 var = vector('list',3)
 var[[1]]$varname = 'U'
 var[[1]]$vartext = 'Uninfected cells'
 var[[1]]$varval = 1e+05
 var[[1]]$flows = c('+n', '-dU*U', '-b*V*U')
 var[[1]]$flownames = c('uninfected cell birth', 'uninfected cell death', 'infection of cells')
 
 var[[2]]$varname = 'I'
 var[[2]]$vartext = 'Infected cells'
 var[[2]]$varval = 0
 var[[2]]$flows = c('+b*V*U', '-dI*I')
 var[[2]]$flownames = c('infection of cells', 'death of infected cells')
 
 var[[3]]$varname = 'V'
 var[[3]]$vartext = 'Virus'
 var[[3]]$varval = 1
 var[[3]]$flows = c('+p*I', '-dV*V', '-b*g*V*U')
 var[[3]]$flownames = c('virus production', 'virus removal', 'infection of cells')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',7)
 par[[1]]$parname = 'n'
 par[[1]]$partext = 'rate of new uninfected cell replenishment'
 par[[1]]$parval = 0
 
 par[[2]]$parname = 'dU'
 par[[2]]$partext = 'rate at which uninfected cells die'
 par[[2]]$parval = 0
 
 par[[3]]$parname = 'dI'
 par[[3]]$partext = 'rate at which infected cells die'
 par[[3]]$parval = 1
 
 par[[4]]$parname = 'dV'
 par[[4]]$partext = 'rate at which virus is cleared'
 par[[4]]$parval = 2
 
 par[[5]]$parname = 'b'
 par[[5]]$partext = 'rate at which virus infects cells'
 par[[5]]$parval = 2e-05
 
 par[[6]]$parname = 'p'
 par[[6]]$partext = 'rate at which infected cells produce virus'
 par[[6]]$parval = 5
 
 par[[7]]$parname = 'g'
 par[[7]]$partext = 'possible conversion factor for virus units'
 par[[7]]$parval = 1
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0
 
 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 30
 
 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 0.1
 
 mbmodel$time = time