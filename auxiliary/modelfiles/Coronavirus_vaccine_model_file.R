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
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('-(S/(S+P+A+I+R+H+D))*c*alpha*thetaP*P',
                    '-(S/(S+P+A+I+R+H+D))*c*alpha*thetaI*I',
                    '-(S/(S+P+A+I+R+H+D))*c*alpha*thetaA*A')
 var[[1]]$flownames = c('infection by presymptomatic',
                        'infection by ill',
                        'infection by asymptomatic')

 var[[2]]$varname = 'P'
 var[[2]]$vartext = 'Presymptomatic'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+nu*(S/(S+P+A+I+R+H+D))*c*alpha*thetaP*P',
                    '+nu*(S/(S+P+A+I+R+H+D))*c*alpha*thetaI*I',
                    '+nu*(S/(S+P+A+I+R+H+D))*c*alpha*thetaA*A',
                    '-sigma*P')
 var[[2]]$flownames = c('infection by presymptomatic', 'infection by ill', 'infection by asymptomatic', 'progression to symptoms')

 var[[3]]$varname = 'A'
 var[[3]]$vartext = 'Asymptomatic'
 var[[3]]$varval = 1
 var[[3]]$flows = c('+nuInverse*(S/(S+P+A+I+R+H+D))*c*alpha*thetaP*P',
                    '+nuInverse*(S/(S+P+A+I+R+H+D))*c*alpha*thetaI*I',
                    '+nuInverse*(S/(S+P+A+I+R+H+D))*c*alpha*thetaA*A',
                    '-gammaA*A')
 var[[3]]$flownames = c('infection by presymptomatic', 'infection by ill', 'infection by asymptomatic', 'recovery')

 var[[4]]$varname = 'I'
 var[[4]]$vartext = 'Ill'
 var[[4]]$varval = 1
 var[[4]]$flows = c('+sigma*P', '-gammaI*I')
 var[[4]]$flownames = c('progression to symptoms', 'progression to recovery or hospitalization')

 var[[5]]$varname = 'R'
 var[[5]]$vartext = 'Recovered'
 var[[5]]$varval = 0
 var[[5]]$flows = c('+gammaA*A', '+phiInverse*gammaI*I', '+rhoInverse*gammaH*H')
 var[[5]]$flownames = c('recovery of asymptomatics', 'recovery of ill', 'recovery of hospitalized')

 var[[6]]$varname = 'H'
 var[[6]]$vartext = 'Hospitalized'
 var[[6]]$varval = 0
 var[[6]]$flows = c('+phi*gammaI*I', '-gammaH*H')
 var[[6]]$flownames = c('progression to hospitalization', 'progression to recovery or death')

 var[[7]]$varname = 'D'
 var[[7]]$vartext = 'Deceased'
 var[[7]]$varval = 0
 var[[7]]$flows = c('+rho*gammaH*H')
 var[[7]]$flownames = c('death')

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',16)
 par[[1]]$parname = 'thetaP'
 par[[1]]$partext = 'infectiousness of presymptomatics'
 par[[1]]$parval = 0.001

 par[[2]]$parname = 'thetaI'
 par[[2]]$partext = 'infectiousness of ill'
 par[[2]]$parval = 0.001

 par[[3]]$parname = 'thetaA'
 par[[3]]$partext = 'infectiousness by asymptomatic'
 par[[3]]$parval = 5e-04

 par[[4]]$parname = 'nu'
 par[[4]]$partext = 'fraction symptomatic'
 par[[4]]$parval = 0.3

 par[[5]]$parname = 'sigma'
 par[[5]]$partext = 'progression to symptomatic'
 par[[5]]$parval = 0.2

 par[[6]]$parname = 'gammaA'
 par[[6]]$partext = 'recovery of asymptomatic'
 par[[6]]$parval = 0.125

 par[[7]]$parname = 'gammaI'
 par[[7]]$partext = 'leaving the symptomatic class'
 par[[7]]$parval = 0.1

 par[[8]]$parname = 'gammaH'
 par[[8]]$partext = 'leaving the hospitalized class'
 par[[8]]$parval = 0.2

 par[[9]]$parname = 'phi'
 par[[9]]$partext = 'fraction of symptomatics hospitalized'
 par[[9]]$parval = 0.05

 par[[10]]$parname = 'rho'
 par[[10]]$partext = 'fraction of hospitalized deceased'
 par[[10]]$parval = 0.01

 par[[11]]$parname = 'n'
 par[[11]]$partext = 'population size'
 par[[11]]$parval = 1003

 par[[12]]$parname = 'nuInverse'
 par[[12]]$partext = 'fraction asymptomatic'
 par[[12]]$parval = 0.7

 par[[13]]$parname = 'phiInverse'
 par[[13]]$partext = 'fraction of symptomatics NOT hospitalized'
 par[[13]]$parval = 0.95

 par[[14]]$parname = 'rhoInverse'
 par[[14]]$partext = 'fraction of hospitalized NOT deceased'
 par[[14]]$parval = 0.99

 par[[15]]$parname = 'c'
 par[[15]]$partext = 'contact matrix'
 par[[15]]$parval = 1

 par[[16]]$parname = 'alpha'
 par[[16]]$partext = 'susceptibility of susceptibles'
 par[[16]]$parval = 1

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


