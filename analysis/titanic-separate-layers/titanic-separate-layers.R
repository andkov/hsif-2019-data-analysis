# knitr::stitch_rmd(script="./___/___.R", output="./___/stitched-output/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graphing/graph-presets.R") # fonts, colors, themes

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>%
library(dplyr)
library(ggplot2)
library(titanic)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("tidyr") # data manipulation
# requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.


# ---- declare-globals ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
# ds0 <- readr::read_csv("./data-unshared/derived/greeted-titanic-train.csv")
ds0 <- titanic::titanic_train
head(ds0)
dplyr::glimpse(ds0)

# ---- inspect-data -------------------------------------------------------------
explore::describe_all(ds0)

# ---- tweak-data --------------------------------------------------------------
# create a new copy that will store tweeks
ds1 <- ds0
# 1. convert columns names to lowercase
names(ds1) <- tolower(names(ds1))
# ds1 %>% glimpse()
# 2. Keep only specific variables and sort columns
ds1 <- ds1 %>%
  dplyr::select(survived, pclass, sex, age, sibsp, parch, fare, embarked)
# ds1 %>% glimpse()
# 3. Rename variables
ds1 <- ds1 %>%
  dplyr::rename(
    n_siblings_spouses  = sibsp
    ,n_parents_children = parch
    ,price_ticket       = fare
    ,port_embarked      = embarked
  )
# 4. Convert a character variable to a factor
ds1 <- ds1 %>%
  dplyr::mutate(
    survived = factor(survived, levels = c(0,1), labels = c("Died", "Survived"))
    ,sex     = factor(sex, levels = c("male","female"), labels = c("Men","Women"))
    ,pclass  = factor(pclass, levels = c(1,2,3), labels = c("First","Second", "Third"))
  )
# 5. Remove observations where a) age is NA b) port_embarked is missing ("")
ds1 <- ds1 %>%
  dplyr::filter(!is.na(age)) %>%
  dplyr::filter(port_embarked != "")
# create an alias data set for modeling
ds_modeling <- ds1
ds_modeling %>% glimpse()

# ---- basic-table --------------------------------------------------------------
ds_modeling %>%
  dplyr::group_by(survived, sex) %>%
  dplyr::summarize(
    n_people = n()
    ,mean_age = mean(age, na.rm = T)
  )
# ---- basic-graph --------------------------------------------------------------


# ---- model-0 -----------------------------------------------------------------
model_0 <- stats::glm(
  formula = survived ~ sex
  ,family = "binomial"
  ,data = ds_modeling
)
summary(model_0)
# create levels of predictors for which to generate predicted values
ds_predicted_0 <- ds_modeling %>%
  dplyr::select(sex) %>%
  dplyr::distinct()
# add model prediction
ds_predicted_0 <- ds_predicted_0 %>%
  dplyr::mutate(
    log_odds = predict(object = model_0, newdata = .)
    ,probability = plogis(log_odds)
  )
# ds_predicted_0

# ---- graph-0 -----------------------------------------------------------------

ds_predicted_0 %>%
  ggplot(aes(x = sex, y = probability))+
  geom_bar(stat = "identity")

# ---- model-1 -----------------------------------------------------------------

model_1 <- stats::glm(
  formula = survived ~ sex + age
  ,family = "binomial"
  ,data = ds_modeling
)
summary(model_1)
# create levels of predictors for which to generate predicted values
ds_predicted_1 <- ds_modeling %>%
  dplyr::select(sex, age) %>%
  dplyr::distinct()
# add model prediction
ds_predicted_1 <- ds_predicted_1 %>%
  dplyr::mutate(
    log_odds     = predict(object = model_1, newdata = .)
    ,probability = plogis(log_odds)
  )

# ---- graph-1 -----------------------------------------------------------------

g1 <- ds_predicted_1 %>%
  ggplot(aes(x = age, y = probability))+
  geom_point(aes(color = sex))
g1


# ---- model-2 -----------------------------------------------------------------

model_2 <- stats::glm(
  formula = survived ~ sex + age + pclass
  ,family = "binomial"
  ,data = ds_modeling
)
summary(model_2)
# create levels of predictors for which to generate predicted values
ds_predicted_2 <- ds_modeling %>%
  dplyr::select(sex, age, pclass) %>%
  dplyr::distinct()
# add model prediction
ds_predicted_2 <- ds_predicted_2 %>%
  dplyr::mutate(
    log_odds     = predict(object = model_2, newdata = .)
    ,probability = plogis(log_odds)
  )

# ---- graph-2 -----------------------------------------------------------------

g2 <- ds_predicted_2 %>%
  ggplot(aes(x = age, y = probability))+
  geom_point(aes(color = sex))+
  facet_wrap("pclass")
g2


# ---- model-3 -----------------------------------------------------------------

model_3 <- stats::glm(
  formula = survived ~ sex + age + pclass + port_embarked
  ,family = "binomial"
  ,data = ds_modeling
)
summary(model_3)
# create levels of predictors for which to generate predicted values
ds_predicted_3 <- ds_modeling %>%
  dplyr::select(sex, age, pclass, port_embarked) %>%
  dplyr::distinct()
# add model prediction
ds_predicted_3 <- ds_predicted_3 %>%
  dplyr::mutate(
    log_odds     = predict(object = model_3, newdata = .)
    ,probability = plogis(log_odds)
  )

# ---- graph-3 -----------------------------------------------------------------

g3 <- ds_predicted_3 %>%
  ggplot(aes(x = age, y = probability))+
  geom_point(aes(color = sex, shape = port_embarked))+
  facet_grid(. ~ pclass)
# facet_grid(port_embarked ~ pclass)
g3


# ---- publish ---------------------------------------
path_report_1 <- "./analysis/titanic-separate-layers/titanic.Rmd"
allReports <- c(path_report_1)
pathFilesToBuild <- c(allReports)
testit::assert("The knitr Rmd files should exist.", base::file.exists(pathFilesToBuild))
# Build the reports
for( pathFile in pathFilesToBuild ) {

  rmarkdown::render(input = pathFile,
                    output_format=c(
                      "html_document"
                      # "pdf_document"
                      # ,"md_document"
                      # "word_document"
                    ),
                    clean=TRUE)
}
