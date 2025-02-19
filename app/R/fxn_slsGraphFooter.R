#' `fxn_slsGraphFooter.R` - Build footer for station-level-summaries time series
#' 
#' @return `slsGraphFooter` - Footer for station-level-summaries time series


fxn_slsGraphFooter <- function() {
  slsGraphFooter <- 
    htmltools::p(
      htmltools::HTML(
        "<sup>1</sup> Since midnight local time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>2</sup> Since the top of the hour"
      ), 
      
      class = "sls-graph-footer"
    )
  
  return(slsGraphFooter)
}
