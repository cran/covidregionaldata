## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE
)

## ----setup--------------------------------------------------------------------
library(covidregionaldata)
all_countries <- get_national_data()

## -----------------------------------------------------------------------------
all_countries

## ----fig.width = 6, message = FALSE-------------------------------------------
library(dplyr)
library(ggplot2)

all_countries %>%
  filter(country == "Italy") %>%
  ggplot() +
  aes(x = date, y = deaths_total) +
  geom_line() +
  labs(x = NULL, y = "All reported Covid-19 deaths, Italy") +
  theme_minimal()

## ----fig.width = 6------------------------------------------------------------
all_countries %>%
  filter(country %in% c(
    "Italy", "United Kingdom", "Spain",
    "United States"
  )) %>%
  ggplot() +
  aes(x = date, y = cases_total, colour = country) +
  geom_line() +
  labs(x = NULL, y = "All reported Covid-19 cases", colour = "Country") +
  theme_minimal() +
  theme(legend.position = "bottom")

## -----------------------------------------------------------------------------
all_countries_totals <- get_national_data(totals = TRUE, verbose = FALSE)
all_countries_totals

## -----------------------------------------------------------------------------
usa_states <- get_regional_data(country = "USA")

## ----fig.width = 6, warning = FALSE-------------------------------------------
usa_states %>%
  filter(state %in% c("New York", "Texas", "Florida")) %>%
  ggplot() +
  aes(x = date, y = cases_total, colour = state) +
  geom_line() +
  labs(x = NULL, y = "All reported Covid-19 cases", colour = "U.S. state") +
  theme_minimal() +
  theme(legend.position = "bottom")

## -----------------------------------------------------------------------------
usa_states_totals <- get_regional_data(
  country = "USA", totals = TRUE,
  verbose = FALSE
)

## ----fig.width = 6------------------------------------------------------------
usa_states_totals %>%
  ggplot() +
  aes(x = reorder(state, -deaths_total), y = deaths_total) +
  geom_bar(stat = "identity") +
  labs(x = "U.S. states", y = "All reported Covid-19 deaths") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90),
    axis.title.y = element_text(hjust = 1),
    legend.position = "bottom"
  )

## ---- eval = FALSE------------------------------------------------------------
#  usa_counties <- get_regional_data(country = "USA", level = "2", verbose = FALSE)

## ----fig.width = 6------------------------------------------------------------
# Get latest worldwide WHO data
map_data <- get_national_data(totals = TRUE, verbose = FALSE) %>%
  rworldmap::joinCountryData2Map(
    joinCode = "ISO2",
    nameJoinColumn = "iso_code"
  )
# Produce map
rworldmap::mapCountryData(map_data,
  nameColumnToPlot = "deaths_total",
  catMethod = "fixedWidth",
  mapTitle = "Total Covid-19 deaths to date",
  addLegend = TRUE
)

