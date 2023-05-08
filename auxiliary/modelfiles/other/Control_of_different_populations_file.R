############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.934578 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Control of different populations'
 mbmodel$description = 'This model expands the basic SIR model to include control measures.'
 mbmodel$author = 'Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'This model includes parameters and variables such as deaths and control measures. The model includes susceptible, infected, recovered, and dead compartments. The processes that are modeled are infection, recovery, birth, death, control measures and immunity.' 

 #Information for all variables
 var = vector('list',12)
 id = 0
 id = id + 1
 var[[id]]$varname = 'Sc'
 var[[id]]$vartext = 'Susceptible Children'
 var[[id]]$varval = 100
 var[[id]]$flows = c('-bcc*Ic*Sc', '-bac*Ia*Sc', '-bec*Ie*Sc', '+bcc*Ic*Sc*f1', '+bac*Ia*Sc*f1', '+bec*Ie*Sc*f1', '+wc*Rc')
 var[[id]]$flownames = c('Child to Child infection', 'Adult to Child infection', 'Elderly to Child infection', 'Child to Child control measures', 'Adult to Child control measure ', 'Elderly to Child control measure', 'Child loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'Ic'
 var[[id]]$vartext = 'Infected Children'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bcc*Ic*Sc', '+bac*Ia*Sc', '+bec*Ie*Sc', '-bcc*Ic*Sc*f1', '-bac*Ia*Sc*f1', '-bec*Ie*Sc*f1', '-gc*Ic')
 var[[id]]$flownames = c('Child to Child infection', 'Adult to Child infection', 'Elderly to Child infection', 'Child to Child control measure', 'Adult to child control measure', 'Elderly to Child control measure', 'Child recovery')
 
 id = id + 1
 var[[id]]$varname = 'Rc'
 var[[id]]$vartext = 'Recovered Children'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gc*Ic', '-mc*gc*Ic', '-wc*Rc')
 var[[id]]$flownames = c('Child recovery', 'Child deaths', 'Child loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'Dc'
 var[[id]]$vartext = 'Dead Children'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+mc*gc*Ic')
 var[[id]]$flownames = c('Child deaths')
 
 id = id + 1
 var[[id]]$varname = 'Sa'
 var[[id]]$vartext = 'Susceptible Adults'
 var[[id]]$varval = 100
 var[[id]]$flows = c('-bca*Ic*Sa', '-baa*Ia*Sa', '-bea*Ie*Sa', '+bca*Ic*Sa*f2', '+baa*Ia*Sa*f2', '+bea*Ie*Sa*f2', '+wa*Ra')
 var[[id]]$flownames = c('Child to Adult infection', 'Adult to Adult infection', 'Elderly to Adult infection', 'Child to Adult control measure', 'Adult to Adult control measure', 'Elderly to Adult control measure', 'Adult loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'Ia'
 var[[id]]$vartext = 'Infected Adults'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bca*Ic*Sa', '+baa*Ia*Sa*', '+bea*Ie*Sa', '-bca*Ic*Sa*f2', '-baa*Ia*Sa*f2', '-bea*Ie*Sa*f2', '-ga*Ia')
 var[[id]]$flownames = c('Child to Adult infection', 'Adult to Adult infection', 'Elderly to Adult infection', 'Child to Adult control measure', 'Adult to Adult control measure', 'Elderly to Adult control measure', 'Adult recovery')
 
 id = id + 1
 var[[id]]$varname = 'Ra'
 var[[id]]$vartext = 'Recovered Adults'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+ga*Ia', '-ma*ga*Ia', '-wa*Ra')
 var[[id]]$flownames = c('Adult recovery', 'Adult deaths', 'Adult loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'Da'
 var[[id]]$vartext = 'Dead Adults'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+ma*ga*Ia')
 var[[id]]$flownames = c('Adult deaths')
 
 id = id + 1
 var[[id]]$varname = 'Se'
 var[[id]]$vartext = 'Susceptible Elderly'
 var[[id]]$varval = 100
 var[[id]]$flows = c('-bce*Ic*Se', '-bae*Ia*Se', '-bee*Ie*Se', '+bce*Ic*Se*f3', '+bae*Ia*Se*f3', '+bee*Ie*Se*f3', '+we*Re')
 var[[id]]$flownames = c('Child to Elderly infection', 'Adult to Elderly infection', 'Elderly to Elderly infection', 'Child to Elderly control measure', 'Adult to Elderly control measure', 'Elderly to Elderly control measure', 'Elderly loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'Ie'
 var[[id]]$vartext = 'Infected Elderly'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bce*Ic*Se', '+bae*Ia*Se', '+bee*Ie*Se', '-bce*Ic*Se*f3', '-bae*Ia*Se*f3', '-bee*Ie*Se*f3', '-ge*Ie')
 var[[id]]$flownames = c('Child to Elderly infection', 'Adult to Elderly infection', 'Elderly to Elderly infection', 'Child to Elderly control measure', 'Adult to Elderly control measure', 'Elderly to Elderly control measure', 'Elderly recovery')
 
 id = id + 1
 var[[id]]$varname = 'Re'
 var[[id]]$vartext = 'Recovered Elderly'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+ga*Ia', '-ma*ga*Ia', '-wa*Ra')
 var[[id]]$flownames = c('Elderly recovery', 'Elderly deaths', 'Elderly loss of immunity')
 
 id = id + 1
 var[[id]]$varname = 'De'
 var[[id]]$vartext = 'Dead Elderly'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+ma*ga*Ia')
 var[[id]]$flownames = c('Elderly deaths')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',21)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bcc'
 par[[id]]$partext = 'Child to Child infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bac'
 par[[id]]$partext = 'Adult to Child infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bec'
 par[[id]]$partext = 'Elderly to Child infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'wc'
 par[[id]]$partext = 'Child loss of immunity rate'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'gc'
 par[[id]]$partext = 'Child recovery rate'
 par[[id]]$parval = 0.06
 
 id = id + 1
 par[[id]]$parname = 'mc'
 par[[id]]$partext = 'Child death rate'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'f1'
 par[[id]]$partext = 'Child control measure'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'bca'
 par[[id]]$partext = 'Child to Adult infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'baa'
 par[[id]]$partext = 'Adult to Adult infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bea'
 par[[id]]$partext = 'Elderly to Adult infection Rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'wa'
 par[[id]]$partext = 'Adult loss of immunity'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'ga'
 par[[id]]$partext = 'Adult recovery rate'
 par[[id]]$parval = 0.06
 
 id = id + 1
 par[[id]]$parname = 'ma'
 par[[id]]$partext = 'Adult death rate'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'f2'
 par[[id]]$partext = 'Adult control measure'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'bce'
 par[[id]]$partext = 'Child to Elderly infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bae'
 par[[id]]$partext = 'Adult to Elderly infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bee'
 par[[id]]$partext = 'Elderly to Elderly infection rate'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'we'
 par[[id]]$partext = 'Elderly loss of immunity'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'ge'
 par[[id]]$partext = 'Elderly recovery rate'
 par[[id]]$parval = 0.06
 
 id = id + 1
 par[[id]]$parname = 'me'
 par[[id]]$partext = 'Elderly death rate'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'f3'
 par[[id]]$partext = 'Elderly control measure'
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