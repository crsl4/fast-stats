library(data.table)
library(ggplot2)
# Define server logic to read selected file ----
server <- function(input, output,session) {
  v <- reactiveValues(doViolinPlot = FALSE)
  # #################################### 
  dsnames<-c() #a vector to store col names
    
  data_set <- reactive({
    req(input$file1)
    inFile <- input$file1
    data_set<-read.csv(inFile$datapath, header=input$header, 
                       sep=input$sep)
  })
  

  output$contents <- renderTable({
    data_set()
  })
  observe({
    dsnames <- names(data_set())
    cb_options <- list()
    cb_options[ dsnames] <- dsnames
    updateRadioButtons(session, "xaxisGrp",
                       label = "X-Axis",
                       choices = cb_options,
                       selected = "")
    updateRadioButtons(session, "yaxisGrp",
                             label = "Y-Axis",
                             choices = cb_options,
                             selected = "")
  })
  output$choose_dataset <- renderUI({
    selectInput("dataset", "Data set", as.list(data_sets))
  })
  ####################################
  
  observeEvent(input$goViolin, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doViolinPlot <- input$goViolin
  })
  
  v2 <- reactiveValues(doHist = FALSE)
  # serve as a middleman between input and output, we can see that render func use v2$doHist instead of input$goHist
  # I guess the id val (i'm not sure about id's class) can only be assigned to bool val; surprisingly, it's int val; so that means R can also treat int as bool used in conditional expr (like C; FALSE equals to 0)
  
  observeEvent(input$goHist, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v2$doHist <- input$goHist
    print(class(v2$doHist))
    
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
  
  v5<-reactiveValues(xv=0)
  observeEvent(input$xaxisGrp,{
    v5$xv<-input$xaxisGrp
  })
  v6<-reactiveValues(yv=0)
  observeEvent(input$yaxisGrp,{
    v6$yv<-input$yaxisGrp
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
        # print(safeError(e)), use as debugger
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
    
    req(input$file1) #to require that user upload a file
    
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
    # fill should contain x var
    
    # v4 <- reactiveValues(doT = FALSE)
    # 
    # 
    # observeEvent(input$goT, {
    #   # 0 will be coerced to FALSE
    #   # 1+ will be coerced to TRUE
    #   v4$doT <- input$goT
    # })
   
    x_val<-unlist(subset(df, select=c(v5$xv)))
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    ggplot(df, aes(x=x_val, y=y_val, fill=x_val))+geom_violin(alpha=0.5)+xlab(v5$xv)+ylab(v6$yv)+labs(fill=v5$xv)+
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
    
   # print(subset(df, select=c(v5$xv)))
   
    x_val<-unlist(subset(df, select=c(v5$xv)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    # y_val<-df[,v6$yv]
    
   
      ggplot(df, aes(x_val, fill=x_val))+geom_bar(alpha=0.5)+ 
        xlab(v5$xv)+labs(fill=v5$xv)+
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

# # Create Shiny app ----
# shinyApp(ui, server)

