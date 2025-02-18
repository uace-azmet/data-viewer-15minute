#' `fxn_slsDownloadHelpText.R` - Build help text for download .tsv button on station-level summaries
#' 
#' @return `slsDownloadHelpText` - Help text for download .tsv button on station-level summaries


fxn_slsDownloadHelpText <- function() {
  slsDownloadHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the buttons below to download a file of the above data with either comma- or tab-separated values."
      ), 
      
      class = "download-help-text"
    )
  
  return(slsDownloadHelpText)
}
