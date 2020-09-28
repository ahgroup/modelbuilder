############################## 
#R script to generate a modelbuilder model object with code. 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Complex ID Control'
 mbmodel$description = 'A compartmental model with several different compartments:  Susceptibles (S), Infected and Pre-symptomatic (P), Infected and Asymptomatic (A), Infected and Symptomatic (I), Recovered and Immune (R) and Dead (D). Also modeled is an environmental pathogen stage (E), and susceptible (Sv) and infected (Iv) vectors.'
 mbmodel$author = 'Andreas Handel, Alexis Vittengl'
 mbmodel$date = Sys.Date()
 mbmodel$details = 'Susceptible individuals (S) can become infected by pre-symptomatic (P), asymptomatic (A) or symptomatic (I) hosts. The rates at which infections from the different types of infected individuals (P, A and I) occur are governed by 3 parameters, _b~P~_, _b~A~_, and _b~I~_. Susceptible individuals (S) can also become infected by contact with the environment or infected vectors, at rates _b~E~_ and _b~v~_. Susceptible vectors (S~v~) can become infected by contact with symptomatic hosts at rate _b~h~_. All infected hosts first enter the presymptomatic stage. They remain there for some time (determined by rate _g~P~_, the inverse of which is the average time spent in the presymptomatic stage). A fraction _f_ of presymptomatic hosts move into the asymptomatic category, and the rest become symptomatic infected hosts. Asymptomatic infected hosts recover after some time (specified by the rate _g~A~_). Similarly, the rate _g~I~_ determines the duration the symptomatic hosts stay in the symptomatic state. For symptomatic hosts, two outcomes are possible. Either recovery or death. The parameter _d_ determines the fraction of hosts that die due to disease. Recovered individuals are initially immune to reinfection. They can lose their immunity at rate _w_ and return to the susceptible compartment. Symptomatic and asymptomatic hosts shed pathogen into the environment at rates p~A~ and p~I~. The pathogen in the environment decays at rate _c_. New susceptible hosts and vectors enter the system (are born) at rates _n~h~_ and _n~v~_. Mortality (death unrelated to disease) for hosts and vectors occurs at rates _m~h~_ and _m~v~_.' 

 #Information for all variables
 var = vector('list',9)
 id = 0
 id = id + 1
 var[[id]]$varname = 'S'
 var[[id]]$vartext = 'Susceptible'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('+nH', '-S*bP*P', '-S*bA*A', '-S*bI*I', '-S*bE*E', '-S*bV*Iv', '+w*R', '-mH*S')
 var[[id]]$flownames = c('Birth of hosts', 'Infection by P', 'Infection by A', 'Infection by I', 'Infection by E', 'Infection by Iv', 'Waning immunity', 'Natural death of P')
 
 id = id + 1
 var[[id]]$varname = 'P'
 var[[id]]$vartext = 'Presymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+S*bP*P', '+S*bA*A', '+S*bI*I', '+S*bE*E', '+S*bV*Iv', '-f*gP*P', '-(1-f)*gP*P', '-mH*P')
 var[[id]]$flownames = c('Infection by P', 'Infection by A', 'Infection by I', 'Infection by E', 'Infection by Iv', 'Presymptomatic moving to asymptomatic', 'Presymptomatic moving to symptomatic', 'Natural death of P')
 
 id = id + 1
 var[[id]]$varname = 'A'
 var[[id]]$vartext = 'Asymptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+f*gP*P', '-gA*A', '-mH*A')
 var[[id]]$flownames = c('Presymptomatic hosts move to asymptomatic', 'Asymptomatic recovery', 'Natural death of A')
 
 id = id + 1
 var[[id]]$varname = 'I'
 var[[id]]$vartext = 'Symptomatic'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+(1-f)*gP*P', '-(1-d)*gI*I', '-d*gI*I', '-mH*I')
 var[[id]]$flownames = c('Presymptomatic moving to symptomatic', 'Symptomatic recovery', 'Symptomatic death', 'Natural death of I')
 
 id = id + 1
 var[[id]]$varname = 'R'
 var[[id]]$vartext = 'Recovered'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+gA*A', '+(1-d)*gI*I', '-w*R', '-mH*R')
 var[[id]]$flownames = c('Asymptomatic recovery', 'Symptomatic recovery', 'waning immunity', 'Natural death of R')
 
 id = id + 1
 var[[id]]$varname = 'D'
 var[[id]]$vartext = 'Dead'
 var[[id]]$varval = 0
 var[[id]]$flows = c('+d*gI*I')
 var[[id]]$flownames = c('Host death due to infection')
 
 id = id + 1
 var[[id]]$varname = 'E'
 var[[id]]$vartext = 'Pathogen in Environment'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+pI*I', '+pA*A', '-c*E')
 var[[id]]$flownames = c('Sheddding by symtpomatic hosts', 'Sheddding by asymtpomatic hosts', 'Pathogen decay')
 
 id = id + 1
 var[[id]]$varname = 'Sv'
 var[[id]]$vartext = 'Susceptible Vector'
 var[[id]]$varval = 1000
 var[[id]]$flows = c('+nV', '-bH*I*Sv', '-mV*Sv')
 var[[id]]$flownames = c('Susceptible vector birth', 'Infection of vectors', 'Susceptible vector natural death')
 
 id = id + 1
 var[[id]]$varname = 'Iv'
 var[[id]]$vartext = 'Infected Vector'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+bH*I*Sv', '-mV*Iv')
 var[[id]]$flownames = c('Infection of vectors', 'Infected vector natural death ')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',19)
 id = 0
 id = id + 1
 par[[id]]$parname = 'nH'
 par[[id]]$partext = 'Birth rate of susceptible hosts'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'mH'
 par[[id]]$partext = 'Death rate of hosts'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'nV'
 par[[id]]$partext = 'Birth rate of susceptible vectors'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'mV'
 par[[id]]$partext = 'Death rate of vectors'
 par[[id]]$parval = 0.001
 
 id = id + 1
 par[[id]]$parname = 'bP'
 par[[id]]$partext = 'rate of transmission from pre-symptomatic hosts'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'bA'
 par[[id]]$partext = 'rate of transmission from asymptomatic hosts'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'bI'
 par[[id]]$partext = 'rate of transmission from symptomatic hosts'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'bE'
 par[[id]]$partext = 'rate of transmission from environment'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'bV'
 par[[id]]$partext = 'rate of transmission from vectors to hosts'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'bH'
 par[[id]]$partext = 'rate of transmission to vectors from hosts'
 par[[id]]$parval = 0.02
 
 id = id + 1
 par[[id]]$parname = 'gP'
 par[[id]]$partext = 'rate of movement out of P compartment'
 par[[id]]$parval = 0.7
 
 id = id + 1
 par[[id]]$parname = 'gA'
 par[[id]]$partext = 'rate of movement out of A compartment'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'gI'
 par[[id]]$partext = 'rate of movement out of I compartment'
 par[[id]]$parval = 0.1
 
 id = id + 1
 par[[id]]$parname = 'pI'
 par[[id]]$partext = 'rate of pathogen shedding into environment by symptomatic hosts'
 par[[id]]$parval = 0.04
 
 id = id + 1
 par[[id]]$parname = 'pA'
 par[[id]]$partext = 'rate of pathogen shedding into environment by asymptomatic hosts'
 par[[id]]$parval = 0.03
 
 id = id + 1
 par[[id]]$parname = 'c'
 par[[id]]$partext = 'rate of pathogen decay in environment'
 par[[id]]$parval = 0.7
 
 id = id + 1
 par[[id]]$parname = 'f'
 par[[id]]$partext = 'fraction of presymptomatic that move to asymptomatic'
 par[[id]]$parval = 0.08
 
 id = id + 1
 par[[id]]$parname = 'd'
 par[[id]]$partext = 'fraction of symptomatic infected hosts that die due to disease'
 par[[id]]$parval = 0.01
 
 id = id + 1
 par[[id]]$parname = 'w'
 par[[id]]$partext = 'rate of immunity waning'
 par[[id]]$parval = 0.003
 
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