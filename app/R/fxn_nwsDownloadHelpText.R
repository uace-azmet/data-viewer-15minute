#' `fxn_nwsDownloadHelpText.R` - Build help text for download .tsv button
#' 
#' @return `nwsDownloadHelpText` - Help text for download .tsv button


fxn_nwsDownloadHelpText <- function() {
  nwsDownloadHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the buttons below to download a file of the above data with either comma- or tab-separated values."
      ), 
      
      class = "download-help-text"
    )
  
  return(nwsDownloadHelpText)
}
