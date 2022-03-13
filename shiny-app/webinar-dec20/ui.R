#####################################################################
#
# ui.R
#     
# 
#
#     This program is free software; you can redistribute it and/or
#     modify it under the terms of the GNU General Public License,
#     version 3, as published by the Free Software Foundation.
#
#     This program is distributed in the hope that it will be useful,
#     but without any warranty; without even the implied warranty of
#     merchantability or fitness for a particular purpose.  See the GNU
#     General Public License, version 3, for more details.
#
#     A copy of the GNU General Public License, version 3, is available
#     at http://www.r-project.org/Licenses/GPL-3
#
# Part of the fast-stats package
# Contains: ui.R
######################################################################

library(shiny)
library(plotly)
library(shinydashboard)
library(shinyjs)

######################################################################
# 
# shinyUI: Create a Shiny UI handler
# ui:
# A user interace definition
# 
###################################################################### 
shinyUI(dashboardPage(
  skin="blue",
 
  dashboardHeader(
    # theme="blue_gradient",
    
    title= tags$a(href='#',
                  tags$img(src='fast-stats-logo-blue-1.png',width=210,height =50)),
    tags$li(img(src='blue.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='logo.png',width=175,height =50),class="dropdown"),
    tags$li(img(src='blue.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='WIDSimpleAcronym.png',width=80,height =50),class="dropdown"),
    tags$li(img(src='blue.png',width=10,height =50),class="dropdown"),
    tags$li(img(src='uw-logo-flush-web.png',width=150,height =50),class="dropdown"),
    tags$li(img(src='blue.png',width=10,height =50),class="dropdown")
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about"),
      menuItem("Data Upload", tabName = "dataUpload"),
      menuItem("Data Visualization", tabName = "dataVisualization"),
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
              box( width=12, status="primary",solidHeader = T,
                   title = "Welcome to the WI Fast Stats app: Ecosystem!",
                   
                   h4(HTML( 'WI Fast Stats is the <a href="https://github.com/crsl4/fast-stats" target="_blank">open-source</a> publicly available web app to analyze data from <a href="https://fastplants.org/" target="_blank">WI Fast Plants</a>.')),

                   h4(HTML( 'This web app is the accompanying tool for the WI Fast Plants webinar: <a href="https://www.carolina.com/knowledge/2020/10/20/webinar-student-designed-ecosystem-experiments-in-middle-grades" target="_blank"><i>Teaching Middle-level and Upper-elementary Students Ecosystem Concepts with Hands-on Fast Plants Investigations</i></a>.')))

              
      ),
      
      tabItem("dataUpload",
              fluidRow(
                box(
                  width = 8, status = "primary",solidHeader = T,
                  title = "File Display",
                  tableOutput("contents"),
                ),
                box(
                  width = 4, status = "primary", solidHeader = T,
                  title = "Data Upload",
                  # Input: Select a file ----
                  
                  radioButtons("fileType","Use Sample Data or Upload Data",
                               choices = c("Sample File" = "sampleFile",
                                           "Upload File" = "uploadFile"),
                               selected = "uploadFile"),
                  
                  conditionalPanel(condition="input.fileType=='uploadFile'", 
                                   
                                   HTML('<p style="color:#808080">Data in delimited text files can be separated by comma, tab or semicolon. For example, Excel data can be exported in .csv (comma separated) or .tab (tab separated) format </p>'),
                                   
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
                                   
                                 
                  ),
                  
                  conditionalPanel(condition="input.fileType=='sampleFile'", 
                                   HTML('<p style="color:#808080">The sample data included here mimics the structure of a dataset the students will have after following the experiments described in the webinar </p>'),
                                   HTML('<p style="color:#808080">Each row corresponds to a plant. The treatment column refers to dark (D) or light (L) and we measure different lengths: root, shoot and total</p>'),
                                   
                                   
                                   
                  ),
                  # Input: Select number of rows to display ----
                  radioButtons("disp","Choose to show 'head' or 'all'",
                               choices = c(Head = "head",
                                           All = "all"),
                               selected = "head"),
                  
                )
              )
      ),
      # data visualization button
      tabItem(
        "dataVisualization",
        
        fluidRow(
          box(
            width = 8, status = "primary", solidHeader = T,
            title = "Plot Display",
            conditionalPanel(condition = "input.plotType==1&&input.goViolin!=0",
                            plotlyOutput("violinPlot")
                             ),
            conditionalPanel(condition = "input.plotType==2&&input.goBox!=0",
                             plotlyOutput("boxPlot") ),
            conditionalPanel(condition = "input.plotType==3&&input.goScatter!=0",
                             plotlyOutput("scatterPlot") ),
          ),
          box(
            width = 4, status = "primary",solidHeader = T, 
            title = "Data Visualization",
            h4("Plot Option:"),
            

            selectInput("plotType","Plot Type",choices =c("ViolinPlot"=1,"BoxPlot"=2,"ScatterPlot"=3)),

        
            
            # mosaic plot
            conditionalPanel(condition="input.plotType==0",
                             
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
                               ),
                             ),
                             HTML('<p style="color:#808080"> <b>Mosaic plot:</b> Plot to visualize contigency tables of frequencies among categorical variables </p>'),
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
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
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
                               column(6,radioButtons("gvScatter","Quantity 1/Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qScatter","Quantity 2:", c("1"="1","2"="2")))
                             ),
                             
                             uiOutput("addLine"),
                             uiOutput("addComment"),
                             
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

           
          )
        )
      ),
     # FAQ button
      tabItem("FAQ",
              box( width=12, status="primary",solidHeader = T,
                   title="Frequently Asked Questions",
                   h4("Q: How to get help? "), 
                   p(HTML('<b>A: Check out the WI Fast Stats google user group where people post questions/answers. You can join to post questions: <a href="https://groups.google.com/g/wi-fast-stats/">https://groups.google.com/g/wi-fast-stats</a></b>')),
                   h4("Q: Where can I find the information about the WI Fast Plants Webinar?"),  
                   p(HTML('<b>A: WI Fast Plants webinar: <a href="https://register.gotowebinar.com/register/1900289654623158541" target="_blank"><i>Teaching Middle-level and Upper-elementary Students Ecosystem Concepts with Hands-on Fast Plants Investigations</i></a>.</b>')),
                   h4("Q: Where can I find the webinar slides for the Data science part?"),
                   p(HTML('<b>A: The webinar slides are in the WI Fast Stats github repo <a href="https://github.com/crsl4/fast-stats/blob/master/slides/dec20-ecosystem.pdf" target="_blank">here</a></b>')),
                   h4("Q: I found a bug or error in the code, how can I report it?"),
                   p(HTML('<b>A: You should file an issue in the github repo: <a href="https://github.com/crsl4/fast-stats/issues" target="_blank">https://github.com/crsl4/fast-stats/issues</a></b>')),
                   h4("Q: How can I provide positive (or constructive) feedback?"),
                   p(HTML(' <b>A: Users feedback is very important to us! Please use <a href="https://forms.gle/PQS92afdhLHwK6kG6" target="_blank">this form </a></b>')),
                   h4("Q: If I use the website and web apps in my work, how do I cite them?"),
                   p(HTML('<b>  A: If you use the website or web apps in your work, we ask that you cite <a href="https://arxiv.org/abs/2012.03290" target="_blank">this paper </a></b>')),
                   h4("Q: Color Palettes Charts: "), 
                   p(HTML('<b>A: The colors palettes here shown come from <a href="https://cran.r-project.org/web/packages/RColorBrewer/index.html" target="_blank">ColorBrewer</a></b>')),
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






