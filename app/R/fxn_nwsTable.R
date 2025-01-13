#' `fxn_nwsTable.R` - Build network-wide summary table
#' 
#' @param inData - Most recent AZMet 15-minute data from `fxn_nwsData.R`
#' @return `nwsTable` - Network-wide summary table, reactable format


fxn_nwsTable <- function(inData) {
  nwsTable <- inData |>
    reactable::reactable(
      columns = list(
        meta_station_name = reactable::colDef(
          name = "Station",
          minWidth = 150,
          #aggregate = NULL,
          #sortable = NULL,
          #resizable = NULL,
          #filterable = NULL,
          #searchable = NULL,
          #filterMethod = NULL,
          #show = TRUE,
          #defaultSortOrder = NULL,
          #sortNALast = FALSE,
          #format = NULL,
          #cell = NULL,
          #grouped = NULL,
          #aggregated = NULL,
          #header = NULL,
          #footer = NULL,
          #details = NULL,
          #filterInput = NULL,
          html = TRUE,
          na = "NA",
          rowHeader = TRUE,
          #minWidth = 100,
          #maxWidth = NULL,
          #width = NULL,
          #align = NULL,
          #vAlign = NULL,
          #headerVAlign = NULL,
          sticky = "left"
          #class = NULL,
          #style = NULL,
          #headerClass = NULL,
          #headerStyle = NULL,
          #footerClass = NULL,
          #footerStyle = NULL
        ), 
        datetime = reactable::colDef(
          name = "Latest Update",
          html = TRUE,
          minWidth = 150,
          na = "NA",
          rowHeader = TRUE
        ),
        meta_bat_volt = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "Batt<br>", tags$span(style = "font-weight: normal; font-size: 0.8rem", "(V)")
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        precip_total_in = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "P<sup>", 
                tags$span(style = "font-weight: normal", "1"), 
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(in)")
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        relative_humidity = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "RH<br>", tags$span(style = "font-weight: normal; font-size: 0.8rem", "(%)")
              )
            ),
          format = reactable::colFormat(digits = 0),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        sol_rad_Wm2 = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "SR<br>", 
                tags$span(
                  style = "font-weight: normal; font-size: 0.8rem",
                  htmltools::HTML("(W/m<sup>2</sup>)")
                )
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_airF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<br>", tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        dwptF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>dew point</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_air_maxF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>max</sub><sup>", 
                tags$span(style = "font-weight: normal", "1"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_air_minF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>min</sub><sup>", 
                tags$span(style = "font-weight: normal", "1"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_panelF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>panel</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_wetbulbF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>wetbulb</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_soil_10cmF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>soil 4-inch</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        temp_soil_50cmF = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "T<sub>soil 20-inch</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(°F)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        vp_saturation = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "VP<sub>saturation</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(kPa)")
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        vp_actual = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "VP<sub>actual</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(kPa)")
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        vp_deficit = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "VP<sub>deficit</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(kPa)")
              )
            ),
          format = reactable::colFormat(digits = 2),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_spd_mph = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WS<br>", tags$span(style = "font-weight: normal; font-size: 0.8rem", "(mph)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_vector_dir = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WD<br>", tags$span(style = "font-weight: normal; font-size: 0.8rem", "(deg)")
              )
            ),
          format = reactable::colFormat(digits = 0),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_spd_max_mph = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WS<sub>max</sub><sup>", 
                tags$span(style = "font-weight: normal", "1"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(mph)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_spd_mean_mph = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WS<sub>2-min</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(mph)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_vector_dir = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WD<sub>2-min</sub><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(deg)")
              )
            ),
          format = reactable::colFormat(digits = 0),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_spd_max_mph_daily = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WS<sub>2-min max</sub><sup>", 
                tags$span(style = "font-weight: normal", "1"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(mph)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_vector_dir_max_daily = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WD<sub>2-min max</sub><sup>", 
                tags$span(style = "font-weight: normal", "1"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(deg)")
              )
            ),
          format = reactable::colFormat(digits = 0),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_spd_max_mph_hourly = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WS<sub>2-min max</sub><sup>", 
                tags$span(style = "font-weight: normal", "2"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(mph)")
              )
            ),
          format = reactable::colFormat(digits = 1),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        ),
        wind_2min_vector_dir_max_hourly = reactable::colDef(
          name = 
            htmltools::HTML(
              paste0(
                "WD<sub>2-min max</sub><sup>", 
                tags$span(style = "font-weight: normal", "2"),
                "</sup><br>", 
                tags$span(style = "font-weight: normal; font-size: 0.8rem", "(deg)")
              )
            ),
          format = reactable::colFormat(digits = 0),
          html = TRUE,
          na = "NA",
          rowHeader = TRUE
        )
      ),
      #columnGroups = NULL,
      rownames = FALSE,
      #groupBy = NULL,
      sortable = FALSE,
      resizable = FALSE,
      filterable = FALSE,
      searchable = FALSE,
      searchMethod = NULL,
      #defaultColDef = NULL,
      #defaultColGroup = NULL,
      #defaultSortOrder = "asc",
      #defaultSorted = NULL,
      pagination = FALSE,
      #defaultPageSize = 10,
      showPageSizeOptions = FALSE,
      #pageSizeOptions = c(10, 25, 50, 100),
      #paginationType = "numbers",
      showPagination = NULL,
      showPageInfo = FALSE,
      #minRows = 1,
      #paginateSubRows = FALSE,
      #details = NULL,
      defaultExpanded = TRUE,
      selection = NULL,
      defaultSelected = NULL,
      onClick = NULL,
      highlight = TRUE,
      outlined = FALSE,
      bordered = TRUE,
      #borderless = FALSE,
      striped = TRUE,
      compact = TRUE,
      #wrap = TRUE,
      #showSortIcon = TRUE,
      #showSortable = FALSE,
      #class = NULL,
      #style = NULL,
      #style = list(fontFamily = "Work Sans, sans-serif", fontSize = "0.875rem"),
      #style = list(fontFamily = "monospace", fontSize = "0.875rem"),
      #rowClass = NULL,
      #rowStyle = NULL,
      fullWidth = TRUE,
      width = "auto",
      height = 400,
      theme = 
        reactable::reactableTheme(
          color = NULL,
          backgroundColor = NULL,
          borderColor = NULL,
          borderWidth = NULL,
          stripedColor = NULL,
          highlightColor = NULL,
          cellPadding = NULL,
          style = NULL,
          tableStyle = NULL,
          headerStyle = NULL,
          groupHeaderStyle = NULL,
          tableBodyStyle = NULL,
          rowGroupStyle = NULL,
          rowStyle = NULL,
          rowStripedStyle = NULL,
          rowHighlightStyle = NULL,
          rowSelectedStyle = NULL,
          #cellStyle = list(fontFamily = "monospace", fontSize = "0.8rem"),
          footerStyle = NULL,
          inputStyle = NULL,
          filterInputStyle = NULL,
          searchInputStyle = NULL,
          selectStyle = NULL,
          paginationStyle = NULL,
          pageButtonStyle = NULL,
          pageButtonHoverStyle = NULL,
          pageButtonActiveStyle = NULL,
          pageButtonCurrentStyle = NULL
        ),
      #language = getOption("reactable.language"),
      #meta = NULL,
      #elementId = NULL,
      #  static = getOption("reactable.static", FALSE)
      #selectionId = NULL
    )
  
  return(nwsTable)
}
