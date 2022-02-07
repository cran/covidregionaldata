## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- include = FALSE---------------------------------------------------------
library(covidregionaldata)
library(dplyr)
library(knitr)
library(dplyr)
library(ggplot2)
library(sf)

## ---- supported_region_plot, echo=FALSE, message=FALSE------------------------

regional_countries <- get_available_datasets() %>%
  filter(type == "regional")

regional_countries_l2 <- regional_countries %>%
  filter(!(is.na(level_2_region)))

world <- map_data("world")

supported_countries <- mutate(
  world,
  fill = case_when(
    region %in% regional_countries_l2[["class"]] ~ "Level 2",
    region %in% regional_countries[["class"]] ~ "Level 1",
    TRUE ~ "Unsupported"
  )
)

ggplot(supported_countries, aes(long, lat, fill = fill, group = group)) +
  geom_polygon(color = "black", lwd = 0.1) +
  scale_fill_manual(
    name = "",
    values = c("#0072b2", "#cc79a7", "grey80")
  ) +
  theme_void() +
  theme(legend.position = "bottom") +
  coord_sf(ylim = c(-55, 80))

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
    )
  )
kable(datasets)

