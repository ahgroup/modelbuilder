## analyze_model.R

analyze_model <- function(wd, modeltype) {
  # Set current working directory
  currentdir <- wd
  rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  load(rdatafile)

  # Print input
  print(modeltype)
  print(wd)
}
