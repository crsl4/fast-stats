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
library(shiny)
library(plotly)
library(shinydashboard)
# library(shinyjs)
library(testthat)


# server <- function(input, output, session) {
#   x <- reactive(input$a * input$b)
# }

test_that("test_reactive", {
  testServer(server, {
    session$setInputs(goViolin=FALSE)
    expect_equal(output$doViolinPlot,FALSE)
  })
})