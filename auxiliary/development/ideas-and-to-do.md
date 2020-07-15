# To-do and ideas for modelbuilder package

# Feedback to look into

Because the program requires all of the boxes to be filled working it is not possible to save in the middle of your work. If I needed to step away from the computer while in the middle of implementing them R would stop running when my computer went to sleep and I would have to start over. I could copy and paste from the page that I had started into the newly launched page but that was very time consuming and frustrating. This happened at least twice. Perhaps the program allows you to save with a warning that errors have been found but still allows you to keep your progress. 

I also received this error a couple of times when I was going to "Make the model". This means I had to close and reopen R. This might be a problem on my end with R though. 
Listening on http://127.0.0.1:7169
Warning: Error in if: missing value where TRUE/FALSE needed
 74: check_model
 73: observeEventHandler [/Library/Frameworks/R.framework/Versions/3.6/Resources/library/modelbuilder/modelbuilder/app.R#127]
  2: shiny::runApp
  1: modelbuilder




## Code Improvements
* Continue implementing unit tests using the testthat package

## Content Improvement
* Integrate with Systems Biology Markup Language (SBML), do import/export to SBML 
* update model check/parse function to allow more flexible models (e.g. sin/cos/etc.)
* Add model checks to make sure user doesn't do something detrimental
* fix/finish function that creates diagrams
* Add a repository for user contributed models to package/github site. Should allow easy upload of a model (rds) file, then automated checking of model and if model is ok, automatic addition to 'database' of models. might want to do that through a shiny app? 
* Test everything, fix bugs
* Work on figure generating code

## Build features to implement
* Allowing for starting values that depend on model parameters is a feature that still needs to be implemented.
* Allowing for time-dependent parameters.
* Allowing for parameters that change on/off at discrete times.

## Advertisement
* Add a repository for user contributed models to package/github site
* Write paper to introduce package
* Find all UGA classes/instructors who could use package.
* Make instructional videos for package
* Send annoucements at suitable times
* Create more docs (tutorials/vignettes)

## General thoughts and comments
* Look into EpiModel::comp_plot() for making flow diagrams 
* look into R consortium package certification
* Get best practices badge: https://bestpractices.coreinfrastructure.org/en
* Maybe submit for Ropensci review: https://github.com/ropensci/onboarding
* Hashtags on twitter when promoting app: #rstats, #dynamicalsystems * Contribute code to Epirecipes? http://epirecip.es/
* develop a 'modelverse' set of packages that allow development/analysis and fitting of compartmental models without coding
* Create a website/repository of modelbuilder models that others can contribute to and download from (Like NetLogo models)

## Similar packages
* ModelMaker – not been updated since 2000
* SAAM II
* STELLA: https://www.iseesystems.com/store/products/ - around $2,000
* PowerSim
* Berkeley Madonna
* Numerus: https://www.numerusinc.com/
* See here: https://en.wikipedia.org/wiki/Comparison_of_system_dynamics_software
* Scilab http://scilab.io/
* SloppyCell
* Simmune
* NetLogo
* NovaModeller

## Good Resources for Shiny coding
* https://mastering-shiny.org/
* https://engineering-shiny.org/
* https://divadnojnarg.github.io/outstanding-shiny-ui/


## Related packages
* POMP
* RxODE, nlmixr
* deSolve

## Maybe relevant organizations/groups
* https://www.systemdynamics.org
* http://go-isop.org/
* https://news.uga.edu/uga-launches-project-to-transform-stem-education/

## Potential funding for further development
* https://www.r-consortium.org/announcement/2018/09/25/fall-2018-isc-call-for-proposals
* https://www.nsf.gov/awardsearch/simpleSearchResult?queryText=Uri+Wilensky&ActiveAwards=true