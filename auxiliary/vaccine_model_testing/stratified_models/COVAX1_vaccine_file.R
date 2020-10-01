############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'COVAX1_vaccine'
 mbmodel$description = 'A Covid vaccine model'
 mbmodel$author = 'COVAMOD consortium'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, presymptomatic, asymptomatic, infected/symptomatic/ill, recovered, and deceased compartments.' 

 #Information for all variables
 var = vector('list',12)
 id = 0
 id = id + 1
 var[[id]]$varname = 'Suv'
 var[[id]]$vartext = 'Susceptible unvaccinated'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-nu_Suv*bP_Suv_Puv*Suv*Puv', '-nu_Suv*bP_Suv_Pv*Suv*Pv', '-(1-nu_Suv)*bP_Suv_Puv*Suv*Puv', '-(1-nu_Suv)*bP_Suv_Pv*Suv*Pv', '-nu_Suv*bA_Suv_Auv*Suv*Auv', '-nu_Suv*bA_Suv_Av*Suv*Av', '-(1-nu_Suv)*bA_Suv_Auv*Suv*Auv', '-(1-nu_Suv)*bA_Suv_Av*Suv*Av', '-nu_Suv*bI_Suv_Iuv*Suv*Iuv', '-nu_Suv*bI_Suv_Iv*Suv*Iv', '-(1-nu_Suv)*bI_Suv_Iuv*Suv*Iuv', '-(1-nu_Suv)*bI_Suv_Iv*Suv*Iv', '*w_Ruv*Ruv')
 var[[id]]$flownames = c('infection by presymptomatic leading to symptomatic infections, unvaccinated', 'infection by presymptomatic leading to symptomatic infections, unvaccinated', 'infection by presymptomatic leading to asymptomatic infections, unvaccinated', 'infection by presymptomatic leading to asymptomatic infections, unvaccinated', 'infection by asymptomatic leading to symptomatic infections, unvaccinated', 'infection by asymptomatic leading to symptomatic infections, unvaccinated', 'infection by asymptomatic leading to asymptomatic infections, unvaccinated', 'infection by asymptomatic leading to asymptomatic infections, unvaccinated', 'infection by symptomatic leading to symptomatic infections, unvaccinated', 'infection by symptomatic leading to symptomatic infections, unvaccinated', 'infection by symptomatic leading to asymptomatic infections, unvaccinated', 'infection by symptomatic leading to asymptomatic infections, unvaccinated', 'waning immunity, unvaccinated', 'waning immunity, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Sv'
 var[[id]]$vartext = 'Susceptible vaccinated'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('-nu_Sv*bP_Sv_Puv*Sv*Puv', '-nu_Sv*bP_Sv_Pv*Sv*Pv', '-(1-nu_Sv)*bP_Sv_Puv*Sv*Puv', '-(1-nu_Sv)*bP_Sv_Pv*Sv*Pv', '-nu_Sv*bA_Sv_Auv*Sv*Auv', '-nu_Sv*bA_Sv_Av*Sv*Av', '-(1-nu_Sv)*bA_Sv_Auv*Sv*Auv', '-(1-nu_Sv)*bA_Sv_Av*Sv*Av', '-nu_Sv*bI_Sv_Iuv*Sv*Iuv', '-nu_Sv*bI_Sv_Iv*Sv*Iv', '-(1-nu_Sv)*bI_Sv_Iuv*Sv*Iuv', '-(1-nu_Sv)*bI_Sv_Iv*Sv*Iv', '*w_Rv*Rv')
 var[[id]]$flownames = c('infection by presymptomatic leading to symptomatic infections, vaccinated', 'infection by presymptomatic leading to symptomatic infections, vaccinated', 'infection by presymptomatic leading to asymptomatic infections, vaccinated', 'infection by presymptomatic leading to asymptomatic infections, vaccinated', 'infection by asymptomatic leading to symptomatic infections, vaccinated', 'infection by asymptomatic leading to symptomatic infections, vaccinated', 'infection by asymptomatic leading to asymptomatic infections, vaccinated', 'infection by asymptomatic leading to asymptomatic infections, vaccinated', 'infection by symptomatic leading to symptomatic infections, vaccinated', 'infection by symptomatic leading to symptomatic infections, vaccinated', 'infection by symptomatic leading to asymptomatic infections, vaccinated', 'infection by symptomatic leading to asymptomatic infections, vaccinated', 'waning immunity, vaccinated', 'waning immunity, vaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Puv'
 var[[id]]$vartext = 'Presymptomatic unvaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+nu_Suv*bP_Suv_Puv*Suv*Puv', '+nu_Suv*bP_Suv_Pv*Suv*Pv', '+nu_Suv*bA_Suv_Auv*Suv*Auv', '+nu_Suv*bA_Suv_Av*Suv*Av', '+nu_Suv*bI_Suv_Iuv*Suv*Iuv', '+nu_Suv*bI_Suv_Iv*Suv*Iv', '-sig_Puv*Puv')
 var[[id]]$flownames = c('infection by presymptomatic, unvaccinated', 'infection by presymptomatic, unvaccinated', 'infection by ill, unvaccinated', 'infection by ill, unvaccinated', 'infection by asymptomatic, unvaccinated', 'infection by asymptomatic, unvaccinated', 'progression to symptoms, unvaccinated', 'progression to symptoms, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Pv'
 var[[id]]$vartext = 'Presymptomatic vaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+nu_Sv*bP_Sv_Puv*Sv*Puv', '+nu_Sv*bP_Sv_Pv*Sv*Pv', '+nu_Sv*bA_Sv_Auv*Sv*Auv', '+nu_Sv*bA_Sv_Av*Sv*Av', '+nu_Sv*bI_Sv_Iuv*Sv*Iuv', '+nu_Sv*bI_Sv_Iv*Sv*Iv', '-sig_Pv*Pv')
 var[[id]]$flownames = c('infection by presymptomatic, vaccinated', 'infection by presymptomatic, vaccinated', 'infection by ill, vaccinated', 'infection by ill, vaccinated', 'infection by asymptomatic, vaccinated', 'infection by asymptomatic, vaccinated', 'progression to symptoms, vaccinated', 'progression to symptoms, vaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Auv'
 var[[id]]$vartext = 'Asymptomatic unvaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+(1-nu_Suv)*bP_Suv_Puv*Suv*Puv', '+(1-nu_Suv)*bP_Suv_Pv*Suv*Pv', '+(1-nu_Suv)*bA_Suv_Auv*Suv*Auv', '+(1-nu_Suv)*bA_Suv_Av*Suv*Av', '+(1-nu_Suv)*bI_Suv_Iuv*Suv*Iuv', '+(1-nu_Suv)*bI_Suv_Iv*Suv*Iv', '-gA_Auv*Auv')
 var[[id]]$flownames = c('infection by presymptomatic, unvaccinated', 'infection by presymptomatic, unvaccinated', 'infection by ill, unvaccinated', 'infection by ill, unvaccinated', 'infection by asymptomatic, unvaccinated', 'infection by asymptomatic, unvaccinated', 'recovery, unvaccinated', 'recovery, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Av'
 var[[id]]$vartext = 'Asymptomatic vaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+(1-nu_Sv)*bP_Sv_Puv*Sv*Puv', '+(1-nu_Sv)*bP_Sv_Pv*Sv*Pv', '+(1-nu_Sv)*bA_Sv_Auv*Sv*Auv', '+(1-nu_Sv)*bA_Sv_Av*Sv*Av', '+(1-nu_Sv)*bI_Sv_Iuv*Sv*Iuv', '+(1-nu_Sv)*bI_Sv_Iv*Sv*Iv', '-gA_Av*Av')
 var[[id]]$flownames = c('infection by presymptomatic, vaccinated', 'infection by presymptomatic, vaccinated', 'infection by ill, vaccinated', 'infection by ill, vaccinated', 'infection by asymptomatic, vaccinated', 'infection by asymptomatic, vaccinated', 'recovery, vaccinated', 'recovery, vaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Iuv'
 var[[id]]$vartext = 'Ill unvaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+sig_Puv*Puv', '-rho_Iuv*gI_Iuv*Iuv', '-(1-rho_Iuv)*gI_Iuv*Iuv')
 var[[id]]$flownames = c('progression to symptoms, unvaccinated', 'progression to symptoms, unvaccinated', 'progression to death, unvaccinated', 'progression to death, unvaccinated', 'progression to recovery, unvaccinated', 'progression to recovery, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Iv'
 var[[id]]$vartext = 'Ill vaccinated'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+sig_Pv*Pv', '-rho_Iv*gI_Iv*Iv', '-(1-rho_Iv)*gI_Iv*Iv')
 var[[id]]$flownames = c('progression to symptoms, vaccinated', 'progression to symptoms, vaccinated', 'progression to death, vaccinated', 'progression to death, vaccinated', 'progression to recovery, vaccinated', 'progression to recovery, vaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Ruv'
 var[[id]]$vartext = 'Recovered unvaccinated'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gA_Auv*Auv', '+(1-rho_Iuv)*gI_Iuv*Iuv', '-w_Ruv*Ruv')
 var[[id]]$flownames = c('recovery of asymptomatics, unvaccinated', 'recovery of asymptomatics, unvaccinated', 'recovery of ill, unvaccinated', 'recovery of ill, unvaccinated', 'waning immunity, unvaccinated', 'waning immunity, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Rv'
 var[[id]]$vartext = 'Recovered vaccinated'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gA_Av*Av', '+(1-rho_Iv)*gI_Iv*Iv', '-w_Rv*Rv')
 var[[id]]$flownames = c('recovery of asymptomatics, vaccinated', 'recovery of asymptomatics, vaccinated', 'recovery of ill, vaccinated', 'recovery of ill, vaccinated', 'waning immunity, vaccinated', 'waning immunity, vaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Duv'
 var[[id]]$vartext = 'Deceased unvaccinated'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+rho_Iuv*gI_Iuv*Iuv')
 var[[id]]$flownames = c('death, unvaccinated', 'death, unvaccinated')
 
 id = id + 1
 var[[id]]$varname = 'Dv'
 var[[id]]$vartext = 'Deceased vaccinated'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+rho_Iv*gI_Iv*Iv')
 var[[id]]$flownames = c('death, vaccinated', 'death, vaccinated')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',24)
 id = 0
 id = id + 1
 par[[id]]$parname = 'nu_Suv'
 par[[id]]$partext = 'fraction symptomatic:  vaccinated'
 par[[id]]$parval = 0.3
 
 id = id + 1
 par[[id]]$parname = 'bP_Suv_Puv'
 par[[id]]$partext = 'transmission by presymptomatic: to  vaccinated from  vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bP_Suv_Pv'
 par[[id]]$partext = 'transmission by presymptomatic: to presymptomatic vaccinated from presymptomatic vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bA_Suv_Auv'
 par[[id]]$partext = 'transmission by asymptomatic: to  vaccinated from  vaccinated'
 par[[id]]$parval = 5e-04
 
 id = id + 1
 par[[id]]$parname = 'bA_Suv_Av'
 par[[id]]$partext = 'transmission by asymptomatic: to asymptomatic vaccinated from asymptomatic vaccinated'
 par[[id]]$parval = 5e-04
 
 id = id + 1
 par[[id]]$parname = 'bI_Suv_Iuv'
 par[[id]]$partext = 'transmission by ill: to  vaccinated from  vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bI_Suv_Iv'
 par[[id]]$partext = 'transmission by ill: to ill vaccinated from ill vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'w_Ruv'
 par[[id]]$partext = 'immunity wane rate:  vaccinated'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'nu_Sv'
 par[[id]]$partext = 'fraction symptomatic: susceptible vaccinated'
 par[[id]]$parval = 0.3
 
 id = id + 1
 par[[id]]$parname = 'bP_Sv_Puv'
 par[[id]]$partext = 'transmission by presymptomatic: to susceptible vaccinated from susceptible vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bP_Sv_Pv'
 par[[id]]$partext = 'transmission by presymptomatic: to susceptible vaccinated from presymptomatic vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bA_Sv_Auv'
 par[[id]]$partext = 'transmission by asymptomatic: to susceptible vaccinated from susceptible vaccinated'
 par[[id]]$parval = 5e-04
 
 id = id + 1
 par[[id]]$parname = 'bA_Sv_Av'
 par[[id]]$partext = 'transmission by asymptomatic: to susceptible vaccinated from asymptomatic vaccinated'
 par[[id]]$parval = 5e-04
 
 id = id + 1
 par[[id]]$parname = 'bI_Sv_Iuv'
 par[[id]]$partext = 'transmission by ill: to susceptible vaccinated from susceptible vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bI_Sv_Iv'
 par[[id]]$partext = 'transmission by ill: to susceptible vaccinated from ill vaccinated'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'w_Rv'
 par[[id]]$partext = 'immunity wane rate: recovered vaccinated'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'sig_Puv'
 par[[id]]$partext = 'progression to symptomatic:  vaccinated'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'sig_Pv'
 par[[id]]$partext = 'progression to symptomatic: presymptomatic vaccinated'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'gA_Auv'
 par[[id]]$partext = 'recovery of asymptomatic:  vaccinated'
 par[[id]]$parval = 0.125
 
 id = id + 1
 par[[id]]$parname = 'gA_Av'
 par[[id]]$partext = 'recovery of asymptomatic: asymptomatic vaccinated'
 par[[id]]$parval = 0.125
 
 id = id + 1
 par[[id]]$parname = 'rho_Iuv'
 par[[id]]$partext = 'fraction dying:  vaccinated'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'gI_Iuv'
 par[[id]]$partext = 'leaving the symptomatic class:  vaccinated'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'rho_Iv'
 par[[id]]$partext = 'fraction dying: ill vaccinated'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'gI_Iv'
 par[[id]]$partext = 'leaving the symptomatic class: ill vaccinated'
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