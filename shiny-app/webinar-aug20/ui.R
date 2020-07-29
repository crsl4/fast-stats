library(shiny)
library(plotly)

shinyUI(pageWithSidebar(
  
  headerPanel(
    img(src = "logo.png", height = 80, width = 350),
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
    # useShinyjs(),
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
                     
                     # Input: Select number of rows to display ----
                     radioButtons("disp","Choose to show 'head' or 'all'",
                                  choices = c(Head = "head",
                                              All = "all"),
                                  selected = "head"),
                     # actionButton("goSummary", "Summary"),
                     
                     HTML('<p>Data in <a href="http://en.wikipedia.org/wiki/Delimiter-separated_values">delimited text files </a> can be separated by comma, tab or semicolon. 
				For example, Excel data can be exported in .csv (comma separated) or .tab (tab separated) format. </p>')
    ),
    conditionalPanel(condition="input.tabs1=='Data visualization'",
                     # img(src = "logo.png", height = 75, width = 230),
                     h4("Plot Option:"),
                     
                     selectInput("plotType","Plot Type",choices =c("ViolinPlot"=0,"BoxPlot"=1)),
                     checkboxInput("addPoints", "Add data points", T),
                     
                     HTML('<p style="color:#808080"> <b>Plot Option: </b> Add data points. This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                     
                     # violinplot
                     conditionalPanel(condition="input.plotType==0",
                                      
                                      h4("Data Visualization:"),
                                      
                                      fluidRow(
                                        column(6,radioButtons("xaxisGrp","Group Variable:", c("1"="1","2"="2"))),
                                        column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
                                      ),
                                      
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goViolin", "Violin Plot"),
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        ),
                                      ),
                                      HTML('<p style="color:#808080"> <b>Violin Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). It is similar to the box plot but it also shows the distribution and spread of the data. </p>'),
                     ),
                     # boxplot
                     conditionalPanel(condition="input.plotType==1",
                                      
                                      h4("Data Visualization:"),
                                      
                                      fluidRow(
                                        column(6,radioButtons("gvBox","Group Variable:", c("1"="1","2"="2"))),
                                        column(6,radioButtons("qBox","Quantity:", c("1"="1","2"="2")))
                                      ),
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goBox", "Box Plot"),
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        )
                                      ),
                                      HTML('<p style="color:#808080"> <b>Box Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). Solid black line in the box represents the median, and the upper and lower edges of the box represent the 3rd and 1st quartiles respectively. </p>'),
                                      
                     ),
    ),
    conditionalPanel(condition="input.tabs1=='Data analysis'",
                     # img(src = "logo.png", height = 75, width = 230),
                     
                     # h4("Data Analysis:"),
                     
                     selectInput("testType","Test Type",choices =c("Chi-Square Test"=0,"T-Test"=1)),
                     # t-test
                     conditionalPanel(condition="input.testType==1",
                                      h4("Data Analysis Option:"),
                                      
                                      checkboxInput("isEqualVar", "Equal Variance", F),
                                      
                                      HTML('<p style="color:#808080"> <b> Equal variance:</b> The standard t test assumes equal variances on the two groups. If the user checks this option, the standard t test is run, but if the user unchecks this option, then the Welch t test is run instead (that does not assume equal variances). </p>'),
                                      fluidRow(
                                        column(6,radioButtons("groupVar","Group Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
                                        column(6,radioButtons("quantity","Quantity:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
                                      ),
                                      uiOutput("sel1"),
                                      uiOutput("sel2"),
                                      HTML('<p style="color:#808080"> <b>T test:</b> Statistical test of the null hypothesis of equality of means of a numerical variable ("Quantity") on two groups ("Group variable"). If the selected group variable has more than two categories, the user will select the two groups to compare. </p>'),
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goT", "T-Test"), 
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        )
                                      ),
                                      HTML('<p style="color:#808080"> <b>How to interpret the result?</b> If the p-value is less than 0.05, we reject the null hypothesis of equality of means. The confidence interval represents the interval for the difference of means. </p>'),
                     ),
                     # chi-square
                     conditionalPanel(condition="input.testType==0",
                                      fluidRow(
                                        column(6,radioButtons("gv1","Group Variable 1:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
                                        column(6,radioButtons("gv2","Group Variable 2:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
                                      ),
                                      HTML('<p style="color:#808080"> <b>Chi-square test:</b> Pearson\'s chi-square test is used to determine whether there is a statistically significant difference between the expected frequencies and the observed frequencies in one or more categories of a contingency table</p>'),
                                      fluidRow(
                                        column(6, align="center", offset = 3,
                                               actionButton("goChi", "Chi-Square Test"), 
                                               tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                                        )
                                      ),
                                      HTML('<p style="color:#808080"> <b>How to interpret the result?</b> If the p-value is less than 0.05, we reject the null hypothesis that in the population there is no difference between the classes (reject independence). </p>'),
                     ),
                     
    ),
    conditionalPanel(condition="input.tabs1=='FAQ'",
                     # img(src = "logo.png", height = 75, width = 230),
                     h4("FAQ")
    )
  ),
  
  mainPanel(
    tags$head(
      tags$style(HTML("
      .shiny-output-error-validation {
        color: red;
        font-size:120%;
      },
    ")),
      # font for shiny notification
      tags$style(
        HTML(".shiny-notification {
             position:fixed;
             top: calc(40%);
             left: calc(40%);
             font-size:120%;
             }
             "
        )
      )
    ),
    tabsetPanel(
      # useShinyjs(),
      # Welcome tab
      tabPanel("About",
               HTML('	<br> <h4> <strong>Welcome to the WI Fast Stats app! </strong> </h4></br>'),
               # h5("Software references"),
               h5( "This is the open-source publicly available web app to analyze data from WI Fast Plants.")
               
               
      ),
      # Data upload tab
      tabPanel("Data upload", #tableOutput("filetable"),
               # Output: Verbatim text for data summary ----
               # verbatimTextOutput("summary",placeholder=F),
               
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
               # successfully hide the annoying verbaltext output using conditionalpanel
               # surprised to find that input$actionbuttonID is actually integer, keep adding one as users click the buttons
               conditionalPanel(condition="input.testType==0&&input.goChi!=0",
                                verbatimTextOutput("chitest",placeholder = F)),
               conditionalPanel(condition="input.testType==1&&input.goT!=0",
                                verbatimTextOutput("ttest",placeholder = F)
               )
      ), 
      
      # FAQ 
      tabPanel("FAQ",
               h5("Q: How to get help? "), 
               p("A: Soon we will have a google user group to post questions and answers for users of the app."),
      ),
      
      
      
      id="tabs1"
      
    ),
    # used to suppress the errors; comment it out everytime we need to debug
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    )
    
  )))







