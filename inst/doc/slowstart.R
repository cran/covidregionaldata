## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ---- eval=TRUE---------------------------------------------------------------
library(covidregionaldata)

## ---- eval=FALSE--------------------------------------------------------------
#  get_national_data()

## -----------------------------------------------------------------------------
#  get_regional_data(country = "france")

## ---- echo=FALSE, eval=TRUE, message=FALSE------------------------------------
start_using_memoise()
knitr::kable(
  tail(get_regional_data(country = "france"), n = 5)
)

## ---- eval=FALSE, message=FALSE-----------------------------------------------
#  france <- France$new(get = TRUE)
#  france$return()

## -----------------------------------------------------------------------------
#  get_regional_data(country = "france", level = "2")

## ---- echo=FALSE, eval=TRUE, message=FALSE------------------------------------
knitr::kable(
  tail(get_regional_data(country = "france", level = "2"), n = 5)
)

## -----------------------------------------------------------------------------
#  get_regional_data("france", totals = TRUE)

## ---- echo=FALSE, eval=TRUE, message=FALSE------------------------------------
knitr::kable(
  tail(get_regional_data(country = "france", totals = TRUE), n = 5)
)

