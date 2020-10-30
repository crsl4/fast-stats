library(shiny)
library(plotly)
library(shinydashboard)
library(shinyjs)
# library(dashboardthemes)

shinyUI(dashboardPage(
  skin="blue",
 
  dashboardHeader(
    # theme="blue_gradient",
    
    title="Fast-Stats Web Tool",
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
                   title = "Welcome to the WI Fast Stats app!",
                   
                   h4(HTML( 'WI Fast Stats is the <a href="https://github.com/crsl4/fast-stats" target="_blank">open-source</a> publicly available web app to analyze data from <a href="https://fastplants.org/" target="_blank">WI Fast Plants</a>.')),
                   h4(HTML( 'This web app is the accompanying tool for the WI Fast Plants webinar: <a href="https://fastplants.org/2020/08/06/new-fast-plants-polycots-selection/" target="_blank"><i>Strategies for adapting WI Fast Plants selection of traits investigations for remote and social distance learning</i></a>.')))
              
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
                                   
                  ),
                  # Input: Select number of rows to display ----
                  radioButtons("disp","Choose to show 'head' or 'all'",
                               choices = c(Head = "head",
                                           All = "all"),
                               selected = "head"),
                  
                )
              )
      ),
      tabItem(
        "dataVisualization",
        
        fluidRow(
          box(
            width = 8, status = "primary", solidHeader = T,
            title = "Plot Display",
            
            # conditionalPanel(condition = "input.plotType==0&&input.goMosaic!=0",
            #                  plotlyOutput("mosaicPlot") ),
            conditionalPanel(condition = "input.plotType==1&&input.goViolin!=0",
                            plotlyOutput("violinPlot")
                             ),
            conditionalPanel(condition = "input.plotType==2&&input.goBox!=0",
                             plotlyOutput("boxPlot") ),
            conditionalPanel(condition = "input.plotType==3&&input.goScatter!=0",
                             plotlyOutput("scatterPlot") ),
            # conditionalPanel(condition = "input.plotType==4&&input.goDensities!=0",
            #                  plotlyOutput("densities") ),
          ),
          box(
            width = 4, status = "primary",solidHeader = T, 
            title = "Data Visualization",
            h4("Plot Option:"),
            
            selectInput("plotType","Plot Type",choices =c("ViolinPlot"=1,"BoxPlot"=2,"ScatterPlot"=3)),
            
            # violinplot
            conditionalPanel(condition="input.plotType==1",
                             
                             HTML('<p style="color:#808080"> <b>Violin Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). It is similar to the box plot but it also shows the distribution and spread of the data. </p>'),
                             
                             checkboxInput("addPoints", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b> This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             h4("Data Visualization:"),
                             
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("xaxisGrp","Group Variable:", c("1"="1","2"="2"))),
                               column(6,radioButtons("yaxisGrp","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorViolin","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
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
                               )
                             )
                             
                             
            ),
            # boxplot
            conditionalPanel(condition="input.plotType==2",
                             
                             
                             
                             HTML('<p style="color:#808080"> <b>Box Plot:</b> Plot a numerical variable ("Quantity") by groups ("Group variable"). Solid black line in the box represents the median, and the upper and lower edges of the box represent the 3rd and 1st quartiles respectively. </p>'),
                             checkboxInput("addPoints2", "Add data points", T),
                             
                             HTML('<p style="color:#808080"> <b>Add data points: </b>  This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset. </p>'),
                             
                             h4("Data Visualization:"),
                             
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("gvBox","Group Variable:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qBox","Quantity:", c("1"="1","2"="2")))
                             ),
                             
                             selectInput("colorBox","Color",choices = c("Blue+Purple"="BuPu","Dark Color"="Dark2","Orange+Red"="OrRd","Yellow+Green+Blue"="YlGnBu","Accent"="Accent","Paired"="Paired","Red+Blue"="RdYlBu","Purple+Red"="PuRd","Set2"="Set2","Purple+Green"="PRGn")
                             ),
                             HTML('<p style="color:#808080"> <b>About colors:</b> Click the <b>FAQ</b> tab in the left sidebar for more details on the color palettes</p>'),
                             
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
                             )
                            
                             
            ),
            # scatterplot
            conditionalPanel(condition="input.plotType==3",
                             
                             HTML('<p style="color:#808080"> <b>Scatter Plot:</b> Plot that shows the relationship between two numerical variables </p>'),
                             
                             h4("Data Visualization:"),
                             
                             HTML('<p style="color:#808080">Please select the two variables to use in the plot and click on the button to generate the plot.</p>'),
                             
                             checkboxInput("addRegression", "Add a linear regression line", T),
                             
                             HTML('<p style="color:#808080"> <b>Add a linear regression line:</b> Automatic computation of slope and intercept for the best line explaining the dots. The line includes a confidence region around it in gray.</p>'),
                             
                             fluidRow(
                               column(6,radioButtons("gvScatter","Quantity 1:",c("1"="1","2"="2"))),
                               column(6,radioButtons("qScatter","Quantity 2:", c("1"="1","2"="2")))
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
                             )
                            
                             
            ),
           
          )
        )
      ),
     
      tabItem("FAQ",
              box( width=12, status="primary",solidHeader = T,
                   title="Frequently Asked Questions",
                   h4("Q: How to get help? "), 
                   p(HTML('<b>A: Soon we will have a google user group to post questions and answers for users of the app.</b>')),
                   h4("Q: Webinar Links: "),  
                   p(HTML('WI Fast Plants webinar: <a href="https://fastplants.org/2020/08/06/new-fast-plants-polycots-selection/" target="_blank"><i>Strategies for adapting WI Fast Plants selection of traits investigations for remote and social distance learning</i></a>.')),
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






