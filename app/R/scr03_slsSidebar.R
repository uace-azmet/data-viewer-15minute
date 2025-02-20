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
      "DATA DISPLAY"
    ),
    
    shiny::helpText(shiny::em(
      "Specify a station group to highlight and variable to show in the graph."
    )),
    
    shiny::selectInput(
      inputId = "azmetStationGroup", 
      label = "AZMet Station Group",
      #choices = sort(unique(azmetStations$stationGroup)),
      choices = sort(unique(azmetStations$stationName)),
      selected = "Group 1"
    ),
    
    shiny::selectInput(
      inputId = "stationVariable", 
      label = "Station Variable",
      #choices = sort(unique(dataVariablesDropdown$variable)),
      #choices = shiny::reactive({sort(colnames(dataETL))}),
      choices = c("relative_humidity", "vp_actual"),
      selected = "relative_humidity"
      #selected = sort(colnames(inData))[1]
    ),
    
    htmltools::br(),
    
    shiny::helpText(shiny::em(
      "We group stations by general proximity, as listed below. Scroll or swipe over the table to view additional columns."
    )),
    
    reactable::reactableOutput(outputId = "stationGroupsTable")
  ) # bslib::sidebar()
