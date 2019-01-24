#' @title A function that takes a modelbuilder model and checks it for errors
#' @description This function takes a modelbuilder model object,
#' and checks that all specifications and constraints for modelbuilder models are met and it is a valid model
#' @param mbmodel A model object or file name and location for the model to be loaded.
#' @return An error message if the model is not properly formulated. If model is ok, it returns NULL.
#' @details This function is a helper function
#' @export

check_model <- function(mbmodel) {

    mberror = NULL

    #needs to have every field to be non-empty, especially model$title
    if (mbmodel$title == "") {mberror = "Please provide a model title"; return(mberror) }
    #check that no non-standard characters are used in title. only letters and numbers and spaces are allowed.
    #pattern =
    if (grepl(pattern,mbmodel$title)) {mberror = "Please only use letters, numbers and spaces in title"; return(mberror) }


    #needs to have a sub-list called var with non-empty fields
    vars = unlist(mbmodel$var)
    #check that all variables have completely filled fields
    if ( sum(vars == "") > 0) {mberror = "Please fill all variable fields"; return(mberror) }


    # Variable names have to start with an upper-case letter and can only contain letters and numbers
    varnames = vars[names(vars) == "varname"]
    #pattern =
    #if (grepl(pattern,mbmodel$title)) {mberror = "Please only use letters, numbers and spaces in title"; return(mberror) }

    #
    #make sure that all flows only consist of specified variables, parameters and math symbols ( +,-,*,^,/,() ).


    pars = mbmodel$par
    #Parameter names have to start with a lower-case letter and can only contain letters and numbers

    #Other math notation such as e.g. sin() or cos() is not yet supported.
    #make sure every parameter listed in the flows is specified as a parameter

    # Function to get the variable prefixes
    # for individual variables, e.g.,
    # "var1", "var2"
    var_prefixes <- sapply(1:values$nvar,
                           function(x) paste0("var", x)) %>%
        unlist(.)

    var_names <- paste0(var_prefixes, "name")
    var_texts <- paste0(var_prefixes, "text")

    # This block of code checks to make sure all the
    # variables that have been initialized are actually
    # filled.
    var_problem <- c(sapply(var_names,
                            function(x) ifelse(input[[x]] == "", 1, 0)),
                     sapply(var_texts,
                            function(x) ifelse(input[[x]] == "", 1, 0))) %>%
        sum(.) %>%
        is_greater_than(0) %>%
        ifelse(., TRUE, FALSE)

    try(if(var_problem == TRUE)
        stop("Variable names or text missing"))

    # Function to get the variable flow prefixes
    # for the individual variable and parameter
    # combinations, e.g., "var1f2" "var2f3"
    varflow_prefixes <- sapply(1:values$nvar,
                               function(x) paste0("var", x, "f",
                                                  1:values$nflow[x])) %>%
        unlist(.)

    varflow_names <- paste0(varflow_prefixes, "name")
    varflow_texts <- paste0(varflow_prefixes, "text")

    # This block of code checks to make sure all the variable
    # flows that have been initialized are actually filled.
    varflow_problem <- c(sapply(varflow_names,
                                function(x) ifelse(input[[x]] == "", 1, 0)),
                         sapply(varflow_texts,
                                function(x) ifelse(input[[x]] == "", 1, 0))) %>%
        sum(.) %>%
        is_greater_than(0) %>%
        ifelse(., TRUE, FALSE)

    # This try() statement checks to see if any variable flow
    # names or texts are missing.
    try(if(varflow_problem == TRUE)
        stop("Variable flow name(s) and / or text(s) missing"))

    # name, text, var
    par_prefixes <- sapply(1:values$npar,
                           function(x) paste0("par", x))
    par_names <- paste0(par_prefixes, "name")
    par_text <- paste0(par_prefixes, "text")
    par_val <- paste0(par_prefixes, "val")

    par_problem <- c(sapply(par_names,
                            function(x) ifelse(input[[x]] == "", 1, 0)),
                     sapply(par_text,
                            function(x) ifelse(input[[x]] == "", 1, 0)),
                     sapply(par_val,
                            function(x) ifelse(input[[x]] == "", 1, 0))) %>%
        sum(.) %>%
        is_greater_than(0) %>%
        ifelse(., TRUE, FALSE)

    # This try() statement checks to see if any parameter names,
    # text, or variables are missing.
    try(if(par_problem == TRUE)
        stop("Parameter values are missing"))

    ## This block of code below checks three things:
    ## 1. All variable names begin with an upper-case letter
    ## 2. All parameter names begin with a lower-case letter
    ## 3. Variable and parameter names contain only letters and numbers

    # Function that uses sapply() to check all characters
    # in a string to make sure the string contains only
    # numbers and letters. Returns a boolean with
    # TRUE if the string contains only numbers and
    # letters, and FALSE if it contains an element
    # that doesn't fall into those two categories.

    # +,-,*,^,/,()
    check_string <- function(string, add_characters = vector()) {
        # All the letters of the alphabet, upper-case and
        # lower-case
        all_letters <- c(letters, toupper(letters), add_characters)
        # Split the string into each atomic part
        elements <- unlist(strsplit(string, split = ""))
        # For each string part, check to see if it can
        # be converted to numeric, or if it is contained
        # in the vector of all upper-case and lower-case
        # letters
        condition <- sapply(elements,
                            function(x) suppressWarnings(!is.na(as.numeric(x))) |
                                x %in% all_letters)
        # is_special_character is a boolean that determines
        # whether there are any special characters in string
        is_special_character <- !(FALSE %in% condition)
        return(is_special_character)
    }

    # This function checks to make sure that the first
    # element of a string is an uppercase letter.
    first_letter_uppercase <- function(x) {
        # All letters of the alphabet, upper case and lower case
        first_element <- unlist(strsplit(x, split = ""))[1]
        condition <- ifelse(first_element %in% all_letters,
                            ifelse(toupper(first_element) == first_element,
                                   TRUE, FALSE), FALSE)
        return(condition)
    }

    # Check to see that variable names meet proper criteria, namely:
    # 1. Starts with an upper-case letter
    # 2. Contains only letters and numbers

    okay_var_names <- sapply(var_names,
                             function(x) (first_letter_uppercase(input[[x]]) &
                                              check_string(input[[x]])))

    try(if(FALSE %in% okay_var_names)
        stop("Make sure variable name starts with upper case letter and contains only letters and numbers"))

    # Check to see that parameter names meet proper criteria, namely:
    # 1. Starts with a lower-case letter
    # 2. Contains only letters and numbers

    okay_par_names <- sapply(par_names,
                             function(x) (!first_letter_uppercase(input[[x]]) &
                                              check_string(input[[x]])))

    try(if(FALSE %in% okay_par_names)
        stop("Make sure parameter name starts with lower case letter and contains only letters and numbers"))

    # Check to see that the parameter flows meet proper criteria, namely:
    # 1. They contain only numbers, letters, and mathematical symbols
    #    (+,-,*,^,/,()).
    # 2. They begin with a "+" or "-".
    # 3. They only contain parameters that have been defined.

    # Condition 1
    math_symbols <- c("+", "-", "*", "^", "/", "(", ")", " ")
    okay_varflow_names <- sapply(varflow_names,
                                 function(x) check_string(input[[x]],
                                                          math_symbols))
    try(if(FALSE %in% okay_varflow_names)
        stop("Make sure flows contain only letters, numbers, and mathematical symbols"))

    # Condition 2 - confused about what needs to be done here

    # Function to make sure flow begins with a "+" or "-"
    check_flow <- function(x) {
        first_element <- unlist(strsplit(input[[x]], split = ""))[1]
        input[[x]] <- ifelse((first_element == "+" | first_element == "-"),
                             input[[x]], paste0("+", input[[x]]))
        return(input[[x]])
    }

    # Condition 3
    # To check to make sure that only parameters already defined
    # are found in the flow, we first extract the letters, which
    # represent the parameters. Then we see if those letters
    # are found in the defined parameter names.

    check_params <- function(x) {
        # x is a variable flow equation
        # All the letters of the alphabet, upper-case and
        # lower-case
        all_letters <- c(letters, toupper(letters))
        # First we get the all of the letter elements
        # in x, which correspond to parameters.
        split_x <- strsplit(x, split = "") %>%
            unlist(.)
        which_letters <- which(split_x %in% all_letters)
        params_in_flow <- split_x[which_letters]

        # Now check each parameter in the flow
        # to see if it's one of the defined
        # parameters.
        defined_parameters <- sapply(par_names,
                                     function(x) input[[x]])
        sapply(params_in_flow,
               function(x) x %in% defined_parameters) %>%
            return(.)
    }



}
