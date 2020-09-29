##############################
#R script to generate a modelbuilder model object with code.
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Characteristics of ID'
 mbmodel$description = 'A compartmental model with several different compartments: Susceptibles (S), Infected and Pre-symptomatic (P), Infected and Asymptomatic (A), Infected and Symptomatic (I), Recovered and Immune (R) and Dead (D)'
 mbmodel$author = 'Andreas Handel, Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model tracks the dynamics of susceptible, presymptomatic, asymptomatic, symptomatic, recovered, and dead individuals. Susceptible (S) individuals can become infected by presymptomatic (P), asymptomatic (A), or infected (I) hosts. All infected individuals enter the presymptomatic stage first, from which they can become symptomatic or asymptomatic. Asymptomatic hosts recover within some specified duration of time, while infected hosts either recover or die, thus entering either R or D. Recovered individuals are immune to reinfection. This model is part of the DSAIDE R package, more information can be found there.'

 #Information for all variables
 var = vector('list',6)
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-bP*S*P', '-bA*S*A', '-bI*S*I')
 var[[1]]$flownames = c('Infection by presymptomatic', 'Infection by asymptomatic', 'Infection by symptomatic')

 var[[2]]$varname = 'P'
 var[[2]]$vartext = 'Presymptomatic'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+bP*S*P', '+bA*S*A', '+bI*S*I', '-f*gP*P', '-(1-f)*gP*P')
 var[[2]]$flownames = c('Infection by presymptomatic', 'Infection by asymptomatic', 'Infection by symptomatic', 'Progression to asymtomatic stage', 'Progression to symptomatic stage')

 var[[3]]$varname = 'A'
 var[[3]]$vartext = 'Asymptomatic'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+f*gP*P', '-gA*A')
 var[[3]]$flownames = c('Progression to asymtomatic stage', 'Recovery of asymptomatic')

 var[[4]]$varname = 'I'
 var[[4]]$vartext = 'Symptomatic'
 var[[4]]$varval = 0
 var[[4]]$flows = c('+(1-f)*gP*P', '-d*gI*I', '-(1-d)*gI*I')
 var[[4]]$flownames = c('Progression to symptomatic stage', 'Progression to death', 'Progression to recovery')

 var[[5]]$varname = 'R'
 var[[5]]$vartext = 'Recovered'
 var[[5]]$varval = 0
 var[[5]]$flows = c('+gA*A', '+(1-d)*gI*I')
 var[[5]]$flownames = c('Recovery of asymptomatic', 'Recovery of symptomatic')

 var[[6]]$varname = 'D'
 var[[6]]$vartext = 'Dead'
 var[[6]]$varval = 0
 var[[6]]$flows = c('+d*gI*I')
 var[[6]]$flownames = c('Death of Symptomatic')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',8)
 par[[1]]$parname = 'bP'
 par[[1]]$partext = 'rate of transmission from P to S'
 par[[1]]$parval = 0

 par[[2]]$parname = 'bA'
 par[[2]]$partext = 'rate of transmission from A to S'
 par[[2]]$parval = 0

 par[[3]]$parname = 'bI'
 par[[3]]$partext = 'rate of transmission from I to S'
 par[[3]]$parval = 0.001

 par[[4]]$parname = 'gP'
 par[[4]]$partext = 'rate at which a person leaves the P compartment'
 par[[4]]$parval = 0.1

 par[[5]]$parname = 'gA'
 par[[5]]$partext = 'rate at which a person leaves the A compartment'
 par[[5]]$parval = 0.1

 par[[6]]$parname = 'gI'
 par[[6]]$partext = 'rate at which a person leaves the I compartment'
 par[[6]]$parval = 0.1

 par[[7]]$parname = 'f'
 par[[7]]$partext = 'fraction of asymptomatic infections'
 par[[7]]$parval = 0

 par[[8]]$parname = 'd'
 par[[8]]$partext = 'fraction of symptomatic hosts that die'
 par[[8]]$parval = 0

 mbmodel$par = par

 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0

 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 200

 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 0.1

 mbmodel$time = time
