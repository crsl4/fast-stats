# WI Fast Stats Documentation

WI Fast Stats is an animated website which serves as a medium to a collection of R-developed web apps that provide Data Visualization and Data Analysis tools for WI Fast Plants data. 

The main website consists of 6 sections:
* [Home](#home)
* [About](#about)
* [Web Apps](#web-apps)
* [Webinars](#webinars)
* [Source Code](#source-code)
* [FAQ](#faq)

## Home
The Home page is a collection of animation using WI Fast Plants photos.
![Home-web](https://github.com/crsl4/fast-stats/blob/master/figures/home_web.png?raw=true)

## About
The About page shows the general information and features of the web apps.
![about-web](https://github.com/crsl4/fast-stats/blob/master/figures/about_web.png?raw=true)

## Web Apps
The Web Apps page lists all the web apps and their links.
![web-apps-web](https://github.com/crsl4/fast-stats/blob/master/figures/webapps_web.png?raw=true)

## Webinars
The Webinars page displays a timeline for all the WI Fast Plant webinars held so far. Each corresponding to a web app listed [above](#web-apps). More webinars will happen in the future and they will be added accordingly alongside their corresponding web app.
![webinars](https://github.com/crsl4/fast-stats/blob/master/figures/timeline.png?raw=true)

## Source Code
The Source Code page presents the link to the Github repository.
![source-code](https://github.com/crsl4/fast-stats/blob/master/figures/sourcecode_web.png?raw=true)

## FAQ
As intended, the FAQ section contains questions and answers related to web apps and webinars. 

![faq-web](https://github.com/crsl4/fast-stats/blob/master/figures/faq_web.png?raw=true)

# Web Apps Documentation

Launching the app brings up the Home tab. The Home tab is basically a landing page that gives a brief introduction to the app and includes relevant information for the corresponding webinars. The following figure shows the basic Home tab.

The web app consists of four main tabs:
* [Data Upload](#data-upload)
* [Data Visualization](#data-visualization)
* [Data Analysis](#data-analysis)
* [FAQ](#faq2)

![Home](https://github.com/crsl4/fast-stats/blob/master/figures/home.png?raw=true) 

## Data Upload

Click Data Upload in the sidepanel to upload a data file. The dataset should be in csv format and it will be uploaded using the Data Upload box. Data should be numeric or factored and should not contain any NULL/NaN/NA values. The file should be no larger than 10MB.

WI Fast Stats web app comes with a sample dataset and in the example below, we will use the "Sample dataset".

![Structure](https://github.com/crsl4/fast-stats/blob/master/figures/upload_file.png?raw=true)


## Data Visualization
Select Data Visualization in the sidepanel in order to visualize the dataset. 

Choose a graph from the Plot Type selector, which contains 5 types of plots for the cotelydon web app (plot options could vary depending on the web app):
* Mosaic Plot
* Violin Plot
* Box Plot 
* Scatter Plot
* Density Plot

Choose the variables you want to compare with in the radio buttons. You must select the variables corresponding to the type specified above, e.g., group variables (factor type) or quantity variables (numeric type); otherwise, the system will throw a warning message, indicating that the variable that you have selected is invalid. 

There are also four interactive functions that provide flexibility to the plot:
* Color
* Point Shape
* Transparency
* Point Size

We provide up to 10 color palettes, 7 kinds of point shape, transparency scalar, and point size scalar in this application. The default settings are: Blue+Purple color palettes, circle point shape, 65% transparency, and point size 1. Try to use different combinations and parameters to visualize the outputs!

After everything is set, click on the button below and the plot will automatically be displayed in the Plot Display box. On the top right corner of the plot, there is a line of tools provided by [Plotly](https://plotly.com/r/) which allow users to download the plot as .png format, zoom in/out the plot, perform Lasso Select, and use compare tooltip to fully interact with the plots.

![Parameters](https://github.com/crsl4/fast-stats/blob/master/figures/boxplot.png?raw=true)



## Data Analysis
We provide 2 statistical tests in this section, namely:
* Chi-Square Test
* T-Test

Compared with the Data Visualization module, Data Analysis is straightforward: all you need to do is to select the type of test and the corresponding variables for the test. The test result will be automatically displayed in the Results Displayed box.

The Data Analysis section also depends on the specific web app. For example, the ecosystem web app does not have a Data Analysis tab because this webinar is aimed at middle school students who have not studied statistical tests yet.

![Tests](https://github.com/crsl4/fast-stats/blob/master/figures/ttest.png?raw=true)



## FAQ {##faq2}
Finally, click FAQ in the sidepanel to see more related information about this app and the webinars. 

![faq](https://github.com/crsl4/fast-stats/blob/master/figures/faq.png?raw=true)


# Feedback, issues and questions

- Join the [Google user group](https://groups.google.com/g/wi-fast-stats/) for general questions about the WI Fast Stats website and web apps
- Issues reports are encouraged through the [GitHub issue tracker](https://github.com/crsl4/fast-stats/issues)
- Feedback is always welcome via the following [google form](https://docs.google.com/forms/d/e/1FAIpQLSdhpEMMHht3oN6XKwp7oHuCRYLLFgixtZ6z_1a0IC7CXLXPdA/viewform)

