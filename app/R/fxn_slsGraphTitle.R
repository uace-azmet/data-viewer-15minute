#' `fxn_slsGraphTitle.R` - Build title for station-level summaries graph
#' 
#' @return `slsGraphTitle` - Title for station-level summaries graph


fxn_slsGraphTitle <- function() {
  slsGraphTitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          bsicons::bs_icon("graph-up", class = "bolder-icon"),
          htmltools::HTML("&nbsp;&nbsp;"),
          toupper("<strong>15-minute data over the period of interest from across the network</strong>"),
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
