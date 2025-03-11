#' `fxn_refreshDataHelpText.R` - Build help text for button to refresh data
#' 
#' @return `refreshDataHelpText` - Help text for button to refresh data


fxn_refreshDataHelpText <- function() {
  refreshDataHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the button below to refresh the above table with the latest 15-minute data."
      ), 
      
      class = "refresh-data-help-text"
    )
  
  return(refreshDataHelpText)
}
