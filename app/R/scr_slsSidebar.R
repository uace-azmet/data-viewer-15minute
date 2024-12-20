slsSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = list(desktop = "open", mobile = "always-above"),
    id = "sidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#000000",
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    bslib::accordion(
      id = "accordion",
      #open = "DATE SELECTION",
      #multiple = TRUE,
      class = NULL,
      width = "auto",
      height = "auto",
      
      bslib::accordion_panel(
        title = "DATA DISPLAY",
        value = "dataDisplay",
        icon = bsicons::bs_icon("graph-up"),
        
        shiny::helpText(shiny::em(
          "Specify an AZMet station to highlight, and battery and weather variables to show in the graph."
        )),
        
        htmltools::br(),
        
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
        )
      ) # bslib::accordion_panel()
    ), # bslib::accordion()
  ) # bslib::sidebar()
