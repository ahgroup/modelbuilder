##############################
#R script to generate a modelbuilder model object with code.
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Host Heterogeneity Model'
 mbmodel$description = 'An SIR type model stratified for two different types of hosts.'
 mbmodel$author = 'Andreas Handel, Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'This model tracks susceptibles, infected and recovered of 2 different types. Think of those types as e.g. males/females, children/adults, etc. The model includes infection, recovery and waning immunity processes for both hosts.'

 #Information for all variables
 var = vector('list',6)
 var[[1]]$varname = 'S1'
 var[[1]]$vartext = 'Susceptible type 1 hosts'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-b11*S1*I1', '-b12*S1*I2', '+w1*R1')
 var[[1]]$flownames = c('Susceptible 1 hosts infected by infected 1 hosts', 'Susceptible 1 hosts infected by infected 2 hosts', 'Loss of immunity by recovered 1 hosts')

 var[[2]]$varname = 'I1'
 var[[2]]$vartext = 'Infected type 1 hosts'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+b11*S1*I1', '+b12*S1*I2', '-g1*I1')
 var[[2]]$flownames = c('Susceptible 1 hosts infected by infected 1 hosts', 'Susceptible 1 hosts infected by infected 2 hosts', 'Infected 1 hosts recovery')

 var[[3]]$varname = 'R1'
 var[[3]]$vartext = 'Recovered type 1 hosts'
 var[[3]]$varval = 0
 var[[3]]$flows = c('+g1*I1', '-w1*R1')
 var[[3]]$flownames = c('Infected 1 hosts recovery', 'Loss of immunity by recovered 1 hosts')

 var[[4]]$varname = 'S2'
 var[[4]]$vartext = 'Susceptible type 2 hosts'
 var[[4]]$varval = 200
 var[[4]]$flows = c('-b21*S2*I1', '-b22*S2*I2', '+w2*R2')
 var[[4]]$flownames = c('Susceptible 2 hosts infected by infected 1 hosts', 'Susceptible 2 hosts infected by infected 2 hosts', 'Loss of immunity by recovered 2 hosts')

 var[[5]]$varname = 'I2'
 var[[5]]$vartext = 'Infected type 2 hosts'
 var[[5]]$varval = 1
 var[[5]]$flows = c('+b21*S2*I1', '+b22*S2*I2', '-g2*I2')
 var[[5]]$flownames = c('Susceptible 2 hosts infected by infected 1 hosts', 'Susceptible 2 hosts infected by infected 2 hosts', 'Infected 2 hosts recovery')

 var[[6]]$varname = 'R2'
 var[[6]]$vartext = 'Recovered type 2 hosts'
 var[[6]]$varval = 0
 var[[6]]$flows = c('+g2*I2', '-w2*R2')
 var[[6]]$flownames = c('Infected 2 hosts recovery', 'Loss of immunity by recovered 2 hosts')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',8)
 par[[1]]$parname = 'b11'
 par[[1]]$partext = 'rate of transmission to susceptible type 1 host from infected type 1 host'
 par[[1]]$parval = 0.002

 par[[2]]$parname = 'b12'
 par[[2]]$partext = 'rate of transmission to susceptible type 1 host from infected type 2 host'
 par[[2]]$parval = 0

 par[[3]]$parname = 'b21'
 par[[3]]$partext = 'rate of transmission to susceptible type 2 host from infected type 1 host'
 par[[3]]$parval = 0

 par[[4]]$parname = 'b22'
 par[[4]]$partext = 'rate of transmission to susceptible type 2 host from infected type 2 host'
 par[[4]]$parval = 0.01

 par[[5]]$parname = 'g1'
 par[[5]]$partext = 'the rate at which infected type 1 hosts recover'
 par[[5]]$parval = 1

 par[[6]]$parname = 'g2'
 par[[6]]$partext = 'the rate at which infected type 2 hosts recover'
 par[[6]]$parval = 1

 par[[7]]$parname = 'w1'
 par[[7]]$partext = 'the rate at which type 1 host immunity wanes'
 par[[7]]$parval = 0

 par[[8]]$parname = 'w2'
 par[[8]]$partext = 'the rate at which type 2 host immunity wanes'
 par[[8]]$parval = 0

 mbmodel$par = par

 #Information for time parameters
 time = vector('list',3)
 time[[1]]$timename = 'tstart'
 time[[1]]$timetext = 'Start time of simulation'
 time[[1]]$timeval = 0

 time[[2]]$timename = 'tfinal'
 time[[2]]$timetext = 'Final time of simulation'
 time[[2]]$timeval = 60

 time[[3]]$timename = 'dt'
 time[[3]]$timetext = 'Time step'
 time[[3]]$timeval = 0.1

 mbmodel$time = time
