library(shiny)
library(plotly)

shinyUI(pageWithSidebar(
  
  headerPanel(
    img(src = "logo.png", height = 50, width = 154),
    # fix the adjust ratio 75/230
    # "Fast-Stats Web Tool",
    #           tags$head(tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
    #                     tags$style(type="text/css", "select { max-width: 200px; }"),
    #                     tags$style(type="text/css", "textarea { max-width: 185px; }"),
    #                     tags$style(type="text/css", ".jslider { max-width: 200px; }"),
    #                     tags$style(type='text/css', ".well { max-width: 330px; }"),
    #                     tags$style(type='text/css', ".span4 { max-width: 330px; }")) 
  ),
  
  sidebarPanel(
    conditionalPanel(condition="input.tabs1=='About'",
                     # img(src = "logo.png", height = 75, width = 230),
                     h4("Introduction")
    ),
    conditionalPanel(condition="input.tabs1=='Data upload'",
                     # img(src = "logo.png", height = 75, width = 230),
                     h4("Data Upload:"),
                     
                     # Input: Select a file ----
                     fileInput("file1", "Choose CSV File or Drag the file here",
                               multiple = FALSE,
                               accept = c("text/csv",
                                          "text/comma-separated-values,text/plain",
                                          ".csv")),
                     
                     # Input: Checkbox if file has header ----
                     tags$p("Click the checkbox if file has a header:"),
                     checkboxInput("header", "Header", TRUE),
                     
                     # Input: Select separator ----
                     radioButtons("sep", "Choose the separator",
                                  choices = c(Comma = ",",
                                              Semicolon = ";",
                                              Tab = "\t"),
                                  selected = ","),
                     
                     h4("Data Summary:"),
                     
                     # Input: Select number of rows to display ----
                     radioButtons("disp","Choose to show 'head' or 'all'",
                                  choices = c(Head = "head",
                                              All = "all"),
                                  selected = "head"),
                     actionButton("goSummary", "Summary"),
                     
                     HTML('<p>Data in <a href="http://en.wikipedia.org/wiki/Delimiter-separated_values">delimited text files </a> can be separated by comma, tab or semicolon. 
				For example, Excel data can be exported in .csv (comma separated) or .tab (tab separated) format. </p>')
    ),
    conditionalPanel(condition="input.tabs1=='Data visualization'",
                     # img(src = "logo.png", height = 75, width = 230),
                     
                     selectInput("plotType","Plot Type",choices =c("ViolinPlot"=0,"BoxPlot"=1)),
                     h4("Plot Option:"),
                     
                     checkboxInput("addPoints", "Add data points", T),
                     
                     h4("Data Visualization:"),
                     
                     fluidRow(
                       column(6,radioButtons("xaxisGrp","Grouping Variables:", c("1"="1","2"="2"))),
                       column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
                     ),
                     
                     conditionalPanel(condition="input.plotType==0",
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goViolin", "Violin Plot"),
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        ),
                                      ),
                                      helpText("help text")
                     ),
                     conditionalPanel(condition="input.plotType==1",
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goBox", "Box Plot"),
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        )
                                      ),
                                      helpText("help text")),
                     
    ),
    conditionalPanel(condition="input.tabs1=='Data analysis'",
                     # img(src = "logo.png", height = 75, width = 230),
                     h4("Data Analysis Option:"),
                     
                     checkboxInput("isEqualVar", "Equal Variance", F),
                     
                     tags$hr(),
                     
                     h4("Data Analysis:"),
                     
                     fluidRow(
                       column(6,radioButtons("groupVar","Grouping Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
                       column(6,radioButtons("quantity","Quantity:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
                     ),
                     uiOutput("sel1"),
                     uiOutput("sel2"),
                     fluidRow(
                       column(6, align="center", offset = 3,
                              actionButton("goT", "T test"), 
                              tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                       )
                     ),
                     helpText("help text")
    ),
    conditionalPanel(condition="input.tabs1=='FAQ'",
                     # img(src = "logo.png", height = 75, width = 230),
    )
  ),
  
  mainPanel(
    tabsetPanel(
      # Welcome tab
      tabPanel("About",
               HTML('	<br> <p> xxx </p>'),
               h5("Software references"),
               HTML('<p> xxx </p>'),
               h5("Further references"),
               HTML('<p> xxx </p>'),
               
      ),
      # Data upload tab
      tabPanel("Data upload", tableOutput("filetable"),
               # Output: Verbatim text for data summary ----
               verbatimTextOutput("summary"),
               # Output: Data file ----
               tableOutput("contents"),
      ),
      # plot tab
      tabPanel("Data visualization", 
               conditionalPanel(condition = "input.plotType==0",
                                plotlyOutput("violinPlot") ),
               conditionalPanel(condition = "input.plotType==1",
                                plotlyOutput("boxPlot") ),
             
      ), 
      # analysis tab
      tabPanel("Data analysis", 
               verbatimTextOutput("ttest"),
      ), 
      
      # FAQ 
      tabPanel("FAQ",
               h5("Q: I have trouble editing the graphic files."), 
               p("A: For EPS files make sure to 'ungroup' all objects so they can be edited independently. 
				In Adobe Illustrator you will also need to use the 'release compound path' command. For PDF 
				files you should 'release clipping mask'. SVG import appears to have problems in Adobe Illustrator 
				and Corel Draw and should be avoided. EPS, PDF and SVG import all work with Inkscape http://www.inkscape.org/."),
      ),
      
      
      
      id="tabs1"
      
    ),
    # used to suppress the errors; comment it out everytime we need to debug
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    )
  )))







