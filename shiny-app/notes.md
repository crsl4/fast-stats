# Update to the shiny app after new data

## Plots
- Histogram: select the variable "Generation"
```{r, echo=FALSE}
p1 = ggplot(dat, aes(Generation, fill=Generation))+geom_bar()+
  theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
        )
p1
```
- Scatterplot: select the grouping variable (Generation) and quantity (Cotyledons); be able to choose who is X and who is Y
```{r, echo=FALSE}
p3 = ggplot(dat, aes(y = Generation, x = Cotyledons, fill = Generation)) +
  geom_jitter(pch = 21, alpha=0.3, width=0.2)+
  theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
        )
p3
```
- Boxplot: choose with/without dots; select the grouping variable (Generation) and quantity (Cotyledons)
```{r, echo=FALSE}
p3.2 = ggplot(dat, aes(x = Generation, y = Cotyledons, fill = Generation)) +
  geom_jitter(pch = 21, alpha=0.3, height=0.2)+
    geom_boxplot(outlier.size = 0, alpha=0.1) +
  theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
        )
p3.2
```
- Violin plot: choose with/without dots; select the grouping variable (Generation) and quantity 
```{r, echo=FALSE}
p4.2 = ggplot(dat, aes(x=Generation, y=Cotyledons, fill=Generation))+geom_violin(alpha=1)+
    geom_jitter(pch = 21, alpha=0.1)+
  ylim(c(1,6))+
  theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
        )

p4.2
```
- Densities: select the grouping variable (Generation) and quantity 
```{r, echo=FALSE}
q1 = ggplot(dat, aes(Cotyledons, fill=Generation))+geom_density(alpha=0.25)+
  theme(
        plot.title = element_text(hjust=0.5, size=rel(1.8)),
        axis.title.x = element_text(size=rel(1.8)),
        axis.title.y = element_text(size=rel(1.8), angle=90, vjust=0.5, hjust=0.5),
        axis.text.x = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(colour="grey", size=rel(1.5), angle=0, hjust=.5, vjust=.5, face="plain"),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey")##,
        )
q1
```

### Future in plots
- flexibility on color, transparency, size
- able to download image

## Analyses
- t test: be able to choose option: equal variances: yes/no; select grouping variable (Generation) and quantitative variable (Cotelydons)
    - if equal.variance=TRUE: t.test(x,y, var.equal=TRUE)
    - if equal.variance=FALSE: t.test(x,y)
    where x and y as defined as the quantitative variable on the two groups
- test for equality of variances: select grouping variable (Generation) and quantitative variable (Cotelydons). There is a choice:
    - normality assumed => levene test: leveneTest(Cotyledons ~ Generation, dat, center=mean)
    - normality not assumed => Fligner-Killeen test: fligner.test(Cotyledons ~ Generation, dat)
- wilcoxon-mann-whitney test: select grouping variable (Generation) and quantitative variable (Cotelydons). wilcox.test(Cotyledons ~ Generation, dat)


# Adding chi-square
For a dataset (`dat`) that has two categorical variables: `cots` and `generation`.
```r
dt = table(dat$cots, dat$generation)
chisq.test(dt)
```

# Descriptions

## About tab

Welcome to the WI Fast Stats app! (this is larger font and bold)
This is the open-source publicly available web app to analyze data from WI Fast Plants.

## Data visualization

Violin Plot: Plot a numerical variable ("Quantity") by groups ("Group variable"). It is similar to the box plot but it also shows the distribution and spread of the data.

Box Plot: Plot a numerical variable ("Quantity") by groups ("Group variable"). Solid black line in the box represents the median, and the upper and lower edges of the box represent the 3rd and 1st quartiles respectively.

Plot Option: Add data points. This option allows the user to add a scatterplot of the data where each dot corresponds to one observation (row) in the dataset.

## Data analysis

T test: Statistical test of the null hypothesis of equality of means of a numerical variable ("Quantity") on two groups ("Group variable"). If the selected group variable has more than two categories, the user will select the two groups to compare.

How to interpret the result? If the p-value is less than 0.05, we reject the null hypothesis of equality of means. The confidence interval represents the interval for the difference of means.

Data Analysis Option: Equal variance. The standard t test assumes equal variances on the two groups. If the user checks this option, the standard t test is run, but if the user unchecks this option, then the Welch t test is run instead (that does not assume equal variances).


## FAQ

(add the next question)

How to get help? 
Soon we will have a google user group to post questions and answers for users of the app.
