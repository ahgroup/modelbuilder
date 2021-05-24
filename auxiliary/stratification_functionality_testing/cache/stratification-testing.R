library(modelbuilder)
library(here)

# load the base model
model_name <- "Coronavirus_vaccine_model_v2.Rds"
mbmodel <- readRDS(here("auxiliary", "modelfiles", model_name))



# create list mapping parameter stratifications to state variable
par_stratify_list <- list(
  list(
    "parname" = "nu",
    "stratify_by" = c("S")
  ),
  list(
    "parname" = "bP",
    "stratify_by" = c("S", "P")
  ),
  list(
    "parname" = "bA",
    "stratify_by" = c("S", "A")
  ),
  list(
    "parname" = "bI",
    "stratify_by" = c("S", "I")
  ),
  list(
    "parname" = "sigma",
    "stratify_by" = "P"
  ),
  list(
    "parname" = "gammaA",
    "stratify_by" = "A"
  ),
  list(
    "parname" = "gammaI",
    "stratify_by" = "I"
  ),
  list(
    "parname" = "gammaH",
    "stratify_by" = "H"
  ),
  list(
    "parname" = "phi",
    "stratify_by" = "I"
  ),
  list(
    "parname" = "rho",
    "stratify_by" = "H"
  )
)

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
risk_model$mbmodel$var[[1]]$flows


# now stratify again by age
stratum_list <- list(
    stratumname = "age",
    names = c("children", "adults", "elderly"),
    labels = c("c", "a", "e"),
    comment = "This defines the age structure."
)

strat_model <- generate_stratified_model(mbmodel = risk_model$mbmodel,
                                         stratum_list = stratum_list,
                                         par_stratify_list = risk_model$par_stratify_list)

mbmodel$var[[1]]$flows  # S
risk_model$mbmodel$var[[1]]$flows  # S_h
strat_model$mbmodel$var[[1]]$flows  # S_h_c

mbmodel$var[[2]]$flows  # P
risk_model$mbmodel$var[[3]]$flows  # P_h
strat_model$mbmodel$var[[7]]$flows  # P_h_c

