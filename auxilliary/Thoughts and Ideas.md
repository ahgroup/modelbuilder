#modelbuilder package information




## general thoughts and ideas
* present at UGA teaching conference: https://coe.uga.edu/events/2018/10/innovation-in-teaching-conference-20181019
* Integrate with Systems Biology Markup Language (SBML)
* Use DiagrammeR package for graph creation?
* Do (and write/publish?) a review of software out there that does what we want to do?
* Go through medley18pcb
* A series of reviews of GUI's for R data analyis: http://r4stats.com/articles/software-reviews/  Might give us some pointers as to ways of doing GUI things for our purpose

## Maybe Comparable/competing software
* Berkley Madonna
* Numerus: https://www.numerusinc.com/

## Package functionality requirements
* Users need to be able to build and analyze compartmental models without coding
* The building and analysis/testing need to happen at the same time so users can test their model behavior as they build it to see if it works
* Things need to be reversible, i.e. for each compartment/variable and each inflow/outflow term, users need to be able to add/remove/edit
* As model is being built, it should interactively show diagram and differential equations, as well as inputs for initial conditions and parameters so a user can run it.
* We could have 2 tabs, a model 'building' that allows building and shows diagram and equations, and a 'testing' that shows inputs and outputs (that one similar to UI of DSAIDE/DSAIRM shiny apps)
* I (Andreas) currently favor trying to do it with/through shiny and coding everything in R as much as possible.
* Add unit tests to package (using testthat)


## Structure/Concept Ideas
* 2 tabs, a 'build' tab and a 'test/analyze' tab
* In build tab, user builds model. 
    * As model is built, a diagram is drawn (maybe using DiagrammeR pacakge)
    * As model is built, conde is written as some internal model object
    * Internal model object can be exported/saved as different formats: ODE, stochastic, discrete time, SMBL, RxODE, others?
* User needs to choose one of ODE/stochastic/discrete time to switch to test/analyze tab
* In test/analyze tab, user can graphically interact with model (e.g. like DSAIDE/DSAIRM)

## Functions needed
* A shiny app for GUI part. Shiny app needs to include interactive model building capability.
* A function that builds and shows a diagram as model is built
* A function that takes the shiny input for the model and turns it into an internal model object.
* Functions that take the internal model object and turn it into code/functions to be run using deSolve, adaptivetau,...
* A function that takes a generated deSolve/adaptivetau,... object and wraps a shiny interface around it (for the 'analyze' tab)

## Model structure
We'll store a model as a list, and save it as Rdata file. The model list will have the following components:

model$title - model title
model$description - a short model description
model$author - name of author
model$date - date of creation or last change
model$var$names - vector of characters containing variable names
model$var$text- vector of characters describing each variable 
model$par$names - vector of characters containing parameter names
model$par$text- vector of characters describing each parameter 
model$flow$VAR$names - a vector of characters for each variable naming all flows for that variable. replicated for all vars.
model$flow$VAR$text - a vector of characters for each variable explaining all flows for that variable. replicated for all vars.


Optional:
model$par$lb - lower bound for a given parameter, vector of numeric values, needs to be in same order as model$par$names
model$par$ub - upper bound for a given parameter, vector of numeric values, needs to be in same order as model$par$names

********
Example for a simple SIR model:
********

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


#next steps

* write a function that takes a model list like the one above and turns it into an ODE function/file like simulate_SIR.R
* write a function that reads the ODE function/file and automatically builds a shiny app/wrapper for it




## Resources
A good source of shiny examples and tips and tricks that might be helpful:
https://deanattali.com/blog/advanced-shiny-tips/
