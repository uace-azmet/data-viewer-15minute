#' `fxn_nwsTableTitle.R` - Build title for network-wide summary table
#' 
#' @param endDate - End date of period of interest
#' @return `nwsTableTitle` - Title for network-wide summary table


fxn_nwsTableTitle <- function(endDate) {
  
  nwsTableTitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          bsicons::bs_icon("table"), 
          htmltools::HTML("&nbsp;&nbsp;"),
          htmltools::HTML(
            toupper(
              paste0(
                "<strong>The latest 15-minute data on ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " from across the network</strong>"
              )
            )
          )
        )
      ),
      htmltools::HTML("&nbsp;"),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Scroll or swipe over the table to view additional rows and columns.",
        id = "infoNwsTableTitle",
        placement = "right"
      ),
      
      class = "nws-table-title"
    )
  
  return(nwsTableTitle)
}
