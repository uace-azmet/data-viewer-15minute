#' `fxn_dataDownloadHelpText.R` - Build help text for download .csv and .tsv buttons
#' 
#' @return `dataDownloadHelpText` - Help text for download .csv and .tsv buttons


fxn_dataDownloadHelpText <- function() {
  dataDownloadHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Click or tap the buttons below to download a file of the above data with either comma- or tab-separated values."
      ), 
      
      class = "data-download-help-text"
    )
  
  return(dataDownloadHelpText)
}
