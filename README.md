[![Travis-CI build Status](https://travis-ci.org/ahgroup/modelbuilder.svg?branch=master)](https://travis-ci.org/ahgroup/modelbuilder)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/ahgroup/modelbuilder?branch=master&svg=true)](https://ci.appveyor.com/project/ahgroup/modelbuilder)
[![Coverage status](https://codecov.io/gh/ahgroup/modelbuilder/branch/master/graph/badge.svg)](https://codecov.io/github/ahgroup/modelbuilder?branch=master)


# modelbuilder
A software package for graphical building and analysis of compartmental simulation models


## Description
This R package provides functionality that lets the user build and analyze compartmental simulation models, implemented as ordinary differential equations, stochastic equivalents, or discrete time models.   
All model building and analysis can be done without writing code. The user can export code for one of the model implementations for further customization.


## Installation
I assume you have `R` installed. I also highly recommend `RStudio`, though it's not required.

1. NOT YET ON CRAN: Install the CRAN release in the usual way with `install.packages('DSAIDE')`.
2. The latest development version (potentially buggy) can be installed from github, using the devtools package. If you don't have it, install the devtools package. The following commands will get you up and running:

```r
install.packages('devtools')
devtools::install_github('ahgroup/modelbuilder')
```
## Basic Use
After install (which you need to do only once), load the package by runing `library('modelbuilder')`. You should receive a short greeting. Now you can open the main menu by running `modelbuilder()`. From the main menu, you can load a model, export code for a model, build a new or modify an existing model, and analyze model dynamics ofr a loaded model.

See the "Get Started" section on the [Github Pages Site](https://ahgroup.github.io/modelbuilder/) for a basic and currently sparse introduction.


## Note
AS OF RIGHT NOW, THE PACKAGE HAS BASIC FUNCTIONALITY, BUT HAS NOT BEEN PROPERLY TESTED AND DEBUGGED YET!
This is a very early version of the package, only some features are already implemented.


## Contributing to the package
The package is on GitHub and you can use the usual GitHub process to contribute updated, bug fixes, etc. If you don't know how to do that or don't have the time, you can also file an issue on GitHub and let me know what should be changed. 

The package is built in a way that makes it (hopefully) easy for others to contribute simulation models for others to use. A formal structure for model sharing is forthcoming.

## Contributors
This R package is developed and maintained by [Andreas Handel](http://handelgroup.uga.edu/). The following individuals have made contributions to this package: Spencer Hall, Ishaan Dave.

