#' `fxn_nwsTableFooter.R` - Build footer for network-wide summary table
#' 
#' @return `nwsTableFooter` - Footer for network-wide summary table


fxn_nwsTableFooter <- function() {
  nwsTableFooter <- 
    htmltools::p(
      htmltools::HTML(
        "<sup>1</sup> Since midnight local time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>2</sup> Since the top of the hour<br><br>Variable key: <strong>Batt</strong> meta_bat_volt; <strong>P</strong><sup>1</sup> precip_total_in; <strong>RH</strong> relative_humidity; <strong>SR</strong> sol_rad_Wm2; <strong>T</strong> temp_airF; <strong>T<sub>max</sub></strong><sup>1</sup> temp_air_maxF; <strong>T<sub>min</sub></strong><sup>1</sup> temp_air_minF; <strong>T<sub>panel</sub></strong> temp_panelF; <strong>T<sub>dew point</sub></strong> dwptF; <strong>T<sub>wetbulb</sub></strong> temp_wetbulbF; <strong>T<sub>soil 4-inch</sub></strong> temp_soil_10cmF; <strong>T<sub>soil 20-inch</sub></strong> temp_soil_50cmF; <strong>VP<sub>actual</sub></strong> vp_actual; <strong>VP<sub>deficit</sub></strong> vp_deficit; <strong>VP<sub>saturation</sub></strong> vp_saturation; <strong>WD</strong> wind_vector_dir; <strong>WD<sub>2-min</sub></strong> wind_2min_vector_dir; <strong>WD<sub>2-min max</sub></strong><sup>1</sup> wind_2min_vector_dir_max_daily; <strong>WD<sub>2-min max</sub></strong><sup>2</sup> wind_2min_vector_dir_max_hourly; <strong>WS</strong> wind_spd_mph; <strong>WS<sub>max</sub></strong><sup>1</sup> wind_spd_max_mph; <strong>WS<sub>2-min</sub></strong> wind_2min_spd_mean_mph; <strong>WS<sub>2-min max</sub></strong><sup>1</sup> wind_2min_spd_max_mph_daily; <strong>WS<sub>2-min max</sub></strong><sup>2</sup> wind_2min_spd_max_mph_hourly"
      ),
      
      class = "nws-table-footer"
    )
  
  return(nwsTableFooter)
}
