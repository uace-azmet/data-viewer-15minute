sidebarGraph <- bslib::sidebar(
  width = 300,
  position = "left",
  open = list(
    desktop = "open", 
    mobile = "always-above"
  ),
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
    "DATA OPTIONS"
  ),
  
  shiny::helpText(
    "Select an AZMet station, specify the time step, and set dates for the period of interest. Then, click or tap 'PREVIEW DATA'."
  ),
  
  shiny::selectInput(
    inputId = "azmetStation", 
    label = "AZMet Station",
    #choices = azmetStations[order(azmetStations$stationName), ]$stationName,
    choices = c("Aguila", "B", "C", "D", "E"),
    selected = "Aguila"
  )
)
