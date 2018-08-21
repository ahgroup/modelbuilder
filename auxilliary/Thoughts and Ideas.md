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
We'll store a model as a list, and save it as Rdata file. 
The model list will have the following components:

### Meta-Information
model$title - model title
model$description - a short model description
model$author - name of author
model$date - date of creation or last change


### Variable information
model$var[[i]]$varname - characters containing variable name, string
model$var[[i]]$vartext - description of variable, string
model$var[[i]]$varval - starting value, numeric
model$var[[i]]$flows - all flow terms, as vector of strings
model$var[[i]]$flownames - description of each flow, vector of strings
i = 1..number of variables

### Parameter information
model$par[[i]]$parname - parameter name
model$par[[i]]$partext - description of parameter 
model$par[[i]]$parval - default value 
i = 1..number of parameters

### Time information
model$time$t0 - starting time, numeric
model$time$tf - final time, numeric
model$time$dt - time step, numeric


Optional/for later:
model$par[[i]]$lb - lower bound for parameter 
model$par[[i]]$ub - upper bound for parameter 


********
Example for a simple SIR model - see make_SIR_model.R
********


#next steps

* write a function that takes a model list like the one above and turns it into an adaptivetau/discrete time/RxODE function
* write a shiny app that allows user to graphically build the above model structure and save as file
* write a function that reads the function/file and automatically builds a shiny app/wrapper for it



## Resources
A good source of shiny examples and tips and tricks that might be helpful:
https://deanattali.com/blog/advanced-shiny-tips/
