

# Overview
WI Fast Stats is an integrated animated web page which serves as a medium to a collection of R-developed web apps that provide Data Visualization and Data Analysis tools for WI Fast Plants data, built by ggplot2, Plotly, and Graphics libraries. 
WI Fast Stats also serves as a user-friendly easy-to-use interface that will render Data Science accessible to K-16 teachers and students without strong programming or mathematical background. The app is simple to use, well documented, and freely available. It is the first and only dedicated tool tailored at WI Fast Plants data and educational objectives. 
# Getting Started
The WI Fast Stats web app can be found at https://my-data-analysis-work.shinyapps.io/webinar-cotyledon/.
* a temporary link
# Running Locally

The easiest way to use Wi Fast Stats is via the web app linked above. But you can also run it locally if you wish.

## Downloading Code

The first step is to download the code. You can do this with Git:

```git clone https://github.com/crsl4/fast-stats.git```

or download and extract a compressed .zip file of the latest revision of the repository from https://github.com/crsl4/fast-stats/archive/master.zip.
## Prerequisites

WI Fast Stats uses a number of packages. You can use the following code in R to install any you don't already have:

```
list.of.packages <- c(
  "shiny", 
  "shinydashboard", 
  "shinyjs", 
  "plotly", 
  "data.table", 
  "ggplot2", 
  "RColorBrewer", 
  "car", 
  "pracma", 
  "ggplotify", 
  "thatssorandom", 
  "rsconnect")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages)
```
## Running the App

From R, run the following command:

```shiny::runApp("/path/to/wi-fast-stats")```

and it should launch the app in your default web browser.


# Source Code
WI Fast Stats is an [open source](http://opensource.org) project, and the source code is available at [https://github.com/crsl4/fast-stats](https://github.com/crsl4/fast-stats)

# Contributions
See details in CONTRIBUTING .md in [this link](https://github.com/crsl4/fast-stats)
* shall add the link for .md file later

# License
WI Fast Stats is licensed under the [MIT](https://opensource.org/licenses/MIT) licence. &copy; Claudia Solis-Lemus (2020)