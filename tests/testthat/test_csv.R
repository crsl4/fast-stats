context("Test CSV")


test_that("testcsv",{
  sample1<-read.csv("testdata/toys.csv",
                   header = T,
                   sep = ",") 
  expect_is(sample1,"data.frame")
  sample2<-read.csv("testdata/2016-brassica.csv",
                   header = T,
                   sep = ",") 
  expect_is(sample2,"data.frame")
})