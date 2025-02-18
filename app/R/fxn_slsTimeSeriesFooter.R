#' `fxn_slsTimeSeriesFooter.R` - Build footer for station-level-summaries time series
#' 
#' @return `slsTimeSeriesFooter` - Footer for station-level-summaries time series


fxn_slsTimeSeriesFooter <- function() {
  slsTimeSeriesFooter <- 
    htmltools::p(
      htmltools::HTML(
        "<sup>1</sup> Since midnight local time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>2</sup> Since the top of the hour"
      ), 
      
      class = "sls-time-series-footer"
    )
  
  return(slsTimeSeriesFooter)
}
