#' `fxn_downloadButtonsDiv.R` - Build HTML div for download .csv and .tsv buttons
#' 
#' @param activeTab - currently active tab in user session
#' @return `downloadButtonsDiv` - HTML div for download .csv and .tsv buttons


fxn_downloadButtonsDiv <- function(activeTab) {
  if (activeTab == "network-wide-summary") {
    downloadButtonsDiv <- 
      htmltools::div(
        shiny::downloadButton(
          "nwsDownloadCSV", 
          label = "Download .csv", 
          class = "btn btn-default btn-blue", 
          type = "button"
        ),
        shiny::downloadButton(
          "nwsDownloadTSV", 
          label = "Download .tsv", 
          class = "btn btn-default btn-blue", 
          type = "button"
        ),
        htmltools::HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"),
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Click or tap to download a file of the above data with either comma- or tab-separated values.",
          id = "nwsDownloadInfo",
          placement = "right"
        ),
        
        style = "display: flex; align-items: top; gap: 0px;", # Flexbox styling
      )
  } else if (activeTab == "station-level-summaries") {
    downloadButtonsDiv <-
      htmltools::div(
        shiny::downloadButton(
          outputId = "slsDownloadCSV", 
          label = "Download .csv", 
          class = "btn btn-default btn-blue", 
          type = "button"
        ),
        shiny::downloadButton(
          outputId = "slsDownloadTSV", 
          label = "Download .tsv", 
          class = "btn btn-default btn-blue", 
          type = "button"
        ),
        htmltools::HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"),
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Click or tap to download a file of the above data with either comma- or tab-separated values.",
          id = "slsDownloadInfo",
          placement = "right"
        ),
        
        style = "display: flex; align-items: top; gap: 0px;", # Flexbox styling
      )
  }
  
  return(downloadButtonsDiv)
}
