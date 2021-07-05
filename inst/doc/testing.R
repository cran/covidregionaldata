## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE
)

## -----------------------------------------------------------------------------
library(covidregionaldata)
ukdata <- UK$new(level = "1", verbose = FALSE)
# could use anything but I used the acutal test one here for simplicity
ukdata$test(snapshot_dir = "../tests/testthat/custom_data/")

## ---- echo = TRUE-------------------------------------------------------------
ukdata$test

## ---- echo = TRUE-------------------------------------------------------------
test_download

## ---- echo = TRUE-------------------------------------------------------------
test_cleaning

## ---- echo = TRUE-------------------------------------------------------------
test_processing

## ---- echo = TRUE-------------------------------------------------------------
test_return

