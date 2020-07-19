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
  
  
  # output$contents <- renderTable({
  #   data_set()
  # })
  observe({
    dsnames <- names(data_set())
    cb_options <- list()
    cb_options[ dsnames] <- dsnames
    updateRadioButtons(session, "xaxisGrp",
                       label = "Group Variable",
                       choices = cb_options,
                       selected = "")
    updateRadioButtons(session, "yaxisGrp",
                       label = "Quantity",
                       choices = cb_options,
                       selected = "")
    updateRadioButtons(session, "groupVar",
                       label = "Group Variable",
                       choices = cb_options,
                       selected = "")
    updateRadioButtons(session, "quantity",
                       label = "Quantity",
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
  
  v7<-reactiveValues(gv=0)
  observeEvent(input$groupVar,{
    v7$gv<-input$groupVar
  })
  
  v8<-reactiveValues(q=0)
  observeEvent(input$quantity,{
    v8$q<-input$quantity
  })
  
  v9 <- reactiveValues(doScatter = FALSE)
  observeEvent(input$goScatter, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v9$doScatter <- input$goScatter
  })
  
  v10 <- reactiveValues(doBox = FALSE)
  observeEvent(input$goBox, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v10$doBox <- input$goBox
  })
  
  v11 <- reactiveValues(doDensities = FALSE)
  observeEvent(input$goDensities, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v11$doDensities <- input$goDensities
  })
  
  v12 <- reactiveValues(doAddPoints =T)
  observeEvent(input$addPoints, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v12$doAddPoints<- input$addPoints
  })
  
  v13 <- reactiveValues(doAdjustSize =F)
  observeEvent(input$adjustSize, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v13$doAdjustSize<- input$adjustSize
  })
  
  # v14 <- reactiveValues(doWidthVal =700)
  # observeEvent(input$widthVal, {
  #   # 0 will be coerced to FALSE
  #   # 1+ will be coerced to TRUE
  #   v14$doWidthVal<- input$widthVal
  # })
  # 
  # v15 <- reactiveValues(doHeightVal =550)
  # observeEvent(input$heightVal, {
  #   # 0 will be coerced to FALSE
  #   # 1+ will be coerced to TRUE
  #   v15$doHeightVal<- input$heightVal
  # })
  
  
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
    
    if (v4$doT == FALSE) return()
    
    # extract var as col obj
    # print(v7$gv)
    
    group_val<-unlist(subset(df, select=c(v7$gv)))
    
    quantity<-unlist(subset(df, select=c(v8$q)))
    
    dat2 = within(df, group <- "(2+)x(2+)")
    # #############################################
    dat2$group[subset(dat2, select=c(v7$gv)) == ""] = "parent"
    dat2$group[subset(dat2, select=c(v7$gv)) == "2x2"] = "2x2"
    dat2$group[subset(dat2, select=c(v7$gv)) == "2x3"] = "2x(2+)"
    dat2$group[subset(dat2, select=c(v7$gv)) == "2x4"] = "2x(2+)"
    # i guess the other group besides the above 4 types is (2+)x(2+)
    dat2$group = factor(dat2$group,levels=c("parent", "2x2", "2x(2+)", "(2+)x(2+)"))
    print(subset(dat2, select=c(v8$q)))
    # dat3 = subset(dat2,group %in% c("2x2","(2+)x(2+)"))
    # dat3$group = factor(dat3$group)
    
    x = subset(dat2, select=c(v8$q))[dat2$group == "2x2",]
    y = subset(dat2, select=c(v8$q))[dat2$group == "(2+)x(2+)",]
    # , in the end omits default val set to be True
    # important
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
    
    v4 <- reactiveValues(doT = FALSE)
    
    
    observeEvent(input$goT, {
      # 0 will be coerced to FALSE
      # 1+ will be coerced to TRUE
      v4$doT <- input$goT
    })
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    # options(repr.plot.width=v14$doWidthVal, repr.plot.height=v15$doHeightVal)
    plot<-ggplot(df, aes(x=x_val, y=y_val, fill=x_val))+geom_violin(alpha=0.5)+xlab(v5$xv)+ylab(v6$yv)+labs(fill=v5$xv)+
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
    if(v12$doAddPoints==T){
      plot<-plot+geom_point(pch = 21, alpha=0.3, position = position_jitterdodge(jitter.height=0.05, jitter.width=2.5))
    }
    return (plot)
  },,width=exprToFunction(input$widthVal),height=exprToFunction(input$heightVal))
  
  # histogram should be the base template
  # all other plots should follow its styles
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
    
    
  },,width=exprToFunction(input$widthVal),height=exprToFunction(input$heightVal))
  
  output$scatterPlot<-renderPlot({
    # FIXME:we want to read the input file only once per session
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
    
    if (v9$doScatter == FALSE) return()
    
    # print(subset(df, select=c(v5$xv)))
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    # y_val<-df[,v6$yv]
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    
    ggplot(df, aes(y = y_val, x = x_val, fill = y_val)) +
      xlab(v5$xv)+labs(fill=v5$xv)+ylab(v6$yv)+
      geom_jitter(pch = 21, alpha=0.3, width=0.2)+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
      ) 
    
    
    
  },width=exprToFunction(input$widthVal),height=exprToFunction(input$heightVal))
  
  output$boxPlot <- renderPlot({
    
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
    
    if (v10$doBox == FALSE) return()
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    plot<-ggplot(df, aes(x = x_val, y = y_val, fill = x_val)) +
      xlab(v5$xv)+labs(fill=v5$xv)+ylab(v6$yv)+
      geom_boxplot(outlier.size = 0, alpha=0.1) +
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
      )
    
    if(v12$doAddPoints==T){
      plot<-  plot+geom_jitter(pch = 21, alpha=0.3, height=0.2)
    }
    
    return (plot)# object returned here must has a parenthesis
  },,width=exprToFunction(input$widthVal),height=exprToFunction(input$heightVal))
  
  output$densities<- renderPlot({
    
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
    
    if (v11$doDensities == FALSE) return()
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    ggplot(df, aes(y_val, fill=x_val))+geom_density(alpha=0.25)+
      xlab(v6$yv)+labs(fill=v5$xv)+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
      )
    
    
  },,width=exprToFunction(input$widthVal),height=exprToFunction(input$heightVal))
  
  # if users wanna change the parameter (say change dots), we can first set a var as p<-ggplot(...). Then use if statement to test user's response, add it piece by piece, and finally return p
}

# # Create Shiny app ----
# shinyApp(ui, server)

