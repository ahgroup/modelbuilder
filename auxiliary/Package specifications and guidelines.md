#modelbuilder package information


## Model structure information
To allow conversion into different functions (and back conversions), the model structure needs to contain specific fields and follow specific rules, as follows


### Meta-Information
model$title - model title (string)
model$description - a short model description (string)
model$author - name of author (string)
model$date - date of creation or last change (string or date)


### Variable information
model$var[[i]]$varname - characters containing variable name. Needs to start with uppercase, can only contain letters and numbers
model$var[[i]]$vartext - description of variable, string
model$var[[i]]$varval - starting value, numeric
model$var[[i]]$flows - all flow terms, as vector of strings. No empty spaces within a flow term are allowed (e.g. S*I instead of S * I). Needs to start with either a + or - sign.
model$var[[i]]$flownames - description of each flow, vector of strings

i = 1..number of variables

### Parameter information
model$par[[i]]$parname - parameter name. string, needs to start with a lowercase letter, can only contain letters and numbers and be a max of 20 characters long.
model$par[[i]]$partext - description of parameter= (string)  
model$par[[i]]$parval - default value (numeric) 

i = 1..number of parameters

### Time information
model$time$t0 - starting time, numeric
model$time$tf - final time, numeric
model$time$dt - time step, numeric

Every entry above is required.



###For possible future extension
model$par[[i]]$lb - lower bound for parameter 
model$par[[i]]$ub - upper bound for parameter 



## Model code information
Code/functions generated from models need to contain certain meta-information to allow back-conversion.

* Every function that is generated needs to list model variables and parameters and their names in the documentation section
* Every function in their definition needs the vector entries vars/pars/time. In this code line, spaces need to be between each = sign.
* desolve functions need to have StartODES/EndODES blocks and above each equation the variable and flow names, separated by : (including white spaces)

