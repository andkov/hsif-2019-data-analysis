# Managing Data Analysis in RStudio using Project-Oriented workflow
Workshop at the 2019 cohort retreat for the Health System Impact Fellowship, Toronto, November 26-29, 2019. 

## Abstract

The workshop will review best practices of reproducible research including folder architecture, data preparation, graph making, statistical modeling, and script documentation. The workshop is targeted at researchers who are expected to conduct their own analysis of data and prepare reports that deliver the findings to both technical and executive audiences within health systems. Using logistic regression as an example, the participants will learn to communicate statistical findings more effectively, and will evaluate the advantages of using computational notebooks in RStudio to disseminate the results.

## Software requirements

To participate in the workshop you will need to install the following software on your computer:

1. **[R](http://cran.r-project.org/)** is the centerpiece of the analysis. Every few months, you'll need to download the most recent version. 

2. **[RStudio Desktop](http://www.rstudio.com/ide/download/desktop)** is the IDE (integrated design interface) that you will use to interact with your R scripts and notebooks.

3. **Several R packages** , most commonly used in a data science workflow. Once you install R and RStudio, please run the following script in your console.  Create a new 'personal library' if it prompts you.

```r
install.packages(c("tidyverse","titanic","kableExtra","knitr", "rmarkdown","DT","scales", "RColorBrewer"))
```

## About the presenter

Andriy Koval, Ph.D. is a data scientist with a background in quantitative methods and interests in data-driven models of human aging. He was a Health System Impact Fellow with Observatory for Population and Public Health ( Centre for Disease Control of British Columbia, UBC) and a research fellow with the Vancouver Island Health Authority. Andriy’s works centers around developing tools for reproducible research with R and GitHub as key components. Presently, Andriy’s work focuses on developing statistical methods for analyzing transactional data extracted from the electronic health records (EHR). His current interests include design of information displays with R, literate programming, statistical modelling in general, and longitudinal analysis in particular. See more at https://andriy.rbind.io and http://github.com/andkov
