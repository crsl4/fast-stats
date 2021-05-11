# How to add a new web-app to WI Fast Stats

This is an internal document for the [Solis-Lemus lab](https://solislemuslab.github.io/). Outside contributors who would like to create new WI Fast Stats web apps, please contact Claudia Solis-Lemus (contact info in the [website](https://solislemuslab.github.io//pages/people.html)) and make sure to read the [contributing doc](https://github.com/crsl4/fast-stats/blob/master/CONTRIBUTING.md).

For contributors within the Solis-Lemus lab: if you are interested to add a new web-app to WI Fast Stats, these are some steps that you can follow. Make sure to always work on `development` branch of your fork.

1. You can copy the existing folder from one of the web apps e.g. `webinar-aug20` since these folders already have the right structure and web app format. You can choose the web-app that has some of the features that you need (e.g. in terms of Data Visualization or Data Analysis)

2. You need to change the `ui.R` file which is what the users see and `server.R` file which is the internal code that runs the plots and data analyses.
    - Make sure to read the official `R shiny` and `shiny dashboard` documentation before making any changes

3. The `ui.R` file controls what the users see. We refer to [`ui.R` file in the `webinar-aug20` example](https://github.com/crsl4/fast-stats/blob/master/shiny-app/webinar-aug20/ui.R) for the following lines of code:
  - If you want to change the color of the web-app, you do that in `ui.R`. For example, in the `ui.R` file in the `webinar-aug20` folder, in line 6 and also in line 63: the variable `status` specifies the color of the web-app. For example, `status="danger"` is a red color
  - If you want to change the description on the About page, you do this in lines 66-70 in the `webinar-aug20` example
  - To change the the right-side menu, you can check lines 20-28
  - The Data Upload part starts on line 81
  - The Data Visualization part starts on line 135
  - The Data Analysis part starts on line 341

9. The `server.R` file contains the actual code that produces the plots and analyses. We refer to [`server.R` file in the `webinar-aug20` example](https://github.com/crsl4/fast-stats/blob/master/shiny-app/webinar-aug20/server.R) for the following lines of code:
  - Starting on line 42, you have the function to upload a file with a choice between "upload file" or using the sample data already included in the web app
  - All the reactive values correspond to choices made by the user in the left-side menu. For example, in line 260 we have the `doBox` option of whether to do the box plot. This selection (binary=true/false) is stored in the `v10$doBox` variable
  - After the reactive values, we have some checks to throw errors if the data or user selection is not valid. For example, line 509 has the function that checks that the user selects two different group variables. If the user selects the same group variable, an error will be prompted: "Please select different 'Group Variables'!"
  - In line 568, we start the main functions to produce plots or analyses. For example, line 607 has the function to create the violin plot. It checks whether the user had selected the violin plot (`v$doViolinPlot==TRUE`). Line 637 contains the plotting function. Note that this function (that starts on line 607) is a `renderPlotly` function because the rendered plot will be a `Plotly` plot. This `plotly` option should match what appears in the `ui.R` file (lines 144-145): `plotlyOutput("violinPlot")`. Statistical analysis, in contrast, have a `renderPrint` function (see line 989 for the t test)

# How to add the web-app to the website

After you have finished the code for the web-app and are satisfied with its appearance and performance, you can incorporate this to the main website (prior approval from the Solis-Lemus lab).

1. First, you need to coordinate with the WID to deploy the web app in order to have a link for the web app

2. All the code for the main website is in the [`fast-stats/website/index.html` file](https://github.com/crsl4/fast-stats/blob/master/website/index.html)

3. You should include your web app in the `WEBAPPS` section on the top menu. If you search for the word "Ecosystem" in the `index.html` file, you will find a chunk of code as the one below that corresponds to the symbol and the web app name. You need to copy and paste a similar chunk and adapt for your web app:
```
    <div class="col-md-4"> 
		<div class="service_icon icon2  delay-03s animated wow zoomIn"> <span><i class="fa fa-crosshairs"></i></span> </div> 
		<div class="service_block">
            <h3 class="animated fadeInUp wow"><a href="https://wi-fast-stats.wid.wisc.edu/ecosystem/" target="_blank" style="color: white">Ecosystem</a></h3>
            <p class="animated fadeInDown wow"> </p>
          </div>
        </div>
```

4. If the new web app is associated with a webinar, then you also need to add your Webinar information in the `WEBINAR` section. You have to copy a similar chunk of code to the ones on the existing web apps. For example, for the Ecosystem web app, the chunk of code will look like:
```
            <div class="col-sm-6 news-item right">
              <div class="news-content">
                <div class="date">
                  <p>Dec</p> 
                </div>
                <h2 class="news-title">Ecosystem</h2> 
                <span>Hands-on Fast Plants study on Ecosystem</span>
                <p>Teaching Middle-level and Upper-elementary Students Ecosystem Concepts with Hands-on Fast Plants Investigations</p>
                <a class="read-more" href=" https://www.carolina.com/knowledge/2020/10/20/webinar-student-designed-ecosystem-experiments-in-middle-grades" target="_blank">Read More</a>
              </div>
            </div>
```
