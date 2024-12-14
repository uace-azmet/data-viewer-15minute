#' `networkWideTableFooter.R` - Build footer for network-wide table
#' 
#' @return `networkWideTableFooter` - Footer for network-wide table


networkWideTableFooter <- function() {
  networkWideTableFooter <- 
    htmltools::p(
      htmltools::HTML(
        "<sup>1</sup> Since midnight local time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>2</sup> Since the top of the hour"
      ), 
      
      class = "network-wide-table-footer"
    )
  
  return(networkWideTableFooter)
}
