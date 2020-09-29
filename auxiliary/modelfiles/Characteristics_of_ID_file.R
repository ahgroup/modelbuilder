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
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-bP*S*P', '-bA*S*A', '-bI*S*I')
 var[[id]]$flownames = c('Infection by presymptomatic', 'Infection by asymptomatic', 'Infection by symptomatic')
 
 id = id + 1
 var[[id]]$varname = 'P'
 var[[id]]$vartext = 'Presymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bP*S*P', '+bA*S*A', '+bI*S*I', '-f*gP*P', '-(1-f)*gP*P')
 var[[id]]$flownames = c('Infection by presymptomatic', 'Infection by asymptomatic', 'Infection by symptomatic', 'Progression to asymtomatic stage', 'Progression to symptomatic stage')
 
 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'Asymptomatic'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+f*gP*P', '-gA*A')
 var[[id]]$flownames = c('Progression to asymtomatic stage', 'Recovery of asymptomatic')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Symptomatic'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+(1-f)*gP*P', '-d*gI*I', '-(1-d)*gI*I')
 var[[id]]$flownames = c('Progression to symptomatic stage', 'Progression to death', 'Progression to recovery')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gA*A', '+(1-d)*gI*I')
 var[[id]]$flownames = c('Recovery of asymptomatic', 'Recovery of symptomatic')
 
 id = id + 1
 var[[id]]$varname = 'D'
 var[[id]]$vartext = 'Dead'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+d*gI*I')
 var[[id]]$flownames = c('Death of Symptomatic')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',8)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bP'
 par[[id]]$partext = 'rate of transmission from P to S'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'bA'
 par[[id]]$partext = 'rate of transmission from A to S'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'rate of transmission from I to S'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'gP'
 par[[id]]$partext = 'rate at which a person leaves the P compartment'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'gA'
 par[[id]]$partext = 'rate at which a person leaves the A compartment'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'gI'
 par[[id]]$partext = 'rate at which a person leaves the I compartment'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'f'
 par[[id]]$partext = 'fraction of asymptomatic infections'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'fraction of symptomatic hosts that die'
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
 time[[id]]$timeval = 200
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time