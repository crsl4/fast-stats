library(shiny)

## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        fileInput("file1", "Choose CSV File",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
        ),
        tags$hr(),
        checkboxInput("header", "Header", TRUE)
      ),
      # Main panel for displaying outputs ----
      mainPanel(
        
        # Output: Verbatim text for data summary ----
        verbatimTextOutput("summary"),
        
        # Output: HTML table with requested number of observations ----
        tableOutput("view")
        
      )
    )
  )
  
  server <- function(input, output) {
    output$summary <- renderPrint({
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, it will be a data frame with 'name',
      # 'size', 'type', and 'datapath' columns. The 'datapath'
      # column will contain the local filenames where the data can
      # be found.
      inFile <- input$file1
      
      if (is.null(inFile))
        return("No file found")
      
      dataset <- read.csv(inFile$datapath, header = input$header)
      summary(dataset)
    })
    
    # Show the first "n" observations ----
    output$view <- renderTable({
      inFile <- input$file1
      
      if (is.null(inFile))
        return(NULL)
      
      dataset <- read.csv(inFile$datapath, header = input$header)
      head(dataset, n = 10)
    })
  }
  
  shinyApp(ui, server)
}

