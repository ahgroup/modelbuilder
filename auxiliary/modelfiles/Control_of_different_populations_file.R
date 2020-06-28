############################## 
#R script to generate a modelbuilder model with code, save and export it. 
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
 var[[1]]$varname = 'Sc'
 var[[1]]$vartext = 'Susceptible Children'
 var[[1]]$varval = 100
 var[[1]]$flows = c('-bcc*Ic*Sc', '-bac*Ia*Sc', '-bec*Ie*Sc', '+bcc*Ic*Sc*f1', '+bac*Ia*Sc*f1', '+bec*Ie*Sc*f1', '+wc*Rc')
 var[[1]]$flownames = c('Child to Child infection', 'Adult to Child infection', 'Elderly to Child infection', 'Child to Child control measures', 'Adult to Child control measure ', 'Elderly to Child control measure', 'Child loss of immunity')
 
 var[[2]]$varname = 'Ic'
 var[[2]]$vartext = 'Infected Children'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+bcc*Ic*Sc', '+bac*Ia*Sc', '+bec*Ie*Sc', '-bcc*Ic*Sc*f1', '-bac*Ia*Sc*f1', '-bec*Ie*Sc*f1', '-gc*Ic')
 var[[2]]$flownames = c('Child to Child infection', 'Adult to Child infection', 'Elderly to Child infection', 'Child to Child control measure', 'Adult to child control measure', 'Elderly to Child control measure', 'Child recovery')
 
 var[[3]]$varname = 'Rc'
 var[[3]]$vartext = 'Recovered Children'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+gc*Ic', '-mc*gc*Ic', '-wc*Rc')
 var[[3]]$flownames = c('Child recovery', 'Child deaths', 'Child loss of immunity')
 
 var[[4]]$varname = 'Dc'
 var[[4]]$vartext = 'Dead Children'
 var[[4]]$varval = 0
 var[[4]]$flows = c('+mc*gc*Ic')
 var[[4]]$flownames = c('Child deaths')
 
 var[[5]]$varname = 'Sa'
 var[[5]]$vartext = 'Susceptible Adults'
 var[[5]]$varval = 100
 var[[5]]$flows = c('-bca*Ic*Sa', '-baa*Ia*Sa', '-bea*Ie*Sa', '+bca*Ic*Sa*f2', '+baa*Ia*Sa*f2', '+bea*Ie*Sa*f2', '+wa*Ra')
 var[[5]]$flownames = c('Child to Adult infection', 'Adult to Adult infection', 'Elderly to Adult infection', 'Child to Adult control measure', 'Adult to Adult control measure', 'Elderly to Adult control measure', 'Adult loss of immunity')
 
 var[[6]]$varname = 'Ia'
 var[[6]]$vartext = 'Infected Adults'
 var[[6]]$varval = 1
 var[[6]]$flows = c('+bca*Ic*Sa', '+baa*Ia*Sa*', '+bea*Ie*Sa', '-bca*Ic*Sa*f2', '-baa*Ia*Sa*f2', '-bea*Ie*Sa*f2', '-ga*Ia')
 var[[6]]$flownames = c('Child to Adult infection', 'Adult to Adult infection', 'Elderly to Adult infection', 'Child to Adult control measure', 'Adult to Adult control measure', 'Elderly to Adult control measure', 'Adult recovery')
 
 var[[7]]$varname = 'Ra'
 var[[7]]$vartext = 'Recovered Adults'
 var[[7]]$varval = 0
 var[[7]]$flows = c('+ga*Ia', '-ma*ga*Ia', '-wa*Ra')
 var[[7]]$flownames = c('Adult recovery', 'Adult deaths', 'Adult loss of immunity')
 
 var[[8]]$varname = 'Da'
 var[[8]]$vartext = 'Dead Adults'
 var[[8]]$varval = 0
 var[[8]]$flows = c('+ma*ga*Ia')
 var[[8]]$flownames = c('Adult deaths')
 
 var[[9]]$varname = 'Se'
 var[[9]]$vartext = 'Susceptible Elderly'
 var[[9]]$varval = 100
 var[[9]]$flows = c('-bce*Ic*Se', '-bae*Ia*Se', '-bee*Ie*Se', '+bce*Ic*Se*f3', '+bae*Ia*Se*f3', '+bee*Ie*Se*f3', '+we*Re')
 var[[9]]$flownames = c('Child to Elderly infection', 'Adult to Elderly infection', 'Elderly to Elderly infection', 'Child to Elderly control measure', 'Adult to Elderly control measure', 'Elderly to Elderly control measure', 'Elderly loss of immunity')
 
 var[[10]]$varname = 'Ie'
 var[[10]]$vartext = 'Infected Elderly'
 var[[10]]$varval = 1
 var[[10]]$flows = c('+bce*Ic*Se', '+bae*Ia*Se', '+bee*Ie*Se', '-bce*Ic*Se*f3', '-bae*Ia*Se*f3', '-bee*Ie*Se*f3', '-ge*Ie')
 var[[10]]$flownames = c('Child to Elderly infection', 'Adult to Elderly infection', 'Elderly to Elderly infection', 'Child to Elderly control measure', 'Adult to Elderly control measure', 'Elderly to Elderly control measure', 'Elderly recovery')
 
 var[[11]]$varname = 'Re'
 var[[11]]$vartext = 'Recovered Elderly'
 var[[11]]$varval = 0
 var[[11]]$flows = c('+ga*Ia', '-ma*ga*Ia', '-wa*Ra')
 var[[11]]$flownames = c('Elderly recovery', 'Elderly deaths', 'Elderly loss of immunity')
 
 var[[12]]$varname = 'De'
 var[[12]]$vartext = 'Dead Elderly'
 var[[12]]$varval = 0
 var[[12]]$flows = c('+ma*ga*Ia')
 var[[12]]$flownames = c('Elderly deaths')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',21)
 par[[1]]$parname = 'bcc'
 par[[1]]$partext = 'Child to Child infection rate'
 par[[1]]$parval = 0.001
 
 par[[2]]$parname = 'bac'
 par[[2]]$partext = 'Adult to Child infection rate'
 par[[2]]$parval = 0.001
 
 par[[3]]$parname = 'bec'
 par[[3]]$partext = 'Elderly to Child infection rate'
 par[[3]]$parval = 0.001
 
 par[[4]]$parname = 'wc'
 par[[4]]$partext = 'Child loss of immunity rate'
 par[[4]]$parval = 0.01
 
 par[[5]]$parname = 'gc'
 par[[5]]$partext = 'Child recovery rate'
 par[[5]]$parval = 0.06
 
 par[[6]]$parname = 'mc'
 par[[6]]$partext = 'Child death rate'
 par[[6]]$parval = 0.2
 
 par[[7]]$parname = 'f1'
 par[[7]]$partext = 'Child control measure'
 par[[7]]$parval = 0.1
 
 par[[8]]$parname = 'bca'
 par[[8]]$partext = 'Child to Adult infection rate'
 par[[8]]$parval = 0.001
 
 par[[9]]$parname = 'baa'
 par[[9]]$partext = 'Adult to Adult infection rate'
 par[[9]]$parval = 0.001
 
 par[[10]]$parname = 'bea'
 par[[10]]$partext = 'Elderly to Adult infection Rate'
 par[[10]]$parval = 0.001
 
 par[[11]]$parname = 'wa'
 par[[11]]$partext = 'Adult loss of immunity'
 par[[11]]$parval = 0.01
 
 par[[12]]$parname = 'ga'
 par[[12]]$partext = 'Adult recovery rate'
 par[[12]]$parval = 0.06
 
 par[[13]]$parname = 'ma'
 par[[13]]$partext = 'Adult death rate'
 par[[13]]$parval = 0.2
 
 par[[14]]$parname = 'f2'
 par[[14]]$partext = 'Adult control measure'
 par[[14]]$parval = 0.1
 
 par[[15]]$parname = 'bce'
 par[[15]]$partext = 'Child to Elderly infection rate'
 par[[15]]$parval = 0.001
 
 par[[16]]$parname = 'bae'
 par[[16]]$partext = 'Adult to Elderly infection rate'
 par[[16]]$parval = 0.001
 
 par[[17]]$parname = 'bee'
 par[[17]]$partext = 'Elderly to Elderly infection rate'
 par[[17]]$parval = 0.001
 
 par[[18]]$parname = 'we'
 par[[18]]$partext = 'Elderly loss of immunity'
 par[[18]]$parval = 0.2
 
 par[[19]]$parname = 'ge'
 par[[19]]$partext = 'Elderly recovery rate'
 par[[19]]$parval = 0.06
 
 par[[20]]$parname = 'me'
 par[[20]]$partext = 'Elderly death rate'
 par[[20]]$parval = 0.02
 
 par[[21]]$parname = 'f3'
 par[[21]]$partext = 'Elderly control measure'
 par[[21]]$parval = 0.1
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0
 
 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 100
 
 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 0.1
 
 mbmodel$time = time