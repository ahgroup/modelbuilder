############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Coronavirus vaccine model'
 mbmodel$description = 'A model with 7 compartments'
 mbmodel$author = 'COVAMOD consortium'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, presymptomatic, asymptomatic, infected/symptomatic/ill, recovered, hospitalized, and deceased compartments. The processes that are modeled are infection, progression to infectiousness, recovery, and progression to hospitalization and death. Immunity is permanent. Demographics through natural births and deaths are not included.' 

 #Information for all variables
 var = vector('list',7)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-nu*bP*S*P', '-(1-nu)*bP*S*P', '-nu*bA*S*A', '-(1-nu)*bA*S*A', '-nu*bI*S*I', '-(1-nu)*bI*S*I')
 var[[id]]$flownames = c('infection by presymptomatic leading to symptomatic infections', 'infection by presymptomatic leading to asymptomatic infections', 'infection by asymptomatic leading to symptomatic infections', 'infection by asymptomatic leading to asymptomatic infections', 'infection by symptomatic leading to symptomatic infections', 'infection by symptomatic leading to asymptomatic infections')
 
 id = id + 1
 var[[id]]$varname = 'P'
 var[[id]]$vartext = 'Presymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+nu*bP*S*P', '+nu*bA*S*A', '+nu*bI*S*I', '-sigma*P')
 var[[id]]$flownames = c('infection by presymptomatic', 'infection by ill', 'infection by asymptomatic', 'progression to symptoms')
 
 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'Asymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+(1-nu)*bP*S*P', '+(1-nu)*bA*S*A', '+(1-nu)*bI*S*I', '-gammaA*A')
 var[[id]]$flownames = c('infection by presymptomatic', 'infection by ill', 'infection by asymptomatic', 'recovery')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Ill'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+sigma*P', '-phi*gammaI*I', '-(1-phi)*gammaI*I')
 var[[id]]$flownames = c('progression to symptoms', 'progression to hospitalization', 'progression to recovery')
 
 id = id + 1
 var[[id]]$varname = 'H'
 var[[id]]$vartext = 'Hospitalized'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+phi*gammaI*I', '-rho*gammaH*H', '-(1-rho)*gammaH*H')
 var[[id]]$flownames = c('progression to hospitalization', 'progression to death', 'progression to recovery')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gammaA*A', '+(1-phi)*gammaI*I', '+(1-rho)*gammaH*H')
 var[[id]]$flownames = c('recovery of asymptomatics', 'recovery of ill', 'recovery of hospitalized')
 
 id = id + 1
 var[[id]]$varname = 'D'
 var[[id]]$vartext = 'Deceased'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+rho*gammaH*H')
 var[[id]]$flownames = c('death')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',16)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bP'
 par[[id]]$partext = 'transmission by presymptomatis'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bA'
 par[[id]]$partext = 'transmission by asymptomatic'
 par[[id]]$parval = 5e-04
 
 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'transmission by ill'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'nu'
 par[[id]]$partext = 'fraction symptomatic'
 par[[id]]$parval = 0.3
 
 id = id + 1
 par[[id]]$parname = 'sigma'
 par[[id]]$partext = 'progression to symptomatic'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'gammaA'
 par[[id]]$partext = 'recovery of asymptomatic'
 par[[id]]$parval = 0.125
 
 id = id + 1
 par[[id]]$parname = 'gammaI'
 par[[id]]$partext = 'leaving the symptomatic class'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'gammaH'
 par[[id]]$partext = 'leaving the hospitalized class'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'phi'
 par[[id]]$partext = 'fraction of symptomatics hospitalized'
 par[[id]]$parval = 0.05
 
 id = id + 1
 par[[id]]$parname = 'rho'
 par[[id]]$partext = 'fraction of hospitalized deceased'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'population size'
 par[[id]]$parval = 1003
 
 id = id + 1
 par[[id]]$parname = 'nuInverse'
 par[[id]]$partext = 'fraction asymptomatic'
 par[[id]]$parval = 0.7
 
 id = id + 1
 par[[id]]$parname = ''
 par[[id]]$partext = ''
 par[[id]]$parval = 
 
 id = id + 1
 par[[id]]$parname = ''
 par[[id]]$partext = ''
 par[[id]]$parval = 
 
 id = id + 1
 par[[id]]$parname = 'c'
 par[[id]]$partext = 'contact matrix'
 par[[id]]$parval = 1
 
 id = id + 1
 par[[id]]$parname = 'alpha'
 par[[id]]$partext = 'susceptibility of susceptibles'
 par[[id]]$parval = 1
 
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