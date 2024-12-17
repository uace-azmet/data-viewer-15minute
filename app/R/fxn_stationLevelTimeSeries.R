#' `fxnTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param batteryVariable - user-specified battery variable
#' @param weatherVariable - user-specified weather variable
#' @return `timeSeries` - time series graphs based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596


fxn_stationLevelTimeSeries <- function(azmetStationGroup, stationVariable) {
  #tib <- tib |>
  #  dplyr::mutate(
  #    meta_station_group = sample(azmetStations$stationGroup, replace = TRUE))
        #azmetStations$stationGroup[which(azmetStations$stationName) == unique(tib$meta_station_name)])
  
  p <- 
    ggplot2::ggplot() +
    ggplot2::geom_col(
      data = dplyr::filter(tib, meta_station_name != azmetStationGroup),
      mapping = ggplot2::aes(x = meta_station_name, y = relative_humidity, fill = meta_bat_volt)
    ) +
    ggplot2::geom_col(
      data = dplyr::filter(tib, meta_station_name == azmetStationGroup),
      mapping = ggplot2::aes(x = meta_station_name, y = relative_humidity), fill = "red"
    )
  
  return(p)
}
