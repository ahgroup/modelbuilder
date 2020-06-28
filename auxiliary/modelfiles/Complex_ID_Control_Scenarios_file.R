############################## 
#R script to generate a modelbuilder model with code, save and export it. 
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
 var[[1]]$varname = 'S'
 var[[1]]$vartext = 'Susceptible Host'
 var[[1]]$varval = 1000
 var[[1]]$flows = c('+eh', '-bP*P*S', '-bA*A*S', '-bI*I*S', '-bE*E*S', '+w*R', '-nh*S')
 var[[1]]$flownames = c('Susceptible host enters system', 'Presymptomatic infection', 'Asymptomatic infection', 'Symptomatic infection', 'Pathogen infection', 'Loss of immunity', 'Host death')
 
 var[[2]]$varname = 'P'
 var[[2]]$vartext = 'Infected, Presymptomatic'
 var[[2]]$varval = 1
 var[[2]]$flows = c('+bP*P*S', '+bA*A*S', '+bI*I*S', '+bE*E*S', '+bV*IV*S', '-gP*P', '-nh*P')
 var[[2]]$flownames = c('Presymptomatic infection', 'Asymptomatic infection', 'Symptomatic infection', 'Pathogen infection', 'Vector infection', 'Presymptomatic recovery', 'Host death')
 
 var[[3]]$varname = 'A'
 var[[3]]$vartext = 'Infected, Asymptomatic'
 var[[3]]$varval = 1
 var[[3]]$flows = c('+f*gP*P', '-gA*A', '-nh*A')
 var[[3]]$flownames = c('Presymptomatic hosts move into the asymptomatic', 'Asymptomatic recovery', 'Host natural death')
 
 var[[4]]$varname = 'I'
 var[[4]]$vartext = 'Infected, Symptomatic'
 var[[4]]$varval = 1
 var[[4]]$flows = c('+gP*P', '-f*gP*P', '-gI*I', '-nh*I')
 var[[4]]$flownames = c('Presymptomatic recovery', 'Presymptomatic hosts move into the asymptomatic', 'Symptomatic recovery', 'Host infection')
 
 var[[5]]$varname = 'R'
 var[[5]]$vartext = 'Recovered'
 var[[5]]$varval = 0
 var[[5]]$flows = c('+gA*A', '+gI*I', '-d*gI*I', '-w*R', '-nh*R')
 var[[5]]$flownames = c('Asymptomatic recovery', 'Symptomatic recovery', 'Host death due to infection', 'Loss of immunity', 'Host natural death')
 
 var[[6]]$varname = 'D'
 var[[6]]$vartext = 'Deaths'
 var[[6]]$varval = 0
 var[[6]]$flows = c('+d*gI*I')
 var[[6]]$flownames = c('Host death due to infection')
 
 var[[7]]$varname = 'E'
 var[[7]]$vartext = 'Pathogen in the environment'
 var[[7]]$varval = 0
 var[[7]]$flows = c('+pI*I', '+pA*A', '-c*E')
 var[[7]]$flownames = c('Symptomatic host pathogen shed', 'Asymptomatic host pathogen shed', 'Pathogen decay')
 
 var[[8]]$varname = 'SV'
 var[[8]]$vartext = 'Susceptible Vectors'
 var[[8]]$varval = 100
 var[[8]]$flows = c('+eV', '-bh*I*SV', '-nV*SV')
 var[[8]]$flownames = c('Susceptible vector enter system', 'Host infection', 'Vector natural death')
 
 var[[9]]$varname = 'IV'
 var[[9]]$vartext = 'Infectious Vectors'
 var[[9]]$varval = 1
 var[[9]]$flows = c('+bh*I*SV', '-nV*IV')
 var[[9]]$flownames = c('Host infection', 'Vector natural Death ')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',19)
 par[[1]]$parname = 'bP'
 par[[1]]$partext = 'Presymptomatic infection rate'
 par[[1]]$parval = 0.002
 
 par[[2]]$parname = 'bA'
 par[[2]]$partext = 'Asymptomatic infection rate'
 par[[2]]$parval = 0.002
 
 par[[3]]$parname = 'bI'
 par[[3]]$partext = 'Symptomatic infection rate'
 par[[3]]$parval = 0.002
 
 par[[4]]$parname = 'bE'
 par[[4]]$partext = 'Pathogen infection rate'
 par[[4]]$parval = 0.002
 
 par[[5]]$parname = 'bV'
 par[[5]]$partext = 'Vector infection rate'
 par[[5]]$parval = 0.002
 
 par[[6]]$parname = 'bh'
 par[[6]]$partext = 'Host natural infection rate'
 par[[6]]$parval = 0.002
 
 par[[7]]$parname = 'nV'
 par[[7]]$partext = 'Vector natural death rate'
 par[[7]]$parval = 0.02
 
 par[[8]]$parname = 'nh'
 par[[8]]$partext = 'Host death rate'
 par[[8]]$parval = 0.02
 
 par[[9]]$parname = 'gP'
 par[[9]]$partext = 'Presymptomatic recovery rate'
 par[[9]]$parval = 0.05
 
 par[[10]]$parname = 'gA'
 par[[10]]$partext = 'Asymptomatic recovery rate'
 par[[10]]$parval = 0.05
 
 par[[11]]$parname = 'gI'
 par[[11]]$partext = 'Symptomatic recovery rate'
 par[[11]]$parval = 0.05
 
 par[[12]]$parname = 'pI'
 par[[12]]$partext = 'Symptomatic host pathogen shed rate'
 par[[12]]$parval = 0.01
 
 par[[13]]$parname = 'pA'
 par[[13]]$partext = 'Asymptomatic host pathogen shed rate'
 par[[13]]$parval = 0.01
 
 par[[14]]$parname = 'c'
 par[[14]]$partext = 'pathogen decay rate '
 par[[14]]$parval = 0.03
 
 par[[15]]$parname = 'eV'
 par[[15]]$partext = 'Susceptible vector enter system rate'
 par[[15]]$parval = 0.2
 
 par[[16]]$parname = 'eh'
 par[[16]]$partext = 'Susceptible host enter system rate'
 par[[16]]$parval = 0.2
 
 par[[17]]$parname = 'f'
 par[[17]]$partext = 'presymptomatic hosts move into the asymptomatic rate'
 par[[17]]$parval = 0.4
 
 par[[18]]$parname = 'd'
 par[[18]]$partext = 'host death rate due to infection'
 par[[18]]$parval = 0.08
 
 par[[19]]$parname = 'w'
 par[[19]]$partext = 'Loss of immunity rate'
 par[[19]]$parval = 0.005
 
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