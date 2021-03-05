# How to add a new web-app to WI Fast Stats

If you are interested to add a new web-app to WI Fast Stats, these are some steps that you can follow. Make sure to always work on `development` branch of your fork.

1. You can copy the existing folder from one of the web apps e.g. `webinar-aug20`. You can choose the web-app that has some of the features that you need

2. You need to change the `ui.R` which is what the users see and `server.R` which is the internal code that runs the plots and data analyses  [we need more details here about what each part means]

3. If you want to change the color of the web-app, you do that in `ui.R` in line 6 and also in line 63: the variable `status` specifies the color of the web-app. For example, `status="danger"` is a red color

4. If you want to change the description on the About page, you do this in `ui.R`, lines 66-70

missing steps to include:
- how to add to the website
- how to deploy a specific web-app (I think that this needs to be done by WID people)
- how to add a DOCS section