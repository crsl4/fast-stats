# Example (Website)
We created an animated website which serves as a medium to a collection of R-developed web apps that provide Data Visualization and Data Analysis tools for WI Fast Plants data. The website consists of 6 sections:
* Home
* About
* Web Apps
* Webinars
* Source Code
* FAQ
## Home
The Home page is a collection of animation using WI Fast Plants pictures.
![Home-web](https://github.com/crsl4/fast-stats/blob/master/figures/home_web.png?raw=true)

## About
This page shows the general information and features for the web apps.
![about-web](https://github.com/crsl4/fast-stats/blob/master/figures/about_web.png?raw=true)

## Web Apps
This page collects all the web apps and their links we have built so far for the WI Fast Plants, maybe more in the future.
![web-apps-web](https://github.com/crsl4/fast-stats/blob/master/figures/webapps_web.png?raw=true)

## Webinars
This page displays a timeline for all the WI Fast Plant webinars held so far. Each corresponding to a web app above. More webinars will happen in the future.
![webinars](https://github.com/crsl4/fast-stats/blob/master/figures/timeline.png?raw=true)

## Source Code
The page presents the Github source code link of the web apps.
![source-code](https://github.com/crsl4/fast-stats/blob/master/figures/sourcecode_web.png?raw=true)

## FAQ
As intended, the FAQ section contains questions and answers related to web apps and webinars. Please share your ideas on Google User Group or Google form. We'd love to hear your feedback!
![faq-web](https://github.com/crsl4/fast-stats/blob/master/figures/faq_web.png?raw=true)

# Example (Web Apps)
## Home
Launching the app brings up the Home tab. The Home tab is basically a landing page that gives a brief introduction to the app and includes relevant information for the corresponding webinars. The following figure shows the basic Home tab.

![Home](https://github.com/crsl4/fast-stats/blob/master/figures/home.png?raw=true) 

WI Fast Plants comes with a sample dataset and this example will use the "Sample dataset", which is the cotyledon dataset.

## Data Upload

Click Data Upload in the sidepanel to begin uploading the file; the data set in csv format using The Data Upload box. Data should be numeric or factored and should not contain any NULL/NaN/NA values. The file should be no larger than 10MB.

![Structure](https://github.com/crsl4/fast-stats/blob/master/figures/upload_file.png?raw=true)

 Again, this example uses the "Sample File", which should already be loaded. 





## Data Visualization
Select the Data Visualization in the sidepanel in order to visualize the data set. The selected parameters are automically displayed in the *Plot Display* box.

Choose a graph from the Plot Type selector, which contains 5 types of plots:
* Mosaic Plot
* Violin Plot
* Box Plot 
* Scatter Plot
* Density Plot

![Parameters](https://github.com/crsl4/fast-stats/blob/master/figures/boxplot.png?raw=true)

Once you upload your file or choose to use the sample file in the Data Upload section, the variables will be automatically displayed in the Data Visualization Box. Choose the variables you want to compare with in the radio buttons. You must select the variables corresponding to the type specified above, e.g., group variables (factor type) or quantity variables (numeric type); otherwise, the system will throw a warning message, indicating that the value you've selected is invalid. 

There are also four interactive functions that increases the flexibility of the graphs:
* Color
* Point Shape
* Transparency
* Point Size

We provide up to 10 color palattes, 7 kinds of point shape, transparency scalar, and point size scalar in this application. The default settings are: Blue+Purple color palattes, point shape, 65% transparency, and point size 1. Try to use different combinations and parameters to visualize the outputs:)

After everything is set, click on the button below and the plot will automatically display in the Plot Display box. On the top right corner of the plot, there is a line of tools provided by [Plotly](https://plotly.com/r/) which you may download the plot as .png format, zoom in/out the plot, perform Lasso Select, and use compare tooltip to fully interact with the plots.
![tools](https://github.com/crsl4/fast-stats/blob/master/figures/tools.png?raw=true)

Notice that you are required to upload a valid file or use the sample file before entering the Data Visualization section. Otherwise there will be no variables shown in the box and clicking the plot button will receive a warning message.

## Data Analysis
We provide 2 tests in this section, namely:
* Chi-Square Test
* T-Test

![Tests](https://github.com/crsl4/fast-stats/blob/master/figures/ttest.png?raw=true)



Compared with the Data Visualization module, Data Analysis is straightforward: all you need to do is to choose two variables as the intended inputs and then click on the button below. Then, the test result will automatically display in the Results Displayed box.

## FAQ
Finally, click FAQ in the sidepanel to see more related information about this app and the webinars. We have also created a Google user group to post questions/answers for WI Fast Plants. 

![faq](https://github.com/crsl4/fast-stats/blob/master/figures/faq.png?raw=true)


Please let us know if there are things you would like to see added (or problems with the app!) by opening up an issue using the GitHub issue tracker at [https://github.com/crsl4/fast-stats/issues](https://github.com/crsl4/fast-stats/issues)
