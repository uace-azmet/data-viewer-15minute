#' `fxn_slsGraph.R` Generate time series graph based on user input
#' 
#' @param inData - AZMet 15-minute data from `fxn_az15min.R`
#' @param stationGroup - user-specified AZMet station group
#' @param stationVariable - user-specified weather variable
#' @return `slsGraph` - time series graph based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596
# https://www.color-hex.com/color-palette/1041718


fxn_slsGraph <- function(inData, azmetStationGroup, stationVariable) {
  
  
  # Input variables -----
  
  inData <- inData |>
    dplyr::mutate(datetime = lubridate::ymd_hms(datetime))
  
  dataOtherGroups <- inData %>% 
    dplyr::filter(meta_station_group != azmetStationGroup) %>% 
    dplyr::group_by(meta_station_name)
  
  dataSelectedGroup <- inData %>% 
    dplyr::filter(meta_station_group == azmetStationGroup) %>% 
    dplyr::arrange(meta_station_name)
  
  hoverlabelFontColor = "#191919"
  hoverlabelFontSize = 14
  layoutFontColor = "#191919"
  layoutFontFamily = "proxima-nova, calibri, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\""
  layoutFontSize = 13
  
  
  # Graph -----
  
  slsGraph <- 
    plotly::plot_ly( # Lines and points for `dataOtherGroups`
      data = dataOtherGroups,
      x = ~datetime,
      y = ~.data[[stationVariable]],
      type = "scatter",
      mode = "lines+markers",
      #color = "rgba(201, 201, 201, 1.0)",
      marker = list(color = "rgba(201, 201, 201, 1.0)", size = 3),
      line = list(color = "rgba(201, 201, 201, 1.0)", width = 1),
      name = "other stations",
      hoverinfo = "text",
      text = 
        ~paste0(
          "<br><b>", stationVariable, ":</b> ", .data[[stationVariable]],
          "<br><b>AZMet Station:</b> ", meta_station_name,
          "<br><b>Date:</b> ", gsub(" 0", " ", format(datetime, "%b %d, %Y")),
          "<br><b>Time:</b> ", format(datetime, "%H:%M:%S")
        ),
      showlegend = TRUE,
      legendgroup = "dataOtherStations",
      legendrank = 2
    ) %>% 
    
    plotly::add_trace( # Lines and points for `dataSelectedGroup`
      inherit = FALSE,
      data = dataSelectedGroup,
      x = ~datetime,
      y = ~.data[[stationVariable]],
      type = "scatter",
      mode = "lines+markers",
      #color = ~meta_station_name,
      marker = list(size = 3),
      line = list(color = ~meta_station_name, width = 1.5),
      name = ~meta_station_name,
      hoverinfo = "text",
      text = 
        ~paste0(
          "<br><b>", stationVariable, ":</b> ", .data[[stationVariable]],
          "<br><b>AZMet Station:</b> ", meta_station_name,
          "<br><b>Date:</b> ", gsub(" 0", " ", format(datetime, "%b %d, %Y")),
          "<br><b>Time:</b> ", format(datetime, "%H:%M:%S")
        ),
      showlegend = TRUE,
      legendgroup = "metaStationName",
      legendrank = 1
    ) %>% 
    
    plotly::config(
      displaylogo = FALSE,
      displayModeBar = TRUE,
      modeBarButtonsToRemove = 
        c(
          "autoScale2d",
          "hoverClosestCartesian", 
          "hoverCompareCartesian", 
          "lasso2d",
          "select"
        ),
      scrollZoom = FALSE,
      toImageButtonOptions = 
        list(
          format = "png", # Either png, svg, jpeg, or webp
          filename = "AZMet-data-viewer-15minute-station-level-summaries",
          height = 400,
          width = 700,
          scale = 5
        )
    ) %>%
    
    plotly::layout(
      font = list(color = layoutFontColor, family = layoutFontFamily, size = layoutFontSize),
      hoverlabel = list(
        font = list(color = hoverlabelFontColor, family = layoutFontFamily, size = hoverlabelFontSize)
      ),
      legend = 
        list(
          groupclick = "toggleitem",
          orientation = "h",
          traceorder = "normal",
          x = 0.00,
          xanchor = "left",
          xref = "container",
          y = 1.05,
          yanchor = "bottom",
          yref = "container"
        ),
      margin = 
        list(
          l = 0,
          r = 50, # For space between plot and modebar
          b = 80, # For space between x-axis title and caption or figure help text
          t = 0,
          pad = 0
        ),
      modebar = list(bgcolor = "#FFFFFF", orientation = "v"),
      xaxis = 
        list(
          range = list(~(min(datetime) - 3000), ~(max(datetime) + 3000)), # unix timestamp values
          title = 
            list(
              font = list(size = 14),
              standoff = 25,
              text = "<b>Date and Time</b>"
            ),
          zeroline = FALSE
        ),
      yaxis = 
        list(
          title = list(
            font = list(size = 14),
            standoff = 25,
            text = ~paste0("<b>", stationVariable, "</b>")
          ),
          zeroline = FALSE
        )
    )
  
  return(slsGraph)
}
