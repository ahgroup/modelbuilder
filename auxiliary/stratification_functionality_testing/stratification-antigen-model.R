library(modelbuilder)
library(here)

# load the base model
model_name <- "Basic_Inoculum_model.Rds"
mbmodel <- readRDS(here("auxiliary",
                        "stratification_functionality_testing",
                        "base_models",
                        model_name))


# create list mapping parameter stratifications to state variable
par_stratify_list <- generate_stratifier_list(mbmodel)

# loop through elements and constrain stratify_by to one variable
for(i in 1:length(par_stratify_list)) {
  par_stratify_list[[i]]$stratify_by <- ""
}


# make stratification by antigen
stratum_list <- list(
  stratumname = "antigen",
  names = 1:14,
  labels = 1:14,
  comment = "This stratifies by antigen."
)

strat_model <- generate_stratified_model(mbmodel = mbmodel,
                                        stratum_list = stratum_list,
                                        par_stratify_list = par_stratify_list)

generate_ode(strat_model)


