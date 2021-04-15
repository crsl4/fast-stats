library(data.table)
library(ggplot2)
library(car)
library(plotly)
library(pracma)
library(graphics)
library(ggplotify)
library(thatssorandom)
library(rsconnect)
library(viridis)
library(RColorBrewer)
library(dplyr)
# library(shinyjs)
# Define server logic to read selected file ----
# global variable
options(shiny.maxRequestSize=10*1024^2)
toy<-read.csv("2016-brassica-new.csv",
              header = T,
              sep = ",")
# toy<-subset(toy, experiment==v54$sec1)
server <- function(input, output,session) {
  # #################################### 
  dsnames<-c() #a vector to store col names
  
  data_set <- reactive({
    if(is.null(input$file1)) return(NULL)
   
    req(input$file1)
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
  output$fileUploaded <- reactive({
    return(!is.null(data_set()))
  })
  outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)
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
                         label = "Group Variable",
                         choices = cb_options,
                         selected = "")
      updateRadioButtons(session, "gv2",
                         label = "Quantity Variable",
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
      updateRadioButtons(session, "section",
                         label = "Choose which column of data to filter",
                         choices = cb_options,
                         selected = "")
    }else{
      updateRadioButtons(session, "xaxisGrp",
                         label = "Group Variable",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "yaxisGrp",
                         label = "Quantity",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "groupVar",
                         label = "Group Variable",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "quantity",
                         label = "Quantity",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gv1",
                         label = "Group Variable",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gv2",
                         label = "Quantity",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gvBox",
                         label = "Group Variable 1",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "qBox",
                         label = "Group Variable 2",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gvMosaic1",
                         label = "Group Variable 1",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gvMosaic2",
                         label = "Group Variable 2",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gvScatter",
                         label = "Group Variable",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "qScatter",
                         label = "Quantity",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "gvDensities",
                         label = "Group Variable",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "qDensities",
                         label = "Quantity",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length"),
                         selected = "")
      updateRadioButtons(session, "section",
                         label = "Choose which column of data to filter",
                         choices = c("Plant"="Plant","Treatment"="Treatment","Root_length_mm"="Root_length_mm","Shoot_length_mm"="Shoot_length_mm","Root_to_Shoot_ratio"="Root_to_Shoot_ratio","Total_length"="Total_length","Experiment"="Experiment"),
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    validate(not_empty(df))
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
  v53<-reactiveValues(section=0)
  observeEvent(input$section,{
    v53$section<-input$section
  })
  v54 <- reactiveValues(sec1 =0)
  observeEvent(input$sec1, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v54$sec1<- input$sec1
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
  
  not_empty<-function(df){
    if(is.null(df))
      showNotification("Please upload a data file first!",duration=3,type = "error")
    
    
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
  
  output$summary <- renderPrint({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
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
    # choice<-v54$sec1
    # colName<-v53$section
    # df1<-subset(df, colName==choice)
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  output$violinPlot <- renderPlotly({
    
    # there must be a way not to repeat the same lines to get df
    
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
    req(df)
    if (v$doViolinPlot == FALSE) return()
    # fill should contain x var
    
    validate(
      not_categorical(df,v5$xv)
    )
    validate(
      not_quantity(df,v6$yv)
    )
    
    x_val<-unlist(subset(df, select=c(v5$xv)))
    y_val<-unlist(subset(df, select=c(v6$yv)))
    
    # options(repr.plot.width=v14$doWidthVal, repr.plot.height=v15$doHeightVal)
    plot<-ggplot(df, aes(x=x_val, y=y_val, fill=x_val))+geom_violin(alpha=v41$transViolin/100)+xlab(v5$xv)+ylab(v6$yv)+labs(fill=v5$xv)+ggtitle("Violin Plot")+
      ylim(c(1,6))+
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
    
    # there must be a way not to repeat the same lines to get df
    
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
    req(df)
    if (v27$doMosaic == FALSE) return()
    # fill should contain x var
    
    # print(df)
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
    
    
    ggplotly(plot,tooltip = c("x", "y"))%>% config(displaylogo = FALSE,displayModeBar = T)
  
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
    req(df)
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
    req(df)
    if (v9$doScatter == FALSE) return()
    
    validate(
      not_categorical(df,v29$gvScatter)
    )
    validate(
      # print(class(df[[v24$qBox]])),
      not_quantity(df,v30$qScatter)
    )
    
    
    x_val<-unlist(subset(df, select=c(v29$gvScatter)))
    # notice that v5$xv here is character, not col obj; but ggplot needs to accept col obj
    # use subset func to extract col object from dataframe; other func, such as df[...], seems not work at all
    # ggplot2 does not accept list object; must use unlist
    y_val<-unlist(subset(df, select=c(v30$qScatter)))
    
    
    p<-ggplot(df, aes(y = y_val, x = x_val, fill = x_val)) +
      xlab(v29$gvScatter)+labs(fill=v29$gvScatter)+ylab(v30$qScatter)+
      geom_jitter(pch = v34$pointShapeScatter, alpha=v33$transScatter/100, width=0.2,size=v35$pointSizeScatter)+
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
    group_list=unlist(subset(df,select=c(v29$gvScatter)))
    colorCount = length(unique(unlist(group_list,use.names=F)))   #8, an arbitrary number
    getPalette <- colorRampPalette(brewer.pal(8, v36$colorScatter),bias=2.5)(colorCount)
    # FIXME LATER:
    # bias value needs to be tested to get the best level change within color palette
    p<-p+scale_fill_manual(values= getPalette)
   
    
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
    req(df)
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
    req(df)
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
    
    ggplotly(p,tooltip = c("x", "y"))%>% config(displaylogo = FALSE,displayModeBar = T)
    
  })
  
  output$sel1<-renderUI({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    # if (v7$gv == "") return()
    if(v7$gv=="UnSpecified_Value") return()
    
    group_list<-unlist(subset(df, select=c(v7$gv)))
    
    selectInput("group1","Group one:",choices=as.character(unique(unlist(group_list,use.names = F))))
    # dont know why cant I put two select input in one uioutput method
  })
  
  output$sel2<-renderUI({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    # if (v7$gv == "") return()
    if(v7$gv=="UnSpecified_Value") return()
    
    group_list<-unlist(subset(df, select=c(v7$gv)))
    
    # dont know why cant I put two select input in one uioutput method
    
    selectInput("group2","Group two:",choices=as.character(unique(unlist(group_list,use.names = F))))
    
  })
  
  output$sec1<-renderUI({
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    
    # if (v7$gv == "") return()
    if(v53$section=="UnSpecified_Value") return()
    
    group_list<-unlist(subset(df, select=c(v53$section)))
    
    selectInput("group1","Category Selected:",choices=as.character(unique(unlist(group_list,use.names = F))))
    # dont know why cant I put two select input in one uioutput method
    # v54$sec1
    # df= subset(df, select==v54$sec1 )
  })
  
  output$goMosaic<-renderUI({
    
    if(input$fileType=="sampleFile")
    {
      df<- toy
    }
    else
    {
      df<-data_set()
    }
    # req(df)
    fluidRow(
      column(6, align="center", offset = 3,
             actionButton("goMosaic", "Mosaic Plot"),
             tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
      )
    )
  })
  # outputOptions(output, 'goMosaic')
  
  
  # summarise acutally
  output$ttest <- renderPrint({
    
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
    req(df)
    if (v4$doT == FALSE) return()
    # check to see if group variable is categorical
    validate(
      not_categorical(df,v7$gv)
    )
    validate(
      not_quantity(df,v8$q)
    )
    
    group_var<-unlist(subset(df, select=c(v7$gv)))
    q_var<-unlist(subset(df, select=c(v8$q)))
    Group_Variable<-as.factor(group_var)
    
    
    df%>%
    group_by(df[v7$gv]) %>%
      summarise(
        count = n(),
        across(starts_with(v8$q), list(mean=mean,sd=sd)),
        # mean = mean(q_var, na.rm = TRUE),
        # sd = sd(q_var, na.rm = TRUE)
      )
    
    
    # , in the end omits default val set to be True
    # # important
    # x = subset(df, select=c(v8$q))[group_val == v14$sel1,]
    # y = subset(df, select=c(v8$q))[group_val == v15$sel2,]
    # check if two group variables are equal
    # if(v16$doEqualVar==T){
    #   t.test(x,y,var.equal = T)
    # }
    # else{
    #   t.test(x,y)
    # }
    
  })
  
  
  output$anovatest<-renderPrint({
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
    req(df)   #really helpful for avoid printing null when file is null
    if (v22$doChi == FALSE) return()
    
      not_categorical(df,v20$gv1)
      
    
    # this we assume that gv2 is quantity
    validate(
      not_quantity(df,v21$gv2)
    )
    
    # check if two group variables are equal
    validate(
      not_equalGV(v20$gv1,v21$gv2)
    )
    # print(v20$gv1)
    
    group_variable1<-unlist(subset(df, select=c(v20$gv1)))
    q_variable2<-unlist(subset(df, select=c(v21$gv2)))
    # print(v22$doChi)
    # print(class(subset(df, select=c(v20$gv1))))
    # sub=unique(unlist(group_variable1,use.names = F))
    # print(class(q_variable2))
    # print(group_variable1)
    Quantity<-q_variable2 
    Group_Variable<-as.factor(group_variable1)
    cat(sprintf('Quantity is %s \n',v20$gv1))
    cat(sprintf('Group_Variable is %s \n', v21$gv2))
    lm.model <- lm( Quantity~ Group_Variable, data = df)
    summary(lm.model)
    # print(aov.model$coefficients)
    
    
    # # dt <- table(group_variable1, q_variable2)
    # # ct<-chisq.test(dt)
    # cat("Observed values:\n")
    # print(ct$observed)
    # cat("\n\n\nExpected values:\n")
    # print(ct$expected)
    # cat("\n\n")
    # chisq.test(dt)
    # the test result cannot be assigned to a variable, otherwise it might get some unexpected errors
  })
  
  # output$down <- downloadHandler(
  #   filename =  function() {
  #     paste("iris", input$downloadOptions, sep=".")
  #   },
  #   # content is a function with argument file. content writes the plot to the device
  #   content = function(file) {
  #     if(input$downloadOptions == "png")
  #       png(file) # open the png device
  #     else if (input$downloadOptions=="pdf")
  #       pdf(file) # open the pdf device
  #     else
  #       jpeg(file)
  #     plot(x=x(), y=y(), main = "iris dataset plot", xlab = xl(), ylab = yl()) # draw the plot
  #     dev.off()  # turn the device off
  #     
  #   } 
  # )
  
  
  # if users wanna change the parameter (say change dots), we can first set a var as p<-ggplot(...). Then use if statement to test user's response, add it piece by piece, and finally return p
}
