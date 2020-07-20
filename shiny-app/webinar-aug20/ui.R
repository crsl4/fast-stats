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
      fileInput("file1", "Choose CSV File or Drag the file here",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      tags$p("Click the checkbox if file has a header:"),
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Choose the separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      # seems like selected is okay
      
      
      # Horizontal line ----
      tags$hr(),
      
      h3("Data Summary:"),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Data Customization",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
      # FIXME: users click on the checkbox and the app changes immediately, needs to let it change after click the summary button; can be solved it by isolated()
      actionButton("goSummary", "Summary"),
      
      # Horizontal line ----
      tags$hr(),
      
      h3("Plot Option:"),
      
      checkboxInput("addPoints", "Add data points", T),
      
      checkboxInput("adjustSize", "Adjust plot size", F),
      
      conditionalPanel(
        # only show this panel when user wanna adjust plot size; this panel uses JS, don't need to have a quotation mark over true
        condition="input.adjustSize==true",
        numericInput("widthVal","Plot Width:",550),
        numericInput("heightVal","Plot Height:",400)
        # I've tested the result and seems that (550,400) is a great parameter for this, if val gets too large, plot simply go out of border in the mainpanel
        # numericInput is the specific input branket for integer inputs; don't use textinput in this case, cos id$val will be characters instead of string
      ),
      # options func may solve this 
      
      tags$hr(),
      
      h3("Data Visualization:"),
      
      fluidRow(
        column(6,radioButtons("xaxisGrp","Grouping Variables:", c("1"="1","2"="2"))),
        column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
      ),
      
      actionButton("goHist", "Histogram"),
      
      actionButton("goViolin", "Violin Plot"),
      
      actionButton("goScatter", "Scatter Plot"),
      
      actionButton("goBox", "Box Plot"),
      
      actionButton("goDensities", "Densities"),
      
      # Horizontal line ----
      tags$hr(),
      
      h3("Data Analysis Option:"),
      
      checkboxInput("isEqualVar", "Equal Variance", F),
      
      tags$hr(),
      
      h3("Data Analysis:"),
      
      fluidRow(
        column(6,radioButtons("groupVar","Group Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
        column(6,radioButtons("quantity","Quantity:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
      ),
      
      uiOutput("sel1"),
      
      uiOutput("sel2"),
      
      actionButton("goT", "T test"), 
      
      actionButton("goLevene", "Levene test"),
      
      actionButton("goFligner", "Fligner test"),  
      
      actionButton("goWilcoxon", "Wilcoxon test"),     
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      
      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),
      
      # Output: Data file ----
      tableOutput("contents"),
      
      # Output: t test ----
      verbatimTextOutput("ttest"),
      
      verbatimTextOutput("levene"),
      
      verbatimTextOutput("fligner"),
      
      verbatimTextOutput("wilcoxon"),
      
      # Output: plot
      plotOutput("histogram"),
      
      # Output: plot
      plotOutput("violinPlot"),
      
      plotOutput("scatterPlot"),
      
      plotOutput("boxPlot"),
      
      plotOutput("densities"),
      
      
      
      
    )
    
  )
)
