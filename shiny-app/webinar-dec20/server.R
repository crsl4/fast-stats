library(data.table)
library(ggplot2)
library(car)
library(plotly)
library(pracma)
library(graphics)
library(ggplotify)
library(thatssorandom)
library(rsconnect)
library(RColorBrewer)
options(shiny.maxRequestSize=10*1024^2)
# global variable
toy<-read.csv("ecosystem-data.csv",
             header = T,
             sep = ",")

# Define server logic to read selected file ----
server <- function(input, output,session) {
  # #################################### 
  dsnames<-c() #a vector to store col names
  
  data_set <- reactive({
    if(is.null(input$file1)) return(NULL)
    req(input$file1)
    inFile <- input$file1
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
    
    
  })
  observe({
    if(input$fileType=="uploadFile"){
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
      updateRadioButtons(session, "gv1",
                         label = "Group Variable 1",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gv2",
                         label = "Group Variable 2",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gvBox",
                         label = "Group Variable",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "qBox",
                         label = "Quantity",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gvMosaic1",
                         label = "Group Variable 1",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gvMosaic2",
                         label = "Group Variable 2",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gvScatter",
                         label = "Group Variable",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "qScatter",
                         label = "Quantity",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gvDensities",
                         label = "Group Variable",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "qDensities",
                         label = "Quantity",
                         choices = cb_options,
                         selected = "")
    }else{
      updateRadioButtons(session, "xaxisGrp",
                         label = "Group Variable",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "yaxisGrp",
                         label = "Quantity",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "groupVar",
                         label = "Group Variable",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "quantity",
                         label = "Quantity",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gv1",
                         label = "Group Variable 1",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gv2",
                         label = "Group Variable 2",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gvBox",
                         label = "Group Variable",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "qBox",
                         label = "Quantity",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gvMosaic1",
                         label = "Group Variable 1",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gvMosaic2",
                         label = "Group Variable 2",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gvScatter",
                         label = "Quantity 1",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "qScatter",
                         label = "Quantity 2",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "gvDensities",
                         label = "Group Variable",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
      updateRadioButtons(session, "qDensities",
                         label = "Quantity",
                         choices = c("Osmocote"="Osmocote","PlantID"="PlantID","Height"="Height","CotWidth"="CotWidth","Hairs"="Hairs","Flowers"="Flowers", "Bracts"="Bracts","Branches"="Branches","Pods"="Pods"),
                         selected = "")
    }
    
  })
  #####################testing
  # observeEvent(input$fileType=="sampleFile", updateRadioButtons(session, "gv1",
  #                                                      label = "Group Variable 1",
  #                                                      choices = c("xxxx"="x"),
  #                                                      selected = ""))
  
  output$choose_dataset <- renderUI({
    selectInput("dataset", "Data set", as.list(data_sets))
  })
  ####################################
  v<-reactiveValues(doViolinPlot=FALSE)
  observeEvent(input$goViolin, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
    v9$doScatter <- input$goScatter
  })
  
  v10 <- reactiveValues(doBox = FALSE)
  observeEvent(input$goBox, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
  
  v14 <- reactiveValues(sel1 =0)
  observeEvent(input$group1, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v14$sel1<- input$group1
  })
  
  v15 <- reactiveValues(sel2 =0)
  observeEvent(input$group2, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v15$sel2<- input$group2
  })
  
  v16 <- reactiveValues(doEqualVar=F)
  observeEvent(input$isEqualVar, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v16$doEqualVar<- input$isEqualVar
  })
  
  v17 <- reactiveValues(doLevene = FALSE)
  observeEvent(input$goLevene, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v17$doLevene <- input$goLevene
  })
  
  v18 <- reactiveValues(doFligner = FALSE)
  observeEvent(input$goFligner, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v18$doFligner <- input$goFligner
  })
  
  v19 <- reactiveValues(doWilcoxon = FALSE)
  observeEvent(input$goWilcoxon, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v19$doWilcoxon <- input$goWilcoxon
  })
  v20<-reactiveValues(gv1=0)
  observeEvent(input$gv1,{
    v20$gv1<-input$gv1
  })
  v21<-reactiveValues(gv2=0)
  observeEvent(input$gv2,{
    v21$gv2<-input$gv2
  })
  v22 <- reactiveValues(doChi = FALSE)
  observeEvent(input$goChi, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v22$doChi <- input$goChi
  })
  v23<-reactiveValues(gvBox=0)
  observeEvent(input$gvBox,{
    v23$gvBox<-input$gvBox
  })
  v24<-reactiveValues(qBox=0)
  observeEvent(input$qBox,{
    v24$qBox<-input$qBox
  })
  v25<-reactiveValues(gvMosaic1=0)
  observeEvent(input$gvMosaic1,{
    v25$gvMosaic1<-input$gvMosaic1
  })
  v26<-reactiveValues(gvMosaic2=0)
  observeEvent(input$gvMosaic2,{
    v26$gvMosaic2<-input$gvMosaic2
  })
  v27 <- reactiveValues(doMosaic = FALSE)
  observeEvent(input$goMosaic, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v27$doMosaic <- input$goMosaic
  })
  v28 <- reactiveValues(doAddPoints2 =T)
  observeEvent(input$addPoints2, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v28$doAddPoints2<- input$addPoints2
  })
  v29<-reactiveValues(gvScatter=0)
  observeEvent(input$gvScatter,{
    v29$gvScatter<-input$gvScatter
  })
  v30<-reactiveValues(qScatter=0)
  observeEvent(input$qScatter,{
    v30$qScatter<-input$qScatter
  })
  v31<-reactiveValues(gvDensities=0)
  observeEvent(input$gvDensities,{
    v31$gvDensities<-input$gvDensities
  })
  v32<-reactiveValues(qDensities=0)
  observeEvent(input$qDensities,{
    v32$qDensities<-input$qDensities
  })
  v33<-reactiveValues(transScatter=0)
  observeEvent(input$transScatter,{
    v33$transScatter<-input$transScatter
  })
  v34<-reactiveValues(pointShapeScatter=0)
  observeEvent(input$pointShapeScatter,{
    v34$pointShapeScatter<-input$pointShapeScatter
  })
  v35<-reactiveValues(pointSizeScatter=0)
  observeEvent(input$pointSizeScatter,{
    v35$pointSizeScatter<-input$pointSizeScatter
  })
  v36<-reactiveValues(colorScatter=0)
  observeEvent(input$colorScatter,{
    v36$colorScatter<-input$colorScatter
  })
  ##
  v37<-reactiveValues(transMosaic=0)
  observeEvent(input$transMosaic,{
    v37$transMosaic<-input$transMosaic
  })
  v38<-reactiveValues(pointShapeMosaic=0)
  observeEvent(input$pointShapeMosaic,{
    v38$pointShapeMosaic<-input$pointShapeMosaic
  })
  v39<-reactiveValues(pointSizeMosaic=0)
  observeEvent(input$pointSizeScatter,{
    v39$pointSizeMosaic<-input$pointSizeMosaic
  })
  v40<-reactiveValues(colorMosaic=0)
  observeEvent(input$colorMosaic,{
    v40$colorMosaic<-input$colorMosaic
  })
  ##
  v41<-reactiveValues(transViolin=0)
  observeEvent(input$transViolin,{
    v41$transViolin<-input$transViolin
  })
  v42<-reactiveValues(pointShapeViolin=0)
  observeEvent(input$pointShapeViolin,{
    v42$pointShapeViolin<-input$pointShapeViolin
  })
  v43<-reactiveValues(pointSizeViolin=0)
  observeEvent(input$pointSizeViolin,{
    v43$pointSizeViolin<-input$pointSizeViolin
  })
  v44<-reactiveValues(colorViolin=0)
  observeEvent(input$colorViolin,{
    v44$colorViolin<-input$colorViolin
  })
  ##box
  v45<-reactiveValues(transBox=0)
  observeEvent(input$transBox,{
    v45$transBox<-input$transBox
  })
  v46<-reactiveValues(pointShapeBox=0)
  observeEvent(input$pointShapeBox,{
    v46$pointShapeBox<-input$pointShapeBox
  })
  v47<-reactiveValues(pointSizeBox=0)
  observeEvent(input$pointSizeBox,{
    v47$pointSizeBox<-input$pointSizeBox
  })
  v48<-reactiveValues(colorBox=0)
  observeEvent(input$colorBox,{
    v48$colorBox<-input$colorBox
  })
  ##densities
  v49<-reactiveValues(transDensities=0)
  observeEvent(input$transDensities,{
    v49$transDensities<-input$transDensities
  })
  v50<-reactiveValues(pointShapeDensities=0)
  observeEvent(input$pointShapeDensities,{
    v50$pointShapeDensities<-input$pointShapeDensities
  })
  v51<-reactiveValues(pointSizeDensities=0)
  observeEvent(input$pointSizeDensities,{
    v51$pointSizeDensities<-input$pointSizeDensities
  })
  v52<-reactiveValues(colorDensities=0)
  observeEvent(input$colorDensities,{
    v52$colorDensities<-input$colorDensities
  })
  v53 <- reactiveValues(addRegression =T)
  observeEvent(input$addRegression, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v53$addRegression<- input$addRegression
  })
  
  
  not_equalGV<-function(input1, input2){
    if(strcmp(input1, input2)){
      showNotification("Please select different 'Group Variables'!",duration=3,type = "error")
      # "Please select different grouping variables!"
    }else if(input1=="" || input2=="")
    {
      F
    }else
    {
      NULL
    }
  }
  
  not_equalGV2<-function(input1, input2){
    if(strcmp(input1, input2)){
      showNotification("Please select different group variables for 'Group one' and 'Group two'!",duration=3,type = "error")
      # "Please select different grouping variables!"
    }else if(input1=="" || input2=="")
    {
      F
    }else
    {
      NULL
    }
  }
  
  not_categorical<-function(df, input){
    # check to see the data type of a specific col in data frame
    if(class(df[[input]])=="numeric"||class(df[[input]])=="integer"||class(df[[input]])=="complex"){
      showNotification( "Please select a categorical variable to be the 'Group Variable'!",duration=3,type = "error")
      # "Please select a categorical variable to be the grouping variable!"
    }else if(df==""||input==""){
      F
    }
    else{
      NULL
    }
  }
  
  not_quantity<-function(df, input){
    # check to see the data type of a specific col in data frame
    if(class(df[[input]])!="numeric"&&class(df[[input]])!="integer"&&class(df[[input]])!="complex"){
      showNotification( "Please select a numerical variable to be the 'Quantity'!",duration=3,type = "error")
      # "Please select a numerical variable to be the quantity!"
      
    }else if(df==""||input==""){
      F
    }
    else{
      NULL
    }
  }
  
  not_empty<-function(df){
    if(is.null(df))
      showNotification("Please upload data file first!",duration=3,type = "error")
    
    
  }
  
  output$summary <- renderPrint({
    df<-data_set()
    
    if (v3$doSummary == FALSE) return()
    
    summary(df)
    
  })
  
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    
    if(input$disp == "head") {
      return(head(df))
    }
    else{
      return(df)
    }
    
  })
  
  output$violinPlot <- renderPlotly({
    
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    # req(df)
    if (v$doViolinPlot == FALSE) return()
    # fill should contain x var
    
    validate(
      not_categorical(df,v5$xv)
    )
    validate(
      not_quantity(df,v6$yv)
    )
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    # print(x_val,"xxxx",class(df[[v5$xv]]))
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    # options(repr.plot.width=v14$doWidthVal, repr.plot.height=v15$doHeightVal)
    # notes about limit: if the data is too large,i.e. extends limit, then we should not include ylim or xlim or it will throw weird "non-inf" error
    plot<-ggplot(df, aes(x=x_val, y=y_val, fill=x_val))+geom_violin(alpha=v41$transViolin/100)+xlab(v5$xv)+ylab(v6$yv)+labs(fill=v5$xv)+ggtitle("Violin Plot")+ 
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        text=element_text(size=8),
        axis.line = element_line(colour = "grey")##,
      )
    if(v12$doAddPoints==T){
      plot<-plot+geom_point(pch = v42$pointShapeViolin, alpha=v41$transViolin/100, position = position_jitterdodge(jitter.height=0.05, jitter.width=2.5),size=v43$pointSizeViolin)
    }
    group_list<-unlist(subset(df,select=c(v5$xv)))
    colorCount=length(unique(unlist(group_list,use.names = F)))
    getPalette<-colorRampPalette(brewer.pal(8,v44$colorViolin),bias=2.5)(colorCount)
    plot<-plot+scale_fill_manual(values=getPalette)
   
    ggplotly(plot,tooltip = c("x", "y"))%>% config(displaylogo = FALSE,displayModeBar = T)
  })
  
  output$mosaicPlot <- renderPlotly({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    if (v27$doMosaic == FALSE) return()
    # fill should contain x var
    
    validate(
      not_categorical(df,v25$gvMosaic1)
    )
    validate(
      not_categorical(df,v26$gvMosaic2)
    )
    validate(
      not_equalGV(v25$gvMosaic1,v26$gvMosaic2)
    )
    g_val1<-unlist(subset(df, select=c(v25$gvMosaic1)))
    g_val2<-unlist(subset(df, select=c(v26$gvMosaic2)))
    # dt = table(g_val1,  g_val2)
    # mosaicplot(dt, shade = TRUE, las=2,xlab=v25$gvMosaic1,ylab=v26$gvMosaic2,main="Mosaic Plot")
    plot<-ggmm(df,g_val1, g_val2)
    plot<-plot+xlab(v25$gvMosaic1)+ylab(v26$gvMosaic2)+ggtitle("Mosaic Plot")+labs(fill=v26$gvMosaic2)+ 
      theme(
        plot.title = element_text(hjust = 0.5),
        text=element_text(size=9)
      )
    group_list=unlist(subset(df,select=c(v25$gvMosaic1)))
    colorCount = length(unique(unlist(group_list,use.names=F)))
    group_list=unlist(subset(df,select=c(v26$gvMosaic2)))
    colorCount = max(colorCount,length(unique(unlist(group_list,use.names=F))) )  
    getPalette <- colorRampPalette(brewer.pal(8, v40$colorMosaic),bias=2.5)(colorCount)
    # FIXME LATER:
    # bias value needs to be tested to get the best level change within color palette
    plot<-plot+scale_fill_manual(values= getPalette)
    
    
    ggplotly(plot)
    
    # ################################################
    # something need to note is that ggplotly is not compatiable with geom_mosaic
  })
  
  output$histogram <- renderPlotly({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    if (v2$doHist == FALSE) return()
    
    # print(subset(df, select=c(v5$xv)))
    
    # tryCatch({
    #   x_val<-unlist(subset(df, select=c(v5$xv)))
    # }error=function(e){
    #   stop(safeError(e))
    # })
    x_val<-unlist(subset(df, select=c(v5$xv)))
    
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    # y_val<-df[,v6$yv]
    
    
    p<-ggplot(df, aes(x_val, fill=x_val))+geom_bar(alpha=0.5)+ 
      xlab(v5$xv)+labs(fill=v5$xv)+
      theme(
        plot.titlelib = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"),
        text=element_text(size=8),
      )
    ggplotly(p)
    
  })
  
  output$scatterPlot<-renderPlotly({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    if (v9$doScatter == FALSE) return()
    
    validate(
      not_quantity(df,v29$gvScatter)
    )
    validate(
      not_quantity(df,v30$qScatter)
    )
    
    
    x_val<-unlist(subset(df, select=c(v29$gvScatter)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    y_val<-unlist(subset(df, select=c(v30$qScatter)))
    # x_val_cat=factor(x_val)
    p<-ggplot(df, aes(x = x_val, y = y_val,fill=x_val)) +
      xlab(v29$gvScatter)+labs(fill=v29$gvScatter)+ylab(v30$qScatter)+
      geom_point(aes(colour = x_val), show.legend = FALSE,pch = v34$pointShapeScatter, alpha=v33$transScatter/100, position = position_jitterdodge(jitter.height=0.075, jitter.width=0.1),size=v35$pointSizeScatter)+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"),
        text=element_text(size=9)
      )
    
    #############################################################
    # df[[v29$gvScatter]]<-as.factor( df[[v29$gvScatter]])
    group_list=unlist(subset(df,select=c(as.factor(v29$gvScatter))))
  
    colorCount = length(unique(unlist(group_list,use.names=F)))   #8, an arbitrary number
    
    getPalette <- colorRampPalette(brewer.pal(8, v36$colorScatter),bias=2.5)(colorCount)
    # print(getPalette)

    p<-p+scale_fill_gradient(low=getPalette[1], high=getPalette[length(getPalette)])
    ###########################################################
    if(v53$addRegression==T){
      # add a aes(group="") solve the problem that one variable is a factor (numerical converts to factor)
      p<-p+geom_smooth(method='lm',formula=y~x)
    }
    # p<-scale_color_gradientn(colors=v36$colorScatter)
    ggplotly(p,tooltip = c("x", "y"))%>% config(displaylogo = FALSE,displayModeBar = T)
    
    
  })
  
  output$boxPlot <- renderPlotly({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    if (v10$doBox == FALSE) return()
    # print(v23$gvBox)
    validate(
      not_categorical(df,v23$gvBox)
    )
    validate(
      # print(class(df[[v24$qBox]])),
      not_quantity(df,v24$qBox)
    )
    
    
    x_val<-unlist(subset(df, select=c(v23$gvBox)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    y_val<-unlist(subset(df, select=c(v24$qBox)))
    # print(x_val)
    plot<-ggplot(df, aes(x = x_val, y = y_val, fill = x_val)) +
      xlab(v23$gvBox)+labs(fill=v23$gvBox)+ylab(v24$qBox)+ggtitle("Box Plot")+
      geom_boxplot(outlier.size = 0, alpha=v45$transBox/100) +
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        text=element_text(size=8),
        axis.line = element_line(colour = "grey")##,
      )
    
    if(v28$doAddPoints2==T){
      plot<-  plot+geom_jitter(pch = v46$pointShapeBox, alpha=v45$transBox/100, size=v47$pointSizeBox)
      
    }
    group_list=unlist(subset(df,select=c(v23$gvBox)))
    colorCount = length(unique(unlist(group_list,use.names=F)))   
    getPalette <- colorRampPalette(brewer.pal(8, v48$colorBox),bias=2.5)(colorCount)
    # FIXME LATER:
    # bias value needs to be tested to get the best level change within color palette
    plot<-plot+scale_fill_manual(values= getPalette)
    
    
    # return (plot)# object returned here must has a parenthesis
    ggplotly(plot,tooltip = c("x", "y"))%>% config(displaylogo = FALSE,displayModeBar = T)
  })
  
  output$densities<- renderPlotly({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    if (v11$doDensities == FALSE) return()
    
    validate(
      not_categorical(df,v31$gvDensities)
    )
    validate(
      # print(class(df[[v24$qBox]])),
      not_quantity(df,v32$qDensities)
    )
    
    
    x_val<-unlist(subset(df, select=c(v31$gvDensities)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    # print(x_val)
    y_val<-unlist(subset(df, select=c(v32$qDensities)))
    
    p<-ggplot(df, aes(y_val, fill=x_val))+geom_density(alpha=v49$transDensities/100)+
      xlab(v32$qDensities)+labs(fill=v31$gvDensities)+
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        text=element_text(size=8),
        axis.line = element_line(colour = "grey")##,
      )
    group_list=unlist(subset(df,select=c(v31$gvDensities)))
    colorCount = length(unique(unlist(group_list,use.names=F)))
    getPalette <- colorRampPalette(brewer.pal(8, v52$colorDensities),bias=2.5)(colorCount)
    # FIXME LATER:
    # bias value needs to be tested to get the best level change within color palette
    p<-p+scale_fill_manual(values= getPalette)
    
    ggplotly(p)
    
  })
  
  # output$goViolin<-renderUI({
  #   if(input$fileType=="sampleFile")
  #   {
  #     df<- toy
  #   }
  #   else
  #   {
  #     df<-data_set()
  #   }
  #   req(df)
  #   fluidRow(
  #     column(6, align="center", offset = 3,
  #            actionButton("goViolin", "Violin Plot"),
  #            tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
  #     )
  #   )
  # })
  # 
  # output$goBox<-renderUI({
  #   if(input$fileType=="sampleFile")
  #   {
  #     df<- toy
  #   }
  #   else
  #   {
  #     df<-data_set()
  #   }
  #   req(df)
  #   fluidRow(
  #     column(6, align="center", offset = 3,
  #            actionButton("goBox", "Box Plot"),
  #            tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
  #     )
  #   )
  # })
  # 
  # output$goScatter<-renderUI({
  #   if(input$fileType=="sampleFile")
  #   {
  #     df<- toy
  #   }
  #   else
  #   {
  #     df<-data_set()
  #   }
  #   req(df)
  #   fluidRow(
  #     column(6, align="center", offset = 3,
  #            actionButton("goScatter", "Scatter Plot"),
  #            tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
  #     )
  #   )
  # })
  #  
  
  
  
  
}