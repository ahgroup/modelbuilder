#' @name remove_model_variableModal
#' @title produces remove variable confirmation modal
#' @description This modal asks users for confirmation that a given variable should be removed.
#' @param varName Character value of the name of the variable in question.
#' @author Joe Zientek - WEST, Inc
#' @export
#' 

remove_model_variableModal <- function(varName){
  modalDialog(
    
    # add formatting to center align text in the modal
    tags$head(tags$style(HTML(".confirmationText {
                                  text-align: center;
                                }
                                "))),
    
    # Display text that asks user to confirm the removal of a specific variable
    div(tags$b(paste0("Are you sure you want to remove ", varName, "?")), class = "confirmationText"),
    
    h1(),
    
    
    # put 'Yes' and 'Cancel' buttons in fluidRow so they can be centered in the modal
    fluidRow(
      
      column(6, align="center", offset = 3, 
             actionButton("remove_model_variableConfirm", "Yes", 
                          style = "color: #fff; background-color: #d42300"), 
             actionButton("remove_model_variableCancel", "Cancel", 
                          style = "color: #fff; background-color: #a9a9a9")
      )# end column
      
    ), # end fluidRow
    
    # Don't include a footer, because the dismiss / cancel button is included in the fluidRow above.
    # You are unable to add styling to a modalButton, so we created our own.
    footer = NULL,
    
    # Allow users to click outside of modal to close the modal
    easyClose = TRUE
    
  )# end modalDialog
}# end remove_model_variableModal
