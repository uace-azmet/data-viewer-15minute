#' `fxn_slsGraphTitle.R` - Build title for station-level summaries graph
#' 
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `slsGraphTitle` - Title for station-level summaries graph


fxn_slsGraphTitle <- function(startDate, endDate) {
  slsGraphTitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          bsicons::bs_icon("graph-up", class = "bolder-icon"),
          htmltools::HTML("&nbsp;&nbsp;"),
          toupper(
            paste0(
              "<strong>15-minute data from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " and across the network</strong>"
            )
          ),
          htmltools::HTML("&nbsp;")
        )
      ),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Hover over data for variable values and click or tap on legend items to toggle data visibility. Select from the icons to the right of the graph for additional functionality.",
        id = "infoSlsGraphTitle",
        placement = "right"
      ),
      
      class = "sls-graph-title"
    )
  
  return(slsGraphTitle)
}
