This folder contains the Rmarkdown notebooks with the plots and statistical analyses for the WI Fast Plants webinars.

## Cotyledon webinar

- `cotelydon-data-analysis.Rmd`: Rmarkdown file with all the R code to plot the data and fit statistical tests. 
    - This file contains the following sections on the data used in the webinar (`data/Polycot-data-2020.csv`):
        - Read data
        - Data visualization: mosaic plot
        - Data analysis: chi-square test
    - This file also contains code for topics not covered in the webinar using the same data (`data/Polycot-data-2020.csv`): a t test, a Levene test (for equality of variances) and a Wilcoxon-Mann-Whitney test which is similar to the t test when normality is violated. We also fit an ANOVA test and its alternative when normality is not met, the Kruskal-Wallis rank sum test.
    - At the end, the file also contains code for another dataset which is not made publicly available (as it is not part of the webinar). This section is kept in the notebook just as book-keeping for internal use of the Solis-Lemus lab.
- `cotelydon-data-analysis.html`: This file has all the results and plots from the R code so that users do not need to run the code necessarily. Note that this file is not properly displayed by github, so you need to open it in your computer (by double-click) after cloning the repository. Instructions to clone the repository are in the main [readme file](https://github.com/crsl4/fast-stats#wi-fast-stats-overview).


## Ecosystem webinar

- `ecosystem-data-analysis.Rmd`: Rmarkdown file with all the R code to plot the data and fit statistical tests. This file contains the following sections on a dataset that is not the one used in the webinar (`data/ecosystem-data.csv`), but it helps illustrate the same analyses.
- `ecosystem-data-analysis.html`: This file has all the results and plots from the R code so that users do not need to run the code necessarily. Note that this file is not properly displayed by github, so you need to open it in your computer (by double-click) after cloning the repository. Instructions to clone the repository are in the main [readme file](https://github.com/crsl4/fast-stats#wi-fast-stats-overview).