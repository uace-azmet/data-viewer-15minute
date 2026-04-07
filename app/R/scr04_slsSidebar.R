slsSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = list(desktop = "open", mobile = "always-above"),
    id = "sidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#191919", # https://www.color-hex.com/color-palette/1041718
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    bslib::accordion(
      id = "timeseriesAccordion",
      #open = "DATE SELECTION",
      #multiple = TRUE,
      class = NULL,
      width = "auto",
      height = "auto",
      
      
      # Visible elements -----
      
      htmltools::p(
        bsicons::bs_icon("sliders", class = "bolder-icon"), 
        htmltools::HTML("&nbsp;<strong>DATA DISPLAY</strong>&nbsp;"),
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Specify a station group to highlight and variable to show in the graph.",
          id = "infoDataOptions",
          placement = "right"
        ),
        
        class = "sls-data-display-title"
      ),
      
      shiny::selectInput(
        inputId = "stationGroup", 
        label = "Station Group",
        choices = c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6"),
        selected = c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6")[1]
      ),
      
      shiny::selectInput(
        inputId = "stationVariable", 
        label = "Station Variable",
        choices = az15minStationVariables,
        selected = az15minStationVariables[1]
      ),
      
      htmltools::p(
        bsicons::bs_icon("layers", class = "bolder-icon"), 
        htmltools::HTML("&nbsp;<strong>STATION GROUPS</strong>&nbsp;"),
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Stations are grouped by general proximity, as listed below. Scroll or swipe over the table to view additional columns.",
          id = "infoStationGroups",
          placement = "right"
        ),
        
        class = "station-groups-title"
      ),
      
      reactable::reactableOutput(outputId = "stationGroupsTable")
    ) # bslib::accordion()
  ) # bslib::sidebar()
