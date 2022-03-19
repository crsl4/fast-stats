We thank the reviewers for such helpful comments that have greatly improved the web apps and the manuscript. All of our changes are in the [review branch](https://github.com/crsl4/fast-stats/tree/review) which we will merge to master after approval by the reviewers and editorial team.

# Review 1

Functionality and Documentation:
- We double checked all the steps in the `readme` file to run the web apps locally, and provided more details on how to install `thatssorandom` and how to run the `shiny::runApp` command
- We have added more comments to the code and we have added a new section on the documentation for young audiences interested in coding
- We modified the interface so that only categorical variables appear under "Group variable" and only quantitative variables appear under "quantity"
- For the `webinar-aug20` sample data, we make `plant ID` a group variable. We found that for the other web apps, it did not make sense to change `plant ID` as categorical variable because some plots became not very intepretable, so we decided to keep them as quantitiative variables.

Software paper
- We added the DOI to me Williams and Hill (1986) paper
- We now make reference to the "Data Upload" section in the paper instead of the "Data Summary"

# Review 2

Functionality and Documentation:
- We double checked all the steps in the `readme` file to run the web apps locally, and provided more details on how to install `thatssorandom` and how to run the `shiny::runApp` command
- Unfortunately, the `Warning: guides(<scale> = FALSE) is deprecated. Please use guides(<scale> = "none") instead.` is out of our control as we are not calling `guides` directly in our mosaic function. We wondered whether we should suppress all warnings so that the user is not confused, but decided against this in case there are bugs or package upgrades that we need to address in the future. For now, we simply added a section about warnings in the documentation.
- We modified the interface so that only categorical variables appear under "Group variable" and only quantitative variables appear under "quantity"
- We have also expanded the documentation including more details about the sample dataset and some of the most common errors and warnings
- The slides provided in the repo are the slides used when teaching the WI Fast plants webinars. The plots in the slides were not created using the same sample data in the repo (but data related to the specific webinar). The goal of the slides was to illustrate statistical concepts, rather than testing the web app. This is actually related to another point brought up by the reviewer (the notebooks). It was precisely the goal of the notebooks to be that reproducible script that anyone could run (but as the reviewer mentioned, they were not working properly). We have now updated the notebooks so that they are indeed reproducible so that anyone can run them and get the plots. We have also added a readme file explaining this in the repo. Hope this satisfies the reviewer!


Notebooks folder
- We have double checked the steps to the notebook to make sure they are indeed reproducible and we have included a readme file explaining how the notebooks can be used to reproduce plots and analyses

Software paper
- We have added the DOI to all papers

Editorial
- We fully revised the documentation
- Thanks for checking that the links to the webinars do not work anymore. The webinars were run in coordination with WI Fast Plants and Carolina Knowledge Center, so the links are on their end. We have reached out to them to ask whether the links have changed, but we have not heard back yet. If it is ok with the reviewers, we will create a new issue on the broken links for now to address this when we receive the new links.