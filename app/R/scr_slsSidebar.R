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
        icon = bsicons::bs_icon("sliders"),
        
        shiny::helpText(shiny::em(
          "Specify a station group to highlight and variable to show in the graph."
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
        ),
        
        shiny::helpText(shiny::em(
          "We group stations by general proximity, as listed below. Scroll over the table to view additional columns."
        )),
        
        htmltools::br(),
        
        reactable::reactableOutput(outputId = "stationGroupsTable")
        
      ) # bslib::accordion_panel()
    ), # bslib::accordion()
  ) # bslib::sidebar()
