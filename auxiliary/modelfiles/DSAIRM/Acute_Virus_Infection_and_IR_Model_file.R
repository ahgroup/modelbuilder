############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2022-05-09 09:26:48 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Acute Virus Infection and IR Model'
 mbmodel$description = 'A model for an acute virus infection with a simple immune response'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes uninfected and infected target cells, virus, and the innate and adaptive immune response. The processes that are modeled are infection, virus production, infected cell and virus death. Immune response dynamics and action are also modeled. See the DSAIRM documentation for model details.' 

 #Information for all variables
 var = vector('list',5)
 id = 0
 id = id + 1
 var[[id]]$varname = 'U'
 var[[id]]$vartext = 'Uninfected cells'
 var[[id]]$varval = 1e+05
 var[[id]]$flows = c('-b*V*U')
 var[[id]]$flownames = c('Infection of cells')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected cells'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+b*V*U', '-dI*I', '-kT*T*I')
 var[[id]]$flownames = c('infection of cells', 'death of infected cells', 'T-cell killing')
 
 id = id + 1
 var[[id]]$varname = 'V'
 var[[id]]$vartext = 'Virus'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+p*I/(1+kF*F)', '-dV*V', '-b*g*V*U')
 var[[id]]$flownames = c('virus production', 'virus removal', 'infection of cells')
 
 id = id + 1
 var[[id]]$varname = 'F'
 var[[id]]$vartext = 'Innate Response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+rF*I', '-dF*F')
 var[[id]]$flownames = c('innate response growth', 'innate response decline')
 
 id = id + 1
 var[[id]]$varname = 'T'
 var[[id]]$vartext = 'Adaptive Response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+rT*T*V', '-dT*T')
 var[[id]]$flownames = c('adaptive response growth', 'adaptive response decline')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',11)
 id = 0
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
 
 id = id + 1
 par[[id]]$parname = 'rF'
 par[[id]]$partext = 'rate of innate response induction'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'dF'
 par[[id]]$partext = 'rate of innate response decay'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'kF'
 par[[id]]$partext = 'strength of innate response action'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'rT'
 par[[id]]$partext = 'rate of adaptive response induction'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'dT'
 par[[id]]$partext = 'rate of adaptive response decay'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'kT'
 par[[id]]$partext = 'strength of adaptive response action'
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
 time[[id]]$timeval = 30
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time