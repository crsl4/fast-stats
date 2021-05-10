# How to add a new web-app to WI Fast Stats

If you are interested to add a new web-app to WI Fast Stats, these are some steps that you can follow. Make sure to always work on `development` branch of your fork.

1. You can copy the existing folder from one of the web apps e.g. `webinar-aug20`. You can choose the web-app that has some of the features that you need

2. You need to change the `ui.R` which is what the users see and `server.R` which is the internal code that runs the plots and data analyses.
    - Make sure to read the official `R shiny` and `shiny dashboard` documentation before making any changes [add links]

3. If you want to change the color of the web-app, you do that in `ui.R`. For example, in the `webinar-aug20` folder, in line 6 and also in line 63: the variable `status` specifies the color of the web-app. For example, `status="danger"` is a red color

4. If you want to change the description on the About page, you do this in `ui.R`, lines 66-70 in the `webinar-aug20` example

5. Lines 20-28 in the `webinar-aug20` example contain the right-side menus

6. The Data Upload part starts on line 81 in the `webinar-aug20` example 

7. The Data Visualization part starts on line 135 in the `webinar-aug20` 
example

8. The Data Analysis part starts on line 341 in the `webinar-aug20` example

# How to add the web-app to the website

1. First, you need to coordinate with the WID to deploy the web app in order to have a link for the web app

2. Navigate to `Fast-stats/website/index.html` file

3. Open the website in a browser https://wi-fast-stats.wid.wisc.edu/, and click the `WEBAPPS` section on the top menu. Then, right click on the Cotelydon name and choose `Inspect` to see where the code is in the `index.html` and then copy the same block of code for your web app. It will look like the following block of code (which corresponds to the Ecosystem web app):
```
        <div class="col-md-4"> 
		<div class="service_icon icon2  delay-03s animated wow zoomIn"> <span><i class="fa fa-crosshairs"></i></span> </div> 
		<div class="service_block">
            <h3 class="animated fadeInUp wow"><a href="https://wi-fast-stats.wid.wisc.edu/ecosystem/" target="_blank" style="color: white">Ecosystem</a></h3>
            <p class="animated fadeInDown wow"> </p>
          </div>
        </div>
```

4. You also need to add your Webinar information in the WEBINAR section. You have to copy a similar chunk of code to the ones on the existing web apps. For example, for the Ecosystem web app, the chunk of code will look like:
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

# How to add a DOCS section

1. Navigate to `fast-stats/DOCS.md` file

2. You can then modify the content there. Please follow the same structure as the existing DOCS.
