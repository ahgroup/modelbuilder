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

strat_model <- generate_stratified_model()
