#' `networkWideTableTitle.R` - Build title for network-wide table
#' 
#' @return `tableTitle` - Title for network-wide table


networkWideTableTitle <- function() {
  networkWideTableTitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          bsicons::bs_icon("table"), 
          htmltools::HTML("&nbsp;"),
          htmltools::HTML("&nbsp;"),
          toupper("The latest 15-minute data from across the network")
        ),
      ),
      
      class = "table-title"
    )
  
  return(networkWideTableTitle)
}
