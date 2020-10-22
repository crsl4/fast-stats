library(shiny)
library(plotly)
library(shinydashboard)

shinyUI(dashboardPage(
  skin="yellow",
  dashboardHeader(
    
    title="Fast-Stats Web Tool",
    tags$li(img(src='yellow1.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='logo.png',width=175,height =50),class="dropdown"),
    tags$li(img(src='yellow1.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='WIDSimpleAcronym.png',width=80,height =50),class="dropdown"),
    tags$li(img(src='yellow1.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='uw-logo-flush-web.png',width=150,height =50),class="dropdown"),
    tags$li(img(src='yellow1.png',width=10,height =50),class="dropdown")
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about"),
      menuItem("Data Upload", tabName = "dataUpload"),
      menuItem("Data Visualization", tabName = "dataVisualization"),
      menuItem("Data Analysis", tabName = "dataAnalysis"),
      menuItem("FAQ", tabName = "FAQ")
    )
  ),
  
  dashboardBody(
    # for internal links
    tags$script(HTML("
        var openTab = function(tabName){
          $('a', $('.sidebar')).each(function() {
            if(this.getAttribute('data-value') == tabName) {
              this.click()
            };
          });
        }
      ")),
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
    
    tabItems(
      tabItem("about",
              box( width=12, status="warning",solidHeader = T,
                   title = "Welcome to the WI Fast Stats app!",
                   
                   h4(HTML( 'WI Fast Stats is the <a href="https://github.com/crsl4/fast-stats" target="_blank">open-source</a> publicly available web app to analyze data from <a href="https://fastplants.org/" target="_blank">WI Fast Plants</a>.')),
                   h4(HTML( 'This web app is the accompanying tool for the WI Fast Plants webinar: <i>Strategies for adapting WI Fast Plants selection of traits investigations for remote and social distance learning</i>.')))
      ),
      
      tabItem("dataUpload",
              fluidRow(
                box(
                  width = 8, status = "warning",solidHeader = T,
                  title = "File Display",
                  tableOutput("contents"),
                ),
                box(
                  width = 4, status = "warning", solidHeader = TRUE,
                  title = "Data Upload",
                  # Input: Select a file ----
                  
                  radioButtons("fileType","Use Sample Data or Upload Data",
                               choices = c("Sample File" = "sampleFile",
                                           "Upload File" = "uploadFile"),
                               selected = "uploadFile"),
                  
                  conditionalPanel(condition="input.fileType=='uploadFile'", 
                                   fileInput("file1", "Choose CSV File or Drag the file here",
                                                                                     multiple = FALSE,
                                                                                     accept = c("text/csv",
                                                                                                "text/comma-separated-values,text/plain",
                                                                                                ".csv")),
                                   HTML('<p style="color:#808080"> <b>Warning:</b> The maximum file size should not exceed <b>10MB</b></p>'),
                                   
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
                                   ),
                  
                  
                  HTML('<p>Data in <a href="http://en.wikipedia.org/wiki/Delimiter-separated_values">delimited text files </a> can be separated by comma, tab or semicolon. 
				For example, Excel data can be exported in .csv (comma separated) or .tab (tab separated) format. </p>'),
                )
              )
      ),
      tabItem(
        "dataVisualization",
        
        fluidRow(
          box(
            width = 8, status = "warning", solidHeader = TRUE,
            title = "Plot Display",
            conditionalPanel(condition = "input.plotType==0&&input.goMosaic!=0",
                             plotlyOutput("mosaicPlot") ),
            conditionalPanel(condition = "input.plotType==1&&input.goViolin!=0",
                             plotlyOutput("violinPlot") ),
            conditionalPanel(condition = "input.plotType==2&&input.goBox!=0",
                             plotlyOutput("boxPlot") ),
            conditionalPanel(condition = "input.plotType==3&&input.goScatter!=0",
                             plotlyOutput("scatterPlot") ),
            conditionalPanel(condition = "input.plotType==4&&input.goDensities!=0",
                             plotlyOutput("densities") ),
          ),
          box(
            width = 4, status = "warning",solidHeader = T,
            title = "Data Visualization",
            h4("Plot Option:"),
            
            selectInput("plotType","Plot Type",choices =c("MosaicPlot"=0,"ViolinPlot"=1,"BoxPlot"=2,"ScatterPlot"=3,"Densities"=4)),
            
            # mosaic plot
            conditionalPanel(condition="input.plotType==0",
                             
                             h4("Data Visualization:"),
                             HTML("Please select the two variables to use in the plot and click on the button to generate the plot."),
                             
                             fluidRow(
                               column(6,radioButtons("gvMosaic1","Group Variable 1:", c("1"="1","2"="2"))),
                               column(6,radioButtons("gvMosaic2","Group Variable 2:", c("1"="1","2"="2")))
                             ),
                             selectInput("colorMosaic","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goMosaic", "Mosaic Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               ),
                             ),
                             HTML('<p style="color:#808080"> <b>Mosaic plot:</b> Plot to visualize contigency tables of frequencies among categorical variables </p>'),
            ),
            
            # violinplot
            conditionalPanel(condition="input.plotType==1",
                             
                             checkboxInput("addPoints", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b> This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             h4("Data Visualization:"),
                             HTML("Please select the two variables to use in the plot and click on the button to generate the plot."),
                             
                             fluidRow(
                               column(6,radioButtons("xaxisGrp","Group Variable:", c("1"="1","2"="2"))),
                               column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorViolin","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar in the left sidebar for more details on the color palettes</p>'),
                             
                             sliderInput("transViolin", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeViolin", "Point Size:",
                                         min = 0, max = 10,
                                         value = 1),
                             
                             selectInput("pointShapeViolin","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goViolin", "Violin Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               ),
                             ),
                             HTML('<p style="color:#808080"> <b>Violin Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). It is similar to the box plot but it also shows the distribution and spread of the data. </p>'),
            ),
            # boxplot
            conditionalPanel(condition="input.plotType==2",
                             checkboxInput("addPoints2", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b>  This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             h4("Data Visualization:"),
                             HTML("Please select the two variables to use in the plot and click on the button to generate the plot."),
                             
                             fluidRow(
                               column(6,radioButtons("gvBox","Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qBox","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorBox","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on color palettes</p>'),
                             
                             sliderInput("transBox", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeBox", "Point Size:",
                                         min = 0, max = 10,
                                         value = 2),
                             
                             selectInput("pointShapeBox","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goBox", "Box Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             HTML('<p style="color:#808080"> <b>Box Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). Solid black line in the box represents the median, and the upper and lower edges of the box represent the 3rd and 1st quartiles respectively. </p>'),
                             
            ),
            # scatterplot
            conditionalPanel(condition="input.plotType==3",
                             
                             h4("Data Visualization:"),
                             HTML("Please select the two variables to use in the plot and click on the button to generate the plot."),
                             
                             fluidRow(
                               column(6,radioButtons("gvScatter","Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qScatter","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorScatter","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
                             sliderInput("transScatter", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeScatter", "Point Size:",
                                         min = 0, max = 10,
                                         value = 2),
                             
                             selectInput("pointShapeScatter","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goScatter", "Scatter Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             HTML('<p style="color:#808080"> <b>Scatter Plot:</b> Plot that shows the relationship between two numerical variables </p>'),
                             
            ),
            # densities
            conditionalPanel(condition="input.plotType==4",
                             
                             h4("Data Visualization:"),
                             HTML("Please select the two variables to use in the plot and click on the button to generate the plot."),
                             
                             fluidRow(
                               column(6,radioButtons("gvDensities","Group Variable:", c("1"="1","2"="2"))),
                               column(6,radioButtons("qDensities","Quantity:", c("1"="1","2"="2")))
                             ),
                             selectInput("colorDensities","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
                             sliderInput("transDensities", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goDensities", "Densities Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             HTML('<p style="color:#808080"> <b>Densities Plot:</b> Plot that represents the distribution of a numeric variable (like a smoothed histogram) </p>')
            ),
          )
        )
      ),
      tabItem(
        "dataAnalysis",
        fluidRow(
          box(
            width = 8, status = "warning", solidHeader = TRUE,
            title = "Results Displayed",
            # successfully hide the annoying verbaltext output using conditionalpanel
            # surprised to find that input$actionbuttonID is actually integer, keep adding one as users click the buttons
            conditionalPanel(condition="input.testType==0&&input.goChi!=0",
                             verbatimTextOutput("chitest",placeholder = F)),
            conditionalPanel(condition="input.testType==1&&input.goT!=0",
                             verbatimTextOutput("ttest",placeholder = F))
          ),
          box(
            width = 4, status = "warning",solidHeader = T,
            title = "Data Analysis",
            
            
            selectInput("testType","Test Type",choices =c("Chi-Square Test"=0,"T-Test"=1)),
            # t-test
            conditionalPanel(condition="input.testType==1",
                             h4("Data Analysis Option:"),
                             
                             checkboxInput("isEqualVar", "Equal Variance", F),
                             
                             HTML('<p style="color:#808080"> <b> Equal variance:</b> The standard t test assumes equal variances on the two groups. If the user checks this option, the standard t test is run, but if the user unchecks this option, then the Welch t test is run instead (that does not assume equal variances). </p>'),
                             fluidRow(
                               column(6,radioButtons("groupVar","Group Variable:", c("1"="1","2"="2"))),
                               column(6,radioButtons("quantity","Quantity:", c("1"="1","2"="2")))
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
                             HTML('<p style="color:#808080"> <b>Assumptions of t test:</b> The t test assumes normality, equal variance and independence. Take a look at <a href="https://wolfganghuber.shinyapps.io/t-test-normality-and-independence/" target="_blank">this link</a> that illustrate how important normality and independence are in the t test results. </p>'),
            ),
            # chi-square
            conditionalPanel(condition="input.testType==0",
                             fluidRow(
                               column(6,radioButtons("gv1","Group Variable 1:", c("1"="1","2"="2"))),
                               column(6,radioButtons("gv2","Group Variable 2:", c("1"="1","2"="2")))
                             ),
                             HTML('<p style="color:#808080"> <b>Chi-square test:</b> Pearson\'s chi-square test is used to determine whether there is a statistically significant difference between the expected frequencies and the observed frequencies in one or more categories of a contingency table</p>'),
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goChi", "Chi-Square Test"), 
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             HTML('<p style="color:#808080"> <b>How to interpret the result?</b> If the p-value is less than 0.05, we reject the null hypothesis that in the population there is no difference between the classes (reject independence). </p>')
            )#conditionpanel ends
          )#box ends
        )#fluidrow ends
      ),#tabitem for data analysis ends
      # cannot add extra , if it's the final tab item!
      tabItem("FAQ",
              box( width=12, status="warning",solidHeader = T,
                   title="Frequently Asked Questions",
                   h4("Q: How to get help? "), 
                   p(HTML('<b>A: Soon we will have a google user group to post questions and answers for users of the app.</b>')),
                   h4("Q: Color Palettes Charts: "), 
                   img(src="color_palettes.png",width=525, height=671),
                   p(HTML('   The colors palettes here shown come from <a href="https://cran.r-project.org/web/packages/RColorBrewer/index.html">ColorBrewer</a>')),
              )
      )
    ),#tabitems end
    
    
    
    # used to suppress the errors; comment it out everytime we need to debug
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    )
    
  ))
)







