#modelbuilder package information


## general thoughts and ideas

* Integrate with Systems Biology Markup Language (SBML)
* Use DiagrammeR package for graph creation?
* Do (and write/publish?) a review of software out there that does what we want to do?
* Go through medley18pcb
* Discuss Melissa’s RxODE package
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