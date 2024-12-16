#' `networkWideTableHelpText.R` - Build help text for network-wide table
#' 
#' @return `networkWideTableHelpText` - Help text for network-wide table


networkWideTableHelpText <- function() {
  networkWideTableHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Scroll over the table to view additional rows and columns."
      ), 
      
      class = "network-wide-table-help-text"
    )
  
  return(networkWideTableHelpText)
}
