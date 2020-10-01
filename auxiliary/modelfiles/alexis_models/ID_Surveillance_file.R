##############################
#R script to generate a modelbuilder model object with code.
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'ID Surveillance'
 mbmodel$description = 'A compartmental model that includes Susceptible, Presymptomatic, Asymptomatic, Symptomatic, Recovered and Dead individuals.'
 mbmodel$author = 'Andreas Handel, Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = ' '

 #Information for all variables
 var = vector('list',6)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('+m', '-S*bP*P', '-S*bA*A', '-S*bI*I', '+w*R', '-n*S')
 var[[id]]$flownames = c('Susceptible natural birth', 'Susceptible hosts infected by presymptomatic hosts', 'Susceptible hosts infected by asymptomatic hosts', 'Susceptible hosts infected by symptomatic hosts', 'Recovered immunity loss', 'Susceptible natural death')

 id = id + 1
 var[[id]]$varname = 'P'
 var[[id]]$vartext = 'Presymptomatic'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+S*bP*P', '+S*bA*A', '+S*bI*I', '-P*gP', '-P*rP', '-P*n')
 var[[id]]$flownames = c('Susceptible hosts infected by presymptomatic hosts', 'Susceptible hosts infected by asymptomatic hosts', 'Susceptible hosts infected by symptomatic hosts', 'Presymptomatic hosts leave stage', 'Presymptomatic hosts recover', 'Presymptomatic natural death')

 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'Asymptomatic'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+f*gP*P', '-A*rA', '-A*n')
 var[[id]]$flownames = c('Presymptomatic hosts change to the asymptomatic hosts', 'Asymptomatic recovery', 'Asymptomatic natural death')

 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Symptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+P*gP', '-P*gP*f', '-I*rI', '-I*n', '-I*d')
 var[[id]]$flownames = c('Total Presymptomatic hosts change to different stage', 'Presymptomatic hosts change to asymptomatic hosts', 'Symptomatic hosts recover', 'Symptomatic host natural death', 'Symptomatic host death due to infection')

 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+P*rP', '+A*rA', '+I*rI', '-w*R')
 var[[id]]$flownames = c('Presymptomatic recovery', 'Asymptomatic recovery', 'Symptomatic recovery', 'Recovered loss of immunity ')

 id = id + 1
 var[[id]]$varname = 'D'
 var[[id]]$vartext = 'Dead'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+d*D')
 var[[id]]$flownames = c('Host death due to infection')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',12)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bP'
 par[[id]]$partext = 'rate of transmission from presymptomatic to susceptible host'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'bA'
 par[[id]]$partext = 'rate of transmission from asymptomatic to susceptible host'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'rate of transmission from symptomatic to susceptible host'
 par[[id]]$parval = 0.001

 id = id + 1
 par[[id]]$parname = 'gP'
 par[[id]]$partext = 'the rate at which presymptomatic hosts move to the next stage'
 par[[id]]$parval = 0.5

 id = id + 1
 par[[id]]$parname = 'f'
 par[[id]]$partext = 'fraction of asymptomatic hosts'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'rate at which infected hosts die'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'w'
 par[[id]]$partext = 'the rate at which host immunity wanes'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'm'
 par[[id]]$partext = 'the rate of births'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'the rate of natural deaths'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'rP'
 par[[id]]$partext = 'rate of pre-symptomatic host removal due to surveillance'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'rA'
 par[[id]]$partext = 'rate of asymptomatic host removal due to surveillance'
 par[[id]]$parval = 0

 id = id + 1
 par[[id]]$parname = 'rI'
 par[[id]]$partext = 'rate of symptomatic host removal due to surveillance'
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
