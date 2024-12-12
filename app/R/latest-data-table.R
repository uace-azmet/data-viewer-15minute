# c2f: convert degrees Celsius to degrees Fahrenheit
# @param: valueIn - variable with units of Celsius
# @return: valueOut - variable with units of Fahrenheit
c2f <- function(valueIn) {
  valueOut <- (valueIn * (9/5)) + 32
  return(valueOut)
}

# kwm22wm2: convert kilowatts/m^2 to watts/m^2
# @param: valueIn - variable with units of kilowatts/m^2
# @return: valueOut - variable with units of watts/m^2
kwm22wm2 <- function(valueIn) {
  valueOut <- valueIn * 1000
  return(valueOut)
}

# mm2in: convert millimeters to inches
# @param: valueIn - variable with units of millimeters
# @return: valueOut - variable with units of inches
mm2in <- function(valueIn) {
  valueOut <- valueIn / 25.4
  return(valueOut)
}

# mps2mph: convert meters/second to miles/hour
# @param: valueIn - variable with units of meters/second
# @return: valueOut - variable with units of miles/hour
mps2mph <- function(valueIn) {
  valueOut <- valueIn * 2.237
  return(valueOut)
}


# Data ELT -----

tib <- azmetr::az_15min() |>
  
  dplyr::mutate(
    datetime = format(datetime, format = "%Y-%m-%d %H:%M:%S"),
    dwptF = c2f(dwpt),
    precip_total_in = mm2in(precip_total_mm),
    sol_rad_Wm2 = kwm22wm2(sol_rad_kWm2),
    temp_airF = c2f(temp_airC),
    temp_air_maxF = c2f(temp_air_maxC),
    temp_air_minF = c2f(temp_air_minC),
    temp_panelF = c2f(temp_panelC),
    temp_soil_10cmF = c2f(temp_soil_10cmC),
    temp_soil_50cmF = c2f(temp_soil_50cmC),
    temp_wetbulbF = c2f(temp_wetbulbC),
    wind_2min_spd_max_mph_daily = mps2mph(wind_2min_spd_max_mps_daily),
    wind_2min_spd_max_mph_hourly = mps2mph(wind_2min_spd_max_mps_hourly),
    wind_2min_spd_mean_mph = mps2mph(wind_2min_spd_mean_mps),
    wind_spd_max_mph = mps2mph(wind_spd_max_mps),
    wind_spd_mph = mps2mph(wind_spd_mps)
  ) |>
  
  dplyr::select(
    meta_station_name,
    datetime,
    dwptF,
    precip_total_in,
    relative_humidity,
    sol_rad_Wm2,
    temp_airF,
    temp_air_maxF,
    temp_air_minF,
    temp_panelF,
    temp_wetbulbF,
    temp_soil_10cmF,
    temp_soil_50cmF,
    vp_saturation,
    vp_actual,
    vp_deficit,
    wind_2min_spd_max_mph_daily,
    wind_2min_spd_max_mph_hourly,
    wind_2min_spd_mean_mph,
    wind_2min_vector_dir,
    wind_2min_vector_dir_max_daily,
    wind_2min_vector_dir_max_hourly,
    wind_spd_max_mph,
    wind_spd_mph,
    wind_vector_dir
  ) |>
  
  dplyr::arrange(meta_station_name)


# Table -----

table <- tib |>
  reactable::reactable(
    columns = list(
      meta_station_name = reactable::colDef(
        name = "Station",
        minWidth = 150,
        #aggregate = NULL,
        #sortable = NULL,
        #resizable = NULL,
        #filterable = NULL,
        #searchable = NULL,
        #filterMethod = NULL,
        #show = TRUE,
        #defaultSortOrder = NULL,
        #sortNALast = FALSE,
        #format = NULL,
        #cell = NULL,
        #grouped = NULL,
        #aggregated = NULL,
        #header = NULL,
        #footer = NULL,
        #details = NULL,
        #filterInput = NULL,
        #html = FALSE,
        na = "NA",
        rowHeader = TRUE,
        #minWidth = 100,
        #maxWidth = NULL,
        #width = NULL,
        #align = NULL,
        #vAlign = NULL,
        #headerVAlign = NULL,
        sticky = "left"
        #class = NULL,
        #style = NULL,
        #headerClass = NULL,
        #headerStyle = NULL,
        #footerClass = NULL,
        #footerStyle = NULL
      ), 
      datetime = reactable::colDef(
        name = "Latest Update",
        minWidth = 150,
        na = "NA",
        rowHeader = TRUE
      ),
      dwptF = reactable::colDef(
        name = "DWPT (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      precip_total_in = reactable::colDef(
        name = paste0("P (in)", common::supsc(1)),
        format = reactable::colFormat(digits = 2),
        na = "NA",
        rowHeader = TRUE
      ),
      relative_humidity = reactable::colDef(
        name = "RH (%)",
        format = reactable::colFormat(digits = 0),
        na = "NA",
        rowHeader = TRUE
      ),
      sol_rad_Wm2 = reactable::colDef(
        name = "SR (W/m2)",
        format = reactable::colFormat(digits = 2),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_airF = reactable::colDef(
        name = "T (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_air_maxF = reactable::colDef(
        name = "Tmax d (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_air_minF = reactable::colDef(
        name = "Tmin d (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_panelF = reactable::colDef(
        name = "Tpanel (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_wetbulbF = reactable::colDef(
        name = "Twet (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_soil_10cmF = reactable::colDef(
        name = "ST4 (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      temp_soil_50cmF = reactable::colDef(
        name = "ST20 (°F)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      vp_saturation = reactable::colDef(
        name = "VPsat (kPa)",
        format = reactable::colFormat(digits = 2),
        na = "NA",
        rowHeader = TRUE
      ),
      vp_actual = reactable::colDef(
        name = "VPact (kPa)",
        format = reactable::colFormat(digits = 2),
        na = "NA",
        rowHeader = TRUE
      ),
      vp_deficit = reactable::colDef(
        name = "VPD (kPa)",
        format = reactable::colFormat(digits = 2),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_spd_max_mph_daily = reactable::colDef(
        name = "WS2max d (mph)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_spd_max_mph_hourly = reactable::colDef(
        name = "WS2max h (mph)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_spd_mean_mph = reactable::colDef(
        name = "WS2 (mph)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_vector_dir = reactable::colDef(
        name = "WD2 (deg)",
        format = reactable::colFormat(digits = 0),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_vector_dir_max_daily = reactable::colDef(
        name = "WD2max d (deg)",
        format = reactable::colFormat(digits = 0),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_2min_vector_dir_max_hourly = reactable::colDef(
        name = "WD2max h (deg)",
        format = reactable::colFormat(digits = 0),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_spd_max_mph = reactable::colDef(
        name = "WSmax d (mph)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_spd_mph = reactable::colDef(
        name = "WS (mph)",
        format = reactable::colFormat(digits = 1),
        na = "NA",
        rowHeader = TRUE
      ),
      wind_vector_dir = reactable::colDef(
        name = "WD (deg)",
        format = reactable::colFormat(digits = 0),
        na = "NA",
        rowHeader = TRUE
      )
    ),
    #columnGroups = NULL,
    rownames = FALSE,
    #groupBy = NULL,
    sortable = FALSE,
    resizable = FALSE,
    filterable = FALSE,
    searchable = FALSE,
    searchMethod = NULL,
    #defaultColDef = NULL,
    #defaultColGroup = NULL,
    #defaultSortOrder = "asc",
    #defaultSorted = NULL,
    pagination = FALSE,
    #defaultPageSize = 10,
    showPageSizeOptions = FALSE,
    #pageSizeOptions = c(10, 25, 50, 100),
    #paginationType = "numbers",
    showPagination = NULL,
    showPageInfo = FALSE,
    #minRows = 1,
    #paginateSubRows = FALSE,
    #details = NULL,
    defaultExpanded = TRUE,
    selection = NULL,
    defaultSelected = NULL,
    onClick = NULL,
    highlight = TRUE,
    outlined = FALSE,
    bordered = FALSE,
    #borderless = FALSE,
    striped = TRUE,
    compact = TRUE,
    #wrap = TRUE,
    #showSortIcon = TRUE,
    #showSortable = FALSE,
    #class = NULL,
    #style = NULL,
    style = list(fontFamily = "Work Sans, sans-serif", fontSize = "0.875rem"),
    #rowClass = NULL,
    #rowStyle = NULL,
    fullWidth = TRUE,
    width = "auto",
    height = 400,
    #theme = getOption("reactable.theme"), <-----
    #language = getOption("reactable.language"),
    #meta = NULL,
    #elementId = NULL,
    static = getOption("reactable.static", FALSE)
    #selectionId = NULL
  )
