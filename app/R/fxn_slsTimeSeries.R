#' `fxn_slsTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - AZMet 15-minute data from `fxn_dataETL.R`
#' @param azmetStation - user-specified AZMet station
#' @param stationVariable - user-specified weather variable
#' @return `slsTimeSeries` - time series graphs based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596
# https://www.color-hex.com/color-palette/1041718


fxn_slsTimeSeries <- function(inData, azmetStationGroup, stationVariable) {
  inData <- inData |>
    dplyr::mutate(datetime = lubridate::ymd_hms(datetime))
  
  #xAxisVariable <- dplyr::filter(dataVariables, name == "datetime")$variable
  xAxisVariable <- "datetime"
  xAxisUnits <- "ymd hms"
  
  yAxisVariable <- dplyr::filter(dataVariables, name == stationVariable)$variable
  yAxisUnits <- dplyr::filter(dataVariables, name == stationVariable)$units
  
  slsTimeSeries <- 
    ggplot2::ggplot() +
    
    # Background data -----
    
    ggplot2::geom_line(
      data = dplyr::filter(inData, meta_station_group != azmetStationGroup),
      mapping = 
        ggplot2::aes(
          x = datetime, 
          y = .data[[stationVariable]], 
          group = meta_station_name
        ), 
      color = "#c9c9c9",
      lineend = "round",
      linewidth = 0.3
    ) +
    ggplot2::geom_point(
      data = dplyr::filter(inData, meta_station_group != azmetStationGroup),
      mapping = ggplot2::aes(
        x = datetime, 
        y = .data[[stationVariable]]
      ),
      color = "#c9c9c9",
      fill = "#c9c9c9",
      shape = 21, 
      size = 0.5,
      stroke = 0.3
    ) +
    
    # Foreground data -----
  
    ggplot2::geom_line(
      data = dplyr::filter(inData, meta_station_group == azmetStationGroup),
      mapping = ggplot2::aes(
        x = datetime, 
        y = .data[[stationVariable]],
        color = meta_station_name,
        group = meta_station_name
      ),
      lineend = "round",
      linewidth = 0.6
    ) +
    ggplot2::geom_point(
      data = dplyr::filter(inData, meta_station_group == azmetStationGroup),
      mapping = ggplot2::aes(
        x = datetime, 
        y = .data[[stationVariable]],
        color = meta_station_name,
        fill = meta_station_name
      ),
      shape = 21, 
      size = 0.8,
      stroke = 0.3
    ) +
    ggplot2::scale_color_brewer(type = "qual", palette = "Dark2") +
    ggplot2::scale_fill_brewer(type = "qual", palette = "Dark2") +
    
    # Format -----
    
    ggplot2::labs(
      x = paste0("\n", xAxisVariable, " (", xAxisUnits, ")"),
      y = paste0(yAxisVariable, " (", yAxisUnits, ")", "\n")
    ) +
    ggplot2::scale_x_datetime(
      breaks = seq(
        from = 
          lubridate::ymd_hms(
            paste(
              lubridate::date(min(inData$datetime)), "00:00:00", sep = " "
            )
          ),
        to = 
          lubridate::ymd_hms(
            paste(
              lubridate::date(max(inData$datetime)) + 1, "00:00:00", sep = " "
            )
          ), 
        by = "12 hours"
      ),
      limits = c(
        lubridate::ymd_hms(min(inData$datetime)),
        lubridate::ymd_hms(max(inData$datetime))
      ),
      expand = expansion(mult = 0.01, add = 0.0)
    ) +
    ggplot2::scale_y_continuous(expand = expansion(mult = 0.01, add = 0.0)) +
    ggplot2::theme_minimal() +
    ggplot2::theme( # https://ggplot2.tidyverse.org/reference/theme.html
      axis.line.x.bottom = element_blank(),
      axis.text = element_text(
        color = "#606060", 
        face = "plain", 
        #family = "monospace",
        size = 10
      ),
      axis.title = element_text(
        color = "#606060", 
        face = "plain", 
        hjust = 0.0, 
        margin = margin(t = 0.2, r = 0, b = 0, l = 0, unit = "cm"),
        size = 10
      ),
      legend.background = element_rect(colour = NA, fill = "#FFFFFF"),
      legend.direction = "horizontal",
      legend.justification = "left",
      legend.key.width = unit(3, "line"),
      legend.margin = margin(t = 0.0, r = 0, b = 0.0, l = -0.3, unit = "cm"),
      legend.position = "top",
      legend.text = element_text(color = "#191919", size = 12),
      legend.title = element_blank()
    )
  
  return(slsTimeSeries)
}
