## analyze_model.R

analyze_model <- function(wd, input) {
  # Set current working directory
  currentdir <- wd
  rdatafile = list.files(path = currentdir, pattern = "\\.Rdata$")
  load(rdatafile)
  
  # Print input
  print(input)
}