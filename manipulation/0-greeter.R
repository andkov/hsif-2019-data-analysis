rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run.
cat("\f") # clear console when working in RStudio

# load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library("magrittr") #Pipes
library("ggplot2")  #graphs
library("dplyr")

# we will predend to work with RAW data, but this is its source:
# titanic::titanic_train %>% readr::write_csv("./data-unshared/raw/titanic-train.csv")
# titanic::titanic_test %>% readr::write_csv("./data-unshared/raw/titanic-test.csv")

# declare-globals ----------------------------------------------------------

# define-custom-functions --------------------------------------------------

# load-data ----------------------------------------------------------------
ds0 <- readr::read_csv("data-unshared/raw/titanic-train.csv")

# inspect-data -------------------------------------------------------------

# ??titanic::titanic_train
# head(ds0)
glimpse(ds0) # equivalent to ds0 %>% glimpse()
# explore::explore_all(ds0)
# explore::describe_all(ds0)
# explore::describe_cat(ds0,Survived)
# explore::explore(ds0)

# tweak-data ---------------------------------------------------------------

# change the spelling of the names to all lowercase letters
names(ds0) <- names(ds0) %>% tolower()

# select variables/columns and rearrange them in a specific order
ds1 <- ds0 %>%
  dplyr::select(passengerid, survived, pclass, sex, age, sibsp, fare)
# alt
ds1 <- dplyr::select(.data = ds0, passengerid, survived, pclass, sex, age, sibsp, fare)

# rename variables
ds2 <- ds1 %>%
  dplyr::rename(
    person_id   = passengerid,
    n_relatives = sibsp,
    cost_fare   = fare
  ) %>%
  dplyr::select(
    person_id, sex, age, pclass, cost_fare, n_relatives, survived
  )

ds2 %>% glimpse()

# basic-table --------------------------------------------------------------
xtabs(survived ~ sex, data = ds)
xtabs(survived ~ pclass, data = ds)

ds2 %>%
  dplyr::group_by(pclass) %>%
  dplyr::summarize(n = n()) %>%
  knitr::kable()

# basic-graph --------------------------------------------------------------
hist(ds2$age)
stem(ds2$age)

# save-to-disk -------------------------------------------------------------
# save prepared data set for subsequent use
ds2 %>% readr::write_csv("./data-unshared/derived/greeted-titanic-train.csv")
