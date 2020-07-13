library(shiny)
# to do:
# - read the df just once, not in every render function
# - robust to column names
# - different tabs? many more options for the user

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  #titlePanel("FastStats"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      img(src = "logo.png", height = 75, width = 230),
      
      h3("Data Upload:"),
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Horizontal line ----
      tags$hr(),
      
      h3("Data Summary:"),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
      
      actionButton("goSummary", "Summary"),
      
      # Horizontal line ----
      tags$hr(),
      
      h3("Data Visualization:"),
      
      actionButton("goHist", "Histogram"),
      
      actionButton("goViolin", "Violin Plot"),
 
      # Horizontal line ----
      tags$hr(),
      
      h3("Data Analysis:"),
      
      actionButton("goT", "t test"),     
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      
      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),
      
      # Output: Data file ----
      tableOutput("contents"),
      
      # Output: t test ----
      verbatimTextOutput("ttest"),
      
      # Output: plot
      plotOutput("histogram"),
      
      # Output: plot
      plotOutput("violinPlot"),
      
      
      
      
    )
    
  )
)

library(ggplot2)
# Define server logic to read selected file ----
server <- function(input, output) {
  v <- reactiveValues(doViolinPlot = FALSE)
  
  observeEvent(input$goViolin, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doViolinPlot <- input$goViolin
  })
  
  v2 <- reactiveValues(doHist = FALSE)
  
  observeEvent(input$goHist, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v2$doHist <- input$goHist
  })
  
  v3 <- reactiveValues(doSummary = FALSE)
  
  observeEvent(input$goSummary, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v3$doSummary <- input$goSummary
  })
  
  v4 <- reactiveValues(doT = FALSE)
  
  observeEvent(input$goT, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v4$doT <- input$goT
  })
  
  output$summary <- renderPrint({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if (v3$doSummary == FALSE) return()
    
    summary(df)
    
  })
  
  output$ttest <- renderPrint({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    dat2 = within(df, group <- "(2+)x(2+)")
    dat2$group[dat2$parents == ""] = "parent"
    dat2$group[dat2$parents == "2x2"] = "2x2"
    dat2$group[dat2$parents == "2x3"] = "2x(2+)"
    dat2$group[dat2$parents == "2x4"] = "2x(2+)"
    dat2$group = factor(dat2$group,levels=c("parent", "2x2", "2x(2+)", "(2+)x(2+)"))
    dat3 = subset(dat2,group %in% c("2x2","(2+)x(2+)"))
    dat3$group = factor(dat3$group)
    
    x = dat2$cotyledons[dat2$group == "2x2"]
    y = dat2$cotyledons[dat2$group == "(2+)x(2+)"]
    
    if (v4$doT == FALSE) return()
    
    t.test(x,y)
    
  })
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  output$violinPlot <- renderPlot({
    
    # there must be a way not to repeat the same lines to get df
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )

    if (v$doViolinPlot == FALSE) return()
    
    ggplot(df, aes(x=parents, y=cotyledons, fill=parents))+geom_violin(alpha=0.5)+
      geom_point(pch = 21, alpha=0.3, position = position_jitterdodge(jitter.height=0.05, jitter.width=2.5))+
      ylim(c(1,6))+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
      )    
  }
  )
  
  output$histogram <- renderPlot({
    
    # there must be a way not to repeat the same lines to get df
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if (v2$doHist == FALSE) return()
    
    ggplot(df, aes(parents, fill=parents))+geom_bar(alpha=0.5)+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
      )    
  }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)

