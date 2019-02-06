library(shiny)
source("write_script.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         actionButton("add", "Add new equation?"),
         actionButton("write", "Write equations to file")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h4("Placeholder Main Panel")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  observeEvent(input$add, {
    insertUI(
      selector = "#add",
      where = "beforeBegin",
      ui = textInput(paste0("equation", input$add),
                     "Equation")
    )
  })
  
  observeEvent(input$write, {
    eq_list <- list(input[[paste0("equation", 1)]],
                    input[[paste0("equation", 2)]])
    print(eq_list)
    
    write_script(eq_list = eq_list)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

