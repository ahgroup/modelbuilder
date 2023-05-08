############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.930296 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Complex ID Control Scenarios'
 mbmodel$description = 'The basic SIR model is expanded to include vectors.'
 mbmodel$author = ' Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'The model includes susceptible, infected, asymptomatic, presymptomactic, pathogens, susceptible vectors, infected vectors, recovered and death compartments. The processes that are modeled are infection, recovery, birth, death, and immunity.' 

 #Information for all variables
 var = vector('list',9)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible Host'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('+eh', '-bP*P*S', '-bA*A*S', '-bI*I*S', '-bE*E*S', '+w*R', '-nh*S')
 var[[id]]$flownames = c('Susceptible host enters system', 'Presymptomatic infection', 'Asymptomatic infection', 'Symptomatic infection', 'Pathogen infection', 'Loss of immunity', 'Host death')
 
 id = id + 1
 var[[id]]$varname = 'P'
 var[[id]]$vartext = 'Infected, Presymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bP*P*S', '+bA*A*S', '+bI*I*S', '+bE*E*S', '+bV*IV*S', '-gP*P', '-nh*P')
 var[[id]]$flownames = c('Presymptomatic infection', 'Asymptomatic infection', 'Symptomatic infection', 'Pathogen infection', 'Vector infection', 'Presymptomatic recovery', 'Host death')
 
 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'Infected, Asymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+f*gP*P', '-gA*A', '-nh*A')
 var[[id]]$flownames = c('Presymptomatic hosts move into the asymptomatic', 'Asymptomatic recovery', 'Host natural death')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Infected, Symptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+gP*P', '-f*gP*P', '-gI*I', '-nh*I')
 var[[id]]$flownames = c('Presymptomatic recovery', 'Presymptomatic hosts move into the asymptomatic', 'Symptomatic recovery', 'Host infection')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gA*A', '+gI*I', '-d*gI*I', '-w*R', '-nh*R')
 var[[id]]$flownames = c('Asymptomatic recovery', 'Symptomatic recovery', 'Host death due to infection', 'Loss of immunity', 'Host natural death')
 
 id = id + 1
 var[[id]]$varname = 'D'
 var[[id]]$vartext = 'Deaths'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+d*gI*I')
 var[[id]]$flownames = c('Host death due to infection')
 
 id = id + 1
 var[[id]]$varname = 'E'
 var[[id]]$vartext = 'Pathogen in the environment'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+pI*I', '+pA*A', '-c*E')
 var[[id]]$flownames = c('Symptomatic host pathogen shed', 'Asymptomatic host pathogen shed', 'Pathogen decay')
 
 id = id + 1
 var[[id]]$varname = 'SV'
 var[[id]]$vartext = 'Susceptible Vectors'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+eV', '-bh*I*SV', '-nV*SV')
 var[[id]]$flownames = c('Susceptible vector enter system', 'Host infection', 'Vector natural death')
 
 id = id + 1
 var[[id]]$varname = 'IV'
 var[[id]]$vartext = 'Infectious Vectors'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bh*I*SV', '-nV*IV')
 var[[id]]$flownames = c('Host infection', 'Vector natural Death ')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',19)
 id = 0
 id = id + 1
 par[[id]]$parname = 'bP'
 par[[id]]$partext = 'Presymptomatic infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'bA'
 par[[id]]$partext = 'Asymptomatic infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'Symptomatic infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'bE'
 par[[id]]$partext = 'Pathogen infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'bV'
 par[[id]]$partext = 'Vector infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'bh'
 par[[id]]$partext = 'Host natural infection rate'
 par[[id]]$parval = 0.002
 
 id = id + 1
 par[[id]]$parname = 'nV'
 par[[id]]$partext = 'Vector natural death rate'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'nh'
 par[[id]]$partext = 'Host death rate'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'gP'
 par[[id]]$partext = 'Presymptomatic recovery rate'
 par[[id]]$parval = 0.05
 
 id = id + 1
 par[[id]]$parname = 'gA'
 par[[id]]$partext = 'Asymptomatic recovery rate'
 par[[id]]$parval = 0.05
 
 id = id + 1
 par[[id]]$parname = 'gI'
 par[[id]]$partext = 'Symptomatic recovery rate'
 par[[id]]$parval = 0.05
 
 id = id + 1
 par[[id]]$parname = 'pI'
 par[[id]]$partext = 'Symptomatic host pathogen shed rate'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'pA'
 par[[id]]$partext = 'Asymptomatic host pathogen shed rate'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'c'
 par[[id]]$partext = 'pathogen decay rate '
 par[[id]]$parval = 0.03
 
 id = id + 1
 par[[id]]$parname = 'eV'
 par[[id]]$partext = 'Susceptible vector enter system rate'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'eh'
 par[[id]]$partext = 'Susceptible host enter system rate'
 par[[id]]$parval = 0.2
 
 id = id + 1
 par[[id]]$parname = 'f'
 par[[id]]$partext = 'presymptomatic hosts move into the asymptomatic rate'
 par[[id]]$parval = 0.4
 
 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'host death rate due to infection'
 par[[id]]$parval = 0.08
 
 id = id + 1
 par[[id]]$parname = 'w'
 par[[id]]$partext = 'Loss of immunity rate'
 par[[id]]$parval = 0.005
 
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