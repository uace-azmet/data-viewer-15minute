#' `fxn_nwsRefreshHelpText.R` - Build help text for button to refresh data on network-wide summary tab
#' 
#' @return `nwsRefreshHelpText` - Help text for button to refresh data on network-wide summary tab


fxn_nwsRefreshHelpText <- function() {
  nwsRefreshHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the button below to refresh the above table with the latest 15-minute data."
      ), 
      
      class = "nws-refresh-help-text"
    )
  
  return(nwsRefreshHelpText)
}
