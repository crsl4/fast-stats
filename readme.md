# WI Fast Stats overview
- WI Fast Stats is the first and only dedicated tool tailored at [WI Fast Plants](https://fastplants.org/) data and educational objectives
- WI Fast Stats is an integrated animated web page with a collection of R-developed web apps that provide Data Visualization and Data Analysis tools for [WI Fast Plants](https://fastplants.org/) data
- WI Fast Stats is a user-friendly easy-to-use interface that will render Data Science accessible to K-16 teachers and students currently using [WI Fast Plants](https://fastplants.org/) lesson plans
- Users do not need to have strong programming or mathematical background to use WI Fast Stats 
- The web apps are simple to use, well documented, and freely available!

# Usage

- WI Fast Stats is browser-based, and thus, no installation is needed
- Users simply need to click on any of the following links
  - [WI Fast Stats](https://wi-fast-stats.wid.wisc.edu/): Integrated web page with access to all available web apps
  - Specific web apps: Each web app is tailored at a specific WI Fast Plants dataset and webinar. Currently, we have implemented web apps for the following webinars:
    - [August 2020](https://wi-fast-stats.wid.wisc.edu/cotyledon/): New WI Fast Plants polycot selection data
    - [December 2020](https://wi-fast-stats.wid.wisc.edu/ecosystem/): Hands-on WI Fast Plants study on ecosystem

More details are available in the documentation: [DOCS.md](https://github.com/crsl4/fast-stats/blob/master/DOCS.md)


# Source Code
WI Fast Stats is an [open source](http://opensource.org) project, and the source code is available at in this repository with the following structure:

- `figures`: Folder containing images needed in the `DOCS.md` file
- `ms`: Manuscript describing the website in the [JOSS](https://joss.theoj.org/) format
- `notebooks`: R markdown files with some of the main functions implemented in the web apps
- `shiny-apps`: R code corresponding to the web apps separated by webinar. We followed the structure of standard shiny apps and the main files are `ui.R` and `server.R`
- `slides`: Slides corresponding to the Data Science part of the WI Fast Plants webinars, also accessible through the website and web apps links
- `website`: HTML and CSS code for the main website


### Running the web apps locally

Users with strong programming skills might like to modify the existing R code and run a version of the web apps locally. 

1. The first step is to download the code. You can do this with git:

```git clone https://github.com/crsl4/fast-stats.git```

or download and extract a compressed zip file with the latest revision of the repository from [here](https://github.com/crsl4/fast-stats/archive/master.zip).

2. Make sure you have the dependencies installed. You can use the following command in R to install all the package dependencies:

```r
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
  "viridis",
  "rsconnect")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages)
install.github(“https://github.com/EdwinTh/thatssorandom")
```

3. Within R, you can run the web app with the following command:

```
shiny::runApp("C:/fast-stats/shiny-app/webinar-aug20")
shiny::runApp("C:/fast-stats/shiny-app/webinar-dec20")
shiny::runApp("C:/fast-stats/shiny-app/webinar-bio152")
   
```

# Contributions

Users interested in expanding functionalities in WI Fast Stats are welcome to do so.
See details on how to contribute in [CONTRIBUTING.md](https://github.com/crsl4/fast-stats/blob/master/CONTRIBUTING.md)

# License
WI Fast Stats is licensed under the [MIT](https://opensource.org/licenses/MIT) licence. &copy; Claudia Solis-Lemus (2020)

# Citation
If you use the WI Fast Stats website or web apps in your work, we ask that you cite [the following paper](https://arxiv.org/abs/2012.03290):
```
@misc{liu2020wi,
      title={WI Fast Stats: a collection of web apps for the visualization and analysis of WI Fast Plants data}, 
      author={Yizhou Liu and Claudia Solis-Lemus},
      year={2020},
      eprint={2012.03290},
      archivePrefix={arXiv},
      primaryClass={q-bio.OT}
}
```

# Feedback, issues and questions

- Join the [Google user group](https://groups.google.com/g/wi-fast-stats/) for general questions about the WI Fast Stats website and web apps
- Issues reports are encouraged through the [GitHub issue tracker](https://github.com/crsl4/fast-stats/issues)
- Feedback is always welcome via the following [google form](https://docs.google.com/forms/d/e/1FAIpQLSdhpEMMHht3oN6XKwp7oHuCRYLLFgixtZ6z_1a0IC7CXLXPdA/viewform)


# Previous WI Fast Stats Version

On August 2020, we deployed a preliminary version of the cotelydon web app on `shinyapps.io` for the WI Fast Plants webinar. **This web app is no longer maintained.** Users can find the code for this simple web app in the `simple-app` branch in this repository and the tagged `v1.0` version [here](https://github.com/crsl4/fast-stats/releases/tag/v1.0).
Also, the preliminary web app can be found in this link: [https://wi-fast-stats.shinyapps.io/webinar-aug20/](https://wi-fast-stats.shinyapps.io/webinar-aug20/). Users are warned that this web app is not maintained anymore, and there are data upload errors when data exceeds a certain (unknown) size.