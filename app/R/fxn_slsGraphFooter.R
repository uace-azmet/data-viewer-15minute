#' `fxn_slsGraphFooter.R` - Build footer for station-level-summaries time series
#' 
#' @return `slsGraphFooter` - Footer for station-level-summaries time series


fxn_slsGraphFooter <- function() {
  slsGraphFooter <- 
    htmltools::p(
      htmltools::HTML(
        "Since midnight local time: precip_total_in; temp_air_maxF; temp_air_minF; wind_2min_spd_max_mph_daily; wind_2min_vector_dir_max_daily; wind_spd_max_mph<br><br>Since the top of the hour: wind_2min_spd_max_mph_hourly; wind_2min_vector_dir_max_hourly"
      ), 
      
      class = "sls-graph-footer"
    )
  
  return(slsGraphFooter)
}
