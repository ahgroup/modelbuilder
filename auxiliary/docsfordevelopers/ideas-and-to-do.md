# To-do/Ideas/Notes Resources for modelbuilder package


## Feedback to look into and address

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
* Simplify and modularize code further if possible
* Turn on flow diagram once the flowdiagramr package is on CRAN

## Content Improvement

### High priority

* Allow saving of unfinished model to come back later. To do so, add a new list entry to mbmodel called "checked". If user saves model during building, have that set as false. Only once user finalizes model is it checked. Unchecked models can not be exported to code or analyzed.

### Medium priority

* Implement a generate_rxode() function which produces code that uses the RxOde package.
  - Should first look into RxOde to decide if worth doing.
  - RxOde might run faster than deSolve
  - RxOde might have dependencies that are not ideal.

* Implement a generate_pomp() function which produces code that uses the pomp package.
  - Initially, only the simulation component of pomp would be used, no fitting
  - Eventually loading data and fitting in a graphical manner is the goal. Likely as a separate package.


* Further update model check/parse function to allow more flexible models (e.g. sin/cos/etc.)

* Allowing for parameters that change on/off at discrete times.

* Allowing for initial conditions or parameter values that are not numeric but instead depend on other quantities. E.g. instead of requiring b1 = 0.1 and b2 = 0.05, allow b1 = 2 * b2. Similarly, allow an initial condition to be S = f * 1000. 
  - Would require all values to be stored as character/string, then checked for consistency (i.e. for b1 = 2 * b2, this is only ok if b2 is defined as numeric).
  - This could or could not be hard, unclear. Also not sure how that could be handled if user interacts with a model through the UI.


### Low priority
* Integrate with Systems Biology Markup Language (SBML), do import/export to SBML. 
* Add further model checks to make sure user doesn't do something wrong.


* Add a repository for user contributed models to package/github site. Should allow easy upload of a model (Rds) file, then automated checking of model and if model is ok, automatic addition to 'database' of models. might want to do that through a shiny app? See e.g. the NetLogo website for a conceptual example: https://ccl.northwestern.edu/netlogo/models/community/





## Documentation / Advertisement
* Create more docs (tutorials/vignettes)
* Write paper to introduce package
* Find all UGA classes/instructors who could use package.
* Make instructional videos for package
* Send annoucements at suitable times


## General thoughts and comments

* Look into EpiModel::comp_plot() for making flow diagrams 
* look into R consortium package certification
* Get best practices badge: https://bestpractices.coreinfrastructure.org/en
* Maybe submit for Ropensci review: https://github.com/ropensci/onboarding
* Hashtags on twitter when promoting app: #rstats, #dynamicalsystems * Contribute code to Epirecipes? http://epirecip.es/
* develop a 'modelverse' set of packages that allow development/analysis and fitting of compartmental models without coding



### Similar packages
* ModelMaker not been updated since 2000
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

### Good Resources for Shiny coding
* https://mastering-shiny.org/
* https://engineering-shiny.org/
* https://divadnojnarg.github.io/outstanding-shiny-ui/


### Related packages
* POMP
* RxODE, nlmixr
* deSolve

### Maybe relevant organizations/groups
* https://www.systemdynamics.org
* http://go-isop.org/
* https://news.uga.edu/uga-launches-project-to-transform-stem-education/

### Potential funding for further development
* https://www.r-consortium.org/announcement/2018/09/25/fall-2018-isc-call-for-proposals
* https://www.nsf.gov/awardsearch/simpleSearchResult?queryText=Uri+Wilensky&ActiveAwards=true
