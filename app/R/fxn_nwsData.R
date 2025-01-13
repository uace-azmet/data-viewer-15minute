#' `fxn_nwsData.R` - Filter 15-minute data for the most recent report from each station
#' 
#' @param inData - AZMet 15-minute data from `fxn_dataETL.R`
#' @return `nwsData` - Most recent data from each station, tibble format


fxn_nwsData <- function(inData) {
  nwsData <- inData |>
    dplyr::group_by(meta_station_name) |>
    dplyr::filter(datetime == max(datetime)) |>
    dplyr::ungroup() |>
    dplyr::select(!meta_station_group) |>
    
    dplyr::mutate(
      dplyr::across(
        c(
          "relative_humidity",
          "wind_vector_dir",
          "wind_2min_vector_dir",
          "wind_2min_vector_dir_max_daily",
          "wind_2min_vector_dir_max_hourly"
        ),
        \(x) round(x, digits = 0)
      )
    ) |>
    
    dplyr::mutate(
      dplyr::across(
        c(
          "temp_airF",
          "dwptF",
          "temp_air_maxF",
          "temp_air_minF",
          "temp_panelF",
          "temp_wetbulbF",
          "temp_soil_10cmF",
          "temp_soil_50cmF",
          "wind_spd_mph",
          "wind_spd_max_mph",
          "wind_2min_spd_mean_mph",
          "wind_2min_spd_max_mph_daily",
          "wind_2min_spd_max_mph_hourly"
        ),
        \(x) round(x, digits = 1)
      )
    ) |>
    
    dplyr::mutate(
      dplyr::across(
        c(
          "meta_bat_volt",
          "precip_total_in",
          "sol_rad_Wm2",
          "vp_saturation",
          "vp_actual",
          "vp_deficit"
        ),
        \(x) round(x, digits = 2)
      )
    )
    
  return(nwsData)
}
