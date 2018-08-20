#this is a proposed list structure for models
#a simple SIR model is implemented
#this structure should be read by a function and turned into desolve code



model = list()
model$title = "SIR model"
model$description = "A basic SIR model with 3 compartments and infection and recovery processes"
model$author = "Andreas Handel"
model$date = Sys.Date()
model$var$names = c("S","I","R")
model$var$text = c("Susceptible","Infected","Recovered")
model$par$names = c('b','g')
model$par$text = c('rate of infection','rate of recovery')
model$flow$S$names = c('-b*S*I')
model$flow$S$text = c('infection of susceptibles')
model$flow$I$names = c('b*S*I','-g*I')
model$flow$I$text = c('infection of susceptibles','recovery of infected')
model$flow$R$names = c('g*I')
model$flow$R$text = c('recovery of infected')


save(model,file = 'SIRmodel.Rdata')
