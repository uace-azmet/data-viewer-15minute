#' `fxnTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param batteryVariable - user-specified battery variable
#' @param stationVariable - user-specified weather variable
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
  tib <- azmetr::az_15min() |>
    
    dplyr::mutate(
      datetime = format(datetime, format = "%Y-%m-%d %H:%M:%S"),
      dwptF = conv_c_to_f(dwpt),
      precip_total_in = conv_mm_to_in(precip_total_mm),
      sol_rad_Wm2 = conv_kwm2_to_wm2(sol_rad_kWm2),
      temp_airF = conv_c_to_f(temp_airC),
      temp_air_maxF = conv_c_to_f(temp_air_maxC),
      temp_air_minF = conv_c_to_f(temp_air_minC),
      temp_panelF = conv_c_to_f(temp_panelC),
      temp_soil_10cmF = conv_c_to_f(temp_soil_10cmC),
      temp_soil_50cmF = conv_c_to_f(temp_soil_50cmC),
      temp_wetbulbF = conv_c_to_f(temp_wetbulbC),
      wind_2min_spd_max_mph_daily = conv_mps_to_mph(wind_2min_spd_max_mps_daily),
      wind_2min_spd_max_mph_hourly = conv_mps_to_mph(wind_2min_spd_max_mps_hourly),
      wind_2min_spd_mean_mph = conv_mps_to_mph(wind_2min_spd_mean_mps),
      wind_spd_max_mph = conv_mps_to_mph(wind_spd_max_mps),
      wind_spd_mph = conv_mps_to_mph(wind_spd_mps)
    ) |>
    
    dplyr::select(
      meta_station_name,
      datetime,
      meta_bat_volt,
      precip_total_in,
      relative_humidity,
      sol_rad_Wm2,
      temp_airF,
      dwptF,
      temp_air_maxF,
      temp_air_minF,
      temp_panelF,
      temp_wetbulbF,
      temp_soil_10cmF,
      temp_soil_50cmF,
      vp_saturation,
      vp_actual,
      vp_deficit,
      wind_spd_mph,
      wind_vector_dir,
      wind_spd_max_mph,
      wind_2min_spd_mean_mph,
      wind_2min_vector_dir,
      wind_2min_spd_max_mph_daily,
      wind_2min_vector_dir_max_daily,
      wind_2min_spd_max_mph_hourly,
      wind_2min_vector_dir_max_hourly
    ) |>
    
    dplyr::arrange(meta_station_name)
  
  p <- 
    ggplot2::ggplot() +
    ggplot2::geom_col(
      data = dplyr::filter(tib, meta_station_name != azmetStationGroup),
      mapping = ggplot2::aes(x = meta_station_name, y = .data[[stationVariable]], fill = relative_humidity)
    ) +
    ggplot2::geom_col(
      data = dplyr::filter(tib, meta_station_name == azmetStationGroup),
      mapping = ggplot2::aes(x = meta_station_name, y = .data[[stationVariable]]), fill = "red"
    )
  
  return(p)
}
