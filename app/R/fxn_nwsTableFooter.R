#' `fxn_nwsTableFooter.R` - Build footer for network-wide summary table
#' 
#' @return `nwsTableFooter` - Footer for network-wide summary table


fxn_nwsTableFooter <- function() {
  nwsTableFooter <- 
    htmltools::p(
      htmltools::HTML(
        "<sup>1</sup> Since midnight local time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>2</sup> Since the top of the hour"
      ), 
      
      class = "nws-table-footer"
    )
  
  return(nwsTableFooter)
}
