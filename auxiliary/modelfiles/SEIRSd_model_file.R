############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'SEIRSd model'
 mbmodel$description = 'A SEIRS model with 4 compartments'
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, exposed/asymptomatic, infected/symptomatic, and recovered compartments. The processes that are modeled are infection, progression to infectiousness, recovery and waning immunity. Demographics through natural births and deaths are also included.' 

 #Information for all variables
 var = vector('list',4)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-bE*S*E', '-bI*S*I', '+w*R', '+n', '-m*S')
 var[[id]]$flownames = c('infection by exposed', 'infection by symptomatic', 'waning immunity', 'births', 'natural deaths')
 
 id = id + 1
 var[[id]]$varname = 'E'
 var[[id]]$vartext = 'Exposed'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bE*S*E', '+bI*S*I', '-gE*E', '-m*E')
 var[[id]]$flownames = c('infection by exposed', 'infection by symptomatic', 'progression to symptoms', 'natural deaths')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected and Symptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+gE*E', '-gI*I', '-m*I')
 var[[id]]$flownames = c('progression to symptoms', 'recovery', 'natural deaths')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gI*I', '-w*R', '-m*R')
 var[[id]]$flownames = c('recovery', 'waning immunity', 'natural death')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',7)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bE'
 par[[id]]$partext = 'infection by exposed'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'infection by symptomatic'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'gE'
 par[[id]]$partext = 'progression rate'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'gI'
 par[[id]]$partext = 'recovery rate'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'w'
 par[[id]]$partext = 'waning immunity'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'births'
 par[[id]]$parval = 0
 
 id = id + 1
 par[[id]]$parname = 'm'
 par[[id]]$partext = 'deaths'
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