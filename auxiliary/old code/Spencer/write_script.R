pre_eq_vec <- c("bacteriaode <- function(t, y, parms)", 
                "{",
                "with(",
                "as.list(c(y, parms)),",
                "{\n")
pre_eq <- paste(pre_eq_vec, collapse = "\n")

post_eq_vec <- c("\n}", ")", "}")
post_eq <- paste(post_eq_vec, collapse = "\n")

eq_list <- list("dB = b*I", "dR = S*I")

write_script <- function(eq_list) {
  equations <- paste(unlist(eq_list), collapse = "\n")
  full_equation <- c(pre_eq, equations, post_eq)
  cat(full_equation, file = "output_script.R")
}

write_script(eq_list)












                
                
                
                