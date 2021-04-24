## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- include = FALSE---------------------------------------------------------
library(covidregionaldata)
library(dplyr)
library(knitr)

## ---- echo = FALSE------------------------------------------------------------
datasets <- get_available_datasets() %>%
  arrange(origin) %>%
  select(Origin = origin, Method = class) %>%
  mutate(
    `GitHub status` = paste0(
      "[![", Method,
      "](https://github.com/epiforecasts/covidregionaldata/workflows/",
      Method, "/badge.svg)]",
      "(https://github.com/epiforecasts/covidregionaldata/actions/workflows/", # nolint
      Method, ".yaml)"
    ),
    `CRAN status` = "*working*"
  )
kable(datasets)

