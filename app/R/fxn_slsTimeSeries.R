#' `fxn_slsTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - AZMet 15-minute data from `fxn_dataETL.R`
#' @param azmetStation - user-specified AZMet station
#' @param stationVariable - user-specified weather variable
#' @return `timeSeries` - time series graphs based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596


fxn_slsTimeSeries <- function(inData, azmetStationGroup, stationVariable) {
  p <- 
    ggplot2::ggplot() +
    ggplot2::geom_line(
      data = dplyr::filter(inData, meta_station_group != azmetStationGroup),
      mapping = ggplot2::aes(x = datetime, y = .data[[stationVariable]], group = meta_station_name), 
      color = "#909090"
    ) +
    ggplot2::geom_line(
      data = dplyr::filter(inData, meta_station_group == azmetStationGroup),
      mapping = ggplot2::aes(x = datetime, y = .data[[stationVariable]], group = meta_station_name)#,
      #color = "red"
    ) +
    ggplot2::scale_color_brewer(type = "qual", palette = "Dark2")
  
  return(p)
}
