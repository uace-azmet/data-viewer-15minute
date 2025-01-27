#' `fxn_slsRefreshHelpText.R` - Build help text for button to refresh data on station-level summaries tab
#' 
#' @return `slsRefreshHelpText` - Help text for button to refresh data on station-level summaries tab


fxn_slsRefreshHelpText <- function() {
  slsRefreshHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the button below to refresh the above graph with the latest 15-minute data."
      ), 
      
      class = "refresh-help-text"
    )
  
  return(slsRefreshHelpText)
}
