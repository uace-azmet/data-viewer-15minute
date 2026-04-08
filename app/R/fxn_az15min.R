#' `fxn_az15min.R` Download AZMet 15-minute data, transform variables, and return to app
#' 
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `az15min` - Downloaded 15-minute data and transformed variables over period of interest, tibble format


fxn_az15min <- function(startDate, endDate) {
  
  if (endDate == lubridate::today(tzone = "America/Phoenix")) {
    az15min <- 
      azmetr::az_15min(
        start_date_time = paste(startDate, "00"),
        end_date_time = endDate
      )
  } else {
    az15min <- 
      azmetr::az_15min(
        start_date_time = paste(startDate, "00"),
        end_date_time = paste(endDate, "24")
      )
  }
  
  az15min <- az15min |>
    dplyr::mutate(
      temp_soil_10cmC = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_10cmC
      ),
      temp_soil_50cmC = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_50cmC
      )
    ) |>
    
    dplyr::mutate(
      datetime = format(datetime, format = "%Y-%m-%d %H:%M:%S"),
      dwptF = fxn_c_to_f(dwpt),
      precip_total_in = fxn_mm_to_in(precip_total_mm),
      sol_rad_Wm2 = fxn_kwm2_to_wm2(sol_rad_kWm2),
      temp_airF = fxn_c_to_f(temp_airC),
      temp_air_maxF = fxn_c_to_f(temp_air_maxC),
      temp_air_minF = fxn_c_to_f(temp_air_minC),
      temp_panelF = fxn_c_to_f(temp_panelC),
      temp_soil_10cmF = fxn_c_to_f(temp_soil_10cmC),
      temp_soil_50cmF = fxn_c_to_f(temp_soil_50cmC),
      temp_wetbulbF = fxn_c_to_f(temp_wetbulbC),
      wind_2min_spd_max_mph_daily = fxn_mps_to_mph(wind_2min_spd_max_mps_daily),
      wind_2min_spd_max_mph_hourly = fxn_mps_to_mph(wind_2min_spd_max_mps_hourly),
      wind_2min_spd_mean_mph = fxn_mps_to_mph(wind_2min_spd_mean_mps),
      wind_spd_max_mph = fxn_mps_to_mph(wind_spd_max_mps),
      wind_spd_mph = fxn_mps_to_mph(wind_spd_mps)
    ) |>
    
    dplyr::mutate(
      meta_station_group = dplyr::if_else(
        meta_station_name %in% c("Ft Mohave CA", "Mohave", "Mohave ETo", "Mohave-2", "Parker", "Parker-2"),
        "Group 1",
        dplyr::if_else(
          meta_station_name %in% c("Roll", "Wellton ETo", "Yuma N.Gila", "Yuma South", "Yuma Valley", "Yuma Valley ETo"),
          "Group 2",
          dplyr::if_else(
            meta_station_name %in% c("Aguila", "Buckeye", "Harquahala", "Maricopa", "Paloma", "Salome"),
            "Group 3",
            dplyr::if_else(
              meta_station_name %in% c("Chino Valley", "Desert Ridge", "Payson", "Phoenix Encanto", "Phoenix Greenway"),
              "Group 4",
              dplyr::if_else(
                meta_station_name %in% c("Coolidge", "Elgin", "Maricopa", "Queen Creek", "Sahuarita", "Test", "Tucson"),
                "Group 5",
                "Group 6"
              )
            )
          )
        )
      )
    ) |>
    
    dplyr::select(
      meta_station_group,
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
      vp_actual,
      vp_deficit,
      vp_saturation,
      wind_spd_mph,
      wind_vector_dir,
      wind_spd_max_mph,
      wind_2min_spd_mean_mph,
      wind_2min_vector_dir,
      wind_2min_spd_max_mph_daily,
      wind_2min_vector_dir_max_daily,
      wind_2min_spd_max_mph_hourly,
      wind_2min_vector_dir_max_hourly
    )   |>
    
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
    ) |>
    
    dplyr::arrange(meta_station_name)
  
  return(az15min)
}
