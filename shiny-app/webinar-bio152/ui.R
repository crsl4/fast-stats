#####################################################################
#
# ui.R
#     
# 
#
#     This program is free software; you can redistribute it and/or
#     modify it under the terms of the MIT License:
#     https://github.com/crsl4/fast-stats/blob/master/LICENSE
#
# Part of the fast-stats package
# Contains: ui.R
######################################################################


library(shiny)
library(plotly)
library(shinydashboard)

######################################################################
# 
# shinyUI: Create a Shiny UI handler (see tutorial: https://shiny.rstudio.com/tutorial/)
# ui: user interface. This function will define the format of the 
# screen (what the user sees when opening the web app)
# 
###################################################################### 
shinyUI(dashboardPage(
  skin="red",
  dashboardHeader(
    
    title= tags$a(href='#',
                  tags$img(src='fast-stats-logo-red-1.png',width=210,height =50)),
    tags$li(img(src='red.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='logo.png',width=175,height =50),class="dropdown"),
    tags$li(img(src='red.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='WIDSimpleAcronym.png',width=80,height =50),class="dropdown"),
    tags$li(img(src='red.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='uw-logo-flush-web.png',width=150,height =50),class="dropdown"),
    tags$li(img(src='red.png',width=10,height =50),class="dropdown")
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
              box( width=12, status="danger",solidHeader = T,
                   title = "Welcome to the WI Fast Stats web-app for IntroBio!",
                   
                   h4(HTML( 'WI Fast Stats is the <a href="https://github.com/crsl4/fast-stats" target="_blank">open-source</a> publicly available web app to analyze data from <a href="https://fastplants.org/" target="_blank">WI Fast Plants</a>.')),

                   h4(HTML( 'This web app is the accompanying tool for the UW-Madison class: <a href="https://introbio.integrativebiology.wisc.edu/" target="_blank">Introductory Biology 151/153-152</a>.')),

                   h4(HTML( 'A 9-minute tutorial of the WI Fast Stats web app can be found <a href="https://www.youtube.com/watch?v=6vX3mVXcK4s&t=4s" target="_blank">here</a>.')),
                                      
                   h4(HTML( 'For more information, a video of the Data Analysis part of a WI Fast Plants webinar can be found <a href="https://www.currikistudio.org/playlist/6155/activity/167241/preview/lti" target="_blank">here</a>.'))
                   
                   ),
      ),
      # dataupload button
      tabItem("dataUpload",
              fluidRow(
                box(
                  width = 8, status = "danger",solidHeader = T,
                  title = "File Display",
                  tableOutput("contents"),
                ),
                box(
                  width = 4, status = "danger", solidHeader = TRUE,
                  title = "Data Upload",
                  # Input: Select a file ----
                  
                  radioButtons("fileType","Use Sample Data or Upload Data",
                               choices = c("Sample File" = "sampleFile",
                                           "Upload File" = "uploadFile"),
                               selected = "uploadFile"),
                  
                  conditionalPanel(condition="input.fileType=='uploadFile'", 
                                   
                                   HTML('<p style="color:#808080">Data in delimited text files can be separated by comma, tab or semicolon. For example, Excel data can be exported in .csv (comma separated) or .tab (tab separated) format. A template of the spreadsheet can be found <a href="https://docs.google.com/spreadsheets/d/12fEIaSCUdT8s16jPEZ3grV6pQeWsy6pcHtwuRlbW5JM/edit?usp=sharing" target="_blank">here</a> </p>'),
                                   
                                   fileInput("file1", "Choose CSV File or Drag the file here",
                                             multiple = FALSE,
                                             accept = c("text/csv",
                                                        "text/comma-separated-values,text/plain",
                                                        ".csv")),
                                   HTML('<p style="color:#808080"> <b>Warning:</b> The maximum file size should not exceed <b>10MB</b></p>'),
                                   HTML('<p style="color:#808080"> <b>Warning:</b> The uploaded file must have a column named<b> Experiment</b>. A template of the spreadsheet can be found <a href="https://docs.google.com/spreadsheets/d/12fEIaSCUdT8s16jPEZ3grV6pQeWsy6pcHtwuRlbW5JM/edit?usp=sharing" target="_blank">here</a></p>'),
                                   
                                   # Input: Checkbox if file has header ----
                                   tags$p("Click the checkbox if file has a header:"),
                                   checkboxInput("header", "Header", TRUE),
                                   
                                   # Input: Select separator ----
                                   radioButtons("sep", "Choose the separator",
                                                choices = c(Comma = ",",
                                                            Semicolon = ";",
                                                            Tab = "\t"),
                                                selected = ","),
                                   
                                   
                  ),
                  
                  conditionalPanel(condition="input.fileType=='sampleFile'", 
                                   HTML('<p style="color:#808080">The sample data included here mimics the structure of a dataset the students will have after following the experiments in class. A template of the spreadsheet can be found <a href="https://docs.google.com/spreadsheets/d/12fEIaSCUdT8s16jPEZ3grV6pQeWsy6pcHtwuRlbW5JM/edit?usp=sharing" target="_blank">here</a>. </p>'),
                                   
                  ),
                  uiOutput("sec1"),
                  HTML('<p style="color:#808080"> When the dataset contains information from multiple experiments, you can select which experiment you want to focus on for the plots. <b>Important:</b> The number of plants (rows) for the <b>Experiment</b> you have selected must be at least <b>15</b> for some of the plots to be displayed properly</p>'),
                  # Input: Select number of rows to display ----
                  radioButtons("disp","Choose to display on the left panel all the data ('all') or just the top rows ('head')",
                               choices = c(Head = "head",
                                           All = "all"),
                               selected = "head"),
                  
                  # radioButtons("section","Choose which column of data to filter",
                  #              choices = c("1"="1","2"="2"),
                  #              selected = ""),
                  
                  
                )
              )
      ),
      # data visualization button
      tabItem(
        "dataVisualization",
        
        fluidRow(
          box(
            width = 8, status = "danger", solidHeader = TRUE,
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
            width = 4, status = "danger",solidHeader = T,
            title = "Data Visualization",
            h4("Plot Option:"),
            
            selectInput("plotType","Plot Type",choices =c("MosaicPlot"=0,"ViolinPlot"=1,"BoxPlot"=2,"ScatterPlot"=3,"Densities"=4)),
            
            # mosaic plot
            conditionalPanel(condition="input.plotType==0",
                             
                             HTML('<p style="color:#808080"> <b>Mosaic plot:</b> Plot to visualize contigency tables of frequencies among categorical variables </p>'),
                             
                             h4("Data Visualization:"),
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
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
                               )
                             )
                            
            ),
            
            # violinplot
            conditionalPanel(condition="input.plotType==1",
                             
                             HTML('<p style="color:#808080"> <b>Violin Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). It is similar to the box plot but it also shows the distribution and spread of the data. </p>'),
                             
                             h4("Data Visualization:"),
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("xaxisGrp","Group Variable:", c("1"="1","2"="2"))),
                               column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             checkboxInput("addPoints", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b> This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             
                             selectInput("colorViolin","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),

                          

                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
                             selectInput("pointShapeViolin","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             
                             
                             sliderInput("transViolin", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeViolin", "Point Size:",
                                         min = 0, max = 10,
                                         value = 1),
                             
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goViolin", "Violin Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             )
                           
            ),
            # boxplot
            conditionalPanel(condition="input.plotType==2",
                             
                             HTML('<p style="color:#808080"> <b>Box Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). Solid black line in the box represents the median, and the upper and lower edges of the box represent the 3rd and 1st quartiles respectively. </p>'),
                             
                             h4("Data Visualization:"),
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("gvBox","Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qBox","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             checkboxInput("addPoints2", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b>  This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             selectInput("colorBox","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),

                           

                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on color palettes</p>'),

                             selectInput("pointShapeBox","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             
                             sliderInput("transBox", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeBox", "Point Size:",
                                         min = 0, max = 10,
                                         value = 2),
                             
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goBox", "Box Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             )
                             
            ),
            # scatterplot
            conditionalPanel(condition="input.plotType==3",
                             HTML('<p style="color:#808080"> <b>Scatter Plot:</b> Plot that shows the relationship between two numerical variables </p>'),
                             
                             h4("Data Visualization:"),
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("gvScatter","Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qScatter","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorScatter","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
                             selectInput("pointShapeScatter","Point Shape",choices =c("Solid Circle"=19,"Bullet"=20,"Filled Circle"=21,"Filled Square"=22,"Filled Diamond"=23,"Filled Triangle Point-Up"=24, "Filled Triangle Point-down"=25)),
                             
                             sliderInput("transScatter", "Transparency:",
                                         min = 30, max = 100,
                                         value = 65),
                             
                             sliderInput("pointSizeScatter", "Point Size:",
                                         min = 0, max = 10,
                                         value = 2),
                             
                             
                             
                             
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goScatter", "Scatter Plot"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             )
                            
                             
            ),
            # densities
            conditionalPanel(condition="input.plotType==4",
                             HTML('<p style="color:#808080"> <b>Densities Plot:</b> Plot that represents the distribution of a numeric variable (like a smoothed histogram) </p>'),
                             
                             h4("Data Visualization:"),
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
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
                             )
                             
            ),
          )
        )
      ),
      tabItem(
        "dataAnalysis",
        fluidRow(
          box(
            width = 8, status = "danger", solidHeader = TRUE,
            title = "Results Displayed",
            # successfully hide the annoying verbaltext output using conditionalpanel
            # surprised to find that input$actionbuttonID is actually integer, keep adding one as users click the buttons
            conditionalPanel(condition="input.testType==0&&input.goChi!=0",
                             verbatimTextOutput("anovatest")),
            conditionalPanel(condition="input.testType==1&&input.goT!=0",
                             verbatimTextOutput("ttest"))
          ),
          box(
            width = 4, status = "danger",solidHeader = T,
            title = "Data Analysis",
            selectInput("testType","Test Type",choices =c("Linear model test"=0,"Summarize"=1)),
            # t-test
            conditionalPanel(condition="input.testType==1",
                             # h4("Data Analysis Option:"),
                             
                             # checkboxInput("isEqualVar", "Equal Variance", F),
                             # 
                             # HTML('<p style="color:#808080"> <b> Equal variance:</b> The standard t test assumes equal variances on the two groups. If the user checks this option, the standard t test is run, but if the user unchecks this option, then the Welch t test is run instead (that does not assume equal variances). </p>'),
                             fluidRow(
                               column(6,radioButtons("groupVar","Group Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
                               column(6,radioButtons("quantity","Quantity:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
                             ),
                             # uiOutput("sel1"),
                             # uiOutput("sel2"),
                             # HTML('<p style="color:#808080"> <b>T test:</b> Statistical test of the null hypothesis of equality of means of a numerical variable ("Quantity") on two groups ("Group variable"). If the selected group variable has more than two categories, the user will select the two groups to compare. </p>'),
                             HTML('<p style="color:#808080"> <b>Statistical summary:</b> We present a table with the number of plants (count), average (mean) and standard deviation (sd) for the selected plant phenotype (Quantity) by different treatments (Group Variable) </p>'),
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goT", "Summarize"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             #HTML('<p style="color:#808080"> <b>Other descriptions come here</b>  </p>'),
                             # HTML('<p style="color:#808080"> <b>Assumptions of t test:</b> The t test assumes normality, equal variance and independence. Take a look at <a href="https://wolfganghuber.shinyapps.io/t-test-normality-and-independence/" target="_blank">this link</a> that illustrate how important normality and independence are in the t test results. </p>'),
            ),
            # lm test
            conditionalPanel(condition="input.testType==0",
                             fluidRow(
                               column(6,radioButtons("gv1","Group Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value"))),
                               column(6,radioButtons("gv2","Quantity Variable:", c("1"="UnSpecified_Value","2"="UnSpecified_Value")))
                             ),
                             # HTML('<p style="color:#808080"> <b>Chi-square test:</b> Pearson\'s chi-square test is used to determine whether there is a statistically significant difference between the expected frequencies and the observed frequencies in one or more categories of a contingency table</p>'),
                             HTML('<p style="color:#808080"> <b>Linear model test:</b> We test whether different treatments (Group Variable) have different values of a measured plant phenotype (Quantity) with a t test.</p>'),
                             fluidRow(
                               column(6, align="center", offset = 3,
                                      actionButton("goChi", "Linear model test"),
                                      tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                               )
                             ),
                             HTML('<p style="color:#808080"> <b>How to interpret the result?</b> The group variable represents the different treatments in the experiment which is internally encoded as binary variables. For example, for the light experiment in the sample data, there are two treatments: light (L) and dark (D). In the coefficients table, there is an intercept which corresponds to the average estimated quantity (whatever plant phenotype chosen) for the dark treatment, and a Group_VariableL which corresponds to the difference in averages between the dark treatment and the light treatment. If this coefficient is close to zero, then we do not have evidence of different plant phenotypes on different treatments. </p>'),
                             # HTML('<p style="color:#808080"> <b>How to interpret the result?</b> If the p-value is less than 0.05, we reject the null hypothesis that in the population there is no difference between the classes (reject independence). </p>')
            )#conditionpanel ends
          )#box ends
        )#fluidrow ends
      ),#tabitem for data analysis ends
      # cannot add extra , if it's the final tab item!
      tabItem("FAQ",
              box( width=12, status="danger",solidHeader = T,
                   title="Frequently Asked Questions",
                   h4("Q: How to get help? "), 
                   p(HTML('A: Check out the WI Fast Stats google user group where people post questions/answers. You can join to post questions: <a href="https://groups.google.com/g/wi-fast-stats/">https://groups.google.com/g/wi-fast-stats</a>')),
                   h4("Q: Where can I find a short tutorial for this class web app?"),  
                   p(HTML('A: A 9-minute tutorial of the WI Fast Stats web app can be found <a href="https://www.youtube.com/watch?v=6vX3mVXcK4s&t=4s" target="_blank">here</a>')),
                   h4("Q: Where can I find the WI Fast Plants webinar slides and video for the Data science part?"),
                   p(HTML('A: The webinar slides are in the WI Fast Stats github repo <a href="https://github.com/crsl4/fast-stats/blob/master/slides/aug20-cotelydon.pdf" target="_blank">here</a> and the video can be found <a href="https://www.currikistudio.org/playlist/6155/activity/167241/preview/lti" target="_blank">here</a>')),
                   h4("Q: I found a bug or error in the code, how can I report it?"),
                   p(HTML('A: You should file an issue in the github repo: <a href="https://github.com/crsl4/fast-stats/issues" target="_blank">https://github.com/crsl4/fast-stats/issues</a>')),
                   h4("Q: How can I provide positive (or constructive) feedback?"),
                   p(HTML('A: Users feedback is very important to us! Please use <a href="https://forms.gle/PQS92afdhLHwK6kG6" target="_blank">this form </a>')),
                   h4("Q: If I use the website and web apps in my work, how do I cite them?"),
                   p(HTML('A: If you use the website or web apps in your work, we ask that you cite <a href="https://arxiv.org/abs/2012.03290" target="_blank">this paper </a>')),
                   h4("Q: Color Palettes Charts: "), 
                   p(HTML('A: The colors palettes here shown come from <a href="https://cran.r-project.org/web/packages/RColorBrewer/index.html" target="_blank">ColorBrewer</a>')),
                   img(src="color_palettes.png",width=525, height=671),
                 
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







