#' `fxn_nwsData.R` - Filter 15-minute data for the most recent report from each station
#' 
#' @param inData - AZMet 15-minute data from `fxn_dataETL.R`
#' @return `nwsData` - Most recent data from each station, tibble format


fxn_nwsData <- function(inData) {
  nwsData <- inData |>
    dplyr::group_by(meta_station_name) |>
    dplyr::filter(datetime == max(datetime)) |>
    dplyr::ungroup() |>
    dplyr::select(!meta_station_group)
    
  return(nwsData)
}
