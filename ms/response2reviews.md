We thank the reviewers for such helpful comments that have greatly improved the web apps and the manuscript.

# Review 1

Functionality and Documentation:
- We double checked all the steps in the `readme` file to run the web apps locally, and provided more details on how to install `thatssorandom` and how to run the `shiny::runApp` command
- We have added more comments to the code and we have added a new section on the documentation for young audiences interested in coding
- We modified the interface so that only categorical variables appear under "Group variable" and only quantitative variables appear under "quantity"
- For the `webinar-aug20` sample data, we make `plant ID` a group variable. We found that for the other web apps, it did not make sense to change `plant ID` as categorical variable because some plots became not very intepretable, so we decided to keep them as quantitiative variables.

add more details on how to install thatssorandom
add more details on how to run runApp
overall check all the steps to run a web app locally
more comments on code! Think of younger audiences looking at the code. No need to comment every line, but explain the overall structure and what each function is doing
“Group variable” should only display the variables that are categorical and “Quantity” should only display the variables that are quantitative
For cotelydon toy data, change plant ID to categorical variable
change the warning on guide scales=FALSE to “none”
check the warnings on fewer than two data points

Add DOI to references
Change Data summary to Data upload
Expand documentation to help students
Make slides available and data for the slides: Maybe change to md
remove the notebooks
editorial comments on broken links