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

ggplot2::theme_set(
  ggplot2::theme_bw(
  )+
    theme(
      strip.background = element_rect(fill="grey90", color = NA)
    )
)

# ---- load-data ---------------------------------------------------------------

ds0 <- read_rds(config$path_ILI)

# ---- tweak-data --------------------------------------------------------------

ds1 <- ds0 %>%
  mutate(
    flu_year = case_when(
      week %in% c("40":"52") ~ year
      ,TRUE ~ year - 1L
    )
    ,across(flu_year, as.factor)
  )

# ---- graph-data --------------------------------------------------------------


# NC Graph


g1 <- ds1 %>%
  filter(state == "North Carolina") %>%
  ggplot(aes(x = week, y = unweighted_ili, group = flu_year, color = flu_year)) +
  geom_line() +
  scale_x_discrete(breaks = seq(1,52,4),) +
  scale_color_brewer(palette = "Dark2") +
  theme(
    axis.text.x = element_text(angle = 270)
  )

g1
