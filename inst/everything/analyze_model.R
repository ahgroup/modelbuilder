# analyze_model.R

analyze_model <- function(wd, input) {
  # Load model
  currentdir <- wd
  rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  load(rdatafile)
  
  # Printing input
  print(input)
}