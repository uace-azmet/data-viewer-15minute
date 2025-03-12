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
      choices = NULL, # see `app.R`, shiny::updateSelectInput(inputId = "azmetStationGroup")
      selected = NULL # see `app.R`, shiny::updateSelectInput(inputId = "azmetStationGroup")
    ),
    
    shiny::selectInput(
      inputId = "stationVariable", 
      label = "Station Variable",
      choices = NULL, # see `app.R`, shiny::updateSelectInput(inputId = "stationVariable")
      selected = NULL # see `app.R`, shiny::updateSelectInput(inputId = "stationVariable")
    ),
    
    htmltools::br(),
    
    shiny::helpText(shiny::em(
      "We group stations by general proximity, as listed below. Scroll or swipe over the table to view additional columns."
    )),
    
    reactable::reactableOutput(outputId = "stationGroupsTable")
  ) # bslib::sidebar()
