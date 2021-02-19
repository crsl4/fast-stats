test_that("test chi sqaure", {
  app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
  app$setInputs(name = "Hadley")
  expect_equal(app$getValue("greeting"), "Hi Hadley")
  
  app$click("reset")
  expect_equal(app$getValue("greeting"), "")
})