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
  dplyr::mutate(end_date = NA)

az15minStartDate <- lubridate::now(tzone = "America/Phoenix") - lubridate::ddays(x = 14)

# az15minVarsID <- 
#   c(
#     "date_doy",
#     "date_hour",
#     "date_seconds",
#     "date_year",
#     "datetime", 
#     "meta_needs_review", 
#     "meta_station_id", 
#     "meta_station_name", 
#     "meta_version"
#   )

# az15minVarsMeasured <- 
#   c(
#     "lw1_mV",
#     "lw1_total_con_mins",
#     "lw1_total_dry_mins",
#     "lw1_total_wet_mins",
#     "lw2_mV",
#     "lw2_total_con_mins",
#     "lw2_total_dry_mins",
#     "lw2_total_wet_mins",
#     "meta_bat_volt",
#     "precip_total_mm",
#     "relative_humidity",
#     "relative_humidity_30cm",
#     "sol_rad_kWm2",
#     "sol_rad_total",
#     "temp_airC",
#     "temp_air_30cmC",
#     "temp_air_maxC",
#     "temp_air_minC",
#     "temp_panelC",
#     "temp_soil_10cmC",
#     "temp_soil_50cmC",
#     "wind_2min_spd_max_mps_daily",
#     "wind_2min_spd_max_mps_hourly",
#     "wind_2min_spd_mean_mps",
#     "wind_2min_vector_dir",
#     "wind_2min_vector_dir_max_daily",
#     "wind_2min_vector_dir_max_hourly",
#     "wind_spd_max_mps",
#     "wind_spd_mps",
#     "wind_vector_dir"
#   )

# az15minVarsDerived <- 
#   c(
#     "dwpt", 
#     "dwpt_30cm",
#     "temp_wetbulbC",
#     "vp_actual",
#     "vp_deficit",
#     "vp_saturation"
#   )

az15minStationVariables <- 
  c(
    "dwptF",
    "meta_bat_volt",
    "precip_total_in",
    "relative_humidity",
    "sol_rad_Wm2",
    "temp_air_maxF",
    "temp_air_minF",
    "temp_airF",
    "temp_panelF",
    "temp_soil_10cmF",
    "temp_soil_50cmF",
    "temp_wetbulbF",
    "vp_actual",
    "vp_deficit",
    "vp_saturation",
    "wind_2min_spd_max_mph_daily",
    "wind_2min_spd_max_mph_hourly",
    "wind_2min_spd_mean_mph",
    "wind_2min_vector_dir",
    "wind_2min_vector_dir_max_daily",
    "wind_2min_vector_dir_max_hourly",
    "wind_spd_max_mph",
    "wind_spd_mph",
    "wind_vector_dir"
  )

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
