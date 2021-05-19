library(modelbuilder)
library(here)

# load the base model
model_name <- "Coronavirus_vaccine_model_v2.Rds"
# model_name <- "SIRSd2.Rds"
mbmodel <- readRDS(here("auxiliary",
                        "vaccine_model_testing",
                        "base_models",
                        model_name))


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

generate_ode(risk_model)


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

generate_tables(strat_model)

mbmodel$var[[1]]$flows  # S
risk_model$var[[1]]$flows  # Sh
strat_model$var[[1]]$flows  # Shc

mbmodel$var[[2]]$flows  # P
risk_model$var[[3]]$flows  # Ph
strat_model$var[[7]]$flows  # Phc

