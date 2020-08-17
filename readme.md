# FastStats
Accompanying data analysis for WI FastPlants (UW-Madison)

To run the shiny app:
1. Open the `app.R` file in RStudio
2. Click `Run app`

# Steps to deploy the simple web app to shinyapps.io

Following [this tutorial](https://docs.rstudio.com/shinyapps.io/index.html):

```r
setwd(/path/to/app)
## the directory that contains ui.R, server.R, and www folder
library(rsconnect)
rsconnect::setAccountInfo(name='wi-fast-stats',
token=’<token key>’,
secret=’<secret key>’)
## command to set up account; this command is only run once
deployApp()
```