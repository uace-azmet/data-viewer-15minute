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
    
    htmltools::p(
      bsicons::bs_icon("sliders"), 
      htmltools::HTML("&nbsp;"), 
      "DATA DISPLAY",
      htmltools::HTML("&nbsp;&nbsp;&nbsp;&nbsp;"),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Specify a station group to highlight and variable to show in the graph.",
        id = "infoDataOptions",
        placement = "right"
      ),
      
      class = "sls-data-display-title"
    ),
    
    shiny::selectInput(
      inputId = "azmetStationGroup", 
      label = "AZMet Station Group",
      choices = NULL, # see `app.R`, shiny::updateSelectInput(inputId = "azmetStationGroup")
      selected = NULL # see `app.R`, shiny::updateSelectInput(inputId = "azmetStationGroup")
    ),
    
    shiny::selectInput(
      inputId = "stationVariable", 
      label = "Station Variable",
      choices = NULL, # see `app.R`, shiny::updateSelectInput(inputId = "stationVariable")
      selected = NULL # see `app.R`, shiny::updateSelectInput(inputId = "stationVariable")
    ),
    
    htmltools::p(
      bsicons::bs_icon("layers"), 
      htmltools::HTML("&nbsp;"), 
      "STATION GROUPS",
      htmltools::HTML("&nbsp;&nbsp;&nbsp;&nbsp;"),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Stations are grouped by general proximity, as listed below. Scroll or swipe over the table to view additional columns.",
        id = "infoStationGroups",
        placement = "right"
      ),
      
      class = "station-groups-title"
    ),
    
    reactable::reactableOutput(outputId = "stationGroupsTable")
  ) # bslib::sidebar()
