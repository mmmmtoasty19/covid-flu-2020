# this script pulls the latest ILI data from the CDC Fluview

# ILI is defined as fever (temperature of 100°F [37.8°C] or greater)
# and a cough and/or a sore throat without a known cause other than influenza
# https://www.cdc.gov/flu/weekly/overview.htm


rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run.
cat("\f") # clear console when working in RStudio
# ---- load-sources ------------------------------------------------------------

# ---- load-packages -----------------------------------------------------------
library(tidyverse)
library(cdcfluview)
# ---- declare-globals ---------------------------------------------------------
config <- config::get()

# ---- load-data ---------------------------------------------------------------

ds0 <- ilinet(years = c(2016,2017,2018,2019,2020), region = "state")

# join mmwrid data for CDC Weekly Morbidity and Mortality Report
# https://www.cdc.gov/mmwr/index.html
# This is a standardized reporting number
ds1 <- ds0 %>% left_join(mmwrid_map, by = c("week_start" = "wk_start"))

# ---- tweak-data --------------------------------------------------------------

ds2 <- ds1 %>%
  select(region,year,week,unweighted_ili,mmwrid) %>%
  rename(state = region) %>%
  mutate(across(week, ~factor(., levels = c(40:52, 1:39))))

# ---- save-data ---------------------------------------------------------------



ds2 %>% write_rds(config$path_ILI ,compress = 'gz')
