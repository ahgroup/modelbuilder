##############################
#R script to generate a modelbuilder model object with code.
#This file was generated on 2021-05-20 07:36:56
##############################

 mbmodel = list() #create empty list

 #Model meta-information
 mbmodel$title = 'Stratified Inoculum Model'
 mbmodel$description = ''
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = ''

 #Information for all variables
 var = vector('list',14+14+1+14)
 id = 0

 for (n in 1:14)
 {
         id = id + 1
         var[[id]]$varname = paste0('H',n)
         var[[id]]$vartext = 'antigen'
         var[[id]]$varval = 100
         var[[id]]$flows = c(paste0('+k',n,'*A',n,'*H',n), paste0('-c',n,'*H',n))
         var[[id]]$flownames = c('removal', 'decay')
}

 id = id + 1
 var[[id]]$varname = 'F'
 var[[id]]$vartext = 'innate response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+p', '-m*F', '+q*fmax*H1/(H1+n)', '-q*F*H1/(H1+n)')
 var[[id]]$flownames = c('growth', 'decay', 'max growth', 'decay from max')

 for (n in 1:14)
 {
         id = id + 1
 var[[id]]$varname = paste0('B',n)
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = paste0('+g',n,'*B',n,'*H',n,'*F/(s',n,'+H',n,'*F)')
 var[[id]]$flownames = c('induction')
 }

 for (n in 1:14)
 {
         id = id + 1
 var[[id]]$varname = paste0('A',n)
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c(paste0('-k',n,'*A',n,'*H',n), paste0('+r',n,'*B',n), paste0('-d',n,'*A',n) )
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 }

 mbmodel$var = var

 #Information for all parameters
 par = vector('list',6*14+5)
 id = 0
 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('k',n)
 par[[id]]$partext = paste0('killing rate ', n)
 par[[id]]$parval = 1e-4
        }

 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('c',n)
 par[[id]]$partext = paste0('antigen decay ', n)
 par[[id]]$parval = 2
 }

 id = id + 1
 par[[id]]$parname = 'p'
 par[[id]]$partext = 'innate growth'
 par[[id]]$parval = 4

 id = id + 1
 par[[id]]$parname = 'm'
 par[[id]]$partext = 'innate decay'
 par[[id]]$parval = 4

 id = id + 1
 par[[id]]$parname = 'q'
 par[[id]]$partext = 'innate induction'
 par[[id]]$parval = 3

 id = id + 1
 par[[id]]$parname = 'fmax'
 par[[id]]$partext = 'innate saturation'
 par[[id]]$parval = 1e5

 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'antigen halfpoint'
 par[[id]]$parval = 100

 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('g',n)
 par[[id]]$partext = paste0('B cell growth ', n)
 par[[id]]$parval = 0.5
 }

 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('s',n)
 par[[id]]$partext = paste('b cell halfpoint',n)
 par[[id]]$parval = 10
 }

 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('r',n)
 par[[id]]$partext = paste('antibody production',n)
 par[[id]]$parval = 100
 }

 for (n in 1:14)
 {
         id = id + 1
 par[[id]]$parname = paste0('d',n)
 par[[id]]$partext = paste('antibody decay',n)
 par[[id]]$parval = 10
 }

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
 time[[id]]$timeval = 20

 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1

 mbmodel$time = time
