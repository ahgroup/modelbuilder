library(modelbuilder)
library(here)

# load the base model
model_name <- "Coronavirus_vaccine_model_v2.Rds"
# model_name <- "SEIRSd_model.Rds"
mbmodel <- readRDS(here("auxiliary", "modelfiles", model_name))


# create list mapping parameter stratifications to state variable
par_stratify_list <- generate_stratifier_list(mbmodel)

# make first stratification by risk profile
stratum_list <- list(
  stratumname = "risk",
  names = c("high risk", "low risk"),
  labels = c("h", "l"),
  comment = "This defines the risk structure."
)

risk_model <- generate_stratified_model(mbmodel = mbmodel,
                                        stratum_list = stratum_list,
                                        par_stratify_list = par_stratify_list)

mbmodel$var[[1]]$flows
risk_model$var[[1]]$flows


# now stratify again by age
stratum_list <- list(
    stratumname = "age",
    names = c("children", "adults", "elderly"),
    labels = c("c", "a", "e"),
    comment = "This defines the age structure."
)
par_stratify_list <- generate_stratifier_list(risk_model)

strat_model <- generate_stratified_model(mbmodel = risk_model,
                                         stratum_list = stratum_list,
                                         par_stratify_list = par_stratify_list)

mbmodel$var[[1]]$flows  # S
risk_model$var[[1]]$flows  # S_h
strat_model$var[[1]]$flows  # S_h_c

mbmodel$var[[2]]$flows  # P
risk_model$var[[3]]$flows  # P_h
strat_model$var[[7]]$flows  # P_h_c

