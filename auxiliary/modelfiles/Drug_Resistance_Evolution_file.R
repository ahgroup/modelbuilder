##############################
#R script to generate a modelbuilder model object with code.
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Drug Resistance Evolution'
 mbmodel$description = 'An SIR-type model that includes drug treatment and resistance.'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected untreated, treated and resistant, and recovered compartments. The processes which are modeled are infection, treatment, resistance generation and recovery.'

 #Information for all variables
 var = vector('list',5)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-S*(1-f)*bu*(1-cu)*Iu', '-S*(1-f)*bt*(1-ct)*It', '-S*f*bu*(1-cu)*Iu', '-S*f*bt*(1-ct)*It','-S*bu*cu*Iu', '-S*bt*ct*It', '-S*br*Ir')
 var[[id]]$flownames = c('untreated individuals infected by untreated infected', 'untreated individuals infected by treated infected','treated individuals infected by untreated infected', 'treated individuals infected by treated infected','resistance emergence in untreated', 'resistance emergence in treated', 'infection by resistant')

 id = id + 1
 var[[id]]$varname = 'Iu'
 var[[id]]$vartext = 'Infected Untreated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+S*(1-f)*bu*(1-cu)*Iu', '+S*(1-f)*bt*(1-ct)*It', '-gu*Iu')
 var[[id]]$flownames = c('untreated individuals infected by untreated infected', 'untreated individuals infected by treated infected', 'untreated recovery')

 id = id + 1
 var[[id]]$varname = 'It'
 var[[id]]$vartext = 'Infected Treated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+S*f*bu*(1-cu)*Iu', '+S*f*bt*(1-ct)*It', '-gt*It')
 var[[id]]$flownames = c('treated individuals who got infected by untreated infected', 'treated individuals who got infected by treated infected', 'treated recovery')

 id = id + 1
 var[[id]]$varname = 'Ir'
 var[[id]]$vartext = 'Infected Resistant'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+S*bu*cu*Iu', '+S*bt*ct*It', '+S*br*Ir', '-gr*Ir')
 var[[id]]$flownames = c('resistance emergence in untreated', 'resistance emergence in treated', 'infection by resistant',  'resistant recovery')

 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gu*Iu', '+gt*It', '+gr*Ir')
 var[[id]]$flownames = c('untreated recovery', 'treated recovery', 'resistant recovery')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',9)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bu'
 par[[id]]$partext = 'untreated infection rate'
 par[[id]]$parval = 0.002

 id = id + 1
 par[[id]]$parname = 'bt'
 par[[id]]$partext = 'treated infection rate'
 par[[id]]$parval = 0.002

 id = id + 1
 par[[id]]$parname = 'br'
 par[[id]]$partext = 'resistant infection rate'
 par[[id]]$parval = 0.002

 id = id + 1
 par[[id]]$parname = 'gu'
 par[[id]]$partext = 'untreated recovery rate'
 par[[id]]$parval = 1

 id = id + 1
 par[[id]]$parname = 'gt'
 par[[id]]$partext = 'treated recovery rate'
 par[[id]]$parval = 1

 id = id + 1
 par[[id]]$parname = 'gr'
 par[[id]]$partext = 'resistant recovery rate'
 par[[id]]$parval = 1

 id = id + 1
 par[[id]]$parname = 'f'
 par[[id]]$partext = 'fraction treated'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'cu'
 par[[id]]$partext = 'resistance emergence untreated'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'ct'
 par[[id]]$partext = 'resistance emergence treated'
 par[[id]]$parval = 0

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
