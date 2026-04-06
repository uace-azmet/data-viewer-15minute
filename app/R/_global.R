# Libraries --------------------


library(azmetr)
library(bsicons)
library(bslib)
library(dplyr)
library(htmltools)
library(plotly)
library(RColorBrewer)
library(reactable)
library(shiny)
library(shinyjs)
library(vroom)


# Files -------------------- 

# Functions. Loaded automatically at app start if in `R` folder
#source("./R/fxn_functionName.R", local = TRUE)

# Scripts. Loaded automatically at app start if in `R` folder
#source("./R/scr_scriptName.R", local = TRUE)


# Variables --------------------

azmetStationMetadata <- azmetr::station_info |>
  dplyr::mutate(end_date = NA) #|> # Placeholder until inactive stations are in API and `azmetr`
  # dplyr::mutate(
  #   end_date = dplyr::if_else(
  #     condition = status == "active",
  #     true = lubridate::today(tzone = "America/Phoenix") - 1,
  #     false = end_date
  #   )
  # )

az15minStartDate <- lubridate::now(tzone = "America/Phoenix") - lubridate::ddays(x = 14)

showNavsetCardTab <- reactiveVal(FALSE)
showPageBottomText <- reactiveVal(FALSE)

stationGroups <- 
  tibble::tibble(
    group1 = c("Ft Mohave CA", "Mohave", "Mohave ETo", "Mohave-2", "Parker", "Parker-2"),
    group2 = c("Roll", "Wellton ETo", "Yuma N.Gila", "Yuma South", "Yuma Valley", "Yuma Valley ETo"),
    group3 = c("Aguila", "Buckeye", "Harquahala", "Maricopa", "Paloma", "Salome"),
    group4 = c("Chino Valley", "Desert Ridge", "Payson", "Phoenix Encanto", "Phoenix Greenway", NA),
    group5 = c("Coolidge", "Elgin", "Queen Creek", "Sahuarita", "Test", "Tucson"),
    group6 = c("Bonita", "Bowie", "Duncan", "Safford", "San Simon", "Willcox Bench")
  )


# Other --------------------


shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))
